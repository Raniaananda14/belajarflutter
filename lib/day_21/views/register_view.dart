import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_21/database/database_helper.dart';
import 'package:flutter_application_1/day_21/models/user_model.dart';
import 'package:flutter_application_1/day_21/views/login_view.dart';
import 'package:flutter_application_1/extention/navigator.dart';

class Registertugas11 extends StatefulWidget {
  const Registertugas11({super.key});

  @override
  State<Registertugas11> createState() => _Registertugas11State();
}

class _Registertugas11State extends State<Registertugas11> {
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nikController = TextEditingController();

  void register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final pass = passwordController.text;
    final nik = nikController.text.trim();

    final user = UserModelBizgrow(email: email, password: pass, nik: nik);
    bool success = await DBHelper().registerUser(user);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Akun berhasil didaftarkan! Silakan login.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF10B981),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      context.push(const Lamanlogin());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Registrasi gagal! Email mungkin sudah digunakan.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      body: Stack(
        children: [
          // Background Gradient Circles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.15), // Indigo
              ),
              child: const SizedBox(),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF14B8A6).withOpacity(0.15), // Teal
              ),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Brand
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_graph_rounded,
                            color: Color(0xFF14B8A6), // Premium Teal
                            size: 55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "BizGrow",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join us to track and optimize your digital presence.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Card Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Email Field
                            const Text(
                              "Email Address",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "name@company.com",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF14B8A6),
                                    width: 1.5,
                                  ),
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              obscureText: obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF14B8A6),
                                    width: 1.5,
                                  ),
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // NIK Field
                            const Text(
                              "NIK (Nomor Induk Kependudukan)",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              controller: nikController,
                              decoration: InputDecoration(
                                hintText: "Enter 16 digit NIK",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF14B8A6),
                                    width: 1.5,
                                  ),
                                ),
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "NIK cannot be empty";
                                }
                                if (value.length < 10) {
                                  return "NIK must be numeric and valid";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Submit Button
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF14B8A6),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF14B8A6,
                                    ).withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: register,
                                child: const Text(
                                  "Register Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign In Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.white60),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push(const Lamanlogin());
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFF14B8A6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "© 2026 BizGrow Technologies Inc. By Ranski.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
