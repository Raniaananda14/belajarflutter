import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/detail_laporan_view.dart';
import 'package:flutter_application_1/day_22/views/lacak_pesanan_view.dart';
import 'package:flutter_application_1/day_22/views/main_navigation.dart';
import 'package:flutter_application_1/day_22/views/product_detail_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  double _totalSales = 0.0;
  int _orderCount = 0;
  int _productCount = 0;
  int _customerCount = 0;
  List<double> _weeklySales = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> _sparklineData = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    final activities = await DBHelper().getAllActivities();
    final products = await DBHelper().getAllProducts();

    double totalSales = 0.0;
    for (var act in activities) {
      totalSales += act.total;
    }

    final List<double> weeklySales = List.filled(7, 0.0);
    for (var act in activities) {
      final dt = _parseDateString(act.tanggal);
      if (dt != null) {
        int weekdayIndex = dt.weekday - 1;
        if (weekdayIndex >= 0 && weekdayIndex < 7) {
          weeklySales[weekdayIndex] += act.total;
        }
      }
    }

    final sortedActivities = List<ActivityModel>.from(activities);
    sortedActivities.sort((a, b) {
      final dtA = _parseDateString(a.tanggal) ?? DateTime(1970);
      final dtB = _parseDateString(b.tanggal) ?? DateTime(1970);
      return dtA.compareTo(dtB);
    });

    final List<double> sparklineData = sortedActivities
        .map((act) => act.total)
        .toList();

    setState(() {
      _totalSales = totalSales;
      _orderCount = activities.length;
      _productCount = products.length;
      _customerCount = (activities.length * 0.5).round().clamp(1, 999);
      _weeklySales = weeklySales;
      _sparklineData = sparklineData;
    });
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



  @override
  Widget build(BuildContext context) {
    final isOwner = SessionManager.role == "Owner";
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Header Greeting Row matching mockup 4
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo, ${SessionManager.name} 👋",
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOwner
                          ? "Berikut ringkasan bisnismu hari ini"
                          : "Temukan produk terbaik untuk kebutuhan Anda",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                // Circular outline notification bell
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.borderColor),
                    color: context.cardBg,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: context.iconPrimary,
                      size: 24,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Belum ada notifikasi baru."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (isOwner) ...[
              // Total Penjualan Card with Sparkline Trend Graph
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DetailLaporanView(),
                    ),
                  ).then((_) => _loadDashboardData());
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Penjualan",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Rp ${_totalSales.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_up_rounded,
                                color: Color(0xFF10B981),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "12.5%",
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "dari minggu lalu",
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Custom Paint line chart matching mockup 4
                      SizedBox(
                        height: 60,
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: DashboardSparklinePainter(
                            dataPoints: _sparklineData,
                            isDark: context.isDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Summary Metric cards (Pesanan, Produk, Pelanggan)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      "Pesanan",
                      _orderCount.toString(),
                      "+8%",
                      const Color(0xFF10B981),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DetailLaporanView(initialTabIndex: 2),
                          ),
                        ).then((_) => _loadDashboardData());
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      "Produk",
                      _productCount.toString(),
                      "+5%",
                      const Color(0xFF10B981),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DetailLaporanView(initialTabIndex: 1),
                          ),
                        ).then((_) => _loadDashboardData());
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      "Pelanggan",
                      _customerCount.toString(),
                      "+10%",
                      const Color(0xFF10B981),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DetailLaporanView(initialTabIndex: 0),
                          ),
                        ).then((_) => _loadDashboardData());
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Penjualan 7 Hari Terakhir Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DetailLaporanView(),
                    ),
                  ).then((_) => _loadDashboardData());
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Penjualan 7 Hari Terakhir",
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildWeeklyBar("Sen", _weeklySales[0]),
                          _buildWeeklyBar("Sel", _weeklySales[1]),
                          _buildWeeklyBar("Rab", _weeklySales[2]),
                          _buildWeeklyBar("Kam", _weeklySales[3]),
                          _buildWeeklyBar("Jum", _weeklySales[4]),
                          _buildWeeklyBar("Sab", _weeklySales[5]),
                          _buildWeeklyBar("Min", _weeklySales[6]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Aktivitas Terbaru Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Aktivitas Terbaru",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DetailLaporanView(),
                        ),
                      );
                    },
                    child: const Text(
                      "Lihat Semua",
                      style: TextStyle(
                        color: Color(0xFF0D9488), // Teal
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Activities List Builder
              FutureBuilder<List<ActivityModel>>(
                future: DBHelper().getAllActivities(),
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
                            "Belum ada aktivitas penjualan.",
                            style: TextStyle(color: context.textPrimary),
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
                      final act = list[index];
                      final isDone = act.status == "Selesai";
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LacakPesananView(order: act),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: context.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: context.inputBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.receipt_long_rounded,
                                      color: context.iconColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pesanan ${act.kodePesanan}",
                                        style: TextStyle(
                                          color: context.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      if (act.namaProduk != null &&
                                          act.namaProduk!.isNotEmpty)
                                        Text(
                                          act.namaProduk!,
                                          style: TextStyle(
                                            color: context.textSecondary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                      Text(
                                        act.tanggal,
                                        style: TextStyle(
                                          color: context.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                      if (act.buyerEmail != null &&
                                          act.buyerEmail!.isNotEmpty)
                                        Text(
                                          "Pembeli: ${act.buyerEmail!}",
                                          style: TextStyle(
                                            color: context.textMuted,
                                            fontSize: 10,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Rp ${act.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Clean status pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDone
                                          ? (context.isDark
                                                ? const Color(0xFF064E3B)
                                                : const Color(0xFFD1FAE5))
                                          : (act.status == 'Pending'
                                                ? const Color(
                                                    0xFF0D9488,
                                                  ).withOpacity(0.12)
                                                : (context.isDark
                                                      ? const Color(0xFF78350F)
                                                      : const Color(
                                                          0xFFFEF3C7,
                                                        ))),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isDone
                                          ? act.status
                                          : (act.status == 'Pending'
                                                ? 'Diproses'
                                                : act.status),
                                      style: TextStyle(
                                        color: isDone
                                            ? (context.isDark
                                                  ? const Color(0xFF34D399)
                                                  : const Color(0xFF065F46))
                                            : (act.status == 'Pending'
                                                  ? const Color(0xFF0D9488)
                                                  : (context.isDark
                                                        ? const Color(
                                                            0xFFFBBF24,
                                                          )
                                                        : const Color(
                                                            0xFF92400E,
                                                          ))),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ] else ...[
              // Guest welcome hero banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mulai Belanja Hari Ini! 🛍️",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Dapatkan barang-barang berkualitas premium dengan pengiriman cepat ke seluruh Indonesia.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D9488),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        context
                            .findAncestorStateOfType<MainNavigationState>()
                            ?.setIndex(1);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Lihat Semua Produk",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pesanan Saya",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFF0D9488),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<ActivityModel>>(
                future: DBHelper().getActivitiesByBuyer(SessionManager.email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    );
                  }
                  final myOrders = snapshot.data ?? [];
                  if (myOrders.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: context.iconColor,
                              size: 36,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Belum ada pesanan.\nMulai belanja dan pesananmu akan muncul di sini!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: myOrders.map((act) {
                      final isDone = act.status == "Selesai";
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: context.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  act.kodePesanan,
                                  style: TextStyle(
                                    color: context.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDone
                                        ? const Color(
                                            0xFF0D9488,
                                          ).withOpacity(0.12)
                                        : Colors.amber.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isDone ? "Selesai" : "Diproses",
                                    style: TextStyle(
                                      color: isDone
                                          ? const Color(0xFF0D9488)
                                          : Colors.amber.shade800,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              act.namaProduk ?? "-",
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              act.tanggal,
                              style: TextStyle(
                                color: context.textMuted,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp ${act.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  style: const TextStyle(
                                    color: Color(0xFF0D9488),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            LacakPesananView(order: act),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D9488),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.local_shipping_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Lacak",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rekomendasi Produk",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.grid_view_rounded,
                    color: Color(0xFF0D9488),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<ProductModel>>(
                future: DBHelper().getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    );
                  }
                  final allProducts = snapshot.data ?? [];
                  final displayProducts = allProducts.take(15).toList();
                  if (displayProducts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Center(
                        child: Text(
                          "Belum ada produk tersedia.",
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
                      final isOutOfStock = product.stok <= 0;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailView(product: product),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.cardBg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: context.borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.01),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(17),
                                        ),
                                        child: (product.gambar != null &&
                                                product.gambar!.isNotEmpty)
                                            ? Image.asset(
                                                product.gambar!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, e, s) => Container(
                                                  color: context.inputBg,
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    color: context.iconColor,
                                                    size: 32,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: context.inputBg,
                                                child: Icon(
                                                  Icons.image_outlined,
                                                  color: context.iconColor,
                                                  size: 32,
                                                ),
                                              ),
                                      ),
                                    ),
                                    // Stock Badge
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOutOfStock
                                              ? const Color(0xFFEF4444)
                                              : const Color(0xFF0D9488),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          isOutOfStock
                                              ? "Habis"
                                              : "Stok: ${product.stok}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Product Details
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.kategori,
                                      style: TextStyle(
                                        color: context.textMuted,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: context.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp ${product.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                      style: const TextStyle(
                                        color: Color(0xFF0D9488),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String val,
    String trend,
    Color col, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              val,
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.arrow_upward_rounded, color: col, size: 12),
                const SizedBox(width: 2),
                Text(
                  trend,
                  style: TextStyle(
                    color: col,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyBar(String day, double amount) {
    double maxWeekly = 0.0;
    for (var val in _weeklySales) {
      if (val > maxWeekly) maxWeekly = val;
    }
    if (maxWeekly == 0.0) maxWeekly = 1.0;

    double heightPercentage = (amount / maxWeekly) * 100;
    if (heightPercentage == 0.0) heightPercentage = 5.0;

    return Column(
      children: [
        // Styled vertical bars
        Container(
          width: 24,
          height: 120 * (heightPercentage / 100),
          decoration: BoxDecoration(
            color: context.isDark
                ? const Color(0xFF0D9488)
                : const Color(0xFF1E293B), // Teal / Dark Slate
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class DashboardSparklinePainter extends CustomPainter {
  final List<double> dataPoints;
  final bool isDark;
  DashboardSparklinePainter({required this.dataPoints, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final curveColor = isDark
        ? const Color(0xFF0D9488)
        : const Color(0xFF1E293B);
    final paint = Paint()
      ..color = curveColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [curveColor.withOpacity(0.08), curveColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final pts = dataPoints.isNotEmpty
        ? dataPoints
        : [10.0, 20.0, 15.0, 35.0, 25.0, 40.0];

    double maxVal = 0.0;
    for (var val in pts) {
      if (val > maxVal) maxVal = val;
    }
    if (maxVal == 0.0) maxVal = 1.0;

    final path = Path();
    final double stepX = pts.length > 1 ? w / (pts.length - 1) : w;

    for (int i = 0; i < pts.length; i++) {
      double valPercent = pts[i] / maxVal;
      double yCoord = h * (0.8 - (0.6 * valPercent));
      double xCoord = i * stepX;

      if (i == 0) {
        path.moveTo(xCoord, yCoord);
      } else {
        final prevX = (i - 1) * stepX;
        final prevValPercent = pts[i - 1] / maxVal;
        final prevY = h * (0.8 - (0.6 * prevValPercent));

        final controlX1 = prevX + stepX / 2;
        final controlY1 = prevY;
        final controlX2 = prevX + stepX / 2;
        final controlY2 = yCoord;

        path.cubicTo(
          controlX1,
          controlY1,
          controlX2,
          controlY2,
          xCoord,
          yCoord,
        );
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DashboardSparklinePainter oldDelegate) => true;
}
