import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/detail_laporan_view.dart';

class LaporanView extends StatefulWidget {
  const LaporanView({super.key});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  String _selectedMonth = "Mei 2024";
  final List<String> _months = ["Mei 2024", "Juni 2026", "Juli 2026", "Agustus 2026"];
  
  DateTimeRange? _selectedDateRange;

  // Dynamically simulated report values
  double _totalOmset = 42500000.0;
  double _biaya = 8200000.0;
  double _laba = 34300000.0;
  double _growth = 12.5;
  double _totalSalesChart = 12750000.0;
  double _kategoriChartScale = 0.6; // 60%

  String _getFormattedPeriod() {
    if (_selectedDateRange == null) {
      return _selectedMonth;
    }
    final start = DateFormat('dd MMM yyyy').format(_selectedDateRange!.start);
    final end = DateFormat('dd MMM yyyy').format(_selectedDateRange!.end);
    return "$start - $end";
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0D9488),
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B),
              onPrimary: Colors.white,
              surface: isDark ? const Color(0xFF1E293B) : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final days = picked.end.difference(picked.start).inDays + 1;
      setState(() {
        _selectedDateRange = picked;
        // Dynamically scale simulation based on picked date range duration
        _totalOmset = 1450000.0 * days;
        _biaya = 290000.0 * days;
        _laba = _totalOmset - _biaya;
        _totalSalesChart = _totalOmset * 0.3;
        _growth = 3.5 + (days % 12);
        _kategoriChartScale = 0.35 + ((days % 6) * 0.1);
      });
      _showSuccessSnackbar("Laporan berhasil difilter untuk $days hari!");
    }
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

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Calendar Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Laporan",
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.borderColor),
                    color: context.cardBg,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.calendar_today_rounded, color: context.iconPrimary, size: 20),
                    onPressed: _pickDateRange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Period Selector with Presets and Custom Range Option
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // reduced vertical padding for dropdown alignment
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    border: Border.all(color: context.borderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedDateRange != null) ...[
                        Text(
                          _getFormattedPeriod(),
                          style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDateRange = null;
                              // Reset standard simulation
                              _totalOmset = 42500000.0;
                              _biaya = 8200000.0;
                              _laba = 34300000.0;
                              _growth = 12.5;
                              _totalSalesChart = 12750000.0;
                              _kategoriChartScale = 0.6;
                            });
                          },
                          child: Icon(Icons.cancel_rounded, size: 16, color: context.textMuted),
                        ),
                      ] else ...[
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _months.contains(_selectedMonth) ? _selectedMonth : _months.first,
                            dropdownColor: context.cardBg,
                            icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.iconColor),
                            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedMonth = newValue;
                                  _selectedDateRange = null;
                                  // Reset standard simulation
                                  _totalOmset = 42500000.0;
                                  _biaya = 8200000.0;
                                  _laba = 34300000.0;
                                  _growth = 12.5;
                                  _totalSalesChart = 12750000.0;
                                  _kategoriChartScale = 0.6;
                                });
                              }
                            },
                            items: _months.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: context.textPrimary)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Total Penjualan Card - Clickable to Detail Laporan
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailLaporanView(
                      initialMonth: _getFormattedPeriod(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Penjualan",
                      style: TextStyle(color: context.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "Rp ${_totalSalesChart.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.trending_up_rounded, color: Color(0xFF10B981), size: 14),
                        const SizedBox(width: 3),
                        Text(
                          "+ ${_growth.toStringAsFixed(1)}% ",
                          style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "dari periode lalu",
                          style: TextStyle(color: context.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: context.dividerColor, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniStat("Total Transaksi", "128 Pesanan"),
                        _buildMiniStat("Rata-rata Harian", "Rp 425.000"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Key Highlights Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailLaporanView(
                      initialMonth: _getFormattedPeriod(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ringkasan Kinerja",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReportRow("Total Omset", "Rp ${_totalOmset.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}", "+ 18.2%", Colors.green),
                    Divider(height: 24, color: context.dividerColor),
                    _buildReportRow("Biaya Pengeluaran", "Rp ${_biaya.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}", "- 4.5%", Colors.red),
                    Divider(height: 24, color: context.dividerColor),
                    _buildReportRow("Laba Bersih", "Rp ${_laba.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}", "+ 22.1%", Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Penjualan Chart Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailLaporanView(
                      initialMonth: _getFormattedPeriod(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penjualan",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Render Cartesian Coordinate Line Chart
                    SizedBox(
                      height: 180,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Y-Axis Labels: 5M to 0
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("5M", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("4M", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("3M", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("2M", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("1M", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text("0", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Chart body
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: CustomPaint(
                                    size: Size.infinite,
                                    painter: CartesianChartPainter(
                                      scaleFactor: _totalSalesChart / 12750000.0,
                                      isDark: context.isDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // X-Axis Labels: 1 to 31
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("1", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text("7", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text("14", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text("21", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text("28", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text("31", style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Kategori Terlaris
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailLaporanView(
                      initialMonth: _getFormattedPeriod(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kategori Terlaris",
                      style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Produk A",
                          style: TextStyle(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Rp ${(10833333.0 * _kategoriChartScale).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                              style: TextStyle(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${(_kategoriChartScale * 100).toStringAsFixed(0)}%",
                              style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Thick category progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _kategoriChartScale,
                        minHeight: 10,
                        backgroundColor: context.inputBg,
                        valueColor: AlwaysStoppedAnimation<Color>(context.iconPrimary), // Adaptive progress bar
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),);
  }

  Widget _buildReportRow(String label, String value, String percent, Color badgeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: context.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: context.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            percent,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: context.textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(color: context.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class CartesianChartPainter extends CustomPainter {
  final double scaleFactor;
  final bool isDark;
  CartesianChartPainter({required this.scaleFactor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 5; i++) {
      double yCoord = h * (i / 5);
      canvas.drawLine(Offset(0, yCoord), Offset(w, yCoord), gridPaint);
    }

    // Draw the chart curve line
    final curveColor = isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B);
    final curvePaint = Paint()
      ..color = curveColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          curveColor.withOpacity(0.08),
          curveColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    // Build curve points with a scale shift depending on selected date range duration
    final path = Path()
      ..moveTo(0, h * (0.8 - (0.1 * scaleFactor)))
      ..lineTo(w * 0.2, h * (0.7 - (0.15 * scaleFactor)))
      ..lineTo(w * 0.4, h * (0.85 - (0.1 * scaleFactor)))
      ..lineTo(w * 0.6, h * (0.55 - (0.2 * scaleFactor)))
      ..lineTo(w * 0.8, h * (0.6 - (0.15 * scaleFactor)))
      ..lineTo(w, h * (0.35 - (0.2 * scaleFactor)));

    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, curvePaint);

    // Draw data points
    final dotPaint = Paint()
      ..color = curveColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w, h * (0.35 - (0.2 * scaleFactor))), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CartesianChartPainter oldDelegate) =>
      oldDelegate.scaleFactor != scaleFactor || oldDelegate.isDark != isDark;
}
