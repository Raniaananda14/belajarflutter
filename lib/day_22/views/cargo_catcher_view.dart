import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

enum ItemType { package, coin, bomb }

class FallingItem {
  final int id;
  final double x; // relative position [0.0, 1.0]
  double y; // relative position [0.0, 1.0]
  final double speed;
  final ItemType type;
  final double rotation;
  final double rotationSpeed;

  FallingItem({
    required this.id,
    required this.x,
    required this.y,
    required this.speed,
    required this.type,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class FloatingScore {
  final String text;
  final double x;
  double y;
  double opacity;
  final Color color;

  FloatingScore(
    this.text,
    this.x,
    this.y, {
    this.opacity = 1.0,
    required this.color,
  });
}

class CargoCatcherView extends StatefulWidget {
  const CargoCatcherView({super.key});

  @override
  State<CargoCatcherView> createState() => _CargoCatcherViewState();
}

class _CargoCatcherViewState extends State<CargoCatcherView>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final Random _random = Random();

  // Game States
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isGameOver = false;
  bool _isAutoplay = false;

  // Audio Player State
  late final AudioPlayer _audioPlayer;
  bool _isMuted = false;

  int _score = 0;
  int _highScore = 0;
  int _lives = 3;
  int _packagesCaught = 0;
  int _coinsCaught = 0;

  double _truckX = 0.5; // position [0.0, 1.0]
  List<FallingItem> _fallingItems = [];
  List<FloatingScore> _floatingScores = [];

  int _framesSinceLastSpawn = 0;
  int _itemIdCounter = 0;
  double _shakeIntensity = 0.0;

  @override
  void initState() {
    super.initState();
    _highScore = SessionManager.cargoHighScore;

    // Initialize AudioPlayer
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);

    // Create a 60fps game loop ticker
    _ticker = createTicker((duration) {
      if (_isPlaying && !_isPaused && !_isGameOver) {
        _updateGame();
      } else {
        // Just update visual elements like decelarating screenshake even when paused
        if (_shakeIntensity > 0) {
          setState(() {
            _shakeIntensity -= 0.8;
            if (_shakeIntensity < 0) _shakeIntensity = 0;
          });
        }
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _packagesCaught = 0;
      _coinsCaught = 0;
      _truckX = 0.5;
      _fallingItems.clear();
      _floatingScores.clear();
      _framesSinceLastSpawn = 0;
      _shakeIntensity = 0.0;
      _isPlaying = true;
      _isPaused = false;
      _isGameOver = false;
    });
    _playMusic();
  }

  void _playMusic() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/funny_game.wav'));
    } catch (e) {
      debugPrint("Error playing music: $e");
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
  }

  void _spawnItem() {
    _itemIdCounter++;
    double x = _random.nextDouble().clamp(0.08, 0.92);

    // Choose item type based on probabilities
    // 60% package, 25% coin, 15% bomb
    double roll = _random.nextDouble();
    ItemType type;
    if (roll < 0.60) {
      type = ItemType.package;
    } else if (roll < 0.85) {
      type = ItemType.coin;
    } else {
      type = ItemType.bomb;
    }

    double speed = _random.nextDouble() * 0.4 + 0.8; // speed multiplier
    double rotation = _random.nextDouble() * pi * 2;
    double rotationSpeed = (_random.nextDouble() - 0.5) * 0.1;

    _fallingItems.add(
      FallingItem(
        id: _itemIdCounter,
        x: x,
        y: 0.0,
        speed: speed,
        type: type,
        rotation: rotation,
        rotationSpeed: rotationSpeed,
      ),
    );
  }

  void _updateGame() {
    setState(() {
      // 1. Decelerate screenshake
      if (_shakeIntensity > 0) {
        _shakeIntensity -= 0.8;
        if (_shakeIntensity < 0) _shakeIntensity = 0;
      }

      // 2. Spawn logic
      _framesSinceLastSpawn++;
      // Speed up spawns as score increases
      int spawnInterval = max(18, 50 - (_score ~/ 80) * 3);
      if (_framesSinceLastSpawn >= spawnInterval) {
        _spawnItem();
        _framesSinceLastSpawn = 0;
      }

      // 3. Game difficulty speed adjustments
      double speedFactor = 0.008 + (_score ~/ 150) * 0.0008;
      speedFactor = speedFactor.clamp(0.007, 0.018);

      // AI autoplay driver
      if (_isAutoplay) {
        _runAI();
      }

      List<FallingItem> remainingItems = [];
      for (var item in _fallingItems) {
        item.y += item.speed * speedFactor;

        // Collision logic with truck (centered horizontally around truckX, vertically around 0.81-0.87)
        // Adjust bounds based on layout
        if (item.y >= 0.81 && item.y <= 0.87) {
          double dx = (item.x - _truckX).abs();
          if (dx < 0.12) {
            _onCatchItem(item);
            continue; // Caught, don't keep in list
          }
        }

        // Missed item reaches bottom
        if (item.y > 0.94) {
          if (item.type == ItemType.package) {
            _onMissPackage();
          }
          continue; // Disappears, don't keep
        }

        remainingItems.add(item);
      }
      _fallingItems = remainingItems;

      // 4. Update floaty scores
      List<FloatingScore> remainingScores = [];
      for (var fs in _floatingScores) {
        fs.y -= 0.006;
        fs.opacity -= 0.025;
        if (fs.opacity > 0) {
          remainingScores.add(fs);
        }
      }
      _floatingScores = remainingScores;
    });
  }

  void _runAI() {
    if (_fallingItems.isEmpty) return;

    // 1. Find the lowest safe item (package or coin)
    FallingItem? target;
    double maxSafeY = -1.0;

    // 2. Identify the closest threatening bomb
    FallingItem? threateningBomb;
    double minBombDistance = 1.0;

    for (var item in _fallingItems) {
      if (item.type == ItemType.bomb) {
        if (item.y > 0.45) {
          double dist = (item.x - _truckX).abs();
          if (dist < 0.25) {
            threateningBomb = item;
            minBombDistance = dist;
          }
        }
      } else {
        // Safe item
        if (item.y > maxSafeY && item.y < 0.84) {
          maxSafeY = item.y;
          target = item;
        }
      }
    }

    double targetX = _truckX;

    // Dodging behavior
    if (threateningBomb != null && minBombDistance < 0.2) {
      // Steer away from bomb
      if (threateningBomb.x < _truckX) {
        targetX = (_truckX + 0.2).clamp(0.08, 0.92);
      } else {
        targetX = (_truckX - 0.2).clamp(0.08, 0.92);
      }
    } else if (target != null) {
      // Move to target item
      targetX = target.x;
    }

    // Move truck horizontally towards targetX
    double aiSpeed =
        0.028 + (_score ~/ 200) * 0.002; // speeds up with difficulty
    aiSpeed = aiSpeed.clamp(0.022, 0.045);

    double dx = targetX - _truckX;
    if (dx.abs() > aiSpeed) {
      _truckX += dx.sign * aiSpeed;
    } else {
      _truckX = targetX;
    }
    _truckX = _truckX.clamp(0.08, 0.92);
  }

  void _onCatchItem(FallingItem item) {
    HapticFeedback.lightImpact();
    int points = 0;
    String text = "";
    Color color = Colors.white;

    if (item.type == ItemType.package) {
      points = 10;
      text = "+10";
      color = const Color(0xFF2DD4BF); // Vibrant light teal
      _packagesCaught++;
    } else if (item.type == ItemType.coin) {
      points = 20;
      text = "+20";
      color = const Color(0xFFF59E0B); // Amber gold
      _coinsCaught++;
    } else if (item.type == ItemType.bomb) {
      _onHitBomb();
      return;
    }

    _score += points;
    _floatingScores.add(FloatingScore(text, item.x, item.y, color: color));

    if (_score > _highScore) {
      _highScore = _score;
      SessionManager.setCargoHighScore(_highScore);
    }
  }

  void _onMissPackage() {
    HapticFeedback.mediumImpact();
    _shakeIntensity = 10.0;
    _lives--;
    _floatingScores.add(
      FloatingScore("LUPUT!", _truckX, 0.8, color: const Color(0xFFEF4444)),
    );

    if (_lives <= 0) {
      _gameOver();
    }
  }

  void _onHitBomb() {
    HapticFeedback.heavyImpact();
    _shakeIntensity = 20.0;
    _lives = 0;
    _floatingScores.add(
      FloatingScore("BOOM!", _truckX, 0.8, color: const Color(0xFFEF4444)),
    );
    _gameOver();
  }

  void _gameOver() {
    setState(() {
      _isGameOver = true;
      _isPlaying = false;
    });
    _audioPlayer.stop();
  }

  Widget _buildItemIcon(ItemType type) {
    switch (type) {
      case ItemType.package:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD97706).withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Color(0xFFF59E0B),
            size: 20,
          ),
        );
      case ItemType.coin:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAB308).withValues(alpha: 0.25),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFACC15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFACC15).withValues(alpha: 0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.monetization_on_rounded,
            color: Color(0xFFFACC15),
            size: 20,
          ),
        );
      case ItemType.bomb:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withValues(alpha: 0.25),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.brightness_5_rounded,
            color: Color(0xFFEF4444),
            size: 20,
          ),
        );
    }
  }

  Widget _buildTruckWidget() {
    return Column(
      children: [
        if (_isAutoplay) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 10, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  "AUTO PILOT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          width: 70,
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isAutoplay
                  ? [const Color(0xFF059669), const Color(0xFF10B981)]
                  : [const Color(0xFF0F766E), const Color(0xFF0D9488)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isAutoplay
                  ? const Color(0xFF34D399)
                  : const Color(0xFF2DD4BF),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isAutoplay
                    ? const Color(0xFF10B981).withValues(alpha: 0.4)
                    : const Color(0xFF0D9488).withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              // Headlights
              Positioned(
                right: 4,
                top: 10,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 10,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.iconPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "BizGrow Cargo Catcher",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: context.iconPrimary,
              ),
              onPressed: _toggleMute,
            ),
            if (_isPlaying && !_isGameOver)
              IconButton(
                icon: Icon(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: context.iconPrimary,
                ),
                onPressed: _togglePause,
              ),
          ],
        ),
        body: Column(
          children: [
            // Top HUD Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.cardBg.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Lives Indicator
                    Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: index < _lives
                                ? const Color(0xFFEF4444)
                                : Colors.grey.withValues(alpha: 0.4),
                            size: 20,
                          ),
                        );
                      }),
                    ),
                    // Current Score
                    Column(
                      children: [
                        Text(
                          "SKOR",
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "$_score",
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    // High Score
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "TERTINGGI",
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_events_rounded,
                              color: Color(0xFFFBBF24),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$_highScore",
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Main Game Area Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            // Subtle background grid lines for premium retro look
                            CustomPaint(
                              size: Size.infinite,
                              painter: GameGridPainter(isDark: isDark),
                            ),

                            // Camera Shake offset wrapper
                            Transform.translate(
                              offset: Offset(
                                _shakeIntensity > 0
                                    ? sin(DateTime.now().millisecond) *
                                          _shakeIntensity
                                    : 0,
                                _shakeIntensity > 0
                                    ? cos(DateTime.now().millisecond) *
                                          _shakeIntensity
                                    : 0,
                              ),
                              child: Stack(
                                children: [
                                  // Falling Items
                                  ..._fallingItems.map((item) {
                                    return Positioned(
                                      left: item.x * constraints.maxWidth - 20,
                                      top: item.y * constraints.maxHeight - 20,
                                      child: Transform.rotate(
                                        angle:
                                            item.rotation +
                                            (item.rotationSpeed * item.y * 30),
                                        child: _buildItemIcon(item.type),
                                      ),
                                    );
                                  }),

                                  // Floating Scores
                                  ..._floatingScores.map((fs) {
                                    return Positioned(
                                      left: fs.x * constraints.maxWidth - 25,
                                      top: fs.y * constraints.maxHeight - 20,
                                      child: Opacity(
                                        opacity: fs.opacity.clamp(0.0, 1.0),
                                        child: Text(
                                          fs.text,
                                          style: TextStyle(
                                            color: fs.color,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            shadows: const [
                                              Shadow(
                                                color: Colors.black54,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  // The Delivery Truck
                                  Positioned(
                                    left: _truckX * constraints.maxWidth - 35,
                                    top: 0.82 * constraints.maxHeight,
                                    child: _buildTruckWidget(),
                                  ),
                                ],
                              ),
                            ),

                            // Interactive Drag Overlay (only when playing and not in Autoplay mode)
                            if (_isPlaying &&
                                !_isPaused &&
                                !_isGameOver &&
                                !_isAutoplay)
                              Positioned.fill(
                                child: GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    setState(() {
                                      // Scale dx movement
                                      double change =
                                          details.primaryDelta! /
                                          constraints.maxWidth;
                                      _truckX = (_truckX + change).clamp(
                                        0.08,
                                        0.92,
                                      );
                                    });
                                  },
                                ),
                              ),

                            // Overlay: Start Game
                            if (!_isPlaying && !_isGameOver)
                              Container(
                                color: Colors.black.withValues(alpha: 0.65),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF0D9488,
                                            ).withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF2DD4BF),
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.local_shipping_rounded,
                                            color: Color(0xFF2DD4BF),
                                            size: 48,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          "TANGKAP KARGO",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Bantu kurir menangkap kargo & koin emas. Hindari bom merah!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF0D9488,
                                            ),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            elevation: 0,
                                          ),
                                          onPressed: _startGame,
                                          child: const Text(
                                            "Mulai Bermain",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // Overlay: Game Over
                            if (_isGameOver)
                              Container(
                                color: Colors.black.withValues(alpha: 0.75),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "PERMAINAN SELESAI",
                                          style: TextStyle(
                                            color: Color(0xFFEF4444),
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(18),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              _buildGameOverStat(
                                                "Skor Akhir",
                                                "$_score",
                                                const Color(0xFF2DD4BF),
                                              ),
                                              const SizedBox(height: 8),
                                              _buildGameOverStat(
                                                "Kargo Ditangkap",
                                                "$_packagesCaught",
                                                Colors.white,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildGameOverStat(
                                                "Koin Didapatkan",
                                                "$_coinsCaught",
                                                const Color(0xFFFBBF24),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  side: const BorderSide(
                                                    color: Colors.white60,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text(
                                                  "Kembali",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF0D9488,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: _startGame,
                                                child: const Text(
                                                  "Main Lagi",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // Overlay: Paused
                            if (_isPaused && !_isGameOver)
                              Container(
                                color: Colors.black.withValues(alpha: 0.65),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.pause_circle_filled_rounded,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "PERMAINAN DITANGGUHKAN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF0D9488,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: _togglePause,
                                        child: const Text(
                                          "Lanjutkan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Control Panel: Autoplay Switch & Stats
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.cardBg.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_mode_rounded,
                          color: _isAutoplay
                              ? const Color(0xFF10B981)
                              : context.iconColor,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Auto-Drive AI",
                              style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "AI mengemudi otomatis",
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _isAutoplay,
                      activeThumbColor: const Color(0xFF10B981),
                      activeTrackColor: const Color(
                        0xFF10B981,
                      ).withValues(alpha: 0.2),
                      onChanged: (val) {
                        setState(() {
                          _isAutoplay = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverStat(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class GameGridPainter extends CustomPainter {
  final bool isDark;
  GameGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.03)
          : Colors.black.withValues(alpha: 0.02)
      ..strokeWidth = 1.0;

    const double colSpacing = 30.0;
    const double rowSpacing = 30.0;

    for (double x = 0; x < size.width; x += colSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += rowSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
