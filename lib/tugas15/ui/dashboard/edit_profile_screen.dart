import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/training_provider.dart';
import '../dashboard/main_dashboard.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _jenisKelamin;
  String? _role;
  int? _batchId;
  bool _statusAktif = true;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _jenisKelamin = user?.jenisKelamin ?? 'L';
    _role = user?.role ?? 'Peserta';
    _batchId = user?.batchId;
    _statusAktif = user?.statusAktif ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Email tidak boleh kosong!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.updateProfile(
      _nameController.text, 
      _emailController.text, 
      _jenisKelamin,
      role: _role,
      batchId: _batchId,
      statusAktif: _statusAktif,
    );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage), backgroundColor: Colors.redAccent),
      );
    }
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF911E5E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF4F6F9),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final trainingProv = Provider.of<TrainingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF911E5E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField('Nama Lengkap', Icons.person_outline, _nameController),
            _buildTextField('Email', Icons.email_outlined, _emailController, type: TextInputType.emailAddress),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<String>(
                value: _jenisKelamin == 'L' || _jenisKelamin == 'P' ? _jenisKelamin : 'L',
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _jenisKelamin = val);
                },
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  prefixIcon: const Icon(Icons.people_outline, color: Color(0xFF911E5E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F9),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<String>(
                value: _role,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Peserta', child: Text('Peserta')),
                  DropdownMenuItem(value: 'Instruktur', child: Text('Instruktur')),
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _role = val);
                },
                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF911E5E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F9),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<int>(
                value: _batchId,
                isExpanded: true,
                hint: const Text('Pilih Batch', overflow: TextOverflow.ellipsis),
                items: trainingProv.batches.isNotEmpty
                    ? trainingProv.batches.map((batch) {
                        return DropdownMenuItem<int>(
                          value: batch.id,
                          child: Text(batch.name, overflow: TextOverflow.ellipsis),
                        );
                      }).toList()
                    : [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Batch kosong', overflow: TextOverflow.ellipsis),
                        )
                      ],
                onChanged: trainingProv.batches.isNotEmpty
                    ? (val) {
                        setState(() => _batchId = val);
                      }
                    : null,
                decoration: InputDecoration(
                  labelText: 'Nomor Batch',
                  prefixIcon: const Icon(Icons.class_outlined, color: Color(0xFF911E5E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F9),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DropdownButtonFormField<bool>(
                value: _statusAktif,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Aktif')),
                  DropdownMenuItem(value: false, child: Text('Tidak Aktif')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _statusAktif = val);
                },
                decoration: InputDecoration(
                  labelText: 'Status Akun',
                  prefixIcon: const Icon(Icons.check_circle_outline, color: Color(0xFF911E5E)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F9),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE63971), Color(0xFF911E5E)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF911E5E).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Perubahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
