import 'package:flutter/material.dart';

void main() {
  runApp(const BizGrowApp());
}

/// MAIN APP
class BizGrowApp extends StatelessWidget {
  const BizGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BizGrow UI',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const MainNavigation(),
    );
  }
}

/// MAIN NAVIGATION
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> pages = [const HomePage(), const AboutPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        centerTitle: true,

        actions: [],

        title: Text(
          currentIndex == 0 ? "BizGrow Dashboard" : "Tentang Aplikasi",

          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      drawer: currentIndex == 0
          ? Drawer(
              backgroundColor: Colors.black,

              child: ListView(
                padding: EdgeInsets.zero,

                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.black),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Container(
                          width: 55,
                          height: 55,

                          decoration: BoxDecoration(
                            color: Colors.white10,

                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: const Icon(
                            Icons.auto_graph,

                            color: Colors.white,

                            size: 28,
                          ),
                        ),

                        const Spacer(),

                        const Text(
                          "BizGrow",

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 22,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Smart Business Solution",

                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ],
                    ),
                  ),

                  drawerMenu(Icons.dashboard, "Dashboard"),

                  drawerMenu(Icons.analytics, "Analytics"),

                  drawerMenu(Icons.inventory_2, "Products"),

                  // drawerMenu(Icons.settings, "Settings"),
                  drawerMenu(Icons.logout, "Logout"),
                ],
              ),
            )
          : null,

      body: pages[currentIndex],

      /// ===================================================
      /// BOTTOM NAVIGATION
      /// ===================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor: Colors.black,

        unselectedItemColor: Colors.grey,

        backgroundColor: Colors.white,

        selectedFontSize: 11,
        unselectedFontSize: 10,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Tentang"),
        ],
      ),
    );
  }

  /// =====================================================
  /// DRAWER MENU
  /// =====================================================

  Widget drawerMenu(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),

      title: Text(
        title,

        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),

      onTap: () {},
    );
  }
}

/// =======================================================
/// HOME PAGE
/// =======================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// CHECKBOX
  bool isCheck = false;

  /// DARK MODE
  bool isSwitch = false;

  /// DROPDOWN
  String selectedItem = "Elektronik";

  List<String> category = ["Elektronik", "Pakaian", "Makanan", "Lainnya"];

  @override
  Widget build(BuildContext context) {
    /// ===================================================
    /// DYNAMIC COLOR
    /// ===================================================

    final backgroundColor = isSwitch
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);

    final cardColor = isSwitch ? const Color(0xFF1E1E1E) : Colors.white;

    final textColor = isSwitch ? Colors.white : Colors.black;

    final subtitleColor = isSwitch ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// HEADER
            Text(
              "Interactive Form",

              style: TextStyle(
                fontSize: 22,

                fontWeight: FontWeight.bold,

                color: textColor,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Kelola bisnis UMKM modern dengan tampilan interaktif.",

              style: TextStyle(color: subtitleColor, height: 1.5, fontSize: 15),
            ),

            const SizedBox(height: 24),

            /// =================================================
            /// CHECKBOX CARD
            /// =================================================
            buildCard(
              cardColor: cardColor,

              title: "1. Syarat & Ketentuan",

              textColor: textColor,

              child: Column(
                children: [
                  CheckboxListTile(
                    value: isCheck,

                    activeColor: Colors.black,

                    title: Text(
                      "Saya menyetujui persyaratan",

                      style: TextStyle(color: textColor, fontSize: 15),
                    ),

                    onChanged: (bool? value) {
                      setState(() {
                        isCheck = value ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: isCheck
                          ? Colors.green.shade100
                          : Colors.red.shade100,

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Text(
                      isCheck
                          ? "Pendaftaran diperbolehkan"
                          : "Pendaftaran belum tersedia",

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// =================================================
            /// SWITCH CARD
            /// =================================================
            buildCard(
              cardColor: cardColor,

              title: "2. Mode Tampilan",

              textColor: textColor,

              child: Column(
                children: [
                  SwitchListTile(
                    value: isSwitch,

                    activeThumbColor: Colors.black,

                    title: Text(
                      "Aktifkan Dark Mode",

                      style: TextStyle(color: textColor, fontSize: 15),
                    ),

                    onChanged: (bool? value) {
                      setState(() {
                        isSwitch = value ?? false;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),

                    height: 90,

                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: isSwitch ? Colors.black : Colors.white,

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(color: Colors.black12),
                    ),

                    child: Center(
                      child: Text(
                        isSwitch ? "Dark Mode Active" : "Light Mode Active",

                        style: TextStyle(
                          color: isSwitch ? Colors.white : Colors.black,

                          fontSize: 13,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// =================================================
            /// DROPDOWN CARD
            /// =================================================
            buildCard(
              cardColor: cardColor,

              title: "3. Kategori Produk",

              textColor: textColor,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),

                    decoration: BoxDecoration(
                      color: isSwitch ? Colors.white10 : Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: DropdownButton(
                      value: selectedItem,

                      isExpanded: true,

                      underline: const SizedBox(),

                      dropdownColor: cardColor,

                      style: TextStyle(color: textColor, fontSize: 12),

                      items: category.map((String items) {
                        return DropdownMenuItem(
                          value: items,

                          child: Text(items),
                        );
                      }).toList(),

                      onChanged: (String? value) {
                        setState(() {
                          selectedItem = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.black,

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Text(
                      "Kategori dipilih : $selectedItem",

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 12,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// CARD UI
  /// =====================================================

  Widget buildCard({
    required String title,

    required Widget child,

    required Color cardColor,

    required Color textColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 15,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: TextStyle(
              fontSize: 15,

              color: textColor,

              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }
}

/// =======================================================
/// ABOUT PAGE
/// =======================================================

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),

      padding: const EdgeInsets.all(20),

      child: Center(
        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 75,
                height: 75,

                decoration: BoxDecoration(
                  color: Colors.black,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Icon(
                  Icons.auto_graph,

                  color: Colors.white,

                  size: 35,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "BizGrow App",

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Aplikasi UMKM modern untuk analisis bisnis dan manajemen produk.",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.black54,

                  height: 1.5,

                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 24),

              infoTile("Developer", "Ranski"),

              infoTile("Version", "1.0.0"),

              infoTile("Framework", "Flutter"),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,

            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),

          Text(
            value,

            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
