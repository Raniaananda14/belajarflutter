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

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    // A small artificial delay for premium feel
    await Future.delayed(const Duration(milliseconds: 600));

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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Selamat datang kembali, ${user.nama}! 👋"),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Email atau Password salah!"),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Fitur Lupa Kata Sandi disimulasikan. Gunakan admin@example.com / password123",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
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
                                  nik: "1234567890123456",
                                  role: "Pembeli",
                                );
                                await DBHelper().registerUser(newUser);
                              }
                              // Fill text fields
                              setState(() {
                                _emailController.text = "tamu@example.com";
                                _passwordController.text = "password123";
                              });
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Kredensial Tamu terisi. Silakan ketuk tombol Masuk!"),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
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
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Kredensial Owner terisi. Silakan ketuk tombol Masuk!"),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
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
                            context,
                            "Google",
                            "assets/google_logo.png", // fallback text icon if asset not loaded
                            Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSocialButton(
                            context,
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
    BuildContext context,
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
        onTap: () {
          // Pre-fill credentials for quick interaction
          setState(() {
            _emailController.text = "admin@example.com";
            _passwordController.text = "password123";
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Mengisi kredensial default untuk demo $label."),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
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

  void _showRegisterSheet(BuildContext context) {
    final regFormKey = GlobalKey<FormState>();
    final nameReg = TextEditingController();
    final emailReg = TextEditingController();
    final passReg = TextEditingController();
    final nikReg = TextEditingController();
    bool isRegObscure = true;
    String selectedRole = "Pembeli";

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
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Form(
                key: regFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    TextFormField(
                      controller: nameReg,
                      style: TextStyle(color: context.textPrimary),
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: "Nama Lengkap",
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Nama Lengkap wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailReg,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: context.textPrimary),
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: "Email",
                      ),
                      validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),
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
                          ),
                          onPressed: () {
                            setModalState(() {
                              isRegObscure = !isRegObscure;
                            });
                          },
                        ),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Kata sandi wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: nikReg,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: context.textPrimary),
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: "NIK (16 Digit)",
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "NIK wajib diisi";
                        if (v.length != 16) return "NIK harus 16 digit";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 24),
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

                          final success = await DBHelper().registerUser(
                            UserModelBizgrow(
                              nama: nameReg.text.trim(),
                              email: emailReg.text.trim(),
                              password: passReg.text,
                              nik: nikReg.text.trim(),
                              role: selectedRole,
                            ),
                          );

                          if (success) {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Registrasi sukses! Silakan login.",
                                ),
                                backgroundColor: Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            _emailController.text = emailReg.text;
                            _passwordController.text = passReg.text;
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Registrasi gagal! Email mungkin sudah terdaftar.",
                                ),
                                backgroundColor: Color(0xFFEF4444),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
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
            );
          },
        );
      },
    );
  }
}

