import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/invoice_a4_view.dart';
import 'package:flutter_application_1/day_22/views/product_detail_view.dart';
import 'package:flutter_application_1/day_22/views/lacak_pesanan_view.dart';
import 'package:intl/intl.dart';

class DetailLaporanView extends StatefulWidget {
  final String initialMonth;
  final int initialTabIndex;
  const DetailLaporanView({super.key, this.initialMonth = "Juni 2026", this.initialTabIndex = 0});

  @override
  State<DetailLaporanView> createState() => _DetailLaporanViewState();
}

class _DetailLaporanViewState extends State<DetailLaporanView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _selectedMonth;
  final List<String> _months = [
    "Juni 2026",
    "Mei 2024",
    "Juli 2026",
    "Agustus 2026",
  ];

  DateTimeRange? _selectedDateRange;

  // Dynamically calculated report values
  double _totalPenjualan = 0.0;
  int _totalPesanan = 0;
  double _rataRataPesanan = 0.0;
  int _produkTerjual = 0;
  int _pelangganBaru = 0;
  double _tingkatKonversi = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    _selectedMonth = widget.initialMonth;

    if (widget.initialMonth.contains(" - ")) {
      try {
        final parts = widget.initialMonth.split(" - ");
        if (parts.length == 2) {
          final start = DateFormat('dd MMM yyyy').parse(parts[0]);
          final end = DateFormat('dd MMM yyyy').parse(parts[1]);
          _selectedDateRange = DateTimeRange(start: start, end: end);
        }
      } catch (e) {
        _selectedDateRange = DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        );
      }
    } else {
      _selectedDateRange = null;
    }
    _loadFinancialDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadFinancialDetails() async {
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

    double totalPenjualan = 0.0;
    int totalPesanan = filtered.length;
    int produkTerjual = 0;
    for (var act in filtered) {
      totalPenjualan += act.total;
      produkTerjual += act.jumlah ?? 0;
    }

    setState(() {
      _totalPenjualan = totalPenjualan;
      _totalPesanan = totalPesanan;
      _rataRataPesanan = totalPesanan > 0 ? totalPenjualan / totalPesanan : 0.0;
      _produkTerjual = produkTerjual;
      _pelangganBaru = (totalPesanan * 0.4).round();
      _tingkatKonversi = totalPesanan > 0 ? 12.5 : 0.0;
    });
  }

  void _simulateForRange(DateTimeRange range) {
    _loadFinancialDetails();
  }

  void _updateSimulationForMonth(String month) {
    _loadFinancialDetails();
  }

  double get _scaleFactor {
    if (_selectedDateRange != null) {
      final days =
          _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays +
          1;
      return days / 30.0;
    } else {
      int factor = _selectedMonth.hashCode.abs() % 10;
      return 0.8 + (factor * 0.15);
    }
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
      initialDateRange:
          _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: context.isDark
                ? const ColorScheme.dark(
                    primary: Color(0xFF0D9488),
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E293B),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF1E293B),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Color(0xFF0F172A),
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _simulateForRange(picked);
      setState(() {
        _selectedDateRange = picked;
      });
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

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.iconColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Detail Laporan",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.calendar_today_rounded,
                color: context.iconColor,
                size: 20,
              ),
              onPressed: _pickDateRange,
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Column(
              children: [
                Container(color: context.borderColor, height: 1),
                TabBar(
                  controller: _tabController,
                  indicatorColor: context.textPrimary,
                  labelColor: context.textPrimary,
                  unselectedLabelColor: context.textSecondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: "Ringkasan"),
                    Tab(text: "Produk"),
                    Tab(text: "Pesanan"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Period Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Periode Laporan",
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ), // reduced vertical padding for dropdown alignment
                    decoration: BoxDecoration(
                      color: context.cardBg.withOpacity(0.7),
                      border: Border.all(color: context.borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedDateRange != null) ...[
                          Text(
                            _getFormattedPeriod(),
                            style: TextStyle(
                              color: context.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDateRange = null;
                                _selectedMonth = _months.first;
                                _updateSimulationForMonth(_selectedMonth);
                              });
                            },
                            child: Icon(
                              Icons.cancel_rounded,
                              size: 16,
                              color: context.textMuted,
                            ),
                          ),
                        ] else ...[
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _months.contains(_selectedMonth)
                                  ? _selectedMonth
                                  : _months.first,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: context.iconColor,
                              ),
                              dropdownColor: context.cardBg,
                              style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedMonth = newValue;
                                    _selectedDateRange = null;
                                    _updateSimulationForMonth(_selectedMonth);
                                  });
                                }
                              },
                              items: _months.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: context.textPrimary,
                                    ),
                                  ),
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
            ),

            // Tab Bar View content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRingkasanTab(),
                  _buildProdukTab(),
                  _buildPesananTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRingkasanTab() {
    final totalPenjualanFormatted = _totalPenjualan
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    final totalPenjualanStr = "Rp $totalPenjualanFormatted";
    final rataRataPesananFormatted = _rataRataPesanan
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    final rataRataPesananStr = "Rp $rataRataPesananFormatted";

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            children: [
              _buildSummaryRow("Total Penjualan", totalPenjualanStr),
              Divider(height: 1, color: context.dividerColor),
              _buildSummaryRow("Total Pesanan", _totalPesanan.toString()),
              Divider(height: 1, color: context.dividerColor),
              _buildSummaryRow("Rata-rata Pesanan", rataRataPesananStr),
              Divider(height: 1, color: context.dividerColor),
              _buildSummaryRow("Produk Terjual", _produkTerjual.toString()),
              Divider(height: 1, color: context.dividerColor),
              _buildSummaryRow("Pelanggan Baru", _pelangganBaru.toString()),
              Divider(height: 1, color: context.dividerColor),
              _buildSummaryRow(
                "Tingkat Konversi",
                "${_tingkatKonversi.toStringAsFixed(1)}%",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProdukTab() {
    return FutureBuilder<List<ActivityModel>>(
      future: DBHelper().getAllActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D9488)),
          );
        }
        final list = snapshot.data ?? [];

        // Filter based on selected period
        final filtered = list.where((act) {
          final dt = _parseDateString(act.tanggal);
          if (dt == null) return false;
          if (_selectedDateRange != null) {
            return _isDateInRange(dt, _selectedDateRange!);
          } else {
            return _isDateInMonth(dt, _selectedMonth);
          }
        }).toList();

        // Group by product name
        final Map<String, Map<String, dynamic>> productMap = {};
        for (var pName in ["Produk A", "Produk B", "Produk C", "Produk D"]) {
          productMap[pName] = {
            "name": pName,
            "qty": 0,
            "sales": 0.0,
          };
        }

        for (var act in filtered) {
          final pName = act.namaProduk ?? "Produk A";
          if (productMap.containsKey(pName)) {
            productMap[pName]!["qty"] = (productMap[pName]!["qty"] as int) + (act.jumlah ?? 0);
            productMap[pName]!["sales"] = (productMap[pName]!["sales"] as double) + act.total;
          } else {
            productMap[pName] = {
              "name": pName,
              "qty": act.jumlah ?? 0,
              "sales": act.total,
            };
          }
        }

        final items = productMap.values.toList();

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final imgPath = _getProductImage(item["name"]);
            return GestureDetector(
              onTap: () async {
                final dbProducts = await DBHelper().getAllProducts();
                final matching = dbProducts.firstWhere(
                  (p) =>
                      p.nama.toLowerCase().trim() ==
                      item["name"].toString().toLowerCase().trim(),
                  orElse: () => ProductModel(
                    nama: item["name"],
                    harga: 0.0,
                    stok: 0,
                    deskripsi: "",
                    kategori: "",
                    status: "Aktif",
                  ),
                );
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailView(product: matching),
                    ),
                  ).then((_) {
                    _loadFinancialDetails();
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.inputBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imgPath.isNotEmpty
                                ? Image.asset(
                                    imgPath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          color: context.iconColor,
                                          size: 20,
                                        ),
                                  )
                                : Icon(
                                    Icons.inventory_2_outlined,
                                    color: context.iconColor,
                                    size: 20,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Terjual: ${item["qty"]} unit",
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "Rp ${(item["sales"] as double).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                      style: const TextStyle(
                        color: Color(0xFF0D9488),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildPesananTab() {
    return FutureBuilder<List<ActivityModel>>(
      future: DBHelper().getAllActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D9488)),
          );
        }
        var list = snapshot.data ?? [];

        // Filter based on selected period
        list = list.where((act) {
          final dt = _parseDateString(act.tanggal);
          if (dt == null) return false;
          if (_selectedDateRange != null) {
            return _isDateInRange(dt, _selectedDateRange!);
          } else {
            return _isDateInMonth(dt, _selectedMonth);
          }
        }).toList();

        // Sort chronologically ascending
        list.sort((a, b) {
          final dtA = _parseDateString(a.tanggal) ?? DateTime(1970);
          final dtB = _parseDateString(b.tanggal) ?? DateTime(1970);
          return dtA.compareTo(dtB);
        });

        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Belum ada pesanan pada periode ini.",
                style: TextStyle(
                  color: context.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        double totalInvoice = 0.0;
        for (var act in list) {
          totalInvoice += act.total;
        }

        final totalInvoiceFormatted = totalInvoice
            .toStringAsFixed(0)
            .replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            );

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                        Text(
                          "Total Nilai Invoice",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${list.length} Pesanan",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rp $totalInvoiceFormatted",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Akumulasi nilai transaksi pada periode terpilih",
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                ),
              );
            }

            final act = list[index - 1];
            String orderImg = "assets/images/10.jpg";
            if (act.kodePesanan.contains("1001")) {
              orderImg = "assets/images/1.jpg";
            } else if (act.kodePesanan.contains("1002")) {
              orderImg = "assets/images/3.jpg";
            } else if (act.kodePesanan.contains("1003")) {
              orderImg = "assets/images/8.jpg";
            }

            return GestureDetector(
              onTap: () => _showOrderDetailSheet(context, act),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.inputBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              orderImg,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: context.iconColor,
                                    size: 20,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: ${act.kodePesanan}",
                              style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              act.tanggal,
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                            Text(
                              act.status,
                              style: TextStyle(
                                color: act.status == "Selesai"
                                    ? const Color(0xFF0D9488)
                                    : Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0D9488),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InvoiceA4View(
                                    order: act,
                                    isReadOnly: true,
                                  ),
                                ),
                              );
                            },
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
    );
  }

  void _showOrderDetailSheet(BuildContext context, ActivityModel order) {
    String prodName = "Produk A";
    String prodImage = "assets/images/1.jpg";
    if (order.kodePesanan.contains("1002")) {
      prodName = "Produk B";
      prodImage = "assets/images/3.jpg";
    } else if (order.kodePesanan.contains("1003")) {
      prodName = "Produk C";
      prodImage = "assets/images/8.jpg";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Detail Pesanan",
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
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        prodImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Icon(
                          Icons.shopping_bag_outlined,
                          size: 30,
                          color: context.iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.kodePesanan,
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prodName,
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.tanggal,
                            style: TextStyle(
                              color: context.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: context.borderColor),
                const SizedBox(height: 16),
                _buildOrderDetailRow("Metode Pembayaran:", "Transfer Bank"),
                const SizedBox(height: 8),
                _buildOrderDetailRow(
                  "Status Pesanan:",
                  order.status,
                  isStatus: true,
                ),
                const SizedBox(height: 8),
                _buildOrderDetailRow(
                  "Total Pembayaran:",
                  "Rp ${order.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                  isTotal: true,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LacakPesananView(order: order),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              "Lacak Pesanan",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.textPrimary,
                          side: BorderSide(color: context.borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  InvoiceA4View(order: order, isReadOnly: true),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              color: Color(0xFF0D9488),
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Invoice A4",
                              style: TextStyle(
                                color: Color(0xFF0D9488),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.textPrimary,
                          side: BorderSide(color: context.borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Tutup",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
  }

  Widget _buildOrderDetailRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isStatus = false,
  }) {
    Color valColor = context.textPrimary;
    if (isTotal) {
      valColor = const Color(0xFF0D9488);
    } else if (isStatus) {
      valColor = value == "Selesai" ? const Color(0xFF10B981) : Colors.amber;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valColor,
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getProductImage(String productName) {
    switch (productName) {
      case 'Produk A':
        return 'assets/images/1.jpg';
      case 'Produk B':
        return 'assets/images/3.jpg';
      case 'Produk C':
        return 'assets/images/8.jpg';
      case 'Produk D':
        return 'assets/images/9.jpg';
      case 'Produk E (Habis)':
        return 'assets/images/10.jpg';
      default:
        return '';
    }
  }
}
