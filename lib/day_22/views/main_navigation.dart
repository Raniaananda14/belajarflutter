import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/dashboard_view.dart';
import 'package:flutter_application_1/day_22/views/product_list_view.dart';
import 'package:flutter_application_1/day_22/views/target_view.dart';
import 'package:flutter_application_1/day_22/views/laporan_view.dart';
import 'package:flutter_application_1/day_22/views/profil_view.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';

class MainNavigation extends StatefulWidget {
  final int initialTab;
  const MainNavigation({super.key, this.initialTab = 0});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = SessionManager.role == "Owner";

    final List<Widget> pages = [
      const DashboardView(),
      const ProductListView(),
      if (isOwner) const TargetView(),
      if (isOwner) const LaporanView(),
      const ProfilView(),
    ];

    final List<BottomNavigationBarItem> barItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Beranda',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_outlined),
        activeIcon: Icon(Icons.inventory_2_rounded),
        label: 'Produk',
      ),
      if (isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.track_changes_outlined),
          activeIcon: Icon(Icons.track_changes_rounded),
          label: 'Target',
        ),
      if (isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart_rounded),
          label: 'Laporan',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_rounded),
        activeIcon: Icon(Icons.person_rounded),
        label: 'Profil',
      ),
    ];

    if (_currentIndex >= pages.length) {
      _currentIndex = pages.length - 1;
    }

    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: pages[_currentIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: context.cardBg.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: context.textPrimary,
            unselectedItemColor: context.textSecondary,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            elevation: 0,
            items: barItems,
          ),
        ),
      ),
    );
  }
}

