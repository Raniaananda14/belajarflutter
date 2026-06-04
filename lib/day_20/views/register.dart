import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_20/database/database1.dart';
import 'package:flutter_application_1/day_20/models/model1.dart';
import 'package:flutter_application_1/day_20/views/login.dart';
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
    final email = emailController.text.trim();
    final pass = passwordController.text;
    final nik = nikController.text;

    if (_formKey.currentState!.validate()) {
      print("Sudah memenuhi syarat");
    }

    if (email.isEmpty || pass.isEmpty || nik.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harap Isi dahulu')));
      return;
    }

    final user = UserModelBizgrow(email: email, password: pass, nik: nik);
    bool success = await DBHelper().registerUser(user);

    // Cek apakah widget masih terpasang (mounted) sebelum menggunakan context
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil didaftarkan')),
      );
      context.push(Lamanlogin());

      // Tambahkan navigasi ke halaman login jika perlu
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun gagal terdaftar!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
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
                  Container(
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
                          "Create your Account",
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

                        // DATA PRIBADI
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Form Email
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "name@company.com",
                                  hintStyle: TextStyle(color: Colors.black38),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
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
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email format is not appropriate";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 6),
                              // Form Password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
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
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is incorrecte";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),

                              // Form NIK
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "NIK",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              TextFormField(
                                // obscureText: obscurePassword,
                                decoration: InputDecoration(
                                  // hintText: "********",
                                  hintStyle: TextStyle(color: Colors.black38),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),

                                  filled: true,
                                  fillColor: Color(0xFFF4F4F4),

                                  // ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                controller: nikController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Isi hanya berupa angka saja";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 28),

                              /// LOGIN BUTTON
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
                                  onPressed: register,
                                  child: const Text(
                                    "Register",
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "All ready have an account? ",
                        style: TextStyle(color: Colors.black54),
                      ),

                      GestureDetector(
                        onTap: () {
                          context.push(Lamanlogin());
                        },
                        child: const Text(
                          "login",
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
          ],
        ),
      ),
    );
  }
}
