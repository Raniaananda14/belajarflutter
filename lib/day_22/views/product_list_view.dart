import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/product_detail_view.dart';
import 'package:flutter_application_1/day_22/views/invoice_a4_view.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  String _selectedCategory = "Semua";
  String _searchQuery = "";
  final List<String> _categories = ["Semua", "Aktif", "Habis"];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _newCategory = "Elektronik";
  String _newStatus = "Aktif";

  void _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final desc = _descController.text.trim();

    String defaultImg = 'assets/images/1.jpg';
    if (_newCategory == 'Pakaian') {
      defaultImg = 'assets/images/3.jpg';
    } else if (_newCategory == 'Makanan') {
      defaultImg = 'assets/images/9.jpg';
    } else if (_newCategory == 'Lainnya') {
      defaultImg = 'assets/images/10.jpg';
    }

    final product = ProductModel(
      nama: name,
      harga: price,
      stok: stock,
      deskripsi: desc,
      kategori: _newCategory,
      status: stock == 0 ? "Habis" : _newStatus,
      gambar: defaultImg,
    );

    bool success = await DBHelper().addProduct(product);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Produk berhasil ditambahkan!"),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _nameController.clear();
      _priceController.clear();
      _stockController.clear();
      _descController.clear();
      setState(() {});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
        children: [
          // Title Bar & Add Button matching Mockup 5
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Produk",
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                // Circular black plus button
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.buttonBg,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add, color: Colors.white, size: 22),
                    onPressed: () => _showAddProductSheet(context),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.toLowerCase();
                      });
                    },
                    style: TextStyle(color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: "Cari produk...",
                      hintStyle: TextStyle(color: context.textMuted),
                      filled: true,
                      fillColor: context.cardBg,
                      prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: context.isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    border: Border.all(color: context.borderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune_rounded, color: context.iconColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Simulasi filter produk."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar matching Mockup 5
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final isSel = cat == _selectedCategory;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSel ? context.iconPrimary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSel ? context.textPrimary : context.textMuted,
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Products List Grid
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: DBHelper().getAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF0D9488)),
                  );
                }

                final list = snapshot.data ?? [];
                final filtered = list.where((p) {
                  final matchSearch = p.nama.toLowerCase().contains(_searchQuery);
                  if (_selectedCategory == "Semua") return matchSearch;
                  return matchSearch && p.status == _selectedCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 48, color: context.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          "Tidak ada produk.",
                          style: TextStyle(color: context.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final prod = filtered[index];
                    final isActive = prod.status == "Aktif";
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: context.inputBg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: (prod.gambar != null && prod.gambar!.isNotEmpty)
                                ? Image.asset(
                                    prod.gambar!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.image_outlined,
                                      color: context.iconColor,
                                      size: 28,
                                    ),
                                  )
                                : _getProductImage(prod.nama).isNotEmpty
                                    ? Image.asset(
                                        _getProductImage(prod.nama),
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.image_outlined,
                                          color: context.iconColor,
                                          size: 28,
                                        ),
                                      )
                                    : Icon(
                                        Icons.image_outlined,
                                        color: context.iconColor,
                                        size: 28,
                                      ),
                          ),
                        ),
                        title: Text(
                          prod.nama,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rp ${prod.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                style: const TextStyle(
                                  color: Color(0xFF0D9488), // Teal
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Stok: ${prod.stok}",
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isActive) ...[
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0D9488).withOpacity(0.12),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.add, color: Color(0xFF0D9488), size: 18),
                                  onPressed: () {
                                    final simulatedOrder = ActivityModel(
                                      kodePesanan: "#BIZ-${(1000 + (prod.id ?? 99))}",
                                      tanggal: "09 Jun 2026",
                                      total: prod.harga,
                                      status: "Selesai",
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InvoiceA4View(
                                          order: simulatedOrder,
                                          product: prod,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            // Status pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? (context.isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5)) // dark/light green
                                    : (context.isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2)), // dark/light red
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                prod.status,
                                style: TextStyle(
                                  color: isActive
                                      ? (context.isDark ? const Color(0xFF34D399) : const Color(0xFF065F46)) // dark/light green text
                                      : (context.isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B)), // dark/light red text
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(Icons.more_vert_rounded, color: context.iconColor),
                              onPressed: () => _showProductOptions(context, prod),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetailView(product: prod)),
                          );
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),);
  }

  void _showProductOptions(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit_outlined, color: context.iconColor),
                title: Text('Edit Produk', style: TextStyle(color: context.textPrimary)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailView(product: product)),
                  ).then((_) => setState(() {}));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: const Text('Hapus Produk', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  if (product.id != null) {
                    await DBHelper().deleteProduct(product.id!);
                    setState(() {});
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Produk berhasil dihapus"),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                      'Tambah Produk Baru',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                  validator: (v) => v!.isEmpty ? "Nama produk wajib diisi" : null,
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
                  style: TextStyle(color: context.textPrimary),
                  decoration: _inputDeco("Deskripsi Produk"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _newCategory,
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
                      _newCategory = val;
                    }
                  },
                  decoration: _inputDeco("Kategori"),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _newStatus,
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
                      _newStatus = val;
                    }
                  },
                  decoration: _inputDeco("Status"),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.buttonBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: _addProduct,
                    child: const Text(
                      'Simpan Produk',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.isDark ? const Color(0xFF0D9488) : const Color(0xFF1E293B)),
      ),
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
