import 'package:flutter/material.dart';

class Tugas10 extends StatefulWidget {
  const Tugas10({super.key});

  State<Tugas10> createState() => _Tugas10State();
}

class _Tugas10State extends State<Tugas10> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();

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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,

        centerTitle: true,

        title: Row(
          mainAxisSize: MainAxisSize.min,

          children: const [
            Icon(Icons.auto_graph),

            SizedBox(width: 8),

            Text("BizGrow", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
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
          ),
        ),
      ],
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final String nama;

  final String kota;

  const ConfirmationPage({super.key, required this.nama, required this.kota});

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
