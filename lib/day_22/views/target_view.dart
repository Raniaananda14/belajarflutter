import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class TargetView extends StatefulWidget {
  const TargetView({super.key});

  @override
  State<TargetView> createState() => _TargetViewState();
}

class _TargetViewState extends State<TargetView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return MonthYearPickerDialog(initialDate: DateTime(2026, 6));
      },
    );

    if (picked != null) {
      final List<String> indonesianMonths = [
        "Januari",
        "Februari",
        "Maret",
        "April",
        "Mei",
        "Juni",
        "Juli",
        "Agustus",
        "September",
        "Oktober",
        "November",
        "Desember",
      ];
      final monthName = indonesianMonths[picked.month - 1];
      setState(() {
        _monthController.text = "$monthName ${picked.year}";
      });
    }
  }

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
        SnackBar(
          content: const Text("Target baru berhasil dibuat!"),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      _monthController.clear();
      _targetController.clear();
      setState(() {});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Title Bar & Add Button matching Mockup style
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Target Bisnis",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.buttonBg,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.add,
                        color: context.isDark
                            ? context.textPrimary
                            : Colors.white,
                        size: 22,
                      ),
                      onPressed: () => _showAddTargetSheet(context),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Area
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                children: [
                  // Highlight Circular Target Card
                  GestureDetector(
                    onTap: () {
                      _showTargetAnalysisSheet(
                        context,
                        TargetModel(
                          bulan: "Mei 2024",
                          targetJumlah: 25000000.0,
                          tercapaiJumlah: 15000000.0,
                          status: "Belum Tercapai",
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: context.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Target Penjualan Bulanan",
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Mei 2024",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp 25.000.000",
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                "60%",
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.6,
                              minHeight: 8,
                              backgroundColor: context.dividerColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.isDark
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFF1E293B),
                              ), // Adaptive brand/slate indicator
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tercapai: Rp 15.000.000",
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Daftar Target Header
                  Text(
                    "Daftar Pencapaian Bulanan",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // FutureBuilder Target Items List matching Mockup 7
                  FutureBuilder<List<TargetModel>>(
                    future: DBHelper().getAllTargets(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFF0D9488),
                            ),
                          ),
                        );
                      }
                      final list = snapshot.data ?? [];
                      if (list.isEmpty) {
                        return Card(
                          color: context.cardBg,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                "Belum ada target.",
                                style: TextStyle(color: context.textSecondary),
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final target = list[index];
                          return GestureDetector(
                            onTap: () =>
                                _showTargetAnalysisSheet(context, target),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: context.cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: context.borderColor),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        target.bulan,
                                        style: TextStyle(
                                          color: context.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        target.status == "Tercapai"
                                            ? "Tercapai"
                                            : "Belum tercapai",
                                        style: TextStyle(
                                          color: target.status == "Tercapai"
                                              ? const Color(0xFF10B981) // Green
                                              : context.textSecondary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Rp ${target.targetJumlah.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTargetSheet(BuildContext context) {
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
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buat Target Bulanan Baru',
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _monthController,
                  readOnly: true,
                  onTap: () => _selectMonth(context),
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco(
                    context,
                    "Pilih Bulan Target",
                    suffixIcon: Icon(
                      Icons.calendar_today_rounded,
                      color: context.iconColor,
                      size: 20,
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Bulan target wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco(
                    context,
                    "Target Jumlah Penjualan (Rp)",
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Jumlah target wajib diisi" : null,
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
                    onPressed: _addTarget,
                    child: Text(
                      'Buat Target',
                      style: TextStyle(
                        color: context.isDark
                            ? context.textPrimary
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  void _showTargetAnalysisSheet(BuildContext context, TargetModel target) {
    final double percent = target.targetJumlah > 0
        ? (target.tercapaiJumlah / target.targetJumlah)
        : 0.0;
    final int percentInt = (percent * 100).round();
    final double remaining = target.targetJumlah - target.tercapaiJumlah;

    String analysisTitle = "";
    String analysisDesc = "";
    List<String> actionSteps = [];
    Color themeColor = const Color(0xFF0D9488);

    if (percent >= 1.0) {
      analysisTitle = "Target Terlampaui 🎉";
      analysisDesc =
          "Luar biasa! Target penjualan untuk bulan ${target.bulan} telah tercapai sebesar $percentInt%. Kinerja penjualan sangat optimal.";
      actionSteps = [
        "Pertahankan konsistensi pasokan produk terlaris.",
        "Pertimbangkan untuk menaikkan target sebesar 10-15% di bulan berikutnya.",
        "Berikan apresiasi atau bonus kepada tim pemasaran.",
      ];
      themeColor = const Color(0xFF10B981);
    } else if (percent >= 0.5) {
      analysisTitle = "Mendekati Target 📈";
      analysisDesc =
          "Cukup baik! Pencapaian target telah menyentuh $percentInt%. Diperlukan sedikit dorongan ekstra untuk menutup sisa target Rp ${remaining.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}.";
      actionSteps = [
        "Fokus pada follow-up transaksi/pesanan yang masih pending.",
        "Gencarkan penawaran bundling produk fast-moving.",
        "Optimalkan promosi digital di sisa hari operasional.",
      ];
      themeColor = const Color(0xFFF59E0B);
    } else {
      analysisTitle = "Perlu Evaluasi Segera ⚠️";
      analysisDesc =
          "Perhatian! Pencapaian baru menyentuh $percentInt%. Diperlukan tindakan korektif segera untuk mendongkrak penjualan yang masih kurang Rp ${remaining.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}.";
      actionSteps = [
        "Evaluasi harga produk dibandingkan kompetitor.",
        "Lakukan program diskon kilat (flash sale) untuk produk lambat laku.",
        "Tinjau ulang strategi pemasaran dan tingkatkan interaksi media sosial.",
      ];
      themeColor = const Color(0xFFEF4444);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: context.borderColor,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Analisis Target',
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: context.iconColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.inputBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: CircularProgressIndicator(
                                value: percent > 1.0 ? 1.0 : percent,
                                strokeWidth: 10,
                                backgroundColor: context.dividerColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  themeColor,
                                ),
                              ),
                            ),
                            Text(
                              "$percentInt%",
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                target.bulan,
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildMetricRow("Target:", target.targetJumlah),
                              const SizedBox(height: 4),
                              _buildMetricRow(
                                "Tercapai:",
                                target.tercapaiJumlah,
                              ),
                              const SizedBox(height: 4),
                              _buildMetricRow(
                                remaining > 0 ? "Kurang:" : "Surplus:",
                                remaining.abs(),
                                isHighlight: true,
                                highlightColor: remaining > 0
                                    ? Colors.redAccent
                                    : const Color(0xFF10B981),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        color: themeColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        analysisTitle,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    analysisDesc,
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "Rekomendasi Tindakan Bisnis:",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...actionSteps.map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: themeColor,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              step,
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildMetricRow(
    String label,
    double val, {
    bool isHighlight = false,
    Color? highlightColor,
  }) {
    final valText =
        "Rp ${val.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          valText,
          style: TextStyle(
            color: isHighlight ? highlightColor : context.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDeco(
    BuildContext context,
    String label, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.textSecondary),
      filled: true,
      fillColor: context.inputBg,
      suffixIcon: suffixIcon,
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
        borderSide: BorderSide(color: context.textPrimary),
      ),
    );
  }
}

class MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  const MonthYearPickerDialog({super.key, required this.initialDate});

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _firstWeekdayOfMonth(int year, int month) {
    final dt = DateTime(year, month, 1);
    return dt.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: context.scaffoldBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Year Selector Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: context.iconColor,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedYear--;
                    });
                  },
                ),
                Text(
                  "$_selectedYear",
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: context.iconColor,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedYear++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: context.borderColor),
            const SizedBox(height: 12),
            // Months Grid
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  return _buildMonthCard(_selectedYear, index);
                },
              ),
            ),
            const SizedBox(height: 12),
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Batal",
                style: TextStyle(
                  color: context.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCard(int year, int monthIndex) {
    final List<String> indonesianMonths = [
      "JANUARI",
      "FEBRUARI",
      "MARET",
      "APRIL",
      "MEI",
      "JUNI",
      "JULI",
      "AGUSTUS",
      "SEPTEMBER",
      "OKTOBER",
      "NOVEMBER",
      "DESEMBER",
    ];
    final monthName = indonesianMonths[monthIndex];
    final daysCount = _daysInMonth(year, monthIndex + 1);
    final startWeekday = _firstWeekdayOfMonth(year, monthIndex + 1);

    final weekdays = ["M", "S", "S", "R", "K", "J", "S"];

    return InkWell(
      onTap: () {
        Navigator.pop(context, DateTime(year, monthIndex + 1));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              monthName,
              style: TextStyle(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekdays.map((day) {
                final isSunday = day == "M";
                return Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSunday ? Colors.red : context.textMuted,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 42,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 0.5,
                  mainAxisSpacing: 0.5,
                ),
                itemBuilder: (context, index) {
                  final dayNumber = index - startWeekday + 1;
                  final isValidDay = dayNumber > 0 && dayNumber <= daysCount;
                  final isSunday = index % 7 == 0;

                  return Container(
                    alignment: Alignment.center,
                    child: isValidDay
                        ? Text(
                            "$dayNumber",
                            style: TextStyle(
                              color: isSunday
                                  ? Colors.red
                                  : context.textSecondary,
                              fontSize: 7,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
