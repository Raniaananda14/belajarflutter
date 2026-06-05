import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';

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

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _nameController = TextEditingController(text: _product.nama);
    _priceController = TextEditingController(text: _product.harga.toStringAsFixed(0));
    _stockController = TextEditingController(text: _product.stok.toString());
    _descController = TextEditingController(text: _product.deskripsi);
  }

  void _deleteProduct() async {
    if (_product.id != null) {
      await DBHelper().deleteProduct(_product.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil dihapus"), backgroundColor: Colors.redAccent),
        );
        Navigator.pop(context);
      }
    }
  }

  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = ProductModel(
      id: _product.id,
      nama: _nameController.text.trim(),
      harga: double.parse(_priceController.text.trim()),
      stok: int.parse(_stockController.text.trim()),
      deskripsi: _descController.text.trim(),
      kategori: _product.kategori,
      status: int.parse(_stockController.text.trim()) > 0 ? "Aktif" : "Habis",
    );

    bool success = await DBHelper().updateProduct(updated);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil diperbarui!"), backgroundColor: Color(0xFF10B981)),
      );
      setState(() {
        _product = updated;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Produk", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () => _showEditSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Box
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: const Center(
                child: Icon(Icons.image_outlined, size: 72, color: Colors.white30),
              ),
            ),
            const SizedBox(height: 24),

            // Title and basic details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _product.nama,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Rp ${_product.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                  style: const TextStyle(color: Color(0xFF14B8A6), fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Stok: ${_product.stok}",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Metadata labels
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Kategori: ${_product.kategori}",
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _product.status == "Aktif" ? const Color(0xFF10B981).withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Status: ${_product.status}",
                style: TextStyle(
                  color: _product.status == "Aktif" ? const Color(0xFF10B981) : Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              "Deskripsi",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _product.deskripsi.isNotEmpty ? _product.deskripsi : "Tidak ada deskripsi untuk produk ini.",
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 48),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _deleteProduct,
                    child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _showEditSheet(context),
                    child: const Text('Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Edit Produk',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Nama Produk"),
                  validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Harga (Rp)"),
                  validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Jumlah Stok"),
                  validator: (v) => v!.isEmpty ? "Stok wajib diisi" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Deskripsi Produk"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _updateProduct,
                  child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    );
  }
}
