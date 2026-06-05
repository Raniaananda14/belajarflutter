import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';

class TargetView extends StatefulWidget {
  const TargetView({super.key});

  @override
  State<TargetView> createState() => _TargetViewState();
}

class _TargetViewState extends State<TargetView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  void _addTarget() async {
    if (!_formKey.currentState!.validate()) return;

    final target = TargetModel(
      bulan: _monthController.text.trim(),
      targetJumlah: double.parse(_targetController.text.trim()),
      tercapaiJumlah: 0.0,
      status: "Belum Tercapai",
    );

    bool success = await DBHelper().addTarget(target);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Target baru berhasil dibuat!"), backgroundColor: Color(0xFF10B981)),
      );
      _monthController.clear();
      _targetController.clear();
      setState(() {});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Bar & Add Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: const Color(0xFF1E293B),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Target Bisnis",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF14B8A6), size: 28),
                onPressed: () => _showAddTargetSheet(context),
              )
            ],
          ),
        ),

        // Main Target Penjualan Bulanan (Dashboard overview card)
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Target Penjualan Bulanan",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Mei 2024",
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: 0.6,
                              strokeWidth: 12,
                              backgroundColor: Colors.white10,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                            ),
                          ),
                          const Column(
                            children: [
                              Text(
                                "60%",
                                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Tercapai",
                                style: TextStyle(color: Colors.white54, fontSize: 11),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tercapai", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                            const SizedBox(height: 4),
                            const Text("Rp 15.000.000", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Target", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                            const SizedBox(height: 4),
                            const Text("Rp 25.000.000", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Daftar Target Header
              const Text(
                "Daftar Target",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // FutureBuilder Target Items List
              FutureBuilder<List<TargetModel>>(
                future: DBHelper().getAllTargets(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
                  }
                  final list = snapshot.data ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final target = list[index];
                      final progress = target.targetJumlah > 0 ? (target.tercapaiJumlah / target.targetJumlah) : 0.0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.04)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  target.bulan,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: target.status == "Tercapai" ? const Color(0xFF10B981).withOpacity(0.15) : Colors.amber.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    target.status,
                                    style: TextStyle(
                                      color: target.status == "Tercapai" ? const Color(0xFF10B981) : Colors.amber,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white10,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp ${target.tercapaiJumlah.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Target: Rp ${target.targetJumlah.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  void _showAddTargetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Buat Target Baru',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _monthController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Nama Bulan (e.g. September 2024)"),
                  validator: (v) => v!.isEmpty ? "Nama bulan wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Target Jumlah Penjualan (Rp)"),
                  validator: (v) => v!.isEmpty ? "Jumlah target wajib diisi" : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _addTarget,
                  child: const Text('Buat Target', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    );
  }
}
