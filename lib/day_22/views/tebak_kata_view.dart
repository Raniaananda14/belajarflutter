import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class WordClue {
  final String word;
  final String clue;
  WordClue(this.word, this.clue);
}

class TebakKataView extends StatefulWidget {
  const TebakKataView({super.key});

  @override
  State<TebakKataView> createState() => _TebakKataViewState();
}

class _TebakKataViewState extends State<TebakKataView> {
  final List<WordClue> _allWords = [
    WordClue("MODAL", "Dana awal yang digunakan untuk memulai usaha"),
    WordClue("UNTUNG", "Selisih positif antara pendapatan total dan biaya total"),
    WordClue("SAHAM", "Bukti kepemilikan nilai sebuah perusahaan"),
    WordClue("PRODUK", "Barang atau jasa yang ditawarkan kepada konsumen"),
    WordClue("MEREK", "Nama atau simbol unik yang mengidentifikasi produk penjual"),
    WordClue("PASAR", "Tempat bertemunya penjual dan pembeli untuk bertransaksi"),
    WordClue("PAJAK", "Kontribusi wajib kepada negara yang bersifat memaksa"),
    WordClue("RUGI", "Kondisi ketika pengeluaran lebih besar dari pendapatan"),
    WordClue("UTANG", "Kewajiban finansial yang harus dibayar kepada pihak lain"),
    WordClue("ASET", "Seluruh kekayaan bernilai milik perorangan atau perusahaan"),
    WordClue("INFLASI", "Kenaikan harga barang secara umum dan terus menerus"),
    WordClue("KONSUMEN", "Pengguna akhir dari barang atau jasa yang diproduksi"),
    WordClue("INVESTASI", "Penanaman modal untuk memperoleh keuntungan di masa depan"),
    WordClue("IKLAN", "Pesan promosi untuk membujuk orang membeli produk"),
    WordClue("OMSET", "Jumlah total uang yang diterima dari hasil penjualan"),
    WordClue("MITRA", "Rekan kerja sama dalam menjalankan kegiatan usaha"),
    WordClue("KREDIT", "Penyediaan uang berdasarkan kesepakatan pinjam-meminjam"),
    WordClue("BUNGA", "Imbal jasa atas pinjaman uang atau simpanan di bank"),
    WordClue("KAS", "Uang tunai atau saldo rekening yang siap digunakan setiap saat"),
  ];

  late List<WordClue> _gameWords;
  int _currentWordIndex = 0;
  int _score = 0;
  int _highScore = 0;
  int _lives = 3;
  bool _isGameOver = false;
  bool _isLevelCleared = false;

  // Game specific variables for current word
  late String _targetWord;
  late String _clueText;
  List<String> _scrambledLetters = [];
  List<String?> _selectedLetters = []; // Letters placed in the slots
  List<int> _letterSourceIndices = []; // Track where each placed letter came from in scrambled pool (-1 if hint)
  List<bool> _letterUsed = []; // Track usage of letters in scrambled pool
  int _hintsUsed = 0;

  @override
  void initState() {
    super.initState();
    _highScore = SessionManager.tebakKataHighScore;
    _startNewGame();
  }

  void _startNewGame() {
    _gameWords = List.from(_allWords)..shuffle();
    _currentWordIndex = 0;
    _score = 0;
    _lives = 3;
    _isGameOver = false;
    _isLevelCleared = false;
    _setupWord();
  }

  void _setupWord() {
    _isLevelCleared = false;
    _targetWord = _gameWords[_currentWordIndex].word.toUpperCase();
    _clueText = _gameWords[_currentWordIndex].clue;
    _hintsUsed = 0;

    // Scramble the word letters
    List<String> chars = _targetWord.split('');
    // If word is short, add a few random letters to make it slightly harder
    final random = Random();
    if (chars.length <= 4) {
      String alphabets = "ABCDEFIJKLMNOPQRSTUVWYZ";
      for (int i = 0; i < 2; i++) {
        chars.add(alphabets[random.nextInt(alphabets.length)]);
      }
    }
    
    // Shuffle the letters
    do {
      chars.shuffle();
    } while (chars.join('') == _targetWord); // Ensure it's not solved initially

    _scrambledLetters = chars;
    _selectedLetters = List.filled(_targetWord.length, null);
    _letterSourceIndices = List.filled(_targetWord.length, -1);
    _letterUsed = List.filled(_scrambledLetters.length, false);
  }

  void _selectLetter(int scrambledIndex) {
    if (_isGameOver || _isLevelCleared) return;
    if (_letterUsed[scrambledIndex]) return;

    // Find the first empty slot
    int emptySlotIndex = _selectedLetters.indexOf(null);
    if (emptySlotIndex != -1) {
      HapticFeedback.lightImpact();
      setState(() {
        _selectedLetters[emptySlotIndex] = _scrambledLetters[scrambledIndex];
        _letterSourceIndices[emptySlotIndex] = scrambledIndex;
        _letterUsed[scrambledIndex] = true;
      });
      _checkAutoSubmit();
    }
  }

  void _removeLetter(int slotIndex) {
    if (_isGameOver || _isLevelCleared) return;
    if (_selectedLetters[slotIndex] == null) return;
    
    // If it was a hint, we can't remove it
    int sourceIndex = _letterSourceIndices[slotIndex];
    if (sourceIndex == -1) {
      return; 
    }

    HapticFeedback.lightImpact();
    setState(() {
      _letterUsed[sourceIndex] = false;
      _selectedLetters[slotIndex] = null;
      _letterSourceIndices[slotIndex] = -1;
    });
  }

  void _resetCurrentWord() {
    if (_isGameOver || _isLevelCleared) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedLetters = List.filled(_targetWord.length, null);
      _letterSourceIndices = List.filled(_targetWord.length, -1);
      _letterUsed = List.filled(_scrambledLetters.length, false);
      _hintsUsed = 0;
    });
  }

  void _useHint() {
    if (_isGameOver || _isLevelCleared) return;
    
    // Find the first empty slot or incorrect slot, and fill it with the correct letter as a permanent hint
    int firstEmptyOrWrong = -1;
    for (int i = 0; i < _targetWord.length; i++) {
      if (_selectedLetters[i] != _targetWord[i]) {
        firstEmptyOrWrong = i;
        break;
      }
    }

    if (firstEmptyOrWrong != -1) {
      HapticFeedback.mediumImpact();
      String correctChar = _targetWord[firstEmptyOrWrong];

      setState(() {
        // If there was already a user letter in that slot, free its source first
        int existingSource = _letterSourceIndices[firstEmptyOrWrong];
        if (existingSource != -1) {
          _letterUsed[existingSource] = false;
        }

        // Find if that correct character exists in the remaining unused letters in the pool
        int poolIndex = -1;
        for (int j = 0; j < _scrambledLetters.length; j++) {
          if (_scrambledLetters[j] == correctChar && !_letterUsed[j]) {
            poolIndex = j;
            break;
          }
        }

        if (poolIndex != -1) {
          _selectedLetters[firstEmptyOrWrong] = correctChar;
          _letterSourceIndices[firstEmptyOrWrong] = poolIndex;
          _letterUsed[poolIndex] = true;
        } else {
          // If not found in pool (e.g. already used elsewhere, or it's extra), force place it as a hint index (-1)
          _selectedLetters[firstEmptyOrWrong] = correctChar;
          _letterSourceIndices[firstEmptyOrWrong] = -1;
        }
        _hintsUsed++;
      });
      _checkAutoSubmit();
    }
  }

  void _checkAutoSubmit() {
    // If all slots are filled, check if correct
    if (!_selectedLetters.contains(null)) {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    String guess = _selectedLetters.join('').toUpperCase();
    if (guess == _targetWord) {
      // Correct!
      HapticFeedback.mediumImpact();
      setState(() {
        _isLevelCleared = true;
        _score++;
        if (_score > _highScore) {
          _highScore = _score;
          SessionManager.setTebakKataHighScore(_highScore);
        }
      });
    } else {
      // Incorrect guess
      HapticFeedback.heavyImpact();
      setState(() {
        _lives--;
        if (_lives <= 0) {
          _isGameOver = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Kata belum tepat! Coba atur ulang huruf."),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFFEF4444),
            ),
          );
          _resetCurrentWord();
        }
      });
    }
  }

  void _nextWord() {
    setState(() {
      _currentWordIndex++;
      if (_currentWordIndex >= _gameWords.length) {
        // Reshuffle and start over if we ran out of words
        _gameWords.shuffle();
        _currentWordIndex = 0;
      }
      _setupWord();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            "Tebak Kata Bisnis 🔠",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top Stats / HUD Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: context.cardBg.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lives
                      Row(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: index < _lives
                                  ? const Color(0xFFEF4444)
                                  : Colors.grey.withOpacity(0.3),
                              size: 22,
                            ),
                          );
                        }),
                      ),
                      // Score
                      Column(
                        children: [
                          Text(
                            "SKOR",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$_score",
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 18,
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
                            "REKOR",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$_highScore kata",
                            style: TextStyle(
                              color: const Color(0xFFD97706),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Game Main Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardBg.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: _isGameOver
                      ? _buildGameOverScreen()
                      : _isLevelCleared
                          ? _buildLevelClearedScreen()
                          : _buildGameplayScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameplayScreen() {
    return Column(
      children: [
        // Clue Section
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD97706).withOpacity(0.3)),
                  ),
                  child: const Text(
                    "PETUNJUK KATA",
                    style: TextStyle(
                      color: Color(0xFFD97706),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _clueText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Letter Slots Layout (Where the user's built word goes)
        Expanded(
          flex: 2,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_targetWord.length, (index) {
                  final letter = _selectedLetters[index];
                  final isHintLetter = _letterSourceIndices[index] == -1 && letter != null;

                  return GestureDetector(
                    onTap: () => _removeLetter(index),
                    child: Container(
                      width: min(44, 300 / _targetWord.length),
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: letter == null
                            ? Colors.transparent
                            : (isHintLetter
                                ? const Color(0xFF10B981).withOpacity(0.15)
                                : context.cardBg),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: letter == null
                              ? context.borderColor.withOpacity(0.6)
                              : (isHintLetter ? const Color(0xFF10B981) : const Color(0xFFD97706)),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter ?? "",
                        style: TextStyle(
                          color: isHintLetter ? const Color(0xFF10B981) : context.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Controls (Reset & Hint)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Reset Button
              TextButton.icon(
                onPressed: _resetCurrentWord,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  "Reset",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),

              // Hint Button
              TextButton.icon(
                onPressed: _useHint,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                ),
                icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                label: const Text(
                  "Petunjuk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // Scrambled Letters Pool (The letters you can click)
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 10,
              children: List.generate(_scrambledLetters.length, (index) {
                final isUsed = _letterUsed[index];
                return GestureDetector(
                  onTap: () => _selectLetter(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isUsed
                          ? Colors.grey.withOpacity(0.1)
                          : const Color(0xFFD97706),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isUsed
                            ? Colors.transparent
                            : const Color(0xFFF59E0B),
                        width: 1.5,
                      ),
                      boxShadow: isUsed
                          ? []
                          : [
                              BoxShadow(
                                color: const Color(0xFFD97706).withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _scrambledLetters[index],
                      style: TextStyle(
                        color: isUsed ? Colors.transparent : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelClearedScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF10B981), width: 2),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF10B981),
            size: 64,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Jawaban Benar! 🎉",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Kata yang disusun:",
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _targetWord,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        if (_hintsUsed > 0)
          Text(
            "Menggunakan $_hintsUsed Bantuan",
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _nextWord,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD97706),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Lanjut Kata Berikutnya",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameOverScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFEF4444), width: 2),
          ),
          child: const Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            color: Color(0xFFEF4444),
            size: 64,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Permainan Selesai 😢",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEF4444),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Anda berhasil menebak $_score kata.",
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Rekor Anda saat ini adalah $_highScore kata.",
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                foregroundColor: context.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: const Text(
                "Kembali",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _startNewGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: const Text(
                "Main Lagi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
