import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Background & card surfaces
  Color get surfaceColor => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get scaffoldBg =>
      isDark ? const Color(0xFF030712) : const Color(0xFFFAFBFC);
  Color get cardBg => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get inputBg =>
      isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC);
  Color get buttonBg =>
      isDark ? const Color(0xFF334155) : const Color(0xFF1E293B);

  // Border & dividers
  Color get borderColor =>
      isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get dividerColor =>
      isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

  // Text colors
  Color get textPrimary =>
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  Color get textSecondary =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get textMuted =>
      isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  // Icon colors
  Color get iconColor =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
  Color get iconPrimary =>
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
}

class ElegantBackground extends StatelessWidget {
  final Widget child;
  const ElegantBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    // Premium dark/light color themes for blobs matching cosmic night sky
    final baseBgColor = context.scaffoldBg;

    final blob1Colors = isDark
        ? [
            const Color(0xFF0284C7).withOpacity(0.35),
            const Color(0xFF0284C7).withOpacity(0.0),
          ] // Sky blue/cyan glow
        : [
            const Color(0xFFFFFBEB).withOpacity(0.5),
            const Color(0xFFFFFBEB).withOpacity(0.0),
          ]; // Ultra soft cream/gold

    final blob2Colors = isDark
        ? [
            const Color(0xFF1E3A8A).withOpacity(0.4),
            const Color(0xFF1E3A8A).withOpacity(0.0),
          ] // Deep indigo/sapphire glow
        : [
            const Color(0xFFE6FFFA).withOpacity(0.55),
            const Color(0xFFE6FFFA).withOpacity(0.0),
          ]; // Ultra soft aquamarine/teal

    final blob3Colors = isDark
        ? [
            const Color(0xFF0EA5E9).withOpacity(0.35),
            const Color(0xFF0EA5E9).withOpacity(0.0),
          ] // Light cyan/nebula blue
        : [
            const Color(0xFFEEF2FF).withOpacity(0.6),
            const Color(0xFFEEF2FF).withOpacity(0.0),
          ]; // Ultra soft indigo/lavender

    final blob4Colors = isDark
        ? [
            const Color(0xFF312E81).withOpacity(0.4),
            const Color(0xFF312E81).withOpacity(0.0),
          ] // Deep cosmic navy/purple glow
        : [
            const Color(0xFFFFF1F2).withOpacity(0.55),
            const Color(0xFFFFF1F2).withOpacity(0.0),
          ]; // Ultra soft rose

    final glassOverlayColor = isDark
        ? Colors.black.withOpacity(0.2)
        : Colors.white.withOpacity(0.3); // cleaner, more frosted glass

    final baseBgDecoration = isDark
        ? const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF020617), // Pitch black at the top
                Color(0xFF0A0F24), // Rich midnight blue in the center
                Color(0xFF020617), // Pitch black at the bottom
              ],
            ),
          )
        : const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF), // Crisp pure white
                Color(0xFFF8FAFC), // Off-white/slate-50
                Color(0xFFF1F5F9), // Very light cool grey/slate-100
              ],
            ),
          );

    return Stack(
      children: [
        // Base backdrop color
        Container(decoration: baseBgDecoration),

        // Blob 1: Soft Mint/Emerald (Top Left)
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: blob1Colors),
            ),
          ),
        ),

        // Blob 2: Vibrant Cyan/Sky Blue (Middle Right)
        Positioned(
          top: 150,
          right: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: blob2Colors),
            ),
          ),
        ),

        // Blob 3: Soft Lavender/Lilac (Bottom Left)
        Positioned(
          top: null, // clear top
          bottom: -120,
          left: -80,
          child: Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: blob3Colors),
            ),
          ),
        ),

        // Blob 4: Soft Rose (Middle Left Accent)
        Positioned(
          top: null, // clear top
          bottom: 250,
          left: -160,
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: blob4Colors),
            ),
          ),
        ),

        // Glassmorphic Blur Filter Overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 85, sigmaY: 85),
            child: Container(color: glassOverlayColor),
          ),
        ),

        // Premium Cosmic Starry Sky / Wave Overlay
        Positioned.fill(
          child: CustomPaint(painter: StarrySkyPainter(isDark: isDark)),
        ),

        // Screen Content
        Positioned.fill(child: child),
      ],
    );
  }
}

class StarrySkyPainter extends CustomPainter {
  final bool isDark;
  const StarrySkyPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      // Light mode: elegant premium dot pattern
      final paint = Paint()
        ..color = const Color(0xFF64748B).withOpacity(0.035)
        ..style = PaintingStyle.fill;

      const double spacing = 24.0;
      const double dotRadius = 0.8;

      for (double x = 0; x < size.width; x += spacing) {
        for (double y = 0; y < size.height; y += spacing) {
          canvas.drawCircle(Offset(x, y), dotRadius, paint);
        }
      }

      // Draw elegant, flowing fluid lines (waves) for a high-end designer feel
      final wavePaint1 = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..shader = const LinearGradient(
          colors: [
            Color(0x020D9488), // Almost invisible teal
            Color(0x180D9488), // Subtle teal highlight
            Color(0x0C6366F1), // Subtle indigo
            Color(0x026366F1), // Fade
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final wavePaint2 = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..shader = const LinearGradient(
          colors: [
            Color(0x02FF4D94), // Fade
            Color(0x10FF4D94), // Soft rose highlight
            Color(0x0C0EA5E9), // Sky blue
            Color(0x020EA5E9), // Fade
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      // Wave 1 path (smooth sweep across center-right)
      final path1 = Path();
      path1.moveTo(0, size.height * 0.3);
      path1.cubicTo(
        size.width * 0.35,
        size.height * 0.15,
        size.width * 0.65,
        size.height * 0.55,
        size.width,
        size.height * 0.4,
      );
      canvas.drawPath(path1, wavePaint1);

      // Wave 2 path (crossing sweep)
      final path2 = Path();
      path2.moveTo(0, size.height * 0.6);
      path2.cubicTo(
        size.width * 0.4,
        size.height * 0.8,
        size.width * 0.7,
        size.height * 0.35,
        size.width,
        size.height * 0.55,
      );
      canvas.drawPath(path2, wavePaint2);

      return;
    }

    // Dark mode: Starry cosmic background (matching user image color grading)
    final random = Random(42); // Seeded to avoid flickering on redraws

    // Draw 140 stars with diverse sizes, positions, opacities, and tones
    for (int i = 0; i < 140; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;

      // Star radius ranging from fine cosmic dust (0.3) to bright stars (2.2)
      final double radius = random.nextDouble() * 1.6 + 0.3;

      // Star opacity (brightness)
      final double opacity = random.nextDouble() * 0.75 + 0.15;

      // Slight color variation for premium depth (some white, some cyan/blue-tinted)
      final double colorRoll = random.nextDouble();
      Color starColor = Colors.white;
      if (colorRoll > 0.85) {
        starColor = const Color(0xFFBAE6FD); // Sky blue 200
      } else if (colorRoll > 0.7) {
        starColor = const Color(0xFFE0F2FE); // Sky blue 100
      }

      final paint = Paint()
        ..color = starColor.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw soft ambient glow behind the brightest stars
      if (radius > 1.7 && random.nextDouble() > 0.4) {
        final glowPaint = Paint()
          ..color = const Color(0xFF38BDF8).withOpacity(opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
        canvas.drawCircle(Offset(x, y), radius * 3.5, glowPaint);
      }

      // Draw star body core
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarrySkyPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
