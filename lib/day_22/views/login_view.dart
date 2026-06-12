import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/main_navigation.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<String> _securityQuestions = [
    "Apa nama hewan peliharaan pertama Anda?",
    "Di kota mana Anda lahir?",
    "Apa nama sekolah dasar pertama Anda?",
    "Siapa nama ibu kandung Anda?",
    "Apa makanan favorit Anda?",
  ];

  void _showTopSnackBar(BuildContext ctx, String message, {bool isError = true}) {
    ScaffoldMessenger.of(ctx).clearSnackBars();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).size.height - 110,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext ctx, String message, {Color? backgroundColor, Duration duration = const Duration(milliseconds: 4000)}) {
    ScaffoldMessenger.of(ctx).clearSnackBars();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    // A small artificial delay for premium feel
    await Future.delayed(const Duration(milliseconds: 600));

    // Bersihkan sesi sebelumnya terlebih dahulu
    await SessionManager.clear();

    final user = await DBHelper().loginUser(email, pass);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      await SessionManager.saveUser(
        name: user.nama,
        email: user.email,
        nik: user.nik,
        role: user.role,
        profileImage: user.profileImage,
      );

      // Handle Guest / Owner specific business info
      if (user.email == "tamu@example.com") {
        await SessionManager.updateBusinessInfo("Tamu / Personal");
      } else if (user.email == "rania@gmail.com") {
        if (SessionManager.businessInfo == "Tamu / Personal") {
          await SessionManager.updateBusinessInfo("BizGrow Jakarta Barat");
        }
      }

      if (!mounted) return;

      _showSnackBar(
        context,
        "Selamat datang kembali, ${user.nama}! 👋",
        backgroundColor: const Color(0xFF10B981),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      _showSnackBar(
        context,
        "Email atau Password salah!",
        backgroundColor: const Color(0xFFEF4444),
      );
    }
  }

  void _showForgotPasswordSheet(BuildContext context) {
    final emailController = TextEditingController();
    final answerController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool isVerifying = false;
    
    // Security question states
    bool isEmailVerified = false;
    String userQuestion = "";
    String correctSecurityAnswer = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.borderColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.lock_reset_rounded, color: Color(0xFF0D9488), size: 30),
                        const SizedBox(width: 8),
                        Text(
                          "Atur Ulang Sandi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isEmailVerified 
                          ? "Jawab pertanyaan keamanan Anda untuk menyetel kata sandi baru."
                          : "Masukkan email Anda untuk mengambil pertanyaan keamanan akun.",
                      style: TextStyle(fontSize: 13, color: context.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    
                    // Email input (read-only if verified)
                    Text(
                      "Email Akun",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      enabled: !isEmailVerified,
                      style: TextStyle(color: isEmailVerified ? context.textMuted : context.textPrimary),
                      decoration: _buildInputDecoration(context: context, hintText: "email@example.com"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!value.contains("@")) {
                          return "Format email tidak valid";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    if (!isEmailVerified) ...[
                      // Verify Email Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isVerifying ? null : () async {
                            if (!formKey.currentState!.validate()) return;
                            setModalState(() {
                              isVerifying = true;
                            });

                            final email = emailController.text.trim();
                            final user = await DBHelper().getUserByEmail(email);

                            setModalState(() {
                              isVerifying = false;
                            });

                            if (user == null) {
                              _showTopSnackBar(context, "Email '$email' tidak terdaftar!");
                              return;
                            }

                            // Check if security question is set
                            if (user.securityQuestion == null || user.securityQuestion!.isEmpty) {
                              // Old seed user bypass or message
                              setModalState(() {
                                userQuestion = "Bypass Keamanan: (User lama belum menyetel pertanyaan. Ketik 'bypass' untuk melanjutkan)";
                                correctSecurityAnswer = "bypass";
                                isEmailVerified = true;
                              });
                            } else {
                              setModalState(() {
                                userQuestion = user.securityQuestion!;
                                correctSecurityAnswer = user.securityAnswer ?? "";
                                isEmailVerified = true;
                              });
                            }
                          },
                          child: isVerifying
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Verifikasi Email",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ] else ...[
                      // Security Question text label
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0D9488).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pertanyaan Keamanan:",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userQuestion,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Answer Input
                      Text(
                        "Jawaban Keamanan Anda",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: answerController,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _buildInputDecoration(context: context, hintText: "Masukkan jawaban Anda"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Jawaban keamanan wajib diisi";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // New Password Input
                      Text(
                        "Kata Sandi Baru",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: newPasswordController,
                        style: TextStyle(color: context.textPrimary),
                        obscureText: obscureNew,
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "••••••••",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: context.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setModalState(() {
                                obscureNew = !obscureNew;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Kata sandi baru tidak boleh kosong";
                          }
                          if (value.length < 6) {
                            return "Kata sandi minimal 6 karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Input
                      Text(
                        "Konfirmasi Kata Sandi Baru",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: confirmPasswordController,
                        style: TextStyle(color: context.textPrimary),
                        obscureText: obscureConfirm,
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "••••••••",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: context.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setModalState(() {
                                obscureConfirm = !obscureConfirm;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Konfirmasi kata sandi tidak boleh kosong";
                          }
                          if (value != newPasswordController.text) {
                            return "Kata sandi tidak cocok";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Reset Password Submit Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isVerifying ? null : () async {
                            if (!formKey.currentState!.validate()) return;
                            
                            // Check answer (case-insensitive, trimmed)
                            final ans = answerController.text.trim();
                            if (ans.toLowerCase() != correctSecurityAnswer.toLowerCase()) {
                              _showTopSnackBar(context, "Verifikasi Gagal: Jawaban keamanan Anda salah!");
                              return;
                            }

                            setModalState(() {
                              isVerifying = true;
                            });

                            final email = emailController.text.trim();
                            final newPass = newPasswordController.text;

                            final success = await DBHelper().updateUserPassword(email, newPass);
                            
                            if (context.mounted) {
                              Navigator.pop(context);
                              _showTopSnackBar(
                                context,
                                success
                                    ? "Kata sandi untuk $email berhasil diatur ulang! silakan masuk."
                                    : "Gagal memperbarui kata sandi. Silakan coba lagi.",
                                isError: !success,
                              );
                            }
                          },
                          child: isVerifying
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Ubah Kata Sandi",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Selamat Datang 👋",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Masuk untuk melanjutkan",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Email Input
                    Text(
                      "Email atau No. HP",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: context.textPrimary),
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: "admin@example.com",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kata Sandi",
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showForgotPasswordSheet(context);
                          },
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(
                              color: Color(0xFF0D9488), // Teal 600
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: context.textPrimary),
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: "••••••••",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: context.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Login Button (Black rounded block button)
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
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.isDark
                                        ? context.textPrimary
                                        : Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Masuk",
                                style: TextStyle(
                                  color: context.isDark
                                      ? context.textPrimary
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.textPrimary,
                              side: BorderSide(color: context.borderColor, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              // Register tamu in DB if not exists
                              var user = await DBHelper().getUserByEmail("tamu@example.com");
                              if (user == null) {
                                final newUser = UserModelBizgrow(
                                  nama: "Tamu",
                                  email: "tamu@example.com",
                                  password: "password123",
                                  nik: "TAMU-GUEST-999",
                                  role: "Pembeli",
                                );
                                await DBHelper().registerUser(newUser);
                              } else if (user.nik == "1234567890123456") {
                                // Update existing guest NIK if it is still the default one
                                await DBHelper().updateUser(
                                  "tamu@example.com",
                                  "Tamu",
                                  "tamu@example.com",
                                  "TAMU-GUEST-999",
                                );
                              }
                              // Fill text fields
                              setState(() {
                                _emailController.text = "tamu@example.com";
                                _passwordController.text = "password123";
                              });
                              if (context.mounted) {
                                _showSnackBar(
                                  context,
                                  "Kredensial Tamu terisi. Silakan ketuk tombol Masuk!",
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline_rounded, size: 18, color: context.textPrimary),
                                const SizedBox(width: 8),
                                Text(
                                  "Masuk Tamu",
                                  style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D9488), // Teal
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              // Register owner in DB if not exists
                              var user = await DBHelper().getUserByEmail("rania@gmail.com");
                              if (user == null) {
                                final newUser = UserModelBizgrow(
                                  nama: "Rania Ananda",
                                  email: "rania@gmail.com",
                                  password: "password123",
                                  nik: "1234567890123456",
                                  role: "Owner",
                                );
                                await DBHelper().registerUser(newUser);
                              }
                              // Fill text fields
                              setState(() {
                                _emailController.text = "rania@gmail.com";
                                _passwordController.text = "password123";
                              });
                              if (context.mounted) {
                                _showSnackBar(
                                  context,
                                  "Kredensial Owner terisi. Silakan ketuk tombol Masuk!",
                                  duration: const Duration(seconds: 2),
                                );
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.admin_panel_settings_outlined, size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Masuk Owner",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: context.borderColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "atau masuk dengan",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: context.borderColor)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Logins (Google & Apple)
                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            "Google",
                            "assets/google_logo.png", // fallback text icon if asset not loaded
                            Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSocialButton(
                            "Apple",
                            "assets/apple_logo.png",
                            context.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Sign Up Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: TextStyle(color: context.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => _showRegisterSheet(context),
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              color: Color(0xFF0D9488), // Teal
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: context.textMuted),
      filled: true,
      fillColor: context.inputBg.withOpacity(
        0.7,
      ), // Blend with gradient background
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.textPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }

  Widget _buildSocialButton(
    String label,
    String assetPath,
    Color iconColor,
  ) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: context.cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: InkWell(
        onTap: () async {
          if (label == "Google") {
            _showGoogleAccountChooser(context);
          } else {
            final String email = "apple_user@icloud.com";
            final String name = "Apple User";
            _performSocialLogin(email, name, "Apple");
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              label == "Google"
                  ? Icons.g_mobiledata_rounded
                  : Icons.apple_rounded,
              color: iconColor,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSocialLogin(String email, String name, String provider) async {
    // Bersihkan sesi sebelumnya terlebih dahulu
    await SessionManager.clear();

    var user = await DBHelper().getUserByEmail(email);
    if (user == null) {
      final newUser = UserModelBizgrow(
        nama: name,
        email: email,
        password: "social_login_password",
        nik: "",
        role: email == "rania@gmail.com" ? "Owner" : "Pembeli",
      );
      await DBHelper().registerUser(newUser);
      user = await DBHelper().getUserByEmail(email);
    }

    if (user != null) {
      await SessionManager.saveUser(
        name: user.nama,
        email: user.email,
        nik: user.nik,
        role: user.role,
        profileImage: user.profileImage,
      );
      
      // Set guest/personal business info for social logins (except Owner)
      if (user.role == "Owner") {
        await SessionManager.updateBusinessInfo("BizGrow Jakarta Barat");
      } else {
        await SessionManager.updateBusinessInfo("Tamu / Personal");
      }

      if (!mounted) return;

      _showSnackBar(
        context,
        "Masuk otomatis via $provider: ${user.nama} 👋",
        backgroundColor: const Color(0xFF10B981),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  void _showGoogleAccountChooser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.borderColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata_rounded, color: Colors.redAccent, size: 36),
                      SizedBox(width: 4),
                      Text(
                        "Pilih Akun Google",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "untuk melanjutkan ke BizGrow",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildGoogleAccountTile(
                    name: "Rania Ananda",
                    email: "rania@gmail.com",
                    avatarInitials: "RA",
                    onTap: () {
                      Navigator.pop(context);
                      _performSocialLogin("rania@gmail.com", "Rania Ananda", "Google");
                    },
                  ),
                  const Divider(),
                  _buildGoogleAccountTile(
                    name: "Tamu",
                    email: "tamu@example.com",
                    avatarInitials: "T",
                    onTap: () {
                      Navigator.pop(context);
                      _performSocialLogin("tamu@example.com", "Tamu", "Google");
                    },
                  ),
                  const Divider(),
                  _buildGoogleAccountTile(
                    name: "Alex Cooper",
                    email: "alex.cooper@gmail.com",
                    avatarInitials: "AC",
                    onTap: () {
                      Navigator.pop(context);
                      _performSocialLogin("alex.cooper@gmail.com", "Alex Cooper", "Google");
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.inputBg,
                      child: Icon(Icons.person_add_alt_1_rounded, color: context.iconColor, size: 20),
                    ),
                    title: const Text(
                      "Gunakan akun lain",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                    onTap: () {
                      Navigator.pop(context);
                      _showCustomEmailGoogleLoginDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoogleAccountTile({
    required String name,
    required String email,
    required String avatarInitials,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.1),
        child: Text(
          avatarInitials,
          style: const TextStyle(
            color: Color(0xFF0D9488),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        email,
        style: TextStyle(fontSize: 12, color: context.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
      onTap: onTap,
    );
  }

  void _showCustomEmailGoogleLoginDialog() {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: this.context.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.g_mobiledata_rounded, color: Colors.redAccent, size: 32),
              SizedBox(width: 8),
              Text("Google Sign-In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  style: TextStyle(color: this.context.textPrimary),
                  decoration: _buildInputDecoration(context: this.context, hintText: "Nama Pengguna"),
                  validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: this.context.textPrimary),
                  decoration: _buildInputDecoration(context: this.context, hintText: "nama@gmail.com"),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Email wajib diisi";
                    if (!v.contains("@")) return "Format email tidak valid";
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: TextStyle(color: this.context.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final email = emailController.text.trim();
                final name = nameController.text.trim();
                Navigator.pop(context);
                _performSocialLogin(email, name, "Google");
              },
              child: const Text("Masuk", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditionsSheet(
    BuildContext context,
    UserModelBizgrow userToRegister,
    String rawPassword,
    VoidCallback onSuccess,
  ) {
    bool isAgreed = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: context.borderColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Syarat & Ketentuan BizGrow",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.inputBg.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.borderColor),
                          ),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Text(
                                "Selamat datang di BizGrow. Dengan mendaftar akun di aplikasi kami, Anda menyetujui kepatuhan penuh terhadap Syarat dan Ketentuan berikut:\n\n"
                                "1. Penggunaan Akun\n"
                                "Anda bertanggung jawab untuk menjaga kerahasiaan kata sandi Anda dan informasi akun lainnya. Segala aktivitas yang terjadi di bawah akun Anda adalah tanggung jawab Anda sepenuhnya.\n\n"
                                "2. Kebijakan Privasi\n"
                                "Kami menghargai privasi data Anda. Informasi pendaftaran seperti nama, email, dan nomor telepon disimpan dengan aman untuk memfasilitasi transaksi dan autentikasi dua faktor.\n\n"
                                "3. Ketentuan Penjual & Pembeli\n"
                                "Pengguna yang terdaftar sebagai Owner (Penjual) setuju untuk menyediakan informasi stok produk yang akurat. Pembeli setuju untuk melakukan pembayaran secara jujur menggunakan metode pembayaran yang disediakan.\n\n"
                                "4. Batasan Tanggung Jawab\n"
                                "BizGrow tidak bertanggung jawab atas kerugian tidak langsung atau masalah yang disebabkan oleh penyedia layanan pihak ketiga seperti jaringan internet atau perbankan virtual account.\n\n"
                                "Kami berhak menangguhkan akun yang melanggar ketentuan atau terlibat dalam aktivitas mencurigakan. Dengan menyetujui, Anda siap mematuhi aturan ini demi kenyamanan bersama.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: isAgreed,
                            activeColor: const Color(0xFF0D9488),
                            onChanged: (val) {
                              setModalState(() {
                                isAgreed = val ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              "Saya setuju dengan Syarat & Ketentuan yang berlaku",
                              style: TextStyle(
                                fontSize: 13,
                                color: context.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isAgreed
                              ? () async {
                                  final success = await DBHelper().registerUser(userToRegister);
                                  if (success) {
                                    if (!context.mounted) return;
                                    Navigator.pop(context); // Close T&C sheet
                                    onSuccess();
                                  } else {
                                    if (!context.mounted) return;
                                    _showTopSnackBar(context, "Pendaftaran gagal! Silakan coba lagi.");
                                  }
                                }
                              : null,
                          child: const Text(
                            "Saya Setuju & Lanjutkan",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showRegisterSheet(BuildContext context) {
    final regFormKey = GlobalKey<FormState>();
    final nameReg = TextEditingController();
    final emailReg = TextEditingController();
    final phoneReg = TextEditingController();
    final passReg = TextEditingController();
    final answerReg = TextEditingController();
    bool isRegObscure = true;
    String selectedRole = "Pembeli";
    String? selectedQuestion;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: regFormKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Akun Baru',
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: context.iconColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Nama Lengkap
                      Text(
                        "Nama Lengkap",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameReg,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Nama Lengkap",
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Nama Lengkap wajib diisi" : null,
                      ),
                      const SizedBox(height: 12),

                      // Email
                      Text(
                        "Email",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailReg,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Email",
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Email wajib diisi";
                          if (!v.contains("@")) return "Format email tidak valid";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Nomor Telepon (saved in nik field)
                      Text(
                        "Nomor Telepon",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: phoneReg,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Nomor Telepon",
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Nomor telepon wajib diisi";
                          if (v.length < 9) return "Nomor telepon minimal 9 digit";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Kata Sandi
                      Text(
                        "Kata Sandi",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passReg,
                        obscureText: isRegObscure,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Kata Sandi",
                          suffixIcon: IconButton(
                            icon: Icon(
                              isRegObscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: context.textSecondary,
                            ),
                            onPressed: () {
                              setModalState(() {
                                isRegObscure = !isRegObscure;
                              });
                            },
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Kata sandi wajib diisi";
                          if (v.length < 6) return "Kata sandi minimal 6 karakter";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Role Dropdown
                      Text(
                        "Peran (Role)",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        dropdownColor: context.cardBg,
                        style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Pilih Peran (Role)",
                        ),
                        items: const [
                          DropdownMenuItem(value: "Pembeli", child: Text("Pembeli (Hanya Belanja)")),
                          DropdownMenuItem(value: "Owner", child: Text("Owner (Kelola Toko)")),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedRole = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Security Question Dropdown
                      Text(
                        "Pertanyaan Keamanan",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedQuestion,
                        dropdownColor: context.cardBg,
                        isExpanded: true,
                        style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Pilih Pertanyaan Keamanan",
                        ),
                        items: _securityQuestions
                            .map((q) => DropdownMenuItem(
                                  value: q,
                                  child: Text(q, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedQuestion = val;
                            });
                          }
                        },
                        validator: (v) => v == null ? "Pilih salah satu pertanyaan keamanan" : null,
                      ),
                      const SizedBox(height: 12),

                      // Security Answer
                      Text(
                        "Jawaban Keamanan Anda",
                        style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: answerReg,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: "Masukkan jawaban Anda",
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? "Jawaban keamanan wajib diisi" : null,
                      ),
                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488), // Teal
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (!regFormKey.currentState!.validate()) return;

                            final email = emailReg.text.trim();
                            // Check unique email
                            final existingUser = await DBHelper().getUserByEmail(email);
                            if (existingUser != null) {
                              if (!context.mounted) return;
                              _showTopSnackBar(context, "Registrasi Gagal: Email '$email' sudah terdaftar!");
                              return;
                            }

                            final userToRegister = UserModelBizgrow(
                              nama: nameReg.text.trim(),
                              email: email,
                              password: passReg.text,
                              nik: phoneReg.text.trim(), // Storing phone number in NIK
                              role: selectedRole,
                              securityQuestion: selectedQuestion,
                              securityAnswer: answerReg.text.trim(),
                            );

                            if (!context.mounted) return;
                            
                            // Show Terms & Conditions Sheet
                            _showTermsAndConditionsSheet(
                              context,
                              userToRegister,
                              passReg.text,
                              () {
                                // On T&C accepted and successfully registered
                                Navigator.pop(context); // Close Registration bottom sheet
                                _showTopSnackBar(
                                  context,
                                  "Registrasi Sukses! Silakan masuk.",
                                  isError: false,
                                );
                                setState(() {
                                  _emailController.text = email;
                                  _passwordController.text = passReg.text;
                                });
                              },
                            );
                          },
                          child: const Text(
                            'Simpan Pendaftaran',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

