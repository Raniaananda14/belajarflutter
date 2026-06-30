import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/training_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _jenisKelamin = 'L';
  
  int? _selectedBatchId;
  int? _selectedTrainingId;

  bool _isObscured = true;
  double _passwordStrength = 0;

  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.isEmpty) {
      setState(() => _passwordStrength = 0);
      return;
    }
    if (value.length >= 8) strength += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[a-z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.25;
    // Cap at 1.0
    setState(() {
      _passwordStrength = strength > 1.0 ? 1.0 : strength;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TrainingProvider>(context, listen: false).getTrainings();
      Provider.of<TrainingProvider>(context, listen: false).getBatches();
    });
  }

  void _register() async {
    if (_selectedBatchId == null || _selectedTrainingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih Batch dan Training terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);
    final data = {
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "jenis_kelamin": _jenisKelamin,
      "batch_id": _selectedBatchId,
      "training_id": _selectedTrainingId
    };

    final success = await provider.register(data);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan Login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isObscure = false, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Buat Akun Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A154B), Color(0xFF911E5E), Color(0xFFE63971)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Registrasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Nama Lengkap', Icons.person_outline, _nameController),
                    _buildTextField('Email', Icons.email_outlined, _emailController, type: TextInputType.emailAddress),
                    
                    // Password Field Custom
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _isObscured,
                        onChanged: _checkPasswordStrength,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF911E5E)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF4F6F9),
                        ),
                      ),
                    ),
                    
                    // Password Strength Indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, left: 4, right: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: _passwordStrength,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _passwordStrength <= 0.25 ? Colors.red :
                              _passwordStrength <= 0.5 ? Colors.orange :
                              _passwordStrength <= 0.75 ? Colors.yellow.shade700 :
                              Colors.green
                            ),
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _passwordStrength == 0 ? 'Masukkan password' :
                            _passwordStrength <= 0.25 ? 'Sangat Lemah' :
                            _passwordStrength <= 0.5 ? 'Lemah' :
                            _passwordStrength <= 0.75 ? 'Sedang' :
                            'Kuat',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _passwordStrength <= 0.25 ? Colors.red :
                                     _passwordStrength <= 0.5 ? Colors.orange :
                                     _passwordStrength <= 0.75 ? Colors.yellow.shade700 :
                                     Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButtonFormField<String>(
                        value: _jenisKelamin,
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
                    
                    // Dropdown untuk Batch
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButtonFormField<int>(
                        value: _selectedBatchId,
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
                                setState(() => _selectedBatchId = val);
                              }
                            : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.numbers, color: Color(0xFF911E5E)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF4F6F9),
                        ),
                      ),
                    ),

                    // Dropdown untuk Training
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: DropdownButtonFormField<int>(
                        value: _selectedTrainingId,
                        isExpanded: true,
                        hint: const Text('Pilih Training', overflow: TextOverflow.ellipsis),
                        items: trainingProv.trainings.isNotEmpty
                            ? trainingProv.trainings.map((training) {
                                return DropdownMenuItem<int>(
                                  value: training.id,
                                  child: Text(training.name, overflow: TextOverflow.ellipsis),
                                );
                              }).toList()
                            : [
                                const DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('Training kosong', overflow: TextOverflow.ellipsis),
                                )
                              ],
                        onChanged: trainingProv.trainings.isNotEmpty
                            ? (val) {
                                setState(() => _selectedTrainingId = val);
                              }
                            : null,
                        decoration: InputDecoration(
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
                        onPressed: auth.isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: auth.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Daftar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
      ),
    );
  }
}
