import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}

class KuisBisnisView extends StatefulWidget {
  const KuisBisnisView({super.key});

  @override
  State<KuisBisnisView> createState() => _KuisBisnisViewState();
}

class _KuisBisnisViewState extends State<KuisBisnisView> {
  final List<Question> _questionBank = [
    Question(
      questionText: "Apa singkatan dari SWOT dalam analisis strategi bisnis?",
      options: [
        "Strategy, Work, Organization, Team",
        "Strength, Weakness, Opportunity, Threat",
        "Sale, Warehouse, Order, Transaction",
        "System, Web, Office, Technology",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Apa arti dari Break Even Point (BEP) dalam keuangan?",
      options: [
        "Titik keuntungan maksimal perusahaan",
        "Titik di mana pendapatan sama dengan pengeluaran (tidak untung/rugi)",
        "Titik kebangkrutan atau gagal bayar",
        "Pajak tahunan yang harus dibayar pelaku usaha",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText:
          "Apa tujuan utama dari melakukan riset pasar sebelum meluncurkan produk?",
      options: [
        "Memahami kebutuhan, preferensi, dan karakteristik konsumen",
        "Menghitung gaji bulanan staf manajemen",
        "Membeli aset fisik untuk operasional kantor baru",
        "Menentukan nama legal perusahaan di notaris",
      ],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: "Siapakah yang disebut sebagai 'Angel Investor'?",
      options: [
        "Lembaga keuangan negara yang meminjamkan modal tanpa jaminan",
        "Individu kaya yang memberikan modal awal untuk startup",
        "Karyawan magang pertama dalam suatu usaha rintisan",
        "Konsultan keuangan yang merapikan laporan audit internal",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Apa perbedaan mendasar antara Aset dan Liabilitas?",
      options: [
        "Aset adalah utang, sedangkan liabilitas adalah piutang usaha",
        "Aset menghasilkan nilai ekonomi, liabilitas menimbulkan biaya pengeluaran",
        "Aset hanya dimiliki perorangan, liabilitas hanya milik korporasi besar",
        "Tidak ada perbedaan yang signifikan di antara keduanya",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Apa yang dimaksud dengan Cash Flow?",
      options: [
        "Aliran masuk dan keluar uang tunai dalam suatu bisnis",
        "Total dana darurat yang disimpan di brankas perusahaan",
        "Biaya operasional bulanan kantor cabang",
        "Laporan pengembalian pajak tahunan kepada dinas pajak",
      ],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: "Model bisnis B2B merupakan singkatan dari...",
      options: [
        "Buyer to Buyer",
        "Business to Business",
        "Brand to Buyer",
        "Business to Buyer",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Apa yang dimaksud dengan segmentasi pasar?",
      options: [
        "Membagi pasar konsumen menjadi kelompok-kelompok yang berbeda",
        "Menggabungkan seluruh varian produk ke satu klasifikasi",
        "Menghitung proyeksi keuntungan bersih akhir tahun",
        "Menutup operasional toko fisik yang sepi pelanggan",
      ],
      correctOptionIndex: 0,
    ),
    Question(
      questionText:
          "Manakah di bawah ini yang merupakan contoh biaya tetap (fixed cost)?",
      options: [
        "Biaya bahan baku produk",
        "Biaya sewa ruko / gedung bulanan",
        "Biaya kemasan dan pengiriman paket",
        "Komisi penjualan per barang",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Apa tujuan utama dari program promosi 'Beli 1 Gratis 1'?",
      options: [
        "Meningkatkan volume penjualan secara cepat dan mengurangi stok",
        "Menurunkan kualitas produk secara permanen",
        "Mempersulit rantai pasokan bahan baku",
        "Menghindari beban pajak penjualan",
      ],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: "Kepanjangan ROI dalam istilah investasi bisnis adalah...",
      options: [
        "Rate of Inflation",
        "Return on Investment",
        "Risk of Inflation",
        "Return on Income",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Fungsi utama dari laporan Laba Rugi adalah...",
      options: [
        "Menunjukkan performa keuangan (keuntungan/kerugian) pada periode tertentu",
        "Mencatat daftar hadir harian karyawan",
        "Menulis visi-misi jangka panjang pendiri perusahaan",
        "Menyimpan daftar riwayat transaksi supplier bahan baku",
      ],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: "Dalam istilah bisnis startup, apa arti dari 'Pivot'?",
      options: [
        "Menutup perusahaan karena bangkrut",
        "Merubah arah strategis bisnis secara mendasar tanpa mengubah visi utama",
        "Merekrut CEO baru dari luar perusahaan",
        "Melakukan penawaran saham ke publik (IPO)",
      ],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: "Apa yang diukur oleh Return on Equity (ROE)?",
      options: [
        "Tingkat pengembalian investasi dari utang",
        "Kemampuan perusahaan menghasilkan laba dari ekuitas pemegang saham",
        "Total gaji yang dibayarkan ke jajaran direktur",
        "Persentase diskon yang diberikan ke distributor",
      ],
      correctOptionIndex: 1,
    ),
  ];

  late List<Question> _quizQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _highScore = 0;
  int _correctAnswersCount = 0;
  bool _quizFinished = false;

  // Question specific states
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;

  // Timer settings
  static const int _maxTimerSeconds = 15;
  int _timerSeconds = _maxTimerSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _highScore = SessionManager.kuisBisnisHighScore;
    _startQuiz();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuiz() {
    // Pick 10 questions randomly from bank
    _quizQuestions = List.from(_questionBank)..shuffle();
    _quizQuestions = _quizQuestions.take(10).toList();

    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswersCount = 0;
    _quizFinished = false;

    _loadQuestion();
  }

  void _loadQuestion() {
    setState(() {
      _selectedAnswerIndex = null;
      _hasAnswered = false;
      _timerSeconds = _maxTimerSeconds;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer?.cancel();
        _onTimeOut();
      }
    });
  }

  void _onTimeOut() {
    HapticFeedback.heavyImpact();
    setState(() {
      _hasAnswered = true;
      _selectedAnswerIndex = -1; // -1 represents timeout (no option selected)
    });

    // Auto-advance after 2 seconds
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        _goToNextQuestion();
      }
    });
  }

  void _onAnswerSelected(int index) {
    if (_hasAnswered) return;

    _timer?.cancel();
    final isCorrect =
        index == _quizQuestions[_currentQuestionIndex].correctOptionIndex;

    if (isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;

      if (isCorrect) {
        _correctAnswersCount++;
        // 10 base points + time remaining * 2 bonus points
        _score += 10 + (_timerSeconds * 2);
      }
    });

    // Auto-advance after 2 seconds
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        _goToNextQuestion();
      }
    });
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _loadQuestion();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _timer?.cancel();
    setState(() {
      _quizFinished = true;
      if (_score > _highScore) {
        _highScore = _score;
        SessionManager.setKuisBisnisHighScore(_highScore);
      }
    });
  }

  String _getBadgeTitle(int score) {
    if (score >= 150) return "CEO Utama 👑";
    if (score >= 100) return "Direktur 👔";
    if (score >= 60) return "Manajer 📈";
    return "Magang 💼";
  }

  Color _getBadgeColor(int score) {
    if (score >= 150) return const Color(0xFFF59E0B); // Gold
    if (score >= 100) return const Color(0xFF4F46E5); // Indigo
    if (score >= 60) return const Color(0xFF0D9488); // Teal
    return const Color(0xFF64748B); // Slate/Grey
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
            "Kuis Bisnis Pintar 🧠",
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
              if (!_quizFinished) ...[
                // Top Progress and Timer HUD
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      // Question Progress Text
                      Text(
                        "Soal ${_currentQuestionIndex + 1} dari ${_quizQuestions.length}",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Score Count
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF4F46E5).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "Skor: $_score",
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Beautiful timer bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: 6,
                        width:
                            MediaQuery.of(context).size.width *
                            0.9 *
                            (_timerSeconds / _maxTimerSeconds),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _timerSeconds <= 5
                                ? [
                                    const Color(0xFFEF4444),
                                    const Color(0xFFF87171),
                                  ]
                                : [
                                    const Color(0xFF4F46E5),
                                    const Color(0xFF6366F1),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Main Quiz Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: context.cardBg.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: _quizFinished
                      ? _buildQuizSummaryScreen()
                      : _buildQuizQuestionScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizQuestionScreen() {
    final question = _quizQuestions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Countdown overlay warning
        if (_timerSeconds <= 5 && !_hasAnswered)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF4444),
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Waktu hampir habis!",
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),

        // Question text
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              question.questionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ),

        // Options lists
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(question.options.length, (index) {
              final optionText = question.options[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildOptionButton(index, optionText, question),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(int index, String optionText, Question question) {
    Color? buttonColor;
    Color? textColor = context.textPrimary;
    Color borderColor = context.borderColor;

    if (_hasAnswered) {
      if (index == question.correctOptionIndex) {
        // Correct Option
        buttonColor = const Color(0xFF10B981).withOpacity(0.15);
        textColor = const Color(0xFF10B981);
        borderColor = const Color(0xFF10B981);
      } else if (index == _selectedAnswerIndex) {
        // Selected wrong option
        buttonColor = const Color(0xFFEF4444).withOpacity(0.15);
        textColor = const Color(0xFFEF4444);
        borderColor = const Color(0xFFEF4444);
      } else {
        // Untouched options
        buttonColor = Colors.transparent;
        textColor = context.textSecondary.withOpacity(0.5);
        borderColor = context.borderColor.withOpacity(0.4);
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: buttonColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _onAnswerSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _hasAnswered
                        ? (index == question.correctOptionIndex
                              ? const Color(0xFF10B981)
                              : (index == _selectedAnswerIndex
                                    ? const Color(0xFFEF4444)
                                    : Colors.grey.withOpacity(0.2)))
                        : const Color(0xFF4F46E5).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      color: _hasAnswered
                          ? Colors.white
                          : const Color(0xFF6366F1),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_hasAnswered) ...[
                  if (index == question.correctOptionIndex)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 18,
                    )
                  else if (index == _selectedAnswerIndex)
                    const Icon(
                      Icons.cancel_rounded,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizSummaryScreen() {
    final badgeTitle = _getBadgeTitle(_score);
    final badgeColor = _getBadgeColor(_score);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Trophy / Icon
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: badgeColor, width: 2),
          ),
          child: Icon(
            _score >= 100
                ? Icons.emoji_events_rounded
                : Icons.military_tech_rounded,
            color: badgeColor,
            size: 64,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Kuis Selesai! 🎉",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: badgeColor.withOpacity(0.3)),
          ),
          child: Text(
            "Pangkat: $badgeTitle",
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Score card details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "BENAR",
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$_correctAnswersCount/10",
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(height: 30, width: 1, color: context.borderColor),
            Column(
              children: [
                Text(
                  "SKOR AKHIR",
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$_score pts",
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(height: 30, width: 1, color: context.borderColor),
            Column(
              children: [
                Text(
                  "TERTINGGI",
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$_highScore pts",
                  style: const TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
                foregroundColor: context.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              child: const Text(
                "Kembali",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
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
