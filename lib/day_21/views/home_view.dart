import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_21/database/database_helper.dart';
import 'package:flutter_application_1/day_21/models/user_model.dart';
import 'package:flutter_application_1/day_21/views/login_view.dart';
import 'package:flutter_application_1/extention/navigator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 2; // Default to 'Products' (catalog) as requested

  // Member CRUD Form controllers
  final _memberFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  String searchQuery = "";

  // Products Tab states
  String _selectedCategory = "All Items";
  int _cartCount = 0;

  final List<String> _categories = [
    "All Items",
    "Ceramics",
    "Textiles",
    "Wood",
    "Leather",
  ];

  // Mock Products data matching the image exactly
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "title": "Artisan Vase Collection",
      "price": "Rp 450.000",
      "category": "Ceramics",
      "assetFallback": "assets/images/1.jpg",
      "icon": Icons.eco_outlined,
      "desc":
          "Curated collection of handcrafted ceramic vases featuring minimalist lines and raw clay textures. Reimagined for modern workspace aesthetics.",
    },
    {
      "id": 2,
      "title": "Woven Bamboo Tote",
      "price": "Rp 725.000",
      "category": "Textiles",
      "assetFallback": "assets/images/13.jpg",
      "icon": Icons.shopping_bag_outlined,
      "desc":
          "Hand-woven tote bag utilizing sustainable organic bamboo fibers. Finished with premium genuine leather handles for maximum comfort and style.",
    },
    {
      "id": 3,
      "title": "Teak Root Centerpiece",
      "price": "Rp 510.000",
      "category": "Wood",
      "assetFallback": "assets/images/15.jpg",
      "icon": Icons.spa_outlined,
      "desc":
          "Elegant dining table centerpiece carved from authentic reclaimed Javanese teak root. Each item is unique in shape, grain pattern, and size.",
    },
    {
      "id": 4,
      "title": "Indigo Batik Scarf",
      "price": "Rp 380.000",
      "category": "Textiles",
      "assetFallback": "assets/images/11.jpg",
      "icon": Icons.gesture_rounded,
      "desc":
          "Traditional handwritten batik pattern dyed in natural indigo. Perfect lightweight accessory crafted by local artisans in Central Java.",
    },
    {
      "id": 5,
      "title": "Leather Portfolio Set",
      "price": "Rp 1.250.000",
      "category": "Leather",
      "assetFallback": "assets/images/9.jpg",
      "icon": Icons.folder_open_outlined,
      "desc":
          "Sophisticated workspace portfolio case containing premium note covers, pencil holders, and tech organizers, made of high-quality vegetable-tanned leather.",
    },
    {
      "id": 6,
      "title": "Eclipse Rattan Pendant",
      "price": "Rp 980.000",
      "category": "Wood",
      "assetFallback": "assets/images/10.jpg",
      "icon": Icons.lightbulb_outline,
      "desc":
          "A dynamic statement pendant light fixture woven entirely by hand from natural premium rattan. Projects beautiful, complex shadow overlays.",
    },
  ];

  void registerNewMember() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    final nik = nikController.text.trim();

    if (email.isEmpty || pass.isEmpty || nik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi semua field terlebih dahulu!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = UserModelBizgrow(email: email, password: pass, nik: nik);
    bool success = await DBHelper().registerUser(user);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anggota baru berhasil ditambahkan!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF10B981),
        ),
      );
      emailController.clear();
      passwordController.clear();
      nikController.clear();
      setState(() {});
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menambah anggota! Email mungkin sudah terdaftar.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedIndex == 2
          ? const Color(0xFFFAF9F6)
          : const Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            // Body Content based on active tab index
            Padding(
              padding: const EdgeInsets.only(
                bottom: 75.0,
              ), // space for bottom navigation
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildHomeTab(),
                  _buildAnalyticsTab(),
                  _buildProductsTab(),
                  _buildStrategyTab(),
                  _buildProfileTab(),
                ],
              ),
            ),

            // Premium Floating Bottom Navigation Bar
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: _selectedIndex == 2
                      ? Colors.white.withOpacity(0.9)
                      : const Color(0xFF1E293B).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        _selectedIndex == 2 ? 0.08 : 0.25,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: _selectedIndex == 2
                        ? Colors.black.withOpacity(0.06)
                        : Colors.white.withOpacity(0.08),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      0,
                      Icons.home_outlined,
                      Icons.home_rounded,
                      "Home",
                    ),
                    _buildNavItem(
                      1,
                      Icons.analytics_outlined,
                      Icons.analytics_rounded,
                      "Analytics",
                    ),
                    _buildNavItem(
                      2,
                      Icons.inventory_2_outlined,
                      Icons.inventory_2_rounded,
                      "Products",
                    ),
                    _buildNavItem(
                      3,
                      Icons.lightbulb_outline_rounded,
                      Icons.lightbulb_rounded,
                      "Strategy",
                    ),
                    _buildNavItem(
                      4,
                      Icons.person_outline_rounded,
                      Icons.person_rounded,
                      "Profile",
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

  // Nav Item Builder
  Widget _buildNavItem(
    int index,
    IconData outlineIcon,
    IconData solidIcon,
    String label,
  ) {
    final bool isSelected = _selectedIndex == index;
    final Color activeColor = _selectedIndex == 2
        ? Colors.black
        : const Color(0xFF14B8A6);
    final Color inactiveColor = _selectedIndex == 2
        ? Colors.black38
        : Colors.white30;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? solidIcon : outlineIcon,
            color: isSelected ? activeColor : inactiveColor,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 0: HOME (Member CRUD Console)
  Widget _buildHomeTab() {
    return Column(
      children: [
        // Title Console
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: const Color(0xFF1E293B),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_graph_rounded,
                      color: Color(0xFF14B8A6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "BizGrow Console",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Color(0xFF14B8A6),
                ),
                onPressed: () => _showAddMemberSheet(context),
              ),
            ],
          ),
        ),

        // Statistics row
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<UserModelBizgrow>>(
            future: DBHelper().getAllUsers(),
            builder: (context, snapshot) {
              final totalMembers = snapshot.data?.length ?? 0;
              return Row(
                children: [
                  Expanded(
                    child: _buildHomeStatCard(
                      "Total Members",
                      "$totalMembers",
                      Icons.people_alt_outlined,
                      const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildHomeStatCard(
                      "DB Status",
                      "Connected",
                      Icons.dns_outlined,
                      const Color(0xFF14B8A6),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            onChanged: (val) {
              setState(() {
                searchQuery = val.toLowerCase();
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search members by email...",
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // List
        Expanded(
          child: FutureBuilder<List<UserModelBizgrow>>(
            future: DBHelper().getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF14B8A6)),
                );
              }

              final list = snapshot.data ?? [];
              final filteredList = list.where((user) {
                return user.email.toLowerCase().contains(searchQuery);
              }).toList();

              if (filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 48),
                      const SizedBox(height: 12),
                      Text("No members match search."),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final user = filteredList[index];
                  final charCode = user.email.isNotEmpty
                      ? user.email.codeUnitAt(0)
                      : 65;
                  final avatarColor =
                      Colors.primaries[charCode % Colors.primaries.length];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          user.email.isNotEmpty
                              ? user.email[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: avatarColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('NIK: ${user.nik}'),
                      trailing: const Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xFF14B8A6),
                      ),
                      onTap: () => _showManageBottomSheet(context, user),
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

  Widget _buildHomeStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: ANALYTICS (Mock graphs & statistics)
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BizAnalytics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Track growth progress, leads, and conversion metrics.",
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),

          // Growth Chart mockup
          Container(
            height: 220,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Organic Growth Rate",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "+24.5%",
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Visual bars representation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBar("Jan", 40),
                    _buildChartBar("Feb", 60),
                    _buildChartBar("Mar", 45),
                    _buildChartBar("Apr", 80),
                    _buildChartBar("May", 70),
                    _buildChartBar("Jun", 95),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Business parameters list
          _buildAnalyticsRow(
            "Conversion Optimization",
            "84.2%",
            Icons.trending_up,
            const Color(0xFF14B8A6),
          ),
          _buildAnalyticsRow(
            "Customer Engagement Index",
            "92.1",
            Icons.bubble_chart_outlined,
            const Color(0xFF6366F1),
          ),
          _buildAnalyticsRow(
            "Database Syncing Latency",
            "12 ms",
            Icons.bolt,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String month, double heightPercentage) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 120 * (heightPercentage / 100),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF14B8A6)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          month,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildAnalyticsRow(
    String title,
    String val,
    IconData icon,
    Color col,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: col, size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: PRODUCTS (PREMIUM CATALOG REPLICA FROM SCREENSHOT)
  Widget _buildProductsTab() {
    // Filtered products list
    final List<Map<String, dynamic>> filteredProducts =
        _selectedCategory == "All Items"
        ? _allProducts
        : _allProducts
              .where((p) => p["category"] == _selectedCategory)
              .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Notification
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Styled Icon matching brand
                    const Icon(
                      Icons.auto_graph_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "BizGrow",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black,
                        size: 28,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No new premium updates."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black87,
                          ),
                        );
                      },
                    ),
                    if (_cartCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$_cartCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tag
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "PREMIUM CATALOG",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Crafts & Lifestyle",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Curated Indonesian heritage, reimagined for the modern professional aesthetic.",
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Categories horizontal list
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Product Grid (2 columns)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final prod = filteredProducts[index];
                return GestureDetector(
                  onTap: () => _showProductDetailSheet(context, prod),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image Box
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(0.08),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _buildProductImage(prod),
                            ),
                            // Floating Add Button
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _cartCount++;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Added ${prod['title']} to selection.",
                                      ),
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        prod["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Price
                      Text(
                        prod["price"],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),

          // Total Count Text
          Center(
            child: Text(
              "${filteredProducts.length} of ${_allProducts.length} products",
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Explore More Button
          Center(
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("All premium products loaded successfully."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                "Explore More",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Load Image with proper asset fallbacks to custom colored container with Icon
  Widget _buildProductImage(Map<String, dynamic> product) {
    return Image.asset(
      product["assetFallback"],
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to beautiful abstract background color and icon
        final colors = [
          [const Color(0xFFFDE68A), const Color(0xFFFCA5A5)],
          [const Color(0xFFA7F3D0), const Color(0xFF6EE7B7)],
          [const Color(0xFFBFDBFE), const Color(0xFF93C5FD)],
          [const Color(0xFFE9D5FF), const Color(0xFFC084FC)],
          [const Color(0xFFFECDD3), const Color(0xFFFDA4AF)],
          [const Color(0xFFC7D2FE), const Color(0xFF818CF8)],
        ];
        final pair = colors[product["id"] % colors.length];

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: pair,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(
              product["icon"] as IconData,
              color: Colors.black.withOpacity(0.5),
              size: 40,
            ),
          ),
        );
      },
    );
  }

  // TAB 3: STRATEGY (Guides / business lists)
  Widget _buildStrategyTab() {
    final strategies = [
      {
        "title": "Branding & Identity Guide",
        "sub": "Learn details of modern visual communication.",
        "badge": "Popular",
      },
      {
        "title": "Batik Supply Chain Scaling",
        "sub": "Maximize procurement productivity with local weavers.",
        "badge": "New",
      },
      {
        "title": "Premium Packaging Solutions",
        "sub": "Sustainable and recycled bamboo boxes packaging.",
        "badge": "VIP",
      },
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Marketing Strategy",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Build structured marketing plans for Indonesian premium items.",
            style: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),

          ...strategies.map((strat) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14B8A6).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          strat["badge"]!,
                          style: const TextStyle(
                            color: Color(0xFF14B8A6),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_outline_rounded,
                          color: Colors.white60,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strat["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    strat["sub"]!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // TAB 4: PROFILE (Mock profile and logout)
  Widget _buildProfileTab() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF14B8A6), width: 2),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withOpacity(0.05),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF14B8A6),
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Administrator Console",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "admin@bizgrow.com",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                children: [
                  _buildProfileRow(
                    "Role",
                    "Super Administrator",
                    Icons.verified_user_outlined,
                  ),
                  const Divider(color: Colors.white12),
                  _buildProfileRow(
                    "Department",
                    "Regional Expansion",
                    Icons.business_outlined,
                  ),
                  const Divider(color: Colors.white12),
                  _buildProfileRow(
                    "Region",
                    "Jakarta, ID",
                    Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text(
                  "Logout from Console",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  context.pushAndRemoveAll(const Lamanlogin());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF14B8A6), size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM SHEET: ADD NEW MEMBER
  void _showAddMemberSheet(BuildContext context) {
    emailController.clear();
    passwordController.clear();
    nikController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Form(
            key: _memberFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add New Member',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _sheetInputDecoration(
                    "Email",
                    Icons.email_outlined,
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _sheetInputDecoration(
                    "Password",
                    Icons.lock_outline_rounded,
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: nikController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _sheetInputDecoration(
                    "NIK",
                    Icons.badge_outlined,
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: registerNewMember,
                  child: const Text(
                    'Add Member',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  // BOTTOM SHEET: MANAGE EXISTING MEMBER
  void _showManageBottomSheet(BuildContext context, UserModelBizgrow user) {
    final editEmailController = TextEditingController(text: user.email);
    final editPasswordController = TextEditingController(text: user.password);
    final editNikController = TextEditingController(text: user.nik);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Manage Member',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: editEmailController,
                style: const TextStyle(color: Colors.white),
                decoration: _sheetInputDecoration(
                  "Email",
                  Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: editPasswordController,
                style: const TextStyle(color: Colors.white),
                decoration: _sheetInputDecoration(
                  "Password",
                  Icons.lock_outline_rounded,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: editNikController,
                style: const TextStyle(color: Colors.white),
                decoration: _sheetInputDecoration("NIK", Icons.badge_outlined),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (user.id != null) {
                          await DBHelper().deleteUser(user.id!);
                          if (context.mounted) {
                            Navigator.pop(context);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data berhasil dihapus'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B8A6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (user.id != null) {
                          final updatedUser = UserModelBizgrow(
                            id: user.id,
                            email: editEmailController.text.trim(),
                            password: editPasswordController.text,
                            nik: editNikController.text.trim(),
                          );
                          bool success = await DBHelper().updateUser(
                            updatedUser,
                          );
                          if (success && context.mounted) {
                            Navigator.pop(context);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data berhasil diperbarui'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Color(0xFF10B981),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _sheetInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      prefixIcon: Icon(icon, color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.5),
      ),
    );
  }

  // BOTTOM SHEET: DETAILED VIEW OF MOCK PRODUCT
  void _showProductDetailSheet(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAF9F6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: _buildProductImage(product),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product["title"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        product["price"],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product["category"],
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product["desc"],
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _cartCount++;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${product['title']} added to your shopping selections.",
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black87,
                          ),
                        );
                      },
                      child: const Text(
                        "Order Premium Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Close Details",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
