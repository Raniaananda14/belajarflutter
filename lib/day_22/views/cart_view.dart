import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/pilih_lokasi_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CartItemModel> _cartItems = [];
  bool _isLoading = true;
  final Set<int> _selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() async {
    setState(() {
      _isLoading = true;
    });
    final items = await DBHelper().getCart(SessionManager.email);
    setState(() {
      _cartItems = items;
      if (_selectedItemIds.isNotEmpty) {
        final currentIds = items.map((e) => e.id).toSet();
        _selectedItemIds.retainAll(currentIds.whereType<int>());
      }
      _isLoading = false;
    });
  }

  void _updateQuantity(CartItemModel item, int newQty) async {
    if (newQty < 1) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hapus Item"),
          content: Text("Apakah Anda yakin ingin menghapus ${item.productNama} dari keranjang?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    final success = await DBHelper().updateCartItemQuantity(item.id!, newQty, SessionManager.email);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Gagal! Maksimal 100 produk dalam keranjang."),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
    _loadCart();
  }

  void _removeItem(CartItemModel item) async {
    await DBHelper().removeFromCart(item.id!);
    _loadCart();
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

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    int totalItems = 0;
    int totalCapacity = 0;
    for (var item in _cartItems) {
      totalCapacity += item.jumlah;
      if (item.id != null && _selectedItemIds.contains(item.id)) {
        totalPrice += item.productHarga * item.jumlah;
        totalItems += item.jumlah;
      }
    }

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
            "Keranjang Belanja",
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            if (_cartItems.isNotEmpty) ...[
              IconButton(
                icon: Icon(
                  _selectedItemIds.length == _cartItems.length
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: const Color(0xFF0D9488),
                ),
                onPressed: () {
                  setState(() {
                    if (_selectedItemIds.length == _cartItems.length) {
                      _selectedItemIds.clear();
                    } else {
                      for (var item in _cartItems) {
                        if (item.id != null) {
                          _selectedItemIds.add(item.id!);
                        }
                      }
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: _selectedItemIds.isEmpty ? Colors.grey : Colors.redAccent,
                ),
                onPressed: _selectedItemIds.isEmpty
                    ? null
                    : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Hapus Item Terpilih"),
                            content: Text("Apakah Anda yakin ingin menghapus ${_selectedItemIds.length} produk terpilih dari keranjang?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          for (var id in _selectedItemIds) {
                            await DBHelper().removeFromCart(id);
                          }
                          setState(() {
                            _selectedItemIds.clear();
                          });
                          _loadCart();
                        }
                      },
              ),
            ],
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
            : _cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: context.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          "Keranjang belanja Anda kosong",
                          style: TextStyle(color: context.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mulai tambahkan produk pilihan Anda ke keranjang!",
                          style: TextStyle(color: context.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        color: const Color(0xFF0D9488).withOpacity(0.06),
                        child: Text(
                          "Total Kapasitas: $totalCapacity / 100 produk",
                          style: const TextStyle(
                            color: Color(0xFF0D9488),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            final prodImg = _getProductImage(item.productNama, item.productGambar);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
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
                              child: Row(
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: context.iconColor,
                                    ),
                                    child: Checkbox(
                                      activeColor: const Color(0xFF0D9488),
                                      checkColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      value: _selectedItemIds.contains(item.id),
                                      onChanged: (bool? checked) {
                                        setState(() {
                                          if (checked == true) {
                                            if (item.id != null) {
                                              _selectedItemIds.add(item.id!);
                                            }
                                          } else {
                                            if (item.id != null) {
                                              _selectedItemIds.remove(item.id!);
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: context.inputBg,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: prodImg.isNotEmpty
                                          ? Image.asset(
                                              prodImg,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) => Icon(
                                                Icons.image_outlined,
                                                color: context.iconColor,
                                              ),
                                            )
                                          : Icon(
                                              Icons.image_outlined,
                                              color: context.iconColor,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.productNama,
                                                style: TextStyle(
                                                  color: context.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => _removeItem(item),
                                              child: const Icon(
                                                Icons.close_rounded,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Rp ${item.productHarga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                          style: const TextStyle(
                                            color: Color(0xFF0D9488),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () => _updateQuantity(item, item.jumlah - 1),
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.inputBg,
                                                  border: Border.all(color: context.borderColor),
                                                ),
                                                child: Icon(Icons.remove, size: 14, color: context.iconColor),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 14),
                                              child: Text(
                                                '${item.jumlah}',
                                                style: TextStyle(
                                                  color: context.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => _updateQuantity(item, item.jumlah + 1),
                                              child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.inputBg,
                                                  border: Border.all(color: context.borderColor),
                                                ),
                                                child: Icon(Icons.add, size: 14, color: context.iconColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          border: Border(top: BorderSide(color: context.borderColor)),
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Pembayaran",
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                    style: const TextStyle(
                                      color: Color(0xFF0D9488),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedItemIds.isEmpty
                                        ? Colors.grey.shade400
                                        : const Color(0xFF0F172A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: _selectedItemIds.isEmpty
                                      ? null
                                      : () {
                                          final selectedItems = _cartItems
                                              .where((item) =>
                                                  item.id != null &&
                                                  _selectedItemIds.contains(item.id))
                                              .toList();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PilihLokasiView(
                                                cartItems: selectedItems,
                                              ),
                                            ),
                                          ).then((_) => _loadCart());
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_checkout_rounded,
                                        color: _selectedItemIds.isEmpty ? Colors.white70 : Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Lanjut ke Checkout${totalItems > 0 ? ' ($totalItems)' : ''}",
                                        style: TextStyle(
                                          color: _selectedItemIds.isEmpty ? Colors.white70 : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
