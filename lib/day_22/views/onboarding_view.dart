import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Kelola Bisnis Anda\ndengan Mudah",
      "subtitle": "Pantau penjualan, kelola produk, dan capai target bisnis lebih efektif.",
    },
    {
      "title": "Pantau Laporan\nPenjualan Real-time",
      "subtitle": "Analisis grafik perkembangan bisnis mingguan dan bulanan dengan akurat.",
    },
    {
      "title": "Capai Target\nBisnis Lebih Cepat",
      "subtitle": "Atur sasaran penjualan Anda dan pantau persentase pencapaian dalam satu dasbor.",
    }
  ];

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Spacing / Optional skip area
                const SizedBox(height: 20),

                // Page View containing illustration & text
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Illustration Placeholder box matching Mockup 2
                          Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              color: context.cardBg.withValues(alpha: 0.7), // Transparent card
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: context.borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: CustomPaint(
                                size: const Size(180, 180),
                                painter: OnboardingVectorPainter(step: index, isDark: context.isDark),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            data["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              data["subtitle"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? context.textPrimary
                            : context.borderColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Bottom buttons matching Mockup 2
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _onNext,
                    child: Text(
                      _currentPage == _onboardingData.length - 1
                          ? "Mulai Sekarang"
                          : "Selanjutnya",
                      style: TextStyle(
                        color: context.isDark ? context.textPrimary : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Skip button "Lewati"
                TextButton(
                  onPressed: _navigateToLogin,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    "Lewati",
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingVectorPainter extends CustomPainter {
  final int step;
  final bool isDark;
  OnboardingVectorPainter({required this.step, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final basePaint = Paint()
      ..color = isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1) // Adaptive grey line
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = isDark ? const Color(0xFF334155).withValues(alpha: 0.4) : const Color(0xFF94A3B8).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = const Color(0xFF0D9488) // Teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (step == 0) {
      // Step 1: Manage Business easily
      // Centered head circle
      canvas.drawCircle(Offset(w * 0.5, h * 0.38), 32, fillPaint);
      canvas.drawCircle(Offset(w * 0.5, h * 0.38), 32, basePaint);

      // Centered and symmetric shoulder curve (hill)
      final hillPath = Path()
        ..moveTo(w * 0.2, h * 0.8)
        ..quadraticBezierTo(w * 0.5, h * 0.55, w * 0.8, h * 0.8)
        ..lineTo(w * 0.8, h * 0.9)
        ..lineTo(w * 0.2, h * 0.9)
        ..close();
      canvas.drawPath(hillPath, fillPaint);
      canvas.drawPath(hillPath, basePaint);

      // Decorative dot (teal ring)
      canvas.drawCircle(Offset(w * 0.75, h * 0.35), 8, accentPaint);
    } else if (step == 1) {
      // Step 2: Analytics graphs
      // Draw 3 growing bars with a growth trend line
      double bw = w * 0.18;
      double sp = w * 0.08;

      // Draw bars
      canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.6, bw, h * 0.25), fillPaint);
      canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.6, bw, h * 0.25), basePaint);

      canvas.drawRect(Rect.fromLTWH(w * 0.2 + bw + sp, h * 0.45, bw, h * 0.4), fillPaint);
      canvas.drawRect(Rect.fromLTWH(w * 0.2 + bw + sp, h * 0.45, bw, h * 0.4), basePaint);

      canvas.drawRect(Rect.fromLTWH(w * 0.2 + 2 * (bw + sp), h * 0.3, bw, h * 0.55), fillPaint);
      canvas.drawRect(Rect.fromLTWH(w * 0.2 + 2 * (bw + sp), h * 0.3, bw, h * 0.55), basePaint);

      // Trend Line
      final path = Path()
        ..moveTo(w * 0.1, h * 0.75)
        ..lineTo(w * 0.29, h * 0.65)
        ..lineTo(w * 0.55, h * 0.48)
        ..lineTo(w * 0.85, h * 0.25);
      canvas.drawPath(path, accentPaint);
      canvas.drawCircle(Offset(w * 0.85, h * 0.25), 6, Paint()..color = const Color(0xFF0D9488));
    } else {
      // Step 3: Target bullseye
      // Draw concentric target circles
      canvas.drawCircle(Offset(w / 2, h / 2), 64, fillPaint);
      canvas.drawCircle(Offset(w / 2, h / 2), 64, basePaint);
      canvas.drawCircle(Offset(w / 2, h / 2), 40, basePaint);
      canvas.drawCircle(Offset(w / 2, h / 2), 18, Paint()..color = const Color(0xFF0D9488));

      // Dart arrow
      final arrowPath = Path()
        ..moveTo(w * 0.8, h * 0.2)
        ..lineTo(w * 0.58, h * 0.42);
      canvas.drawPath(arrowPath, accentPaint);
      // arrowhead
      final head = Path()
        ..moveTo(w * 0.56, h * 0.44)
        ..lineTo(w * 0.62, h * 0.4)
        ..lineTo(w * 0.6, h * 0.46)
        ..close();
      canvas.drawPath(head, Paint()..color = const Color(0xFF0D9488));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

