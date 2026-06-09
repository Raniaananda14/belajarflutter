import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late ProductModel _product;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descController;
  late String _category;
  late String _status;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _nameController = TextEditingController(text: _product.nama);
    _priceController = TextEditingController(text: _product.harga.toStringAsFixed(0));
    _stockController = TextEditingController(text: _product.stok.toString());
    _descController = TextEditingController(text: _product.deskripsi);
    _category = _product.kategori.isNotEmpty ? _product.kategori : "Elektronik";
    _status = _product.status.isNotEmpty ? _product.status : "Aktif";
  }

  void _deleteProduct() async {
    if (_product.id != null) {
      await DBHelper().deleteProduct(_product.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Produk berhasil dihapus"),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final stockVal = int.parse(_stockController.text.trim());
    final finalStatus = stockVal == 0 ? "Habis" : _status;

    final updated = ProductModel(
      id: _product.id,
      nama: _nameController.text.trim(),
      harga: double.parse(_priceController.text.trim()),
      stok: stockVal,
      deskripsi: _descController.text.trim(),
      kategori: _category,
      status: finalStatus,
      gambar: _product.gambar,
    );

    bool success = await DBHelper().updateProduct(updated);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Produk berhasil diperbarui!"),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      setState(() {
        _product = updated;
      });
      Navigator.pop(context);
    }
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
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.iconPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Detail Produk",
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: context.iconPrimary),
              onPressed: () => _showEditSheet(context),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Box matching Mockup 5 style
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: (_product.gambar != null && _product.gambar!.isNotEmpty)
                      ? Image.asset(
                          _product.gambar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_outlined,
                            size: 72,
                            color: context.iconColor,
                          ),
                        )
                      : _getProductImage(_product.nama).isNotEmpty
                          ? Image.asset(
                              _getProductImage(_product.nama),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.image_outlined,
                                size: 72,
                                color: context.iconColor,
                              ),
                            )
                          : Icon(
                              Icons.image_outlined,
                              size: 72,
                              color: context.iconColor,
                            ),
                ),
              ),
            const SizedBox(height: 24),

            // Title and basic details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _product.nama,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Text(
                  "Rp ${_product.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                  style: const TextStyle(
                    color: Color(0xFF0D9488),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Stok: ${_product.stok} unit tersedia",
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Metadata labels
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Text(
                    "Kategori: ${_product.kategori}",
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _product.status == "Aktif"
                        ? (context.isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5))
                        : (context.isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Status: ${_product.status}",
                    style: TextStyle(
                      color: _product.status == "Aktif"
                          ? (context.isDark ? const Color(0xFF34D399) : const Color(0xFF065F46))
                          : (context.isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B)),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Description
            Text(
              "Deskripsi Produk",
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Text(
                _product.deskripsi.isNotEmpty
                    ? _product.deskripsi
                    : "Tidak ada deskripsi untuk produk ini.",
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _deleteProduct,
                    child: const Text('Hapus Produk', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _showEditSheet(context),
                    child: const Text(
                      'Edit Produk',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),);
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                      'Edit Detail Produk',
                      style: TextStyle(color: context.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: context.iconColor),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Nama Produk"),
                  validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Harga (Rp)"),
                  validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Jumlah Stok"),
                  validator: (v) => v!.isEmpty ? "Stok wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Deskripsi Produk"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  dropdownColor: context.cardBg,
                  style: TextStyle(color: context.textPrimary),
                  items: ["Elektronik", "Pakaian", "Makanan", "Lainnya"].map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: TextStyle(color: context.textPrimary)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _category = val;
                      });
                    }
                  },
                  decoration: _inputDeco("Kategori"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  dropdownColor: context.cardBg,
                  style: TextStyle(color: context.textPrimary),
                  items: ["Aktif", "Habis"].map((stat) {
                    return DropdownMenuItem(
                      value: stat,
                      child: Text(stat, style: TextStyle(color: context.textPrimary)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _status = val;
                      });
                    }
                  },
                  decoration: _inputDeco("Status"),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488), // Teal
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: _updateProduct,
                    child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.textSecondary),
      filled: true,
      fillColor: context.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: context.isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B))),
    );
  }

  String _getProductImage(String productName) {
    switch (productName) {
      case 'Produk A':
        return 'assets/images/1.jpg';
      case 'Produk B':
        return 'assets/images/2.webp';
      case 'Produk C':
        return 'assets/images/3.jpg';
      case 'Produk D':
        return 'assets/images/4.jpg';
      case 'Produk E (Habis)':
        return 'assets/images/5.jpg';
      default:
        return '';
    }
  }
}
