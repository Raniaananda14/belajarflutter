import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Color(0xFF232323)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, color: Colors.white, size: 120),

            const SizedBox(height: 40),

            const Text(
              "Track Your Business Growth",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              "Monitor your UMKM business performance professionally and efficiently.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
