import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/invoice_a4_view.dart';
import 'package:flutter_application_1/day_22/views/lacak_pesanan_view.dart';

class GroupedOrder {
  final String kodePesanan;
  final String tanggal;
  final double total;
  final String status;
  final String? alamat;
  final double? koordinatX;
  final double? koordinatY;
  final String productNames;
  final List<ActivityModel> items;

  GroupedOrder({
    required this.kodePesanan,
    required this.tanggal,
    required this.total,
    required this.status,
    this.alamat,
    this.koordinatX,
    this.koordinatY,
    required this.productNames,
    required this.items,
  });
}

class PesananSayaView extends StatefulWidget {
  const PesananSayaView({super.key});

  @override
  State<PesananSayaView> createState() => _PesananSayaViewState();
}

class _PesananSayaViewState extends State<PesananSayaView> {
  List<GroupedOrder> _groupedOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    final rawOrders = await DBHelper().getActivitiesByBuyer(SessionManager.email);
    
    // Group orders by kodePesanan
    final Map<String, List<ActivityModel>> groups = {};
    for (var act in rawOrders) {
      groups.putIfAbsent(act.kodePesanan, () => []).add(act);
    }
    
    final List<GroupedOrder> grouped = [];
    groups.forEach((kode, items) {
      final isPending = items.any((item) => item.status == "Pending");
      final status = isPending ? "Pending" : "Selesai";
      
      final double total = items.fold(0.0, (sum, item) => sum + item.total);
      final productNames = items.map((item) => "${item.namaProduk} (${item.jumlah}x)").join(", ");
      
      grouped.add(GroupedOrder(
        kodePesanan: kode,
        tanggal: items.first.tanggal,
        total: total,
        status: status,
        alamat: items.first.alamat,
        koordinatX: items.first.koordinatX,
        koordinatY: items.first.koordinatY,
        productNames: productNames,
        items: items,
      ));
    });

    setState(() {
      _groupedOrders = grouped;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.iconPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Pesanan Saya",
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
            : _groupedOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 64, color: context.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          "Belum ada pesanan",
                          style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mulai belanja dan lacak pengiriman pesananmu di sini!",
                          style: TextStyle(color: context.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadOrders,
                    color: const Color(0xFF0D9488),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: _groupedOrders.length,
                      itemBuilder: (context, index) {
                        final order = _groupedOrders[index];
                        final isDone = order.status == "Selesai";
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.kodePesanan,
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDone
                                          ? const Color(0xFF0D9488).withOpacity(0.12)
                                          : Colors.amber.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isDone ? "Selesai" : "Diproses",
                                      style: TextStyle(
                                        color: isDone ? const Color(0xFF0D9488) : Colors.amber.shade800,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                order.productNames,
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.tanggal,
                                style: TextStyle(
                                  color: context.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rp ${order.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                    style: const TextStyle(
                                      color: Color(0xFF0D9488),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (isDone) ...[
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => InvoiceA4View(
                                                  order: order.items.first,
                                                  isReadOnly: true,
                                                  address: order.alamat ?? "Jakarta, Indonesia",
                                                ),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(0xFF0D9488)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.description_rounded,
                                            size: 14,
                                            color: Color(0xFF0D9488),
                                          ),
                                          label: const Text(
                                            "Lihat Invoice",
                                            style: TextStyle(
                                              color: Color(0xFF0D9488),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Pass the first raw activity model representing this grouped transaction
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => LacakPesananView(order: order.items.first),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0D9488),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
