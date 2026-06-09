import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class InvoiceA4View extends StatefulWidget {
  final ActivityModel order;
  final ProductModel? product;
  final bool isReadOnly;
  const InvoiceA4View({super.key, required this.order, this.product, this.isReadOnly = false});

  @override
  State<InvoiceA4View> createState() => _InvoiceA4ViewState();
}

class _InvoiceA4ViewState extends State<InvoiceA4View> {
  late int _qty;
  late double _unitPrice;
  late String _prodName;

  @override
  void initState() {
    super.initState();
    _prodName = widget.product?.nama ?? "Produk A";
    _unitPrice = widget.product?.harga ?? 150000.0;
    _qty = widget.product != null ? 1 : (widget.order.total / _unitPrice).round().clamp(1, 99);
    if (widget.product == null) {
      if (widget.order.kodePesanan.contains("1002")) {
        _prodName = "Produk B";
        _unitPrice = 200000.0;
        _qty = (widget.order.total / _unitPrice).round().clamp(1, 99);
      } else if (widget.order.kodePesanan.contains("1003")) {
        _prodName = "Produk C";
        _unitPrice = 75000.0;
        _qty = (widget.order.total / _unitPrice).round().clamp(1, 99);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = _unitPrice * _qty;
    final double tax = subtotal * 0.11; // 11% VAT
    final double total = subtotal + tax;

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
            "Invoice A4 Preview",
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              // A4 Aspect Ratio Container (1:1.414)
              Center(
                child: AspectRatio(
                  aspectRatio: 1 / 1.414,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D9488),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0D9488).withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1.5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.auto_graph_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "BIZGROW",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Solusi Tumbuh Bisnis Anda",
                                      style: TextStyle(fontSize: 8, color: const Color(0xFF475569)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "INVOICE",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "No: INV-${widget.order.kodePesanan.replaceAll('#', '')}",
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: const Color(0xFFCBD5E1)),
                        const SizedBox(height: 16),

                        // Billing Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("DITERBITKAN UNTUK:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
                                const SizedBox(height: 4),
                                const Text("Rania Ananda", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                const Text("rania@gmail.com", style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                                const Text("Jakarta, Indonesia", style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("TANGGAL TRANSAKSI:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
                                const SizedBox(height: 4),
                                Text(widget.order.tanggal, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                const SizedBox(height: 8),
                                Text("METODE PEMBAYARAN:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF64748B))),
                                const SizedBox(height: 4),
                                const Text("Transfer Bank", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Table Headers
                        Container(
                          color: const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: const Row(
                            children: [
                              Expanded(flex: 3, child: Text("DESKRIPSI PRODUK", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                              Expanded(flex: 2, child: Text("QTY", textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                              Expanded(flex: 2, child: Text("HARGA", textAlign: TextAlign.right, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                              Expanded(flex: 2, child: Text("TOTAL", textAlign: TextAlign.right, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                            ],
                          ),
                        ),

                        // Table Item Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_prodName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    const SizedBox(height: 2),
                                    Text("Produk premium pilihan", style: TextStyle(fontSize: 8, color: const Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "$_qty",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Rp ${_unitPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 9, color: Color(0xFF0F172A)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Rp ${subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 0.5, color: const Color(0xFFE2E8F0)),

                        const Spacer(),

                        // Subtotal & Calculations
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomSizedWidthBox(
                              width: 180,
                              child: Column(
                                children: [
                                  _buildInvoiceSummaryRow("Subtotal", subtotal),
                                  const SizedBox(height: 6),
                                  _buildInvoiceSummaryRow("PPN (11%)", tax),
                                  const SizedBox(height: 6),
                                  Container(height: 1, color: const Color(0xFFCBD5E1)),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Akhir", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                      Text(
                                        "Rp ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // Bottom Signatures
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Catatan:", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF475569))),
                                const SizedBox(height: 2),
                                Text("1. Pembayaran sah setelah dana masuk rekening.", style: TextStyle(fontSize: 7, color: const Color(0xFF64748B))),
                                Text("2. Invoice ini diterbitkan secara elektronik.", style: TextStyle(fontSize: 7, color: const Color(0xFF64748B))),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Hormat Kami,", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                const SizedBox(height: 24),
                                const Text("BIZGROW FINANCE", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Color(0xFF0F172A))),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Checkout Action Button / Print Button
              if (!widget.isReadOnly) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ).buttons(
                    context: context,
                    order: widget.order,
                    qty: _qty,
                    total: total,
                  ),
                ),
                const SizedBox(height: 20),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Simulasi mencetak invoice A4..."),
                            backgroundColor: const Color(0xFF0D9488),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.print_rounded, color: context.isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B)),
                          const SizedBox(width: 8),
                          Text(
                            "Cetak Invoice (Selesai)",
                            style: TextStyle(
                              color: context.isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
        // Floating action checkout +/- buttons
        floatingActionButton: widget.isReadOnly
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Minus button
                  FloatingActionButton(
                    heroTag: 'btn_minus',
                    backgroundColor: const Color(0xFF64748B),
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.remove, color: Colors.white, size: 24),
                    onPressed: () {
                      if (_qty > 1) {
                        setState(() {
                          _qty--;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Jumlah $_prodName berkurang menjadi $_qty!"),
                            backgroundColor: const Color(0xFF64748B),
                            duration: const Duration(milliseconds: 700),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  // Plus button
                  FloatingActionButton(
                    heroTag: 'btn_plus',
                    backgroundColor: const Color(0xFF0D9488),
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                    onPressed: () {
                      setState(() {
                        _qty++;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Jumlah $_prodName bertambah menjadi $_qty!"),
                          backgroundColor: const Color(0xFF0D9488),
                          duration: const Duration(milliseconds: 700),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInvoiceSummaryRow(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 9, color: const Color(0xFF475569))),
        Text(
          "Rp ${val.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }
}

class CustomSizedWidthBox extends StatelessWidget {
  final double width;
  final Widget child;
  const CustomSizedWidthBox({super.key, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}

extension on ButtonStyle {
  Widget buttons({
    required BuildContext context,
    required ActivityModel order,
    required int qty,
    required double total,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Checkout sukses untuk ${order.kodePesanan} (Qty: $qty, Total: Rp ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')})!"),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Navigator.pop(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Checkout Sekarang",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
