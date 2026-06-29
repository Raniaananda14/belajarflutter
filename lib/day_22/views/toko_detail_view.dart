import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/product_detail_view.dart';
 
class TokoConfig {
  final String nama;
  final String owner;
  final String alamat;
  final String email;
  final double rating;

  const TokoConfig({
    required this.nama,
    required this.owner,
    required this.alamat,
    required this.email,
    required this.rating,
  });

  static const Map<String, TokoConfig> shops = {
    "BizGrow Jakarta Barat": TokoConfig(
      nama: "BizGrow Jakarta Barat",
      owner: "Rania Ananda",
      alamat: "Jl. M.H. Thamrin No. 8, Jakarta Pusat (Gudang Utama)",
      email: "rania@gmail.com",
      rating: 4.9,
    ),
    "Karya Mandiri Shop": TokoConfig(
      nama: "Karya Mandiri Shop",
      owner: "Budi Santoso",
      alamat: "Jl. Diponegoro No. 24, Medan (Cabang Sumatera)",
      email: "budi.karyamandiri@example.com",
      rating: 4.7,
    ),
    "Abadi Jaya Store": TokoConfig(
      nama: "Abadi Jaya Store",
      owner: "Siti Aminah",
      alamat: "Jl. Basuki Rahmat No. 100, Surabaya (Cabang Jawa Timur)",
      email: "siti.abadijaya@example.com",
      rating: 4.8,
    ),
  };

  static TokoConfig getByName(String? name) {
    return shops[name] ?? shops["BizGrow Jakarta Barat"]!;
  }
}

class TokoDetailView extends StatefulWidget {
  final String shopName;
  const TokoDetailView({super.key, required this.shopName});

  @override
  State<TokoDetailView> createState() => _TokoDetailViewState();
}

class _TokoDetailViewState extends State<TokoDetailView> {
  List<ProductModel> _shopProducts = [];
  bool _isLoading = true;
  String _selectedStatus = "Semua";

  @override
  void initState() {
    super.initState();
    _loadShopProducts();
  }

  void _loadShopProducts() async {
    setState(() {
      _isLoading = true;
    });
    final products = await DBHelper().getProductsByShop(widget.shopName);
    setState(() {
      _shopProducts = products;
      _isLoading = false;
    });
  }

  void _showChatSimulator(BuildContext context, String shopName, String ownerName) {
    final TextEditingController msgController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    final List<Map<String, dynamic>> messages = [
      {
        "sender": "owner",
        "text": "Halo! Selamat datang di $shopName. Ada yang bisa saya bantu terkait produk kami? 😊",
        "time": "Baru saja"
      }
    ];

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
            void scrollDown() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  // Chat Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: context.borderColor)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
                          child: const Icon(Icons.store_rounded, color: Color(0xFF0D9488)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shopName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.textPrimary,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Online (Owner: $ownerName)",
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: context.iconColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Chat Messages Area
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg["sender"] == "user";
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFF0D9488)
                                  : context.inputBg,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 16),
                              ),
                            ),
                            child: Text(
                              msg["text"],
                              style: TextStyle(
                                color: isMe ? Colors.white : context.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Chat Input Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: context.borderColor)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.inputBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: TextField(
                              controller: msgController,
                              style: TextStyle(color: context.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Kirim pesan ke Owner...",
                                hintStyle: TextStyle(color: context.textMuted),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D9488),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white, size: 18),
                            onPressed: () {
                              final text = msgController.text.trim();
                              if (text.isEmpty) return;

                              setModalState(() {
                                messages.add({
                                  "sender": "user",
                                  "text": text,
                                  "time": "Baru saja"
                                });
                              });
                              msgController.clear();
                              scrollDown();

                              // Simulate typing indicator reply
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                if (!context.mounted) return;
                                String reply = "Terima kasih atas pesan Anda! Kami akan segera merespons pertanyaan Anda secepatnya.";
                                final lowerText = text.toLowerCase();
                                if (lowerText.contains("stok") || lowerText.contains("ready")) {
                                  reply = "Semua produk yang bertanda 'Tersedia' siap dikirim! Stok kami terupdate secara real-time di aplikasi.";
                                } else if (lowerText.contains("diskon") || lowerText.contains("promo") || lowerText.contains("murah")) {
                                  reply = "Harga kami sudah harga terbaik, namun kami sering mengadakan promo khusus di akhir bulan. Ditunggu ya!";
                                } else if (lowerText.contains("kirim") || lowerText.contains("ongkir") || lowerText.contains("lokasi")) {
                                  reply = "Lokasi toko kami tertera di detail toko. Pesanan dikirim segera setelah pembayaran diverifikasi.";
                                }

                                setModalState(() {
                                  messages.add({
                                    "sender": "owner",
                                    "text": reply,
                                    "time": "Baru saja"
                                  });
                                });
                                scrollDown();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getProductImage(String productName, String? dbGambar) {
    if (dbGambar != null && dbGambar.isNotEmpty) {
      return dbGambar;
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
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopName = widget.shopName;
    final isSeeded = TokoConfig.shops.containsKey(shopName);

    if (isSeeded) {
      final config = TokoConfig.shops[shopName]!;
      return _buildMainLayout(context, config.nama, config.owner, config.alamat, config.email, config.rating);
    } else {
      return FutureBuilder<Map<String, String>?>(
        future: DBHelper().getNewOwner(),
        builder: (context, snapshot) {
          String ownerName = "Owner Baru";
          String ownerEmail = "owner.baru@example.com";
          if (snapshot.hasData && snapshot.data != null) {
            ownerName = snapshot.data!['nama'] ?? "Owner Baru";
            ownerEmail = snapshot.data!['email'] ?? "owner.baru@example.com";
          } else if (SessionManager.role == "Owner" && SessionManager.businessInfo == shopName) {
            ownerName = SessionManager.name;
            ownerEmail = SessionManager.email;
          }
          return _buildMainLayout(context, shopName, ownerName, "Alamat Toko Belum Ditentukan", ownerEmail, 5.0);
        },
      );
    }
  }

  Widget _buildMainLayout(
    BuildContext context,
    String shopName,
    String owner,
    String alamat,
    String email,
    double rating,
  ) {
    // Filter products locally by status
    final filteredProducts = _shopProducts.where((p) {
      if (_selectedStatus == "Semua") return true;
      return p.status == _selectedStatus;
    }).toList();

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
            shopName,
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0D9488)),
              onPressed: () => _showChatSimulator(context, shopName, owner),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Header/Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      color: const Color(0xFF0D9488).withOpacity(0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFF0D9488).withOpacity(0.1),
                                child: const Icon(Icons.store_rounded, color: Color(0xFF0D9488), size: 36),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shopName,
                                      style: TextStyle(
                                        color: context.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Owner: $owner",
                                      style: TextStyle(
                                        color: context.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  alamat,
                                  style: TextStyle(color: context.textSecondary, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                email,
                                style: TextStyle(color: context.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                "$rating / 5.0 (Peringkat Toko)",
                                style: TextStyle(color: context.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Products Grid Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Produk Toko Kami (${filteredProducts.length})",
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Status Filters Tab Bar
                          SizedBox(
                            height: 38,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              children: ["Semua", "Tersedia", "Tidak Tersedia"].map((status) {
                                final isSelected = _selectedStatus == status;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedStatus = status;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF0D9488) : context.cardBg,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF0D9488) : context.borderColor,
                                      ),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : context.textSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          filteredProducts.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(24),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Tidak ada produk dengan status ini.",
                                    style: TextStyle(color: context.textSecondary),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: 0.72,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    final isOutOfStock = product.stok <= 0;
                                    final prodImg = _getProductImage(product.nama, product.gambar);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailView(product: product),
                                          ),
                                        ).then((_) => _loadShopProducts());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.cardBg,
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(color: context.borderColor),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.01),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                                                      child: prodImg.isNotEmpty
                                                          ? Image.asset(prodImg, fit: BoxFit.cover)
                                                          : Container(
                                                              color: context.inputBg,
                                                              child: Icon(Icons.image_outlined, color: context.iconColor, size: 32),
                                                            ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 8,
                                                    left: 8,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: isOutOfStock ? const Color(0xFFEF4444) : const Color(0xFF0D9488),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        isOutOfStock ? "Tidak Tersedia" : "Stok: ${product.stok}",
                                                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.kategori,
                                                    style: TextStyle(color: context.textMuted, fontSize: 9, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    product.nama,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: context.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Rp ${product.harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                                                    style: const TextStyle(color: Color(0xFF0D9488), fontSize: 12, fontWeight: FontWeight.bold),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
