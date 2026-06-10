import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/detail_laporan_view.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';

class LaporanView extends StatefulWidget {
  const LaporanView({super.key});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  String _selectedMonth = "Juni 2026";
  final List<String> _months = ["Juni 2026", "Mei 2024", "Juli 2026", "Agustus 2026"];
  
  DateTimeRange? _selectedDateRange;

  // Dynamically simulated/calculated report values
  double _totalOmset = 0.0;
  double _biaya = 0.0;
  double _laba = 0.0;
  double _growth = 12.5;
  double _totalSalesChart = 0.0;
  double _kategoriChartScale = 0.6; // 60%
  List<double> _dailySalesValues = [];

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  void _loadFinancialData() async {
    final allActivities = await DBHelper().getAllActivities();
    
    // Filter activities by date range or selected month
    final filtered = allActivities.where((act) {
      final dt = _parseDateString(act.tanggal);
      if (dt == null) return false;
      if (_selectedDateRange != null) {
        return _isDateInRange(dt, _selectedDateRange!);
      } else {
        return _isDateInMonth(dt, _selectedMonth);
      }
    }).toList();

    double totalOmset = 0.0;
    for (var act in filtered) {
      totalOmset += act.total;
    }

    // Determine the number of days in the period
    int totalDays = 30; // default
    DateTime startDate;
    if (_selectedDateRange != null) {
      startDate = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
      totalDays = _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays + 1;
    } else {
      int month = 6;
      int year = 2026;
      final Map<String, int> monthMapping = {
        'januari': 1, 'februari': 2, 'maret': 3, 'april': 4, 'mei': 5, 'juni': 6,
        'juli': 7, 'agustus': 8, 'september': 9, 'oktober': 10, 'november': 11, 'desember': 12
      };
      final normalized = _selectedMonth.toLowerCase().trim();
      for (var entry in monthMapping.entries) {
        if (normalized.contains(entry.key)) {
          month = entry.value;
          break;
        }
      }
      final parts = normalized.split(RegExp(r'\s+'));
      if (parts.length == 2) {
        year = int.tryParse(parts[1]) ?? 2026;
      }
      startDate = DateTime(year, month, 1);
      // number of days in this month
      totalDays = DateTime(year, month + 1, 0).day;
    }

    final List<double> dailyValues = List.filled(totalDays, 0.0);

    for (var act in filtered) {
      final dt = _parseDateString(act.tanggal);
      if (dt != null) {
        int index;
        if (_selectedDateRange != null) {
          index = dt.difference(startDate).inDays;
        } else {
          index = dt.day - 1;
        }
        if (index >= 0 && index < totalDays) {
          dailyValues[index] += act.total;
        }
      }
    }

    setState(() {
      _totalOmset = totalOmset;
      _biaya = totalOmset * 0.20; // 20% estimated costs
      _laba = _totalOmset - _biaya;
      _totalSalesChart = totalOmset;
      _dailySalesValues = dailyValues;
      
      // Calculate growth relative to hardcoded base or previous period
      _growth = totalOmset > 0 ? 12.5 : 0.0;
      _kategoriChartScale = totalOmset > 0 ? 0.65 : 0.0;
    });
  }

  List<String> _getChartXLabels() {
    if (_selectedDateRange != null) {
      final days = _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays + 1;
      if (days <= 7) {
        final list = <String>[];
        for (int i = 0; i < days; i++) {
          list.add(_selectedDateRange!.start.add(Duration(days: i)).day.toString());
        }
        return list;
      } else {
        final midDay = _selectedDateRange!.start.add(Duration(days: (days / 2).round()));
        return [
          _selectedDateRange!.start.day.toString(),
          midDay.day.toString(),
          _selectedDateRange!.end.day.toString(),
        ];
      }
    } else {
      return ["1", "7", "14", "21", "28", "31"];
    }
  }

  DateTime? _parseDateString(String dateStr) {
    try {
      final Map<String, String> monthMapping = {
        'januari': '01',
        'februari': '02',
        'maret': '03',
        'april': '04',
        'mei': '05',
        'juni': '06',
        'juli': '07',
        'agustus': '08',
        'september': '09',
        'oktober': '10',
        'november': '11',
        'desember': '12',
      };

      String normalized = dateStr.toLowerCase().trim();
      for (var entry in monthMapping.entries) {
        if (normalized.contains(entry.key)) {
          normalized = normalized.replaceAll(entry.key, entry.value);
          break;
        }
      }

      final parts = normalized.split(RegExp(r'\s+'));
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return null;
  }

  bool _isDateInRange(DateTime date, DateTimeRange range) {
    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
    );
    return date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        date.isBefore(end.add(const Duration(seconds: 1)));
  }

  bool _isDateInMonth(DateTime date, String monthStr) {
    final Map<String, int> monthMapping = {
      'januari': 1,
      'februari': 2,
      'maret': 3,
      'april': 4,
      'mei': 5,
      'juni': 6,
      'juli': 7,
      'agustus': 8,
      'september': 9,
      'oktober': 10,
      'november': 11,
      'desember': 12,
    };
    final normalized = monthStr.toLowerCase().trim();
    int? month;
    int? year;
    for (var entry in monthMapping.entries) {
      if (normalized.contains(entry.key)) {
        month = entry.value;
        break;
      }
    }
    final parts = normalized.split(RegExp(r'\s+'));
    if (parts.length == 2) {
      year = int.tryParse(parts[1]);
    }
    if (month != null && year != null) {
      return date.year == year && date.month == month;
    }
    return false;
  }

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
      setState(() {
        _selectedDateRange = picked;
      });
      _loadFinancialData();
      final days = picked.end.difference(picked.start).inDays + 1;
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
                            });
                            _loadFinancialData();
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
                                });
                                _loadFinancialData();
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
                ).then((_) {
                  _loadFinancialData();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
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
                ).then((_) {
                  _loadFinancialData();
                });
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
                ).then((_) {
                  _loadFinancialData();
                });
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
                                      dataPoints: _dailySalesValues,
                                      isDark: context.isDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // X-Axis Labels
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: _getChartXLabels().map((lbl) => Text(
                                    lbl,
                                    style: TextStyle(
                                      color: context.textMuted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )).toList(),
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
            color: badgeColor.withValues(alpha: 0.1),
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
  final List<double> dataPoints;
  final bool isDark;
  CartesianChartPainter({required this.dataPoints, required this.isDark});

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

    if (dataPoints.isEmpty) return;

    double maxVal = 0.0;
    for (var val in dataPoints) {
      if (val > maxVal) maxVal = val;
    }
    if (maxVal == 0.0) maxVal = 1000000.0;

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
          curveColor.withValues(alpha: 0.08),
          curveColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final path = Path();
    final double stepX = dataPoints.length > 1 ? w / (dataPoints.length - 1) : w;

    for (int i = 0; i < dataPoints.length; i++) {
      double valPercent = dataPoints[i] / maxVal;
      double yCoord = h * (0.9 - (0.7 * valPercent));
      double xCoord = i * stepX;

      if (i == 0) {
        path.moveTo(xCoord, yCoord);
      } else {
        final prevX = (i - 1) * stepX;
        final prevValPercent = dataPoints[i - 1] / maxVal;
        final prevY = h * (0.9 - (0.7 * prevValPercent));
        
        final controlX1 = prevX + stepX / 2;
        final controlY1 = prevY;
        final controlX2 = prevX + stepX / 2;
        final controlY2 = yCoord;
        
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, xCoord, yCoord);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, curvePaint);

    final dotPaint = Paint()
      ..color = curveColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dataPoints.length; i++) {
      if (dataPoints[i] > 0.0) {
        double valPercent = dataPoints[i] / maxVal;
        double yCoord = h * (0.9 - (0.7 * valPercent));
        double xCoord = i * stepX;
        canvas.drawCircle(Offset(xCoord, yCoord), 4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CartesianChartPainter oldDelegate) => true;
}

