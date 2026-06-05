import 'package:flutter/material.dart';
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
      "subtitle": "Pantau penjualan, kelola produk, dan capai target bisnis lebih efektif dalam satu dasbor.",
      "imageIcon": "business"
    },
    {
      "title": "Pantau Laporan\nPenjualan Real-time",
      "subtitle": "Analisis grafik perkembangan bisnis mingguan dan bulanan dengan akurat.",
      "imageIcon": "analytics"
    },
    {
      "title": "Capai Target\nBisnis Lebih Cepat",
      "subtitle": "Atur sasaran penjualan Anda dan pantau persentase pencapaian dengan fitur AI strategy.",
      "imageIcon": "target"
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    "Lewati",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Page View
              SizedBox(
                height: 380,
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
                        // Illustration Placeholder
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Center(
                            child: Icon(
                              _getIconForType(data["imageIcon"]!),
                              color: const Color(0xFF14B8A6),
                              size: 72,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          data["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Spacer(),

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
                      color: _currentPage == index ? const Color(0xFF14B8A6) : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Bottom Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF14B8A6)],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _onNext,
                  child: Text(
                    _currentPage == _onboardingData.length - 1 ? "Mulai Sekarang" : "Selanjutnya",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case "business":
        return Icons.auto_graph_rounded;
      case "analytics":
        return Icons.insights_rounded;
      case "target":
        return Icons.track_changes_rounded;
      default:
        return Icons.business_center_rounded;
    }
  }
}
