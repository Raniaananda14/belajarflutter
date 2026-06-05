import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/views/product_detail_view.dart';

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

  void _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      nama: _nameController.text.trim(),
      harga: double.parse(_priceController.text.trim()),
      stok: int.parse(_stockController.text.trim()),
      deskripsi: _descController.text.trim(),
      kategori: _newCategory,
      status: int.parse(_stockController.text.trim()) > 0 ? "Aktif" : "Habis",
    );

    bool success = await DBHelper().addProduct(product);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan!"), backgroundColor: Color(0xFF10B981)),
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
    return Column(
      children: [
        // Title Bar & Add Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: const Color(0xFF1E293B),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Produk",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF14B8A6), size: 28),
                onPressed: () => _showAddProductSheet(context),
              )
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val.toLowerCase();
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Cari produk...",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.04),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Categories selector
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSel = cat == _selectedCategory;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF14B8A6) : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSel ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Products List Grid
        Expanded(
          child: FutureBuilder<List<ProductModel>>(
            future: DBHelper().getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
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
                      Icon(Icons.inbox_outlined, size: 48, color: Colors.white24),
                      const SizedBox(height: 12),
                      Text("Tidak ada produk.", style: TextStyle(color: Colors.white.withOpacity(0.4))),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final prod = filtered[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.01),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF14B8A6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF14B8A6)),
                      ),
                      title: Text(
                        prod.nama,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        "Rp ${prod.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}\nStok: ${prod.stok}",
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: prod.status == "Aktif" ? const Color(0xFF10B981).withOpacity(0.15) : Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          prod.status,
                          style: TextStyle(
                            color: prod.status == "Aktif" ? const Color(0xFF10B981) : Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
    );
  }

  void _showAddProductSheet(BuildContext context) {
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
                  'Tambah Produk Baru',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDeco("Nama Produk"),
                  validator: (v) => v!.isEmpty ? "Nama produk wajib diisi" : null,
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
                  onPressed: _addProduct,
                  child: const Text('Simpan Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
