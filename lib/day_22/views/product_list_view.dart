import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/product_detail_view.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/views/cart_view.dart';
import 'package:flutter_application_1/day_22/views/toko_detail_view.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  String _selectedCategory = "Semua";
  String _searchQuery = "";
  final List<String> _categories = ["Semua", "Elektronik", "Pakaian", "Makanan", "Lainnya"];

  final List<Map<String, dynamic>> _stores = [
    {
      "nama": "BizGrow Jakarta Barat",
      "owner": "Rania Ananda",
      "rating": 4.9,
      "gambar": "assets/images/1.jpg"
    },
    {
      "nama": "Karya Mandiri Shop",
      "owner": "Budi Santoso",
      "rating": 4.7,
      "gambar": "assets/images/3.jpg"
    },
    {
      "nama": "Abadi Jaya Store",
      "owner": "Siti Aminah",
      "rating": 4.5,
      "gambar": "assets/images/8.jpg"
    },
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _newCategory = "Elektronik";
  String? _newProductImage;

  void _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final desc = _descController.text.trim();

    final product = ProductModel(
      nama: name,
      harga: price,
      stok: stock,
      deskripsi: desc,
      kategori: _newCategory,
      status: stock > 0 ? "Tersedia" : "Tidak Tersedia",
      gambar: _newProductImage,
      toko: SessionManager.businessInfo,
    );

    bool success = await DBHelper().addProduct(product);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Produk berhasil ditambahkan!"),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      _nameController.clear();
      _priceController.clear();
      _stockController.clear();
      _descController.clear();
      _newProductImage = null;
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
                  if (SessionManager.role == "Owner")
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.buttonBg,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => _showAddProductSheet(context),
                      ),
                    ),
                  if (SessionManager.role != "Owner")
                    FutureBuilder<List<CartItemModel>>(
                      future: DBHelper().getCart(SessionManager.email),
                      builder: (context, snapshot) {
                        final list = snapshot.data ?? [];
                        int totalItems = 0;
                        for (var item in list) {
                          totalItems += item.jumlah;
                        }
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: context.iconPrimary,
                                size: 26,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CartView(),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                            ),
                            if (totalItems > 0)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$totalItems',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),

            // Toko Rekomendasi Horizontal Shops Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Toko Rekomendasi 🌟",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 84,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _stores.length,
                      itemBuilder: (context, idx) {
                        final store = _stores[idx];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TokoDetailView(shopName: store["nama"]),
                              ),
                            );
                          },
                          child: Container(
                            width: 175,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: context.borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.01),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    store["gambar"],
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 40,
                                      height: 40,
                                      color: context.inputBg,
                                      child: Icon(Icons.store, color: context.iconColor, size: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        store["nama"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Owner: ${store["owner"]}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: context.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 10),
                                          const SizedBox(width: 2),
                                          Text(
                                            "${store["rating"]}",
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: context.textPrimary,
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Search Bar & Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: context.iconColor,
                          size: 20,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
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
                              color: isSel
                                  ? context.iconPrimary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSel
                                ? context.textPrimary
                                : context.textMuted,
                            fontSize: 14,
                            fontWeight: isSel
                                ? FontWeight.bold
                                : FontWeight.w600,
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
                      child: CircularProgressIndicator(
                        color: Color(0xFF0D9488),
                      ),
                    );
                  }

                  final list = snapshot.data ?? [];
                  final filtered = list.where((p) {
                    final matchSearch = p.nama.toLowerCase().contains(
                      _searchQuery,
                    );
                    if (_selectedCategory == "Semua") return matchSearch;
                    return matchSearch && p.kategori == _selectedCategory;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: context.textMuted,
                          ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final prod = filtered[index];
                      final isTersedia = prod.status == "Tersedia";
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.01),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
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
                              child: _getProductImage(prod.nama, prod.gambar).isNotEmpty
                                  ? Image.asset(
                                      _getProductImage(prod.nama, prod.gambar),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D9488).withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Rp ${prod.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                        style: const TextStyle(
                                          color: Color(0xFF0D9488), // Teal
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
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
                              // Status pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isTersedia
                                      ? (context.isDark
                                            ? const Color(0xFF064E3B)
                                            : const Color(
                                                0xFFD1FAE5,
                                              )) // dark/light green
                                      : (context.isDark
                                            ? const Color(0xFF7F1D1D)
                                            : const Color(
                                                0xFFFEE2E2,
                                              )), // dark/light red
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  prod.status,
                                  style: TextStyle(
                                    color: isTersedia
                                        ? (context.isDark
                                              ? const Color(0xFF34D399)
                                              : const Color(
                                                  0xFF065F46,
                                                )) // dark/light green text
                                        : (context.isDark
                                              ? const Color(0xFFFCA5A5)
                                              : const Color(
                                                  0xFF991B1B,
                                                )), // dark/light red text
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (SessionManager.role == "Owner") ...[
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    Icons.more_vert_rounded,
                                    color: context.iconColor,
                                  ),
                                  onPressed: () =>
                                      _showProductOptions(context, prod),
                                ),
                              ],
                            ],
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailView(product: prod),
                              ),
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
      ),
    );
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
                title: Text(
                  'Edit Produk',
                  style: TextStyle(color: context.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailView(product: product),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Hapus Produk',
                  style: TextStyle(color: Colors.red),
                ),
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
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                          ),
                        ],
                      ),
                       const SizedBox(height: 20),
                      // Display Owner's registered shop name
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.inputBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.store_rounded, color: Color(0xFF0D9488), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Toko Anda",
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    SessionManager.businessInfo,
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: context.textPrimary),
                        decoration: _inputDeco("Nama Produk"),
                        validator: (v) =>
                            v!.isEmpty ? "Nama produk wajib diisi" : null,
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
                      // Interactive image picker card
                      GestureDetector(
                        onTap: () {
                          _showImagePickerDialog(context, (selectedPath) {
                            setModalState(() {
                              _newProductImage = selectedPath;
                            });
                          });
                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: context.inputBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _newProductImage != null
                                  ? const Color(0xFF0D9488)
                                  : context.borderColor,
                              width: 1.5,
                            ),
                          ),
                          child: _newProductImage != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        _newProductImage!,
                                        width: double.infinity,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.35),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Ubah Gambar Produk",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            _newProductImage = null;
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.black.withOpacity(0.6),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: context.textSecondary,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Pilih Gambar Produk",
                                      style: TextStyle(
                                        color: context.textSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Format: JPG, PNG, WEBP",
                                      style: TextStyle(
                                        color: context.textMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _newCategory,
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
                            setModalState(() {
                              _newCategory = val;
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
                            backgroundColor: context.buttonBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _addProduct,
                          child: const Text(
                            'Simpan Produk',
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
              ),
            );
          },
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

  void _showImagePickerDialog(BuildContext context, Function(String) onSelect) {
    final List<String> images = [
      'assets/images/1.jpg',
      'assets/images/2.webp',
      'assets/images/3.jpg',
      'assets/images/4.jpg',
      'assets/images/5.jpg',
      'assets/images/6.webp',
      'assets/images/7.webp',
      'assets/images/8.jpg',
      'assets/images/9.jpg',
      'assets/images/10.jpg',
      'assets/images/11.jpg',
      'assets/images/12.jpg',
      'assets/images/13.jpg',
      'assets/images/14.jpg',
      'assets/images/15.jpg',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilih Gambar",
                style: TextStyle(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: context.iconColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 320,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final imgPath = images[index];
                return GestureDetector(
                  onTap: () {
                    onSelect(imgPath);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imgPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getProductImage(String productName, String? dbGambar) {
    if (dbGambar != null && dbGambar.isNotEmpty) {
      return dbGambar;
    }
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
      case 'Produk F':
        return 'assets/images/8.jpg';
      case 'Produk G':
        return 'assets/images/9.jpg';
      case 'Produk H':
        return 'assets/images/10.jpg';
      case 'Produk I':
        return 'assets/images/11.jpg';
      case 'Produk J':
        return 'assets/images/12.jpg';
      case 'Produk K':
        return 'assets/images/13.jpg';
      case 'Produk L':
        return 'assets/images/14.jpg';
      case 'Produk M':
        return 'assets/images/15.jpg';
      case 'Produk N':
        return 'assets/images/6.webp';
      case 'Produk O':
        return 'assets/images/7.webp';
      default:
        return '';
    }
  }
}

