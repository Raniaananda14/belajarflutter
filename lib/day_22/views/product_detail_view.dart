import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/cart_view.dart';
import 'package:flutter_application_1/day_22/views/toko_detail_view.dart';

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

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _nameController = TextEditingController(text: _product.nama);
    _priceController = TextEditingController(
      text: _product.harga.toStringAsFixed(0),
    );
    _stockController = TextEditingController(text: _product.stok.toString());
    _descController = TextEditingController(text: _product.deskripsi);
    _category = _product.kategori.isNotEmpty ? _product.kategori : "Elektronik";
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
      kategori: _category,
      status: int.parse(_stockController.text.trim()) > 0 ? "Aktif" : "Habis",
    );

    bool success = await DBHelper().updateProduct(updated);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Produk berhasil diperbarui!"),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.iconPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Detail Produk",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            if (SessionManager.role == "Owner")
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
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: _getProductImage(_product.nama).isNotEmpty
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _product.status == "Aktif"
                          ? (context.isDark
                                ? const Color(0xFF064E3B)
                                : const Color(0xFFD1FAE5))
                          : (context.isDark
                                ? const Color(0xFF7F1D1D)
                                : const Color(0xFFFEE2E2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Status: ${_product.status}",
                      style: TextStyle(
                        color: _product.status == "Aktif"
                            ? (context.isDark
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFF065F46))
                            : (context.isDark
                                  ? const Color(0xFFFCA5A5)
                                  : const Color(0xFF991B1B)),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ), // Spacing between metadata tags and shop card
              // Toko Owner Card
              GestureDetector(
                onTap: () {
                  final shopName = _product.toko ?? "BizGrow Jakarta Barat";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TokoDetailView(shopName: shopName),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Builder(
                    builder: (context) {
                      final shopName = _product.toko ?? "BizGrow Jakarta Barat";
                      final isSeeded = TokoConfig.shops.containsKey(shopName);
                      if (isSeeded) {
                        final config = TokoConfig.shops[shopName]!;
                        return _buildShopCardRow(
                          context,
                          config.nama,
                          config.owner,
                          config.email,
                        );
                      } else {
                        return FutureBuilder<Map<String, String>?>(
                          future: DBHelper().getNewOwner(),
                          builder: (context, snapshot) {
                            String ownerName = "Owner Baru";
                            String ownerEmail = "owner.baru@example.com";
                            if (snapshot.hasData && snapshot.data != null) {
                              ownerName =
                                  snapshot.data!['nama'] ?? "Owner Baru";
                              ownerEmail =
                                  snapshot.data!['email'] ??
                                  "owner.baru@example.com";
                            } else if (SessionManager.role == "Owner" &&
                                SessionManager.businessInfo == shopName) {
                              ownerName = SessionManager.name;
                              ownerEmail = SessionManager.email;
                            }
                            return _buildShopCardRow(
                              context,
                              shopName,
                              ownerName,
                              ownerEmail,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
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

              // Checkout / Beli button
              Row(
                children: [
                  if (SessionManager.role != "Owner" &&
                      _product.id != null) ...[
                    SizedBox(
                      height: 52,
                      width: 64,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0D9488),
                          side: const BorderSide(
                            color: Color(0xFF0D9488),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: _product.stok > 0
                            ? () async {
                                final success = await DBHelper().addToCart(
                                  _product.id!,
                                  SessionManager.email,
                                  1,
                                );
                                if (!mounted) return;
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Berhasil dimasukkan ke keranjang! 🛒",
                                      ),
                                      backgroundColor: const Color(0xFF10B981),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Gagal! Maksimal 100 produk dalam keranjang.",
                                      ),
                                      backgroundColor: const Color(0xFFEF4444),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _product.stok > 0
                              ? const Color(0xFF0D9488)
                              : Colors.grey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _product.stok > 0
                            ? () async {
                                final success = await DBHelper().addToCart(
                                  _product.id!,
                                  SessionManager.email,
                                  1,
                                );
                                if (!mounted) return;
                                if (success) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CartView(),
                                    ),
                                  ).then((_) {
                                    // Refresh product stock
                                    DBHelper().getAllProducts().then((
                                      allProds,
                                    ) {
                                      final matching = allProds.firstWhere(
                                        (p) => p.id == _product.id,
                                        orElse: () => _product,
                                      );
                                      if (mounted) {
                                        setState(() {
                                          _product = matching;
                                        });
                                      }
                                    });
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Gagal! Maksimal 100 produk dalam keranjang.",
                                      ),
                                      backgroundColor: const Color(0xFFEF4444),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_checkout_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _product.stok > 0
                                  ? 'Beli Sekarang'
                                  : 'Stok Habis',
                              style: const TextStyle(
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
                ],
              ),
              if (SessionManager.role == "Owner") ...[
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _deleteProduct,
                        child: const Text(
                          'Hapus Produk',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.buttonBg,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => _showEditSheet(context),
                        child: const Text(
                          'Edit Produk',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
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
                      'Edit Detail Produk',
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
                  initialValue: _category,
                  dropdownColor: context.cardBg,
                  style: TextStyle(color: context.textPrimary),
                  items: ["Elektronik", "Pakaian", "Makanan", "Lainnya"].map((
                    cat,
                  ) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        style: TextStyle(color: context.textPrimary),
                      ),
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488), // Teal
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _updateProduct,
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
        borderSide: BorderSide(
          color: context.isDark
              ? const Color(0xFF0D9488)
              : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  String _getProductImage(String productName) {
    if (_product.gambar != null && _product.gambar!.isNotEmpty) {
      return _product.gambar!;
    }
    switch (productName) {
      case 'Vas Bunga Keramik Minimalis':
        return 'assets/images/1.jpg';
      case 'Tas Anyaman Bambu Premium':
        return 'assets/images/3.jpg';
      case 'Syal Batik Tulis Indigo':
        return 'assets/images/8.jpg';
      case 'Mangkuk Kayu Jati Solid':
        return 'assets/images/9.jpg';
      case 'Terrarium Kaca Hexagonal (Habis)':
        return 'assets/images/10.jpg';
      case 'Nampan Saji Kayu Mahoni':
        return 'assets/images/2.webp';
      case 'Mouse Wireless Silent Premium':
        return 'assets/images/4.jpg';
      case 'Madu Hutan Multiflora Organik':
        return 'assets/images/5.jpg';
      case 'Kemeja Linen Casual Premium':
        return 'assets/images/6.webp';
      case 'Lilin Aromaterapi Soy Wax':
        return 'assets/images/7.webp';
      case 'Biji Kopi Arabika Gayo':
        return 'assets/images/11.jpg';
      case 'Dompet Kulit Asli Handmade':
        return 'assets/images/12.jpg';
      case 'Cangkir Keramik Lukis Hand-painted':
        return 'assets/images/13.jpg';
      case 'Keyboard Mekanikal Retro Bluetooth':
        return 'assets/images/14.jpg';
      case 'Minyak Atsiri Essential Oil Lavender':
        return 'assets/images/15.jpg';
      case 'Powerbank Fast Charging 10000mAh':
        return 'assets/images/el_1.jpg';
      case 'Earphone TWS Bluetooth 5.3':
        return 'assets/images/el_2.jpg';
      case 'Speaker Bluetooth Portable Waterproof':
        return 'assets/images/el_3.jpg';
      case 'Lampu Meja LED Smart Touch':
        return 'assets/images/el_4.jpg';
      case 'Jaket Hoodie Katun Fleece':
        return 'assets/images/pk_1.jpg';
      case 'Celana Chino Slim Fit Pria':
        return 'assets/images/pk_2.jpg';
      case 'Topi Canvas Vintage Baseball':
        return 'assets/images/pk_3.jpg';
      case 'Keripik Tempe Goreng Renyah':
        return 'assets/images/mk_1.jpg';
      case 'Teh Hijau Melati Organik':
        return 'assets/images/mk_2.jpg';
      case 'Selai Kacang Tanah Creamy':
        return 'assets/images/mk_3.jpg';
      case 'Cokelat Hitam Artisan 70%':
        return 'assets/images/mk_4.jpg';
      case 'Notebook Jurnal Kulit A5':
        return 'assets/images/ln_1.jpg';
      case 'Pajangan Dinding Macrame Leaf':
        return 'assets/images/ln_2.jpg';
    }
    return '';
  }

  Widget _buildShopCardRow(
    BuildContext context,
    String shopName,
    String owner,
    String email,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
          child: const Icon(
            Icons.store_rounded,
            color: Color(0xFF0D9488),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shopName,
                style: TextStyle(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Owner: $owner ($email)",
                style: TextStyle(color: context.textSecondary, fontSize: 11),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: Colors.grey,
        ),
      ],
    );
  }
}
