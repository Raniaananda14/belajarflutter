/// ======================================================
/// ONBOARDING SCREEN - BIZGROW
/// ======================================================
library;

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Track Your Business",
      "description":
          "Pantau perkembangan bisnis secara realtime dengan dashboard modern.",
      "image": "https://images.unsplash.com/photo-1551288049-bebda4e38f71",
    },

    {
      "title": "Smart Business Analytics",
      "description":
          "Lihat laporan penjualan dan performa bisnis dengan visual premium.",
      "image": "https://images.unsplash.com/photo-1460925895917-afdab827c52f",
    },

    {
      "title": "Grow Your UMKM",
      "description":
          "Kembangkan bisnis UMKM dengan strategi dan insight modern.",
      "image": "https://images.unsplash.com/photo-1520607162513-77705c0f0d4a",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F5),

      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "BizGrow",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},

                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// ================= PAGEVIEW
            Expanded(
              child: PageView.builder(
                controller: pageController,

                itemCount: onboardingData.length,

                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  final data = onboardingData[index];

                  return Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [
                        /// ================= CARD
                        Container(
                          width: double.infinity,
                          height: 380,

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(28),
                          ),

                          child: Column(
                            children: [
                              /// TOP MINI CARD
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 60,

                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F4F4),

                                        borderRadius: BorderRadius.circular(14),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(10),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            const Icon(
                                              Icons.show_chart,
                                              size: 16,
                                              color: Colors.black,
                                            ),

                                            const SizedBox(height: 8),

                                            Container(
                                              width: 40,
                                              height: 5,

                                              decoration: BoxDecoration(
                                                color: Colors.black12,

                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            Container(
                                              width: 60,
                                              height: 10,

                                              decoration: BoxDecoration(
                                                color: Colors.black,

                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Container(
                                      height: 60,

                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F4F4),

                                        borderRadius: BorderRadius.circular(14),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(10),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            const Icon(
                                              Icons.show_chart,
                                              size: 16,
                                              color: Colors.black,
                                            ),

                                            const SizedBox(height: 8),

                                            Container(
                                              width: 40,
                                              height: 5,

                                              decoration: BoxDecoration(
                                                color: Colors.black12,

                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            Container(
                                              width: 30,
                                              height: 10,

                                              decoration: BoxDecoration(
                                                color: Colors.black,

                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              /// BLACK CARD
                              Container(
                                width: double.infinity,

                                height: 80,

                                decoration: BoxDecoration(
                                  color: Colors.black,

                                  borderRadius: BorderRadius.circular(18),
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Container(
                                            width: 90,
                                            height: 12,

                                            decoration: BoxDecoration(
                                              color: Colors.white,

                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          Container(
                                            width: 120,
                                            height: 14,

                                            decoration: BoxDecoration(
                                              color: Colors.white,

                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        width: 42,
                                        height: 42,

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),

                                          border: Border.all(
                                            color: Colors.white24,
                                          ),
                                        ),

                                        child: const Icon(
                                          Icons.auto_graph_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              /// IMAGE
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),

                                  child: Image.network(
                                    data["image"]!,

                                    width: double.infinity,

                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// TITLE
                        Text(
                          data["title"]!,

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// DESCRIPTION
                        Text(
                          data["description"]!,

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// INDICATOR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: List.generate(onboardingData.length, (
                            index,
                          ) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),

                              margin: const EdgeInsets.symmetric(horizontal: 4),

                              width: currentPage == index ? 22 : 6,

                              height: 6,

                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? Colors.black
                                    : Colors.black26,

                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }),
                        ),

                        const Spacer(),

                        /// NEXT BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 58,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            onPressed: () {
                              /// NEXT PAGE
                              if (currentPage < onboardingData.length - 1) {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),

                                  curve: Curves.easeInOut,
                                );
                              } else {
                                /// PINDAH KE LOGIN
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              }
                            },

                            child: Text(
                              currentPage == onboardingData.length - 1
                                  ? "Get Started"
                                  : "Next",

                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 16,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// LEARN MORE
                        GestureDetector(
                          onTap: () {},

                          child: const Text(
                            "Learn more",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======================================================
/// LOGIN SCREEN
/// ======================================================

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: const Center(
        child: Text(
          "Login Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
