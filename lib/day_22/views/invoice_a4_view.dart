import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class InvoiceA4View extends StatefulWidget {
  final ActivityModel order;
  final ProductModel? product;
  final String address;
  final double? koordinatX;
  final double? koordinatY;
  final bool isReadOnly;
  const InvoiceA4View({
    super.key,
    required this.order,
    this.product,
    this.address = "Jakarta, Indonesia",
    this.koordinatX,
    this.koordinatY,
    this.isReadOnly = false,
  });

  @override
  State<InvoiceA4View> createState() => _InvoiceA4ViewState();
}

class _InvoiceA4ViewState extends State<InvoiceA4View> {
  late int _qty;
  late double _unitPrice;
  late String _prodName;
  DateTime _selectedDate = DateTime(2026, 6, 10);
  List<ActivityModel> _invoiceItems = [];
  bool _isLoading = true;

  String _formatIndonesianDate(DateTime dt) {
    final months = [
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
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
  }

  Future<void> _loadInvoiceItems() async {
    final items = await DBHelper().getActivitiesByOrderCode(widget.order.kodePesanan);
    if (mounted) {
      setState(() {
        _invoiceItems = items;
        if (_invoiceItems.isEmpty) {
          _invoiceItems = [widget.order];
        }
        _isLoading = false;
      });
    }
  }

  void _executeCheckout(double totalAmount) async {
    final dateStr = _formatIndonesianDate(_selectedDate);
    
    if (_invoiceItems.length <= 1 && widget.product != null) {
      // Single-product checkout flow
      await DBHelper().addActivity(
        ActivityModel(
          kodePesanan: widget.order.kodePesanan,
          tanggal: dateStr,
          total: totalAmount,
          status: "Selesai",
          alamat: widget.address,
          koordinatX: widget.koordinatX,
          koordinatY: widget.koordinatY,
          namaProduk: _prodName,
          jumlah: _qty,
          buyerEmail: widget.order.buyerEmail ?? SessionManager.email,
        ),
      );

      // Decrement product stock if product is not null
      if (widget.product!.id != null) {
        final newStock = (widget.product!.stok - _qty).clamp(0, 999);
        await DBHelper().updateProductStock(widget.product!.id!, newStock);
      }
    } else {
      // Multi-item / Cart checkout flow
      for (var item in _invoiceItems) {
        await DBHelper().addActivity(
          ActivityModel(
            id: item.id,
            kodePesanan: item.kodePesanan,
            tanggal: dateStr,
            total: item.total,
            status: "Selesai",
            alamat: widget.address,
            koordinatX: widget.koordinatX,
            koordinatY: widget.koordinatY,
            namaProduk: item.namaProduk,
            jumlah: item.jumlah,
            buyerEmail: item.buyerEmail ?? SessionManager.email,
          ),
        );
      }
      
      // Clear the cart
      await DBHelper().clearCart(SessionManager.email);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Checkout sukses untuk ${widget.order.kodePesanan}!",
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _prodName = widget.product?.nama ?? widget.order.namaProduk ?? "Produk A";
    _unitPrice = widget.product?.harga ?? 150000.0;
    _qty = widget.product != null
        ? 1
        : (widget.order.jumlah ?? (widget.order.total / _unitPrice).round().clamp(1, 99));
        
    // Fallback detection logic for old seed data
    if (widget.product == null && widget.order.namaProduk == null) {
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
    _loadInvoiceItems();
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = 0.0;
    if (_invoiceItems.length <= 1) {
      subtotal = _unitPrice * _qty;
    } else {
      for (var item in _invoiceItems) {
        subtotal += item.total;
      }
    }
    final double tax = subtotal * 0.11; // 11% VAT
    final double total = subtotal + tax;

    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.iconPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Invoice A4 Preview",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
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
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
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
                                        color: const Color(
                                          0xFF0D9488,
                                        ).withValues(alpha: 0.2),
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
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: const Color(0xFF475569),
                                      ),
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
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DITERBITKAN UNTUK:",
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    SessionManager.name,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    SessionManager.email,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    widget.address,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "TANGGAL TRANSAKSI:",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.isReadOnly
                                      ? widget.order.tanggal
                                      : _formatIndonesianDate(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "METODE PEMBAYARAN:",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Transfer Bank",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Table Headers
                        Container(
                          color: const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "DESKRIPSI PRODUK",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "QTY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "HARGA",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "TOTAL",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Table Item Rows
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF0D9488),
                              ),
                            ),
                          )
                        else if (_invoiceItems.length <= 1)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _prodName,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Produk premium pilihan",
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "$_qty",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Rp ${_unitPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Rp ${subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 0.5, color: const Color(0xFFE2E8F0)),
                            ],
                          )
                        else
                          Column(
                            children: _invoiceItems.map((item) {
                              final double itemPrice = item.total / (item.jumlah ?? 1);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.namaProduk ?? "-",
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0F172A),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Produk premium pilihan",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "${item.jumlah}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Rp ${itemPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Rp ${item.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 0.5, color: const Color(0xFFE2E8F0)),
                                ],
                              );
                            }).toList(),
                          ),

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
                                  Container(
                                    height: 1,
                                    color: const Color(0xFFCBD5E1),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Total Akhir",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text(
                                        "Rp ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0D9488),
                                        ),
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
                                Text(
                                  "Catatan:",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "1. Pembayaran sah setelah dana masuk rekening.",
                                  style: TextStyle(
                                    fontSize: 7,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  "2. Invoice ini diterbitkan secara elektronik.",
                                  style: TextStyle(
                                    fontSize: 7,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Hormat Kami,",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "BIZGROW FINANCE",
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
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
                const SizedBox(height: 10),
                // Address summary card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF0D9488),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "LOKASI PENGIRIMAN",
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.address,
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Date Selector button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal Transaksi",
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              final isDark =
                                  Theme.of(context).brightness ==
                                  Brightness.dark;
                              return Theme(
                                data:
                                    (isDark
                                            ? ThemeData.dark()
                                            : ThemeData.light())
                                        .copyWith(
                                          colorScheme: ColorScheme.fromSeed(
                                            seedColor: const Color(0xFF0D9488),
                                            brightness: isDark
                                                ? Brightness.dark
                                                : Brightness.light,
                                            primary: const Color(0xFF0D9488),
                                          ),
                                        ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: context.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: context.borderColor,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    color: Color(0xFF0D9488),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _formatIndonesianDate(_selectedDate),
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.edit_calendar_rounded,
                                color: context.iconColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Checkout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _executeCheckout(total),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_checkout_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Checkout Sekarang",
                            style: TextStyle(
                              color: Colors.white,
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
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: context.isDark
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF1E293B),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Simulasi mencetak invoice A4...",
                            ),
                            backgroundColor: const Color(0xFF0D9488),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.print_rounded,
                            color: context.isDark
                                ? const Color(0xFF0D9488)
                                : const Color(0xFF1E293B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Cetak Invoice (Selesai)",
                            style: TextStyle(
                              color: context.isDark
                                  ? const Color(0xFF0D9488)
                                  : const Color(0xFF1E293B),
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
        floatingActionButton: widget.isReadOnly || _invoiceItems.length > 1
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
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      if (_qty > 1) {
                        setState(() {
                          _qty--;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Jumlah $_prodName berkurang menjadi $_qty!",
                            ),
                            backgroundColor: const Color(0xFF64748B),
                            duration: const Duration(milliseconds: 700),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                          content: Text(
                            "Jumlah $_prodName bertambah menjadi $_qty!",
                          ),
                          backgroundColor: const Color(0xFF0D9488),
                          duration: const Duration(milliseconds: 700),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
        Text(
          label,
          style: TextStyle(fontSize: 9, color: const Color(0xFF475569)),
        ),
        Text(
          "Rp ${val.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

class CustomSizedWidthBox extends StatelessWidget {
  final double width;
  final Widget child;
  const CustomSizedWidthBox({
    super.key,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}

class MapPainter extends CustomPainter {
  final Offset? markerPosition;
  MapPainter({this.markerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint();

    // 1. Ocean Background - Soft Google Maps water blue
    final oceanRect = Rect.fromLTWH(0, 0, w, h);
    final oceanPaint = Paint()..color = const Color(0xFFA5C9EB);
    canvas.drawRect(oceanRect, oceanPaint);

    // Subtle coordinate grid
    paint.color = Colors.white.withValues(alpha: 0.2);
    paint.strokeWidth = 0.8;
    for (double i = 0; i < w; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, h), paint);
    }
    for (double i = 0; i < h; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(w, i), paint);
    }

    // 2. Land Paint - Google Maps signature warm beige
    final landColor = const Color(0xFFF1F3F4);
    final landPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = landColor;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFDADCE0) // Google Maps light grey border
      ..strokeWidth = 1.0;

    // Green Parks / Forest Paint - Google Maps soft green
    final parkPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFDFF1D7);

    // Draw Islands with smooth Bezier curves:
    // 1. Sumatera
    final pathSumatera = Path()
      ..moveTo(w * 0.04, h * 0.18)
      ..quadraticBezierTo(w * 0.08, h * 0.14, w * 0.12, h * 0.16)
      ..lineTo(w * 0.22, h * 0.30)
      ..quadraticBezierTo(w * 0.30, h * 0.42, w * 0.35, h * 0.56)
      ..quadraticBezierTo(w * 0.36, h * 0.61, w * 0.31, h * 0.62)
      ..quadraticBezierTo(w * 0.28, h * 0.60, w * 0.24, h * 0.54)
      ..lineTo(w * 0.12, h * 0.38)
      ..quadraticBezierTo(w * 0.06, h * 0.28, w * 0.04, h * 0.18)
      ..close();
    canvas.drawPath(pathSumatera, landPaint);

    final pathSumateraParks = Path()
      ..moveTo(w * 0.08, h * 0.20)
      ..quadraticBezierTo(w * 0.12, h * 0.22, w * 0.15, h * 0.28)
      ..lineTo(w * 0.25, h * 0.45)
      ..quadraticBezierTo(w * 0.29, h * 0.49, w * 0.27, h * 0.54)
      ..close();
    canvas.drawPath(pathSumateraParks, parkPaint);
    canvas.drawPath(pathSumatera, borderPaint);

    // 2. Jawa
    final pathJawa = Path()
      ..moveTo(w * 0.33, h * 0.67)
      ..quadraticBezierTo(w * 0.42, h * 0.66, w * 0.50, h * 0.70)
      ..quadraticBezierTo(w * 0.55, h * 0.70, w * 0.58, h * 0.71)
      ..quadraticBezierTo(w * 0.58, h * 0.74, w * 0.54, h * 0.73)
      ..quadraticBezierTo(w * 0.46, h * 0.72, w * 0.33, h * 0.69)
      ..close();
    canvas.drawPath(pathJawa, landPaint);

    final pathJawaParks = Path()
      ..moveTo(w * 0.35, h * 0.68)
      ..quadraticBezierTo(w * 0.40, h * 0.68, w * 0.43, h * 0.71)
      ..quadraticBezierTo(w * 0.48, h * 0.71, w * 0.52, h * 0.72)
      ..close();
    canvas.drawPath(pathJawaParks, parkPaint);
    canvas.drawPath(pathJawa, borderPaint);

    // 3. Kalimantan
    final pathKalimantan = Path()
      ..moveTo(w * 0.38, h * 0.35)
      ..quadraticBezierTo(w * 0.40, h * 0.26, w * 0.44, h * 0.24)
      ..quadraticBezierTo(w * 0.48, h * 0.22, w * 0.52, h * 0.21)
      ..quadraticBezierTo(w * 0.56, h * 0.25, w * 0.58, h * 0.32)
      ..quadraticBezierTo(w * 0.60, h * 0.38, w * 0.58, h * 0.42)
      ..quadraticBezierTo(w * 0.56, h * 0.48, w * 0.53, h * 0.49)
      ..quadraticBezierTo(w * 0.46, h * 0.51, w * 0.40, h * 0.46)
      ..quadraticBezierTo(w * 0.36, h * 0.42, w * 0.38, h * 0.35)
      ..close();
    canvas.drawPath(pathKalimantan, landPaint);

    final pathKalimantanParks = Path()
      ..moveTo(w * 0.42, h * 0.28)
      ..quadraticBezierTo(w * 0.48, h * 0.25, w * 0.52, h * 0.30)
      ..quadraticBezierTo(w * 0.50, h * 0.42, w * 0.44, h * 0.40)
      ..close();
    canvas.drawPath(pathKalimantanParks, parkPaint);
    canvas.drawPath(pathKalimantan, borderPaint);

    // 4. Sulawesi
    final pathSulawesi = Path()
      ..moveTo(w * 0.60, h * 0.38)
      ..quadraticBezierTo(w * 0.62, h * 0.27, w * 0.72, h * 0.22)
      ..quadraticBezierTo(w * 0.73, h * 0.24, w * 0.67, h * 0.32)
      ..quadraticBezierTo(w * 0.72, h * 0.38, w * 0.73, h * 0.42)
      ..quadraticBezierTo(w * 0.69, h * 0.44, w * 0.71, h * 0.53)
      ..quadraticBezierTo(w * 0.67, h * 0.52, w * 0.65, h * 0.45)
      ..quadraticBezierTo(w * 0.63, h * 0.58, w * 0.60, h * 0.58)
      ..quadraticBezierTo(w * 0.61, h * 0.48, w * 0.61, h * 0.42)
      ..close();
    canvas.drawPath(pathSulawesi, landPaint);

    final pathSulawesiParks = Path()
      ..moveTo(w * 0.64, h * 0.38)
      ..quadraticBezierTo(w * 0.66, h * 0.42, w * 0.68, h * 0.46)
      ..close();
    canvas.drawPath(pathSulawesiParks, parkPaint);
    canvas.drawPath(pathSulawesi, borderPaint);

    // 5. Papua
    final pathPapua = Path()
      ..moveTo(w * 0.80, h * 0.40)
      ..quadraticBezierTo(w * 0.83, h * 0.37, w * 0.85, h * 0.39)
      ..quadraticBezierTo(w * 0.84, h * 0.42, w * 0.87, h * 0.43)
      ..quadraticBezierTo(w * 0.94, h * 0.42, w * 0.98, h * 0.45)
      ..quadraticBezierTo(w * 0.99, h * 0.55, w * 0.98, h * 0.62)
      ..quadraticBezierTo(w * 0.92, h * 0.61, w * 0.88, h * 0.58)
      ..quadraticBezierTo(w * 0.84, h * 0.54, w * 0.80, h * 0.40)
      ..close();
    canvas.drawPath(pathPapua, landPaint);

    final pathPapuaParks = Path()
      ..moveTo(w * 0.84, h * 0.42)
      ..quadraticBezierTo(w * 0.90, h * 0.45, w * 0.94, h * 0.50)
      ..quadraticBezierTo(w * 0.88, h * 0.54, w * 0.85, h * 0.48)
      ..close();
    canvas.drawPath(pathPapuaParks, parkPaint);
    canvas.drawPath(pathPapua, borderPaint);

    // 6. Bali & Nusa Tenggara
    final pathBaliNusa = Path()
      ..moveTo(w * 0.59, h * 0.72)
      ..lineTo(w * 0.61, h * 0.73)
      ..quadraticBezierTo(w * 0.68, h * 0.74, w * 0.75, h * 0.75)
      ..quadraticBezierTo(w * 0.75, h * 0.77, w * 0.68, h * 0.76)
      ..lineTo(w * 0.59, h * 0.74)
      ..close();
    canvas.drawPath(pathBaliNusa, landPaint);
    canvas.drawPath(pathBaliNusa, borderPaint);

    // Google Maps Styled Highways (Gold/Yellow with outlines)
    final highwayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFFDD663) // Gold highway
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final localRoadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white // Local road
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    // Draw main Trans-island highway routes:
    // Sumatera highway (Banda Aceh -> Medan -> Padang -> Palembang -> Lampung)
    final pathSumateraHighways = Path()
      ..moveTo(w * 0.06, h * 0.12)
      ..lineTo(w * 0.12, h * 0.22)
      ..lineTo(w * 0.18, h * 0.38)
      ..lineTo(w * 0.28, h * 0.50)
      ..lineTo(w * 0.34, h * 0.58);
    canvas.drawPath(pathSumateraHighways, highwayPaint);

    // Jawa highway (Jakarta -> Bandung -> Semarang -> Yogyakarta -> Surabaya -> Denpasar -> Mataram -> Kupang)
    final pathJawaHighways = Path()
      ..moveTo(w * 0.36, h * 0.67)
      ..lineTo(w * 0.40, h * 0.69)
      ..lineTo(w * 0.47, h * 0.70)
      ..lineTo(w * 0.48, h * 0.72)
      ..lineTo(w * 0.54, h * 0.71)
      ..lineTo(w * 0.59, h * 0.73)
      ..lineTo(w * 0.63, h * 0.74)
      ..lineTo(w * 0.74, h * 0.76);
    canvas.drawPath(pathJawaHighways, highwayPaint);

    // Kalimantan highway (Pontianak -> Banjarmasin -> Balikpapan -> Samarinda)
    final pathKalimantanHighways = Path()
      ..moveTo(w * 0.43, h * 0.38)
      ..lineTo(w * 0.52, h * 0.46)
      ..lineTo(w * 0.55, h * 0.38)
      ..lineTo(w * 0.56, h * 0.34);
    canvas.drawPath(pathKalimantanHighways, highwayPaint);

    // Sulawesi highway (Makassar -> Palu -> Manado)
    final pathSulawesiHighways = Path()
      ..moveTo(w * 0.63, h * 0.53)
      ..lineTo(w * 0.64, h * 0.36)
      ..lineTo(w * 0.72, h * 0.23);
    canvas.drawPath(pathSulawesiHighways, highwayPaint);

    // Papua highway (Sorong -> Jayapura -> Merauke)
    final pathPapuaHighways = Path()
      ..moveTo(w * 0.81, h * 0.41)
      ..lineTo(w * 0.96, h * 0.46)
      ..lineTo(w * 0.97, h * 0.61);
    canvas.drawPath(pathPapuaHighways, highwayPaint);

    // Thrown in local white roads branching out from hubs:
    final localRoads = Path()
      ..moveTo(w * 0.12, h * 0.22)..lineTo(w * 0.10, h * 0.26)
      ..moveTo(w * 0.36, h * 0.67)..lineTo(w * 0.35, h * 0.62)
      ..moveTo(w * 0.54, h * 0.71)..lineTo(w * 0.56, h * 0.68)
      ..moveTo(w * 0.55, h * 0.38)..lineTo(w * 0.51, h * 0.35);
    canvas.drawPath(localRoads, localRoadPaint);

    // Island Labels
    void drawIslandLabel(String text, Offset position) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Color(0xFF70757A), // Google Maps secondary grey label
            fontSize: 9.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          position.dx - textPainter.width / 2,
          position.dy - textPainter.height / 2,
        ),
      );
    }

    drawIslandLabel("SUMATERA", Offset(w * 0.17, h * 0.38));
    drawIslandLabel("KALIMANTAN", Offset(w * 0.48, h * 0.33));
    drawIslandLabel("SULAWESI", Offset(w * 0.67, h * 0.37));
    drawIslandLabel("PAPUA", Offset(w * 0.89, h * 0.51));
    drawIslandLabel("JAWA", Offset(w * 0.43, h * 0.75));

    // Draw City Nodes (Shipping Hubs) - Google Maps Style Business Pins
    final cityPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final cityBorder = Paint()
      ..color = const Color(0xFF1A73E8) // Google Maps blue
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final cityGlow = Paint()
      ..color = const Color(0xFF1A73E8).withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    void drawCityNode(String name, Offset pos) {
      canvas.drawCircle(pos, 5.0, cityGlow);
      canvas.drawCircle(pos, 3.0, cityPaint);
      canvas.drawCircle(pos, 3.0, cityBorder);

      final textPainter = TextPainter(
        text: TextSpan(
          text: name,
          style: const TextStyle(
            color: Color(0xFF202124), // Google Maps dark grey
            fontSize: 8.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Tiny badge background for readability
      final rectPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          pos.dx - textPainter.width / 2 - 3,
          pos.dy + 4,
          textPainter.width + 6,
          textPainter.height + 2,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rrect, rectPaint);
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = const Color(0xFFDADCE0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );

      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, pos.dy + 5),
      );
    }

    // Draw all 24 shipping hubs dynamically
    drawCityNode("Banda Aceh", Offset(w * 0.06, h * 0.12));
    drawCityNode("Medan", Offset(w * 0.12, h * 0.22));
    drawCityNode("Padang", Offset(w * 0.18, h * 0.38));
    drawCityNode("Palembang", Offset(w * 0.28, h * 0.50));
    drawCityNode("B. Lampung", Offset(w * 0.34, h * 0.58));

    drawCityNode("Jakarta", Offset(w * 0.36, h * 0.67));
    drawCityNode("Bandung", Offset(w * 0.40, h * 0.69));
    drawCityNode("Semarang", Offset(w * 0.47, h * 0.70));
    drawCityNode("Yogyakarta", Offset(w * 0.48, h * 0.72));
    drawCityNode("Surabaya", Offset(w * 0.54, h * 0.71));

    drawCityNode("Pontianak", Offset(w * 0.43, h * 0.38));
    drawCityNode("Banjarmasin", Offset(w * 0.52, h * 0.46));
    drawCityNode("Balikpapan", Offset(w * 0.55, h * 0.38));
    drawCityNode("Samarinda", Offset(w * 0.56, h * 0.34));

    drawCityNode("Makassar", Offset(w * 0.63, h * 0.53));
    drawCityNode("Palu", Offset(w * 0.64, h * 0.36));
    drawCityNode("Manado", Offset(w * 0.72, h * 0.23));

    drawCityNode("Denpasar", Offset(w * 0.59, h * 0.73));
    drawCityNode("Mataram", Offset(w * 0.63, h * 0.74));
    drawCityNode("Kupang", Offset(w * 0.74, h * 0.76));

    drawCityNode("Ambon", Offset(w * 0.77, h * 0.45));

    drawCityNode("Sorong", Offset(w * 0.81, h * 0.41));
    drawCityNode("Jayapura", Offset(w * 0.96, h * 0.46));
    drawCityNode("Merauke", Offset(w * 0.97, h * 0.61));
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) =>
      oldDelegate.markerPosition != markerPosition;
}

