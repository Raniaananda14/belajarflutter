import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_12/state12.dart';
import 'package:flutter_application_1/extention/navigator.dart';

void main() {
  runApp(const BizGrowApp());
}

class BizGrowApp extends StatelessWidget {
  const BizGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizGrow',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SplashScreen(),
    );
  }
}

/// ======================================================
/// SPLASH SCREEN
/// ======================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.grey.shade900, Colors.black],
            radius: 1.2,
            center: Alignment.center,
          ),
        ),

        child: Column(
          children: [
            const Spacer(),

            /// LOGO
            Container(
              width: 70,
              height: 70,

              decoration: BoxDecoration(
                color: const Color(0xFF3B3B3B),
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Icon(
                Icons.auto_graph_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(height: 34),

            /// TITLE
            const Text(
              "BizGrow",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            /// SUBTITLE
            const Text(
              "Grow Your Business Smarter",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),

            const SizedBox(height: 30),

            /// LOADING BAR
            Container(
              width: 110,
              height: 4,

              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Container(
                  width: 40,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// FOOTER
            Padding(
              padding: const EdgeInsets.only(bottom: 24),

              child: Text(
                "POWERED BY INTELLIGENT STRATEGY",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 9,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======================================================
/// ONBOARDING SCREEN
/// ======================================================

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
      "title": "Business Analytics",
      "description":
          "Analisa performa bisnis UMKM secara profesional dan modern.",
      "image": "https://images.unsplash.com/photo-1460925895917-afdab827c52f",
    },

    {
      "title": "Grow Your UMKM",
      "description":
          "Kembangkan bisnis dengan strategi premium dan monitoring pintar.",
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
            /// HEADER
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },

                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// PAGEVIEW
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
                        /// CARD
                        Container(
                          width: double.infinity,
                          height: 300,

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(28),
                          ),

                          child: Column(
                            children: [
                              /// MINI CARD
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 56,

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
                                              size: 14,
                                            ),

                                            const SizedBox(height: 8),

                                            Container(
                                              width: 36,
                                              height: 5,

                                              decoration: BoxDecoration(
                                                color: Colors.black12,

                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            Container(
                                              width: 52,
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

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Container(
                                      height: 56,

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
                                              size: 14,
                                            ),

                                            const SizedBox(height: 8),

                                            Container(
                                              width: 36,
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

                                height: 70,

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
                                            width: 80,
                                            height: 10,

                                            decoration: BoxDecoration(
                                              color: Colors.white,

                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          Container(
                                            width: 110,
                                            height: 12,

                                            decoration: BoxDecoration(
                                              color: Colors.white,

                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        width: 40,
                                        height: 40,

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
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

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

                        const SizedBox(height: 34),

                        /// TITLE
                        Text(
                          data["title"]!,

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// DESCRIPTION
                        Text(
                          data["description"]!,

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Colors.black54,

                            fontSize: 12,

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

                              width: currentPage == index ? 20 : 6,

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

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            onPressed: () {
                              if (currentPage < onboardingData.length - 1) {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),

                                  curve: Curves.easeInOut,
                                );
                              } else {
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        GestureDetector(
                          onTap: () {},

                          child: const Text(
                            "Learn more",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
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

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const LoginScreen(),
    theme: ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFFF4F4F4),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_graph,
                          color: Colors.black,
                          size: 55,
                        ),

                        const SizedBox(width: 6),

                        const Text(
                          "BizGrow",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              /// LOGIN CARD
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),

                      /// TITLE
                      const Text(
                        "Sign in to your Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Enter your details to access your growth dashboard.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Email Addres",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "name@company.com",
                                hintStyle: TextStyle(color: Colors.black38),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.black12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.black12),
                                ),

                                filled: true,
                                fillColor: Color(0xFFF4F4F4),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.red),
                                ),

                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email format is not appropriate";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Password",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    "Forgot?",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            TextFormField(
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                hintText: "********",
                                hintStyle: TextStyle(color: Colors.black38),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.black12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.black12),
                                ),

                                filled: true,
                                fillColor: Color(0xFFF4F4F4),

                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),

                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password is incorrecte";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 28),

                            // LOGIN BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),

                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // context.pushReplacement(State12());

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  12,
                                                ),
                                          ),

                                          title: Column(
                                            children: [
                                              Icon(
                                                Icons.verified,
                                                color: Colors.green,
                                                size: 50,
                                              ),
                                              Text(
                                                "Login successful!",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),

                                          backgroundColor: Colors.white,

                                          actions: [
                                            Center(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xFF005BBF,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusGeometry.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context.pushReplacement(
                                                    State12(),
                                                  );
                                                },
                                                child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },

                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// OR LINE
                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: Colors.black12),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(height: 1, color: Colors.black12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// GOOGLE BUTTON
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Text(
                                "Continue with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(),

                      const SizedBox(height: 18),

                      /// REGISTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.black54),
                          ),

                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "© 2026 BizGrow Technologies Inc. By Ranski.",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
