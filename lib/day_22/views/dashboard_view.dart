import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/cargo_catcher_view.dart';
import 'package:flutter_application_1/day_22/views/detail_laporan_view.dart';
import 'package:flutter_application_1/day_22/views/lacak_pesanan_view.dart';
import 'package:flutter_application_1/day_22/views/main_navigation.dart';
import 'package:flutter_application_1/day_22/views/pesanan_saya_view.dart';
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
  String _selectedCategory = "Semua";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDashboardData() async {
    List<ActivityModel> activities = await DBHelper().getAllActivities();
    final isOwner = SessionManager.role == "Owner";
    final isNewOwner = isOwner && SessionManager.email != "rania@gmail.com";
    if (isNewOwner) {
      activities = activities
          .where((act) => act.buyerEmail != null && act.buyerEmail!.isNotEmpty)
          .toList();
      if (activities.isEmpty) {
        activities = [
          ActivityModel(
            id: 9991,
            kodePesanan: "#BIZ-8001",
            tanggal: "11 Juni 2026",
            total: 150000.0,
            status: "Selesai",
            alamat: "Jl. Merdeka No. 10, Jakarta",
            koordinatX: -6.2088,
            koordinatY: 106.8456,
            namaProduk: "Produk A",
            jumlah: 1,
            buyerEmail: "buyer.demo@example.com",
          ),
          ActivityModel(
            id: 9992,
            kodePesanan: "#BIZ-8002",
            tanggal: "10 Juni 2026",
            total: 240000.0,
            status: "Selesai",
            alamat: "Jl. Sudirman No. 45, Jakarta",
            koordinatX: -6.2189,
            koordinatY: 106.8557,
            namaProduk: "Produk B",
            jumlah: 2,
            buyerEmail: "buyer.demo@example.com",
          ),
          ActivityModel(
            id: 9993,
            kodePesanan: "#BIZ-8003",
            tanggal: "09 Juni 2026",
            total: 350000.0,
            status: "Selesai",
            alamat: "Jl. Gatot Subroto No. 12, Jakarta",
            koordinatX: -6.2290,
            koordinatY: 106.8658,
            namaProduk: "Produk C",
            jumlah: 1,
            buyerEmail: "buyer.demo@example.com",
          ),
        ];
      }
    }
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

    double weeklySum = weeklySales.fold(0.0, (a, b) => a + b);
    if (weeklySum == 0.0) {
      weeklySales[0] = 450000.0;  // Sen
      weeklySales[2] = 850000.0;  // Rab
      weeklySales[3] = 650000.0;  // Kam
      weeklySales[4] = 500000.0;  // Jum
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

    if (sparklineData.isEmpty) {
      sparklineData.addAll([100000.0, 300000.0, 250000.0, 450000.0, 350000.0, 500000.0]);
    }

    setState(() {
      _totalSales = totalSales == 0.0 ? 2150000.0 : totalSales;
      _orderCount = activities.length == 0 ? 4 : activities.length;
      _productCount = products.length;
      _customerCount = activities.length == 0 ? 12 : (activities.length * 0.5).round().clamp(1, 999);
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

  Widget _buildShopeeHeader(BuildContext context) {
    final isOwner = SessionManager.role == "Owner";
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: context.textPrimary, fontSize: 14),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari produk di BizGrow...",
                hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, color: context.textSecondary, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PesananSayaView()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            context
                .findAncestorStateOfType<MainNavigationState>()
                ?.setIndex(isOwner ? 4 : 2);
          },
          child: CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
            backgroundImage: SessionManager.profileImage != null && SessionManager.profileImage!.isNotEmpty
                ? AssetImage(SessionManager.profileImage!)
                : null,
            child: SessionManager.profileImage == null || SessionManager.profileImage!.isEmpty
                ? Text(
                    SessionManager.name.isNotEmpty ? SessionManager.name[0].toUpperCase() : "U",
                    style: const TextStyle(
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
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
            if (!isOwner)
              _buildShopeeHeader(context)
            else
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
              _buildGameBanner(context),
            ] else ...[
              // Recommended Products placed first
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
                ],
              ),
              const SizedBox(height: 12),

              // Category Bubble Chips
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children:
                      [
                        "Semua",
                        "Elektronik",
                        "Pakaian",
                        "Makanan",
                        "Lainnya",
                      ].map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0D9488)
                                  : context.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF0D9488)
                                    : context.borderColor,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: const Color(
                                      0xFF0D9488,
                                    ).withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : context.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),
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
                  final filteredProducts = allProducts.where((p) {
                    final matchesCategory = _selectedCategory == "Semua" || p.kategori == _selectedCategory;
                    final matchesSearch = p.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        p.deskripsi.toLowerCase().contains(_searchQuery.toLowerCase());
                    return matchesCategory && matchesSearch;
                  }).toList();
                  final displayProducts = filteredProducts.take(15).toList();
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.70,
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
                              builder: (_) =>
                                  ProductDetailView(product: product),
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
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(17),
                                            ),
                                        child:
                                            (product.gambar != null &&
                                                product.gambar!.isNotEmpty)
                                            ? Image.asset(
                                                product.gambar!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, e, s) =>
                                                    Container(
                                                      color: context.inputBg,
                                                      child: Icon(
                                                        Icons.image_outlined,
                                                        color:
                                                            context.iconColor,
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
                                    // Peringkat Badge
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFF59E0B).withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "Peringkat ${index + 1}",
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
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0D9488).withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "Rp ${product.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                            style: const TextStyle(
                                              color: Color(0xFF0D9488),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          isOutOfStock ? "Tidak Tersedia" : "Stok: ${product.stok}",
                                          style: TextStyle(
                                            color: isOutOfStock ? const Color(0xFFEF4444) : context.textSecondary,
                                            fontSize: 10,
                                            fontWeight: isOutOfStock ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
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
              const SizedBox(height: 24),

              // Guest welcome hero banner pushed down
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
              const SizedBox(height: 24),

              // Game banner pushed down
              _buildGameBanner(context),
            ],
            const SizedBox(height: 30),
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

  Widget _buildGameBanner(BuildContext context) {
    final highscore = SessionManager.cargoHighScore;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Game: Tangkap Kargo! 🚚",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (highscore > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFBBF24).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFFBBF24),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$highscore pts",
                        style: const TextStyle(
                          color: Color(0xFFFBBF24),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Bantu driver BizGrow menangkap kargo dan koin yang jatuh. Mainkan sendiri atau aktifkan Autopilot AI untuk melihat simulasi!",
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D9488),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CargoCatcherView()),
              ).then((_) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
            label: const Text(
              "Mainkan Sekarang",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
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
