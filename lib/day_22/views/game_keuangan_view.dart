import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class FinancialEvent {
  final String title;
  final String description;
  final String buttonText;
  final String? secondaryButtonText;
  final Function(GameState state) onChoosePrimary;
  final Function(GameState state)? onChooseSecondary;

  FinancialEvent({
    required this.title,
    required this.description,
    required this.buttonText,
    this.secondaryButtonText,
    required this.onChoosePrimary,
    this.onChooseSecondary,
  });
}

class GameState {
  double cash;
  double savings;
  double goldGrams;
  double stockShares;
  int businessBranches;
  double goldPrice;
  double stockPrice;
  double monthlyRevenue;

  GameState({
    required this.cash,
    required this.savings,
    required this.goldGrams,
    required this.stockShares,
    required this.businessBranches,
    required this.goldPrice,
    required this.stockPrice,
    required this.monthlyRevenue,
  });
}

class GameKeuanganView extends StatefulWidget {
  const GameKeuanganView({super.key});

  @override
  State<GameKeuanganView> createState() => _GameKeuanganViewState();
}

class _GameKeuanganViewState extends State<GameKeuanganView> {
  final Random _random = Random();

  // Game configuration
  static const int _totalMonths = 10;
  static const double _targetNetWorth = 25000000.0;
  static const double _branchCost = 4000000.0;
  static const double _branchRevenueBonus = 600000.0;

  // Game States
  int _currentMonth = 1;
  late GameState _state;
  bool _isGameOver = false;
  bool _isWon = false;
  int _highScore = 0;

  // Track logs/history for the month
  List<String> _monthlyLogs = [];

  @override
  void initState() {
    super.initState();
    _highScore = SessionManager.keuanganHighScore;
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _currentMonth = 1;
      _isGameOver = false;
      _isWon = false;
      _monthlyLogs = ["Game dimulai! Kelola uang Anda dengan bijak."];
      _state = GameState(
        cash: 10000000.0,
        savings: 0.0,
        goldGrams: 0.0,
        stockShares: 0.0,
        businessBranches: 0,
        goldPrice: 1000000.0, // Rp 1.000.000 per gram
        stockPrice: 5000.0,   // Rp 5.000 per share
        monthlyRevenue: 1500000.0, // Base monthly salary
      );
    });
  }

  double get _totalNetWorth {
    return _state.cash +
        _state.savings +
        (_state.goldGrams * _state.goldPrice) +
        (_state.stockShares * _state.stockPrice) +
        (_state.businessBranches * _branchCost);
  }

  void _endMonth() {
    HapticFeedback.mediumImpact();
    
    // Liquidate assets or check final score if it's month 10
    if (_currentMonth >= _totalMonths) {
      _finishGame();
      return;
    }

    _monthlyLogs.clear();

    // 1. Calculate Savings Interest (0.5% per month)
    if (_state.savings > 0) {
      double interest = _state.savings * 0.005;
      _state.savings += interest;
      _monthlyLogs.add("Bunga tabungan diperoleh: +Rp ${_formatMoney(interest)}");
    }

    // 2. Add Monthly Income
    double revenue = _state.monthlyRevenue + (_state.businessBranches * _branchRevenueBonus);
    _state.cash += revenue;
    _monthlyLogs.add("Pendapatan bulanan diterima: +Rp ${_formatMoney(revenue)}");

    // 3. Fluctuates Gold price (-10% to +15%)
    double goldChangePercent = (_random.nextDouble() * 0.25) - 0.10; // -10% to +15%
    _state.goldPrice = (_state.goldPrice * (1 + goldChangePercent)).clamp(600000.0, 2000000.0);
    String goldDir = goldChangePercent >= 0 ? "naik" : "turun";
    _monthlyLogs.add("Harga emas $goldDir ${(goldChangePercent * 100).toStringAsFixed(1)}% menjadi Rp ${_formatMoney(_state.goldPrice)}/gr");

    // 4. Fluctuates Stock price (-30% to +50%)
    double stockChangePercent = (_random.nextDouble() * 0.80) - 0.30; // -30% to +50%
    _state.stockPrice = (_state.stockPrice * (1 + stockChangePercent)).clamp(2000.0, 15000.0);
    String stockDir = stockChangePercent >= 0 ? "naik" : "turun";
    _monthlyLogs.add("Harga Saham $stockDir ${(stockChangePercent * 100).toStringAsFixed(1)}% menjadi Rp ${_formatMoney(_state.stockPrice)}/lbr");

    // Increment month
    setState(() {
      _currentMonth++;
    });

    // 5. Trigger a Random Event
    _triggerRandomEvent();
  }

  void _finishGame() {
    setState(() {
      _isGameOver = true;
      double finalScore = _totalNetWorth;
      _isWon = finalScore >= _targetNetWorth;

      if (_isWon && finalScore > _highScore) {
        _highScore = finalScore.toInt();
        SessionManager.setKeuanganHighScore(_highScore);
      } else if (!_isWon && finalScore.toInt() > _highScore) {
        // High score can still be updated even if goals aren't fully met, representing personal record
        _highScore = finalScore.toInt();
        SessionManager.setKeuanganHighScore(_highScore);
      }
    });
  }

  // --- Financial Actions ---
  void _tradeSavings(bool isDeposit, double amount) {
    if (isDeposit) {
      if (_state.cash >= amount) {
        HapticFeedback.lightImpact();
        setState(() {
          _state.cash -= amount;
          _state.savings += amount;
        });
      } else {
        _showErrorSnackBar("Kas tidak cukup!");
      }
    } else {
      if (_state.savings >= amount) {
        HapticFeedback.lightImpact();
        setState(() {
          _state.savings -= amount;
          _state.cash += amount;
        });
      } else {
        _showErrorSnackBar("Saldo tabungan tidak cukup!");
      }
    }
  }

  void _tradeGold(bool isBuy, double grams) {
    double totalCost = grams * _state.goldPrice;
    if (isBuy) {
      if (_state.cash >= totalCost) {
        HapticFeedback.lightImpact();
        setState(() {
          _state.cash -= totalCost;
          _state.goldGrams += grams;
        });
      } else {
        _showErrorSnackBar("Kas tidak cukup untuk membeli emas!");
      }
    } else {
      if (_state.goldGrams >= grams) {
        HapticFeedback.lightImpact();
        setState(() {
          _state.goldGrams -= grams;
          _state.cash += totalCost;
        });
      } else {
        _showErrorSnackBar("Jumlah emas Anda tidak cukup!");
      }
    }
  }

  void _tradeStocks(bool isBuy, double shares) {
    double totalCost = shares * _state.stockPrice;
    if (isBuy) {
      if (_state.cash >= totalCost) {
        HapticFeedback.lightImpact();
        setState(() {
          _state.cash -= totalCost;
          _state.stockShares += shares;
        });
      } else {
        _showErrorSnackBar("Kas tidak cukup untuk membeli saham!");
      }
    } else {
      if (_state.stockShares >= shares) {
        HapticFeedback.lightImpact();
        setState(() {
          _state.stockShares -= shares;
          _state.cash += totalCost;
        });
      } else {
        _showErrorSnackBar("Jumlah saham Anda tidak cukup!");
      }
    }
  }

  void _buyBusinessBranch() {
    if (_state.businessBranches >= 4) {
      _showErrorSnackBar("Maksimal cabang usaha tercapai (4 cabang)!");
      return;
    }

    if (_state.cash >= _branchCost) {
      HapticFeedback.mediumImpact();
      setState(() {
        _state.cash -= _branchCost;
        _state.businessBranches++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cabang usaha ke-${_state.businessBranches} berhasil dibeli! Pendapatan pasif bertambah."),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else {
      _showErrorSnackBar("Kas tidak cukup untuk ekspansi usaha!");
    }
  }

  void _showErrorSnackBar(String message) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // --- Random Events System ---
  void _triggerRandomEvent() {
    final List<FinancialEvent> eventPool = [
      FinancialEvent(
        title: "Perbaikan Toko Darurat 🛠️",
        description: "Atap bangunan usaha Anda bocor karena hujan lebat. Biaya perbaikan mendadak harus dibayarkan sebesar Rp 1.500.000.",
        buttonText: "Bayar (Rp 1.500.000)",
        onChoosePrimary: (state) {
          state.cash = (state.cash - 1500000.0).clamp(0.0, double.infinity);
          _addLog("Kejadian: Membayar perbaikan atap ruko Rp 1.500.000");
        },
      ),
      FinancialEvent(
        title: "Bonus Kinerja Penjualan 📈",
        description: "Strategi promosi Anda berhasil! Bulan ini penjualan meningkat drastis dan Anda mendapatkan bonus tunai Rp 2.500.000.",
        buttonText: "Terima Bonus",
        onChoosePrimary: (state) {
          state.cash += 2500000.0;
          _addLog("Kejadian: Menerima bonus penjualan Rp 2.500.000");
        },
      ),
      FinancialEvent(
        title: "Dividen Saham Cair 💰",
        description: "Perusahaan tempat Anda memiliki saham membagikan keuntungan perusahaan secara langsung.",
        buttonText: "Klaim Dividen",
        onChoosePrimary: (state) {
          if (state.stockShares > 0) {
            double dividend = state.stockShares * 400; // Rp 400 per share
            state.cash += dividend;
            _addLog("Kejadian: Menerima dividen saham Rp ${_formatMoney(dividend)}");
            _showSuccessDialog("Dividen Diterima!", "Anda menerima dividen tunai sebesar Rp ${_formatMoney(dividend)} karena memiliki ${state.stockShares.toInt()} lembar saham.");
          } else {
            _addLog("Kejadian: Dividen dibagikan tapi Anda tidak memiliki saham.");
            _showSuccessDialog("Dividen Kosong", "Dividen dibagikan, namun Anda tidak memiliki saham saat ini.");
          }
        },
      ),
      FinancialEvent(
        title: "Tawaran Pelatihan Bisnis 🧠",
        description: "Sebuah asosiasi menawarkan pelatihan manajemen keuangan seharga Rp 2.000.000. Pelatihan ini diperkirakan meningkatkan pendapatan bulanan Anda sebesar Rp 400.000 mulai bulan depan secara permanen.",
        buttonText: "Ikuti (Rp 2.000.000)",
        secondaryButtonText: "Lewati",
        onChoosePrimary: (state) {
          if (state.cash >= 2000000.0) {
            state.cash -= 2000000.0;
            state.monthlyRevenue += 400000.0;
            _addLog("Kejadian: Mengikuti kelas manajemen. Pendapatan bulanan +Rp 400.000");
          } else {
            _showErrorSnackBar("Kas tidak cukup!");
          }
        },
        onChooseSecondary: (state) {
          _addLog("Kejadian: Melewatkan tawaran pelatihan bisnis.");
        },
      ),
      FinancialEvent(
        title: "Gejolak Pasar Emas 🏆",
        description: "Ketidakpastian ekonomi global membuat investor ramai-ramai membeli emas. Harga emas meningkat tajam sebesar 15% secara mendadak!",
        buttonText: "Mengerti",
        onChoosePrimary: (state) {
          state.goldPrice = state.goldPrice * 1.15;
          _addLog("Kejadian: Pasar emas menguat 15%");
        },
      ),
      FinancialEvent(
        title: "Krisis Pasar Saham 📉",
        description: "Kenaikan suku bunga mendadak membuat pasar saham mengalami koreksi hebat. Nilai saham Anda turun sebesar 25%!",
        buttonText: "Mengerti",
        onChoosePrimary: (state) {
          state.stockPrice = state.stockPrice * 0.75;
          _addLog("Kejadian: Pasar saham anjlok 25%");
        },
      ),
      FinancialEvent(
        title: "Peluang Promo Pemasaran 📢",
        description: "Agensi iklan menawarkan promosi khusus di media sosial seharga Rp 1.000.000. Jika diambil, pendapatan bulanan Anda akan naik Rp 200.000 mulai bulan depan.",
        buttonText: "Gunakan Promo (Rp 1.000.000)",
        secondaryButtonText: "Lewati",
        onChoosePrimary: (state) {
          if (state.cash >= 1000000.0) {
            state.cash -= 1000000.0;
            state.monthlyRevenue += 200000.0;
            _addLog("Kejadian: Membeli paket iklan. Pendapatan bulanan +Rp 200.000");
          } else {
            _showErrorSnackBar("Kas tidak cukup!");
          }
        },
        onChooseSecondary: (state) {
          _addLog("Kejadian: Melewatkan peluang iklan.");
        },
      ),
    ];

    // Pick a random event
    final event = eventPool[_random.nextInt(eventPool.length)];

    // Show event dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: context.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: context.borderColor),
            ),
            title: Text(
              event.title,
              style: TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              event.description,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            actions: [
              if (event.secondaryButtonText != null)
                TextButton(
                  onPressed: () {
                    if (event.onChooseSecondary != null) {
                      event.onChooseSecondary!(_state);
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text(
                    event.secondaryButtonText!,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  // If it costs cash and they don't have enough, warn them and do nothing (can't choose primary if they cannot pay, except forced events like repair)
                  if (event.title.contains("Pelatihan") && _state.cash < 2000000.0) {
                    _showErrorSnackBar("Kas tidak cukup untuk mengambil kursus!");
                    return;
                  }
                  if (event.title.contains("Promo") && _state.cash < 1000000.0) {
                    _showErrorSnackBar("Kas tidak cukup untuk membeli iklan!");
                    return;
                  }
                  
                  event.onChoosePrimary(_state);
                  Navigator.pop(context);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0891B2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  event.buttonText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addLog(String log) {
    setState(() {
      _monthlyLogs.add(log);
    });
  }

  void _showSuccessDialog(String title, String desc) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: context.cardBg,
        title: Text(
          title,
          style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          desc,
          style: TextStyle(color: context.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  String _formatMoney(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
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
            "Simulasi Keuangan 💰",
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
              // Monthly & Net Worth Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.cardBg.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BULAN",
                                style: TextStyle(color: context.textSecondary, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$_currentMonth / $_totalMonths",
                                style: TextStyle(color: context.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "TARGET ASET BERSIH",
                                style: TextStyle(color: context.textSecondary, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rp ${_formatMoney(_targetNetWorth)}",
                                style: const TextStyle(color: Color(0xFF10B981), fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TOTAL ASET BERSIH",
                                style: TextStyle(color: context.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Rp ${_formatMoney(_totalNetWorth)}",
                                style: TextStyle(
                                  color: _totalNetWorth >= _targetNetWorth ? const Color(0xFF10B981) : const Color(0xFF0891B2),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          // High Score Badge
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "REKOR TERBAIK",
                                style: TextStyle(color: context.textSecondary, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Rp ${_formatMoney(_highScore.toDouble())}",
                                style: const TextStyle(color: Color(0xFFD97706), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Gameplay area
              Expanded(
                child: _isGameOver
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: context.cardBg.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: context.borderColor),
                          ),
                          child: _buildGameOverScreen(),
                        ),
                      )
                    : _buildTradingDashboard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradingDashboard() {
    return Column(
      children: [
        // Monthly logs ticker (Subtle sliding list)
        if (_monthlyLogs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0891B2).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0891B2).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.feed_rounded, color: Color(0xFF0891B2), size: 12),
                      SizedBox(width: 6),
                      Text(
                        "LAPORAN BULAN INI",
                        style: TextStyle(
                          color: Color(0xFF0891B2),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ..._monthlyLogs.map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "• $log",
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

        // Grid/List of trading instruments
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              // Liquid Cash Wallet Card
              _buildLiquidCashCard(),
              const SizedBox(height: 12),

              // Tabungan
              _buildSavingsCard(),
              const SizedBox(height: 12),

              // Emas
              _buildGoldCard(),
              const SizedBox(height: 12),

              // Saham
              _buildStocksCard(),
              const SizedBox(height: 12),

              // Ekspansi Bisnis
              _buildBusinessExpansionCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),

        // End month button bar
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
          child: ElevatedButton(
            onPressed: _endMonth,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0891B2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentMonth >= _totalMonths ? "SELESAIKAN GAME 🏆" : "AKHIRI BULAN DAN PROSES 📅",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiquidCashCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Uang Kas (Likuid)",
                style: TextStyle(color: context.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                "Rp ${_formatMoney(_state.cash)}",
                style: TextStyle(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.savings_rounded, color: Color(0xFF0EA5E9), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tabungan Bank",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        "Bunga: 0.5% / bln (Bebas Risiko)",
                        style: TextStyle(color: context.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "Rp ${_formatMoney(_state.savings)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Withdraw button
              _buildActionButton(
                label: "Tarik 1 Jt",
                color: const Color(0xFFEF4444),
                onTap: () => _tradeSavings(false, 1000000.0),
              ),
              const SizedBox(width: 8),
              // Deposit button
              _buildActionButton(
                label: "Simpan 1 Jt",
                color: const Color(0xFF10B981),
                onTap: () => _tradeSavings(true, 1000000.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoldCard() {
    double totalGoldValue = _state.goldGrams * _state.goldPrice;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Investasi Emas",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        "Harga: Rp ${_formatMoney(_state.goldPrice)} / gram",
                        style: TextStyle(color: context.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${_state.goldGrams.toStringAsFixed(1)} gr",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "= Rp ${_formatMoney(totalGoldValue)}",
                    style: TextStyle(color: context.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                label: "Jual 1 gr",
                color: const Color(0xFFEF4444),
                onTap: () => _tradeGold(false, 1.0),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                label: "Beli 1 gr",
                color: const Color(0xFF10B981),
                onTap: () => _tradeGold(true, 1.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStocksCard() {
    double totalStockValue = _state.stockShares * _state.stockPrice;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.show_chart_rounded, color: Color(0xFF4F46E5), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Saham Pasar Modal",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        "Harga: Rp ${_formatMoney(_state.stockPrice)} / lbr",
                        style: TextStyle(color: context.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${_state.stockShares.toInt()} lbr",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "= Rp ${_formatMoney(totalStockValue)}",
                    style: TextStyle(color: context.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                label: "Jual 200 lbr",
                color: const Color(0xFFEF4444),
                onTap: () => _tradeStocks(false, 200.0),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                label: "Beli 200 lbr",
                color: const Color(0xFF10B981),
                onTap: () => _tradeStocks(true, 200.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessExpansionCard() {
    double totalRevenue = _state.monthlyRevenue + (_state.businessBranches * _branchRevenueBonus);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0891B2).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store_rounded, color: Color(0xFF0891B2), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ekspansi Cabang Toko",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        "Pemasukan/cabang: +Rp ${_formatMoney(_branchRevenueBonus)}/bln",
                        style: TextStyle(color: context.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${_state.businessBranches} / 4 Cabang",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "Total Gaji: Rp ${_formatMoney(totalRevenue)}",
                    style: TextStyle(color: context.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _state.businessBranches >= 4 ? null : _buyBusinessBranch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0891B2),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: context.isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: const Icon(Icons.add_business_rounded, size: 14),
                label: Text(
                  _state.businessBranches >= 4
                      ? "Cabang Maksimal"
                      : "Beli Cabang (Rp ${_formatMoney(_branchCost)})",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildGameOverScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _isWon ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFEF4444).withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: _isWon ? const Color(0xFF10B981) : const Color(0xFFEF4444), width: 2),
          ),
          child: Icon(
            _isWon ? Icons.military_tech_rounded : Icons.cancel_presentation_rounded,
            color: _isWon ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            size: 64,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isWon ? "Anda Menang! 🏆" : "Target Belum Tercapai 😢",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _isWon ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isWon
              ? "Luar biasa! Anda berhasil mengumpulkan aset bersih melebihi target Rp ${_formatMoney(_targetNetWorth)} pada bulan ke-10."
              : "Sayang sekali, aset bersih Anda masih kurang Rp ${_formatMoney(_targetNetWorth - _totalNetWorth)} untuk mencapai target Rp ${_formatMoney(_targetNetWorth)}.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // End Game Asset Report Table
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.isDark ? const Color(0xFF030712) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            children: [
              _buildReportRow("Uang Kas", "Rp ${_formatMoney(_state.cash)}"),
              _buildReportRow("Tabungan", "Rp ${_formatMoney(_state.savings)}"),
              _buildReportRow("Nilai Emas (${_state.goldGrams.toStringAsFixed(1)} gr)", "Rp ${_formatMoney(_state.goldGrams * _state.goldPrice)}"),
              _buildReportRow("Nilai Saham (${_state.stockShares.toInt()} lbr)", "Rp ${_formatMoney(_state.stockShares * _state.stockPrice)}"),
              _buildReportRow("Nilai Cabang Usaha (${_state.businessBranches})", "Rp ${_formatMoney(_state.businessBranches * _branchCost)}"),
              const Divider(height: 16),
              _buildReportRow("Total Aset Bersih", "Rp ${_formatMoney(_totalNetWorth)}", isBold: true),
            ],
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
                backgroundColor: const Color(0xFF0891B2),
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

  Widget _buildReportRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? context.textPrimary : context.textSecondary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isBold ? const Color(0xFF10B981) : context.textPrimary,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
