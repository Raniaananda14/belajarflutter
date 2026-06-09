import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingView()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background subtle aesthetic gradients
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D9488).withOpacity(0.04), // Soft Teal glow
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withOpacity(0.04), // Soft Indigo glow
                ),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Redesigned BizGrow Logo to match Mockup 1
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: CustomPaint(
                          size: const Size(100, 100),
                          painter: BizGrowLogoPainter(isDark: context.isDark),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "BizGrow",
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Grow Your Business\nGrow Your Future",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Page indicators / loader at bottom as shown in Mockup 1
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.textPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BizGrowLogoPainter extends CustomPainter {
  final bool isDark;
  BizGrowLogoPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Drawing the mockup logo: three vertical bars growing and an upward arrow
    final paintBar1 = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1) // Adaptive bar colors
      ..style = PaintingStyle.fill;

    final paintBar2 = Paint()
      ..color = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)
      ..style = PaintingStyle.fill;

    final paintBar3 = Paint()
      ..color = isDark ? const Color(0xFF64748B) : const Color(0xFF475569)
      ..style = PaintingStyle.fill;

    final paintArrow = Paint()
      ..color = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A) // Slate 900 / Main accent
      ..style = PaintingStyle.fill;

    // Dimensions
    double w = size.width;
    double h = size.height;
    double barWidth = w * 0.16;
    double spacing = w * 0.08;

    // Draw Bar 1
    double bar1Left = w * 0.16;
    double bar1Height = h * 0.35;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar1Left, h - bar1Height - 10, barWidth, bar1Height),
        const Radius.circular(6),
      ),
      paintBar1,
    );

    // Draw Bar 2
    double bar2Left = bar1Left + barWidth + spacing;
    double bar2Height = h * 0.6;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar2Left, h - bar2Height - 10, barWidth, bar2Height),
        const Radius.circular(6),
      ),
      paintBar2,
    );

    // Draw Bar 3 (with arrow integration)
    double bar3Left = bar2Left + barWidth + spacing;
    double bar3Height = h * 0.85;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar3Left, h - bar3Height - 10, barWidth, bar3Height),
        const Radius.circular(6),
      ),
      paintBar3,
    );

    // Draw rising arrow on top of Bar 3
    final path = Path();
    double arrowBaseY = h - bar3Height - 10;
    
    // Triangle arrow head pointing up-right
    path.moveTo(bar3Left - 2, arrowBaseY + 8); // bottom-left
    path.lineTo(bar3Left + barWidth / 2, arrowBaseY - 8); // tip of arrow
    path.lineTo(bar3Left + barWidth + 2, arrowBaseY + 8); // bottom-right
    path.close();

    canvas.drawPath(path, paintArrow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
