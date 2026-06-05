import 'package:flutter/material.dart';

class Homepage1 extends StatefulWidget {
  const Homepage1({super.key});

  @override
  State<Homepage1> createState() => _Homepage1State();
}

class _Homepage1State extends State<Homepage1> {
  int currentIndex = 0;

  // final List<Widget> pages = [const HomePage(), const AboutPage()];

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

      // body: pages[currentIndex],

      /// BOTTOM NAVIGATION
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
