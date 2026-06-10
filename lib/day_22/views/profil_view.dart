import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/login_view.dart';
import 'package:image_picker/image_picker.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Profile Header - Clickable Avatar & Details
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _changeAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.borderColor,
                              border: Border.all(
                                color: context.isDark
                                    ? const Color(0xFF475569)
                                    : Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child:
                                  SessionManager.profileImage.isNotEmpty &&
                                      File(
                                        SessionManager.profileImage,
                                      ).existsSync()
                                  ? Image.file(
                                      File(SessionManager.profileImage),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 56,
                                        color: context.iconColor,
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.buttonBg,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _editPersonalDetails,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            SessionManager.name,
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: context.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      SessionManager.email,
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${SessionManager.role} BizGrow",
                      style: TextStyle(
                        color: context.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Profile Actions List - All Editable
              Container(
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  children: [
                    _buildProfileTile(
                      icon: Icons.badge_outlined,
                      title: "NIK Karyawan",
                      subtitle: SessionManager.nik,
                      onTap: _editNik,
                    ),
                    Divider(height: 1, color: context.dividerColor),
                    _buildProfileTile(
                      icon: Icons.storefront_outlined,
                      title: "Informasi Bisnis",
                      subtitle: SessionManager.businessInfo,
                      onTap: _editBusinessInfo,
                    ),
                    Divider(height: 1, color: context.dividerColor),
                    _buildProfileTile(
                      icon: Icons.lock_outline_rounded,
                      title: "Keamanan Akun",
                      subtitle: "Ubah kata sandi akun",
                      onTap: _changePassword,
                    ),
                    Divider(height: 1, color: context.dividerColor),
                    _buildProfileTile(
                      icon: Icons.notifications_none_rounded,
                      title: "Notifikasi",
                      subtitle: "Kelola setelan notifikasi",
                      onTap: _manageNotifications,
                    ),
                    Divider(height: 1, color: context.dividerColor),
                    _buildThemeTile(),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Log Out Button matching Mockup 10 layout
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDark
                        ? const Color(0xFF7F1D1D)
                        : const Color(0xFFFEE2E2), // Dark/Light Red background
                    elevation: 0,
                    side: BorderSide(
                      color: context.isDark
                          ? const Color(0xFFB91C1C)
                          : const Color(0xFFFCA5A5),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _logOut,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: context.isDark
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFB91C1C),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Keluar dari Akun",
                        style: TextStyle(
                          color: context.isDark
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFB91C1C), // Red text
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: context.iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: TextStyle(color: context.textSecondary, fontSize: 13),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: context.textMuted,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeTile() {
    final isDark = context.isDark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.inputBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          color: isDark ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B),
          size: 22,
        ),
      ),
      title: Text(
        "Mode Gelap",
        style: TextStyle(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          isDark ? "Tema Gelap Aktif" : "Tema Terang Aktif",
          style: TextStyle(color: context.textSecondary, fontSize: 13),
        ),
      ),
      trailing: Switch(
        value: isDark,
        activeThumbColor: const Color(0xFF0D9488),
        onChanged: (val) async {
          final newMode = val ? "dark" : "light";
          await SessionManager.setThemeMode(newMode);
          setState(() {});
        },
      ),
    );
  }

  // Action methods to change profile configurations

  void _changeAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const Text("Galeri Foto"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        final success = await DBHelper().updateUserProfileImage(
          SessionManager.email,
          image.path,
        );
        if (success) {
          await SessionManager.updateProfileImage(image.path);
          setState(() {});
          _showSuccessSnackbar("Foto profil berhasil diperbarui!");
        } else {
          _showErrorSnackbar("Gagal memperbarui foto profil di database.");
        }
      }
    } catch (e) {
      _showErrorSnackbar("Gagal mengambil gambar: $e");
    }
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _editPersonalDetails() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: SessionManager.name);
    final emailController = TextEditingController(text: SessionManager.email);
    final oldEmail = SessionManager.email;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ubah Data Diri',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: context.iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Nama Lengkap"),
                  validator: (v) =>
                      v!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Email"),
                  validator: (v) =>
                      v!.isEmpty ? "Email tidak boleh kosong" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final nik = SessionManager.nik;

                      // Save to SQLite
                      final success = await DBHelper().updateUser(
                        oldEmail,
                        name,
                        email,
                        nik,
                      );
                      if (success) {
                        // Save to SessionManager
                        await SessionManager.updateProfile(
                          name: name,
                          email: email,
                          nik: nik,
                        );
                        setState(() {});
                        if (mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackbar("Data diri berhasil disimpan!");
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Gagal memperbarui profil. Email mungkin sudah terdaftar.",
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Simpan Perubahan',
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
  }

  void _editNik() {
    final formKey = GlobalKey<FormState>();
    final nikController = TextEditingController(text: SessionManager.nik);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ubah NIK Karyawan',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: context.iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nikController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Nomor Induk Kependudukan (NIK)"),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "NIK wajib diisi";
                    if (v.length != 16) return "NIK harus 16 digit";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final newNik = nikController.text.trim();

                      // Update SQLite
                      final success = await DBHelper().updateUser(
                        SessionManager.email,
                        SessionManager.name,
                        SessionManager.email,
                        newNik,
                      );
                      if (success) {
                        await SessionManager.updateProfile(
                          name: SessionManager.name,
                          email: SessionManager.email,
                          nik: newNik,
                        );
                        setState(() {});
                        if (mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackbar("NIK berhasil diperbarui!");
                        }
                      }
                    },
                    child: const Text(
                      'Simpan NIK',
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
  }

  void _editBusinessInfo() {
    final formKey = GlobalKey<FormState>();
    final busController = TextEditingController(
      text: SessionManager.businessInfo,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ubah Informasi Bisnis',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: context.iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: busController,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Nama Toko/Bisnis"),
                  validator: (v) =>
                      v!.isEmpty ? "Nama bisnis tidak boleh kosong" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final business = busController.text.trim();
                      await SessionManager.updateBusinessInfo(business);
                      setState(() {});
                      if (mounted) {
                        Navigator.pop(context);
                        _showSuccessSnackbar(
                          "Informasi bisnis berhasil diperbarui!",
                        );
                      }
                    },
                    child: const Text(
                      'Simpan Bisnis',
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
  }

  void _changePassword() {
    final formKey = GlobalKey<FormState>();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ubah Kata Sandi',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: context.iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPassController,
                  obscureText: true,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Kata Sandi Baru"),
                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPassController,
                  obscureText: true,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Konfirmasi Kata Sandi Baru"),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Wajib diisi";
                    if (v != newPassController.text)
                      return "Kata sandi tidak cocok";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final pass = newPassController.text;

                      final success = await DBHelper().updateUserPassword(
                        SessionManager.email,
                        pass,
                      );
                      if (success) {
                        if (mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackbar("Kata sandi berhasil diubah!");
                        }
                      }
                    },
                    child: const Text(
                      'Simpan Sandi Baru',
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
  }

  void _manageNotifications() {
    bool sales = SessionManager.notifSales;
    bool target = SessionManager.notifTarget;
    bool system = SessionManager.notifSystem;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Setelan Notifikasi',
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 18,
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
                  SwitchListTile(
                    title: Text(
                      "Notifikasi Penjualan",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Dapatkan update ketika pesanan selesai",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    value: sales,
                    activeThumbColor: const Color(0xFF0D9488),
                    onChanged: (val) {
                      setModalState(() {
                        sales = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      "Notifikasi Target",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Dapatkan info saat progress bulanan naik",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    value: target,
                    activeThumbColor: const Color(0xFF0D9488),
                    onChanged: (val) {
                      setModalState(() {
                        target = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      "Notifikasi Sistem",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      "Update informasi rilis dan fitur BizGrow",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    value: system,
                    activeThumbColor: const Color(0xFF0D9488),
                    onChanged: (val) {
                      setModalState(() {
                        system = val;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.buttonBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        await SessionManager.updateNotificationSettings(
                          sales: sales,
                          target: target,
                          system: system,
                        );
                        if (mounted) {
                          Navigator.pop(context);
                          _showSuccessSnackbar(
                            "Setelan notifikasi berhasil disimpan!",
                          );
                        }
                      },
                      child: const Text(
                        'Simpan Setelan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _logOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Keluar"),
          content: const Text(
            "Apakah Anda yakin ingin keluar dari akun BizGrow?",
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // close dialog
                await SessionManager.clear();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginView()),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                "Keluar",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.textSecondary),
      filled: true,
      fillColor: context.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: BorderSide(
          color: context.isDark
              ? const Color(0xFF0D9488)
              : const Color(0xFF1E293B),
        ),
      ),
    );
  }
}
