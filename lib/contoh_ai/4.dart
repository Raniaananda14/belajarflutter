import 'package:flutter/material.dart';

class ai4 extends StatefulWidget {
  const ai4({super.key});

  @override
  State<ai4> createState() => _ai4State();
}

class _ai4State extends State<ai4> {
  /// =========================================
  /// GLOBAL KEY
  /// =========================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// =========================================
  /// CONTROLLER
  /// =========================================

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  /// =========================================
  /// SHOW DIALOG
  /// =========================================

  void showDataDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Konfirmasi Data",

            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Nama : ${nameController.text}"),

              const SizedBox(height: 8),

              Text("Email : ${emailController.text}"),

              const SizedBox(height: 8),

              Text("No HP : ${phoneController.text}"),

              const SizedBox(height: 8),

              Text("Kota : ${cityController.text}"),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),

              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => ConfirmationPage(
                      nama: nameController.text,

                      kota: cityController.text,
                    ),
                  ),
                );
              },

              child: const Text(
                "Lanjut",

                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        elevation: 0,

        title: Row(
          children: const [
            Icon(Icons.auto_graph),

            SizedBox(width: 8),

            Text("BizGrow", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        backgroundColor: Colors.white,

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ===================================
            /// HEADER
            /// ===================================
            Text(
              "HANDCRAFTED",

              style: TextStyle(
                color: Colors.grey.withOpacity(0.5),

                letterSpacing: 8,

                fontSize: 16,

                fontWeight: FontWeight.w300,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Registration\nForm Validation",

              style: TextStyle(
                fontSize: 30,

                height: 1.2,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Lengkapi data untuk mendaftar pada aplikasi BizGrow modern dashboard.",

              style: TextStyle(
                color: Colors.black54,

                fontSize: 13,

                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),

            /// ===================================
            /// FORM CARD
            /// ===================================
            Container(
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(28),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),

                    blurRadius: 20,

                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    /// =========================
                    /// NAMA
                    /// =========================
                    buildTextField(
                      controller: nameController,

                      label: "Nama Lengkap",

                      hint: "Masukkan nama lengkap",

                      icon: Icons.person,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama wajib diisi";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    /// =========================
                    /// EMAIL
                    /// =========================
                    buildTextField(
                      controller: emailController,

                      label: "Email",

                      hint: "example@gmail.com",

                      icon: Icons.email,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email wajib diisi";
                        }

                        if (!value.contains("@")) {
                          return "Email harus mengandung @";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    /// =========================
                    /// NOMOR HP
                    /// =========================
                    buildTextField(
                      controller: phoneController,

                      label: "Nomor HP",

                      hint: "08xxxxxxxxxx",

                      icon: Icons.phone,

                      validator: (value) {
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    /// =========================
                    /// KOTA
                    /// =========================
                    buildTextField(
                      controller: cityController,

                      label: "Kota Asal",

                      hint: "Masukkan kota asal",

                      icon: Icons.location_city,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kota wajib diisi";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// BUTTON
                    /// =========================
                    SizedBox(
                      width: double.infinity,

                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDataDialog();
                          }
                        },

                        child: const Text(
                          "Daftar",

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 15,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================================
  /// TEXT FIELD
  /// =========================================

  Widget buildTextField({
    required TextEditingController controller,

    required String label,

    required String hint,

    required IconData icon,

    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,

          validator: validator,

          style: const TextStyle(fontSize: 13),

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 12),

            prefixIcon: Icon(icon, size: 20),

            filled: true,

            fillColor: const Color(0xFFF7F7F7),

            contentPadding: const EdgeInsets.symmetric(vertical: 18),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),

              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),

              borderSide: const BorderSide(color: Colors.black),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),

              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

/// =============================================
/// CONFIRMATION PAGE
/// =============================================

class ConfirmationPage extends StatelessWidget {
  final String nama;

  final String kota;

  const ConfirmationPage({super.key, required this.nama, required this.kota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(30),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 90,
                  height: 90,

                  decoration: BoxDecoration(
                    color: Colors.black,

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: const Icon(Icons.check, color: Colors.white, size: 45),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Registrasi Berhasil",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Text(
                  "Terima kasih, $nama dari $kota telah mendaftar.",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.black54,

                    fontSize: 14,

                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Kembali",

                      style: TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
