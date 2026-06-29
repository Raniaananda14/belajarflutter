import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/database_helper.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/invoice_a4_view.dart';
import 'package:flutter_application_1/day_22/views/lacak_pesanan_view.dart';

class PilihLokasiView extends StatefulWidget {
  final ProductModel? product;
  final List<CartItemModel>? cartItems;
  const PilihLokasiView({super.key, this.product, this.cartItems});

  @override
  State<PilihLokasiView> createState() => _PilihLokasiViewState();
}

class ShippingLocation {
  final String city;
  final String province;
  final String island;
  final String address;
  final double rx;
  final double ry;

  const ShippingLocation({
    required this.city,
    required this.province,
    required this.island,
    required this.address,
    required this.rx,
    required this.ry,
  });
}

const List<ShippingLocation> _shippingHubs = [
  // Sumatera
  ShippingLocation(
    city: "Medan",
    province: "Sumatera Utara",
    island: "Sumatera",
    address: "Jl. Diponegoro No. 24",
    rx: 0.12,
    ry: 0.22,
  ),
  ShippingLocation(
    city: "Banda Aceh",
    province: "Aceh",
    island: "Sumatera",
    address: "Jl. Teuku Umar No. 10",
    rx: 0.06,
    ry: 0.12,
  ),
  ShippingLocation(
    city: "Padang",
    province: "Sumatera Barat",
    island: "Sumatera",
    address: "Jl. Khatib Sulaiman No. 45",
    rx: 0.18,
    ry: 0.38,
  ),
  ShippingLocation(
    city: "Palembang",
    province: "Sumatera Selatan",
    island: "Sumatera",
    address: "Jl. Jend. Sudirman No. 120",
    rx: 0.28,
    ry: 0.50,
  ),
  ShippingLocation(
    city: "Bandar Lampung",
    province: "Lampung",
    island: "Sumatera",
    address: "Jl. Raden Intan No. 88",
    rx: 0.34,
    ry: 0.58,
  ),
  // Jawa
  ShippingLocation(
    city: "Jakarta Pusat",
    province: "DKI Jakarta",
    island: "Jawa",
    address: "Jl. M.H. Thamrin No. 8 (Gudang Utama)",
    rx: 0.36,
    ry: 0.67,
  ),
  ShippingLocation(
    city: "Bandung",
    province: "Jawa Barat",
    island: "Jawa",
    address: "Jl. Asia Afrika No. 15",
    rx: 0.40,
    ry: 0.69,
  ),
  ShippingLocation(
    city: "Semarang",
    province: "Jawa Tengah",
    island: "Jawa",
    address: "Jl. Pemuda No. 142",
    rx: 0.47,
    ry: 0.70,
  ),
  ShippingLocation(
    city: "Yogyakarta",
    province: "DIY",
    island: "Jawa",
    address: "Jl. Malioboro No. 60",
    rx: 0.48,
    ry: 0.72,
  ),
  ShippingLocation(
    city: "Surabaya",
    province: "Jawa Timur",
    island: "Jawa",
    address: "Jl. Basuki Rahmat No. 100",
    rx: 0.54,
    ry: 0.71,
  ),
  // Kalimantan
  ShippingLocation(
    city: "Pontianak",
    province: "Kalimantan Barat",
    island: "Kalimantan",
    address: "Jl. Gajah Mada No. 9",
    rx: 0.43,
    ry: 0.38,
  ),
  ShippingLocation(
    city: "Banjarmasin",
    province: "Kalimantan Selatan",
    island: "Kalimantan",
    address: "Jl. Lambung Mangkurat No. 22",
    rx: 0.52,
    ry: 0.46,
  ),
  ShippingLocation(
    city: "Balikpapan",
    province: "Kalimantan Timur",
    island: "Kalimantan",
    address: "Jl. Jend. Sudirman No. 50",
    rx: 0.55,
    ry: 0.38,
  ),
  ShippingLocation(
    city: "Samarinda",
    province: "Kalimantan Timur",
    island: "Kalimantan",
    address: "Jl. Mulawarman No. 15",
    rx: 0.56,
    ry: 0.34,
  ),
  // Sulawesi
  ShippingLocation(
    city: "Makassar",
    province: "Sulawesi Selatan",
    island: "Sulawesi",
    address: "Jl. AP Pettarani No. 18",
    rx: 0.63,
    ry: 0.53,
  ),
  ShippingLocation(
    city: "Palu",
    province: "Sulawesi Tengah",
    island: "Sulawesi",
    address: "Jl. Moh. Hatta No. 5",
    rx: 0.64,
    ry: 0.36,
  ),
  ShippingLocation(
    city: "Manado",
    province: "Sulawesi Utara",
    island: "Sulawesi",
    address: "Jl. Sam Ratulangi No. 12",
    rx: 0.72,
    ry: 0.23,
  ),
  // Bali & Nusa Tenggara
  ShippingLocation(
    city: "Denpasar",
    province: "Bali",
    island: "Bali & Nusa Tenggara",
    address: "Jl. Raya Puputan No. 10",
    rx: 0.59,
    ry: 0.73,
  ),
  ShippingLocation(
    city: "Mataram",
    province: "Nusa Tenggara Barat",
    island: "Bali & Nusa Tenggara",
    address: "Jl. Pejanggik No. 12",
    rx: 0.63,
    ry: 0.74,
  ),
  ShippingLocation(
    city: "Kupang",
    province: "Nusa Tenggara Timur",
    island: "Bali & Nusa Tenggara",
    address: "Jl. El Tari No. 1",
    rx: 0.74,
    ry: 0.76,
  ),
  // Maluku
  ShippingLocation(
    city: "Ambon",
    province: "Maluku",
    island: "Maluku",
    address: "Jl. Pattimura No. 8",
    rx: 0.77,
    ry: 0.45,
  ),
  // Papua
  ShippingLocation(
    city: "Sorong",
    province: "Papua Barat Daya",
    island: "Papua",
    address: "Jl. Jend. Sudirman No. 3",
    rx: 0.81,
    ry: 0.41,
  ),
  ShippingLocation(
    city: "Jayapura",
    province: "Papua",
    island: "Papua",
    address: "Jl. Sentani No. 100",
    rx: 0.96,
    ry: 0.46,
  ),
  ShippingLocation(
    city: "Merauke",
    province: "Papua Selatan",
    island: "Papua",
    address: "Jl. Brawijaya No. 12",
    rx: 0.97,
    ry: 0.61,
  ),
];

class _PilihLokasiViewState extends State<PilihLokasiView> {
  bool _isLocationSelected = false;
  String _selectedAddress = "Belum memilih lokasi. Silakan tap di peta.";
  double? _selectedRx;
  double? _selectedRy;
  bool _isLocationPermissionGranted = false;
  final TransformationController _transformationController =
      TransformationController();

  void _zoom(double factor) {
    final matrix = _transformationController.value.clone();
    final currentScale = matrix.getMaxScaleOnAxis();
    final newScale = (currentScale * factor).clamp(0.5, 4.0);
    final netFactor = newScale / currentScale;
    matrix.scale(netFactor, netFactor);
    _transformationController.value = matrix;
  }

  void _requestLocationAccess() async {
    if (_isLocationPermissionGranted) {
      _setToSimulatedCurrentLocation();
      return;
    }

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF0D9488),
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Akses Lokasi",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            "Izinkan 'BizGrow' untuk mengakses lokasi perangkat ini agar dapat menentukan titik alamat pengiriman Anda secara otomatis.",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context, "while_using"),
                  child: const Text(
                    "Saat Aplikasi Digunakan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context, "only_this_time"),
                  child: Text(
                    "Hanya Kali Ini",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF475569),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, "deny"),
                  child: const Text(
                    "Jangan Izinkan",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == "while_using" || result == "only_this_time") {
      setState(() {
        _isLocationPermissionGranted = true;
      });
      _setToSimulatedCurrentLocation();
    } else if (result == "deny") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Izin lokasi ditolak. Silakan pilih lokasi secara manual di peta.",
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
  }

  void _setToSimulatedCurrentLocation() {
    final simulatedHub = _shippingHubs.firstWhere(
      (h) => h.city == "Jakarta Pusat",
    );
    setState(() {
      _selectedRx = simulatedHub.rx;
      _selectedRy = simulatedHub.ry;
      _selectedAddress =
          "${simulatedHub.address}, ${simulatedHub.city}, ${simulatedHub.province} (${simulatedHub.island})";
      _isLocationSelected = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Lokasi Anda berhasil dideteksi otomatis (Jakarta Pusat) 📍",
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _selectLocation(Offset localPos, double width, double height) {
    final rx = (localPos.dx / width).clamp(0.0, 1.0);
    final ry = (localPos.dy / height).clamp(0.0, 1.0);

    ShippingLocation closest = _shippingHubs[0];
    double minDist = double.infinity;
    for (final loc in _shippingHubs) {
      final dist =
          (loc.rx - rx) * (loc.rx - rx) + (loc.ry - ry) * (loc.ry - ry);
      if (dist < minDist) {
        minDist = dist;
        closest = loc;
      }
    }

    setState(() {
      _selectedRx = closest.rx;
      _selectedRy = closest.ry;
      _selectedAddress =
          "${closest.address}, ${closest.city}, ${closest.province} (${closest.island})";
      _isLocationSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElegantBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.iconPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Pilih Alamat Pengiriman",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            // Header instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Ketuk pada peta di bawah ini untuk menentukan titik koordinat lokasi pengiriman Anda se-Indonesia.",
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Address description card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isLocationSelected
                      ? const Color(0xFF0D9488).withOpacity(0.06)
                      : Colors.orange.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isLocationSelected
                        ? const Color(0xFF0D9488).withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _isLocationSelected
                          ? Icons.location_on_rounded
                          : Icons.info_outline_rounded,
                      color: _isLocationSelected
                          ? const Color(0xFF0D9488)
                          : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedAddress,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Map container (takes up remaining space)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.borderColor, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const double canvasW = 1200;
                        const double canvasH = 800;
                        final markerPos =
                            (_selectedRx != null && _selectedRy != null)
                            ? Offset(
                                _selectedRx! * canvasW,
                                _selectedRy! * canvasH,
                              )
                            : null;
                        return Stack(
                          children: [
                            // InteractiveViewer containing the scrollable and zoomable map child
                            Positioned.fill(
                              child: InteractiveViewer(
                                transformationController:
                                    _transformationController,
                                minScale: 0.4,
                                maxScale: 4.0,
                                boundaryMargin: const EdgeInsets.all(500),
                                constrained: false,
                                child: GestureDetector(
                                  onTapDown: (details) {
                                    _selectLocation(
                                      details.localPosition,
                                      canvasW,
                                      canvasH,
                                    );
                                  },
                                  child: SizedBox(
                                    width: canvasW,
                                    height: canvasH,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: MapPainter(
                                              markerPosition: markerPos,
                                            ),
                                          ),
                                        ),
                                        if (_selectedRx != null &&
                                            _selectedRy != null)
                                          Positioned(
                                            left: (_selectedRx! * canvasW) - 18,
                                            top: (_selectedRy! * canvasH) - 36,
                                            child: const Icon(
                                              Icons.location_on_rounded,
                                              color: Colors.red,
                                              size: 36,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0, 3),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Floating Google Maps style Search Bar
                            Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF5F6368),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _isLocationSelected
                                            ? _selectedAddress.split(',').first
                                            : "Cari di Google Maps...",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: _isLocationSelected
                                              ? const Color(0xFF202124)
                                              : const Color(0xFF70757A),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.mic_none_rounded,
                                      color: Color(0xFF5F6368),
                                      size: 20,
                                    ),
                                    const VerticalDivider(
                                      width: 16,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: const Color(0xFF1A73E8),
                                      child: Text(
                                        SessionManager.name.isNotEmpty
                                            ? SessionManager.name[0]
                                                  .toUpperCase()
                                            : "U",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Floating map controls (Compass, Layers, Zoom)
                            Positioned(
                              top: 68,
                              right: 12,
                              child: Column(
                                children: [
                                  // Compass
                                  _buildMapControlIcon(Icons.explore_outlined, () {
                                    // Reset map zoom/pan back to default identity view
                                    _transformationController.value =
                                        Matrix4.identity();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Kompas diatur ulang (Default View) 🧭",
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 8),
                                  // Layers Toggle
                                  _buildMapControlIcon(Icons.layers_outlined, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Tampilan Peta default / Satelit diubah",
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            // Zoom Controls
                            Positioned(
                              bottom: 74,
                              right: 12,
                              child: Column(
                                children: [
                                  _buildMapControlIcon(Icons.add_rounded, () {
                                    _zoom(1.25);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Zoom In (+1.25x)"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 6),
                                  _buildMapControlIcon(
                                    Icons.remove_rounded,
                                    () {
                                      _zoom(0.8);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Zoom Out (-0.8x)"),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (!_isLocationSelected)
                              IgnorePointer(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "Tap di Peta Untuk Pilih Lokasi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // Current Location Button styled as Google Maps My Location
                            Positioned(
                              bottom: 16,
                              right: 12,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 0.5,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      _requestLocationAccess();
                                      // Focus the map around Jakarta Pusat (0.36, 0.67) when location is simulated
                                      final targetX = 0.36 * canvasW;
                                      final targetY = 0.67 * canvasH;
                                      final viewportW = constraints.maxWidth;
                                      final viewportH = constraints.maxHeight;

                                      // Set zoom translation matrix to center on Jakarta
                                      final translationMatrix =
                                          Matrix4.identity()
                                            ..translate(
                                              (viewportW / 2) - targetX * 1.5,
                                              (viewportH / 2) - targetY * 1.5,
                                            )
                                            ..scale(1.5);
                                      _transformationController.value =
                                          translationMatrix;
                                    },
                                    child: const Icon(
                                      Icons.my_location_rounded,
                                      color: Color(
                                        0xFF1A73E8,
                                      ), // Google Maps signature blue
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLocationSelected
                        ? const Color(0xFF0F172A)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLocationSelected
                      ? () async {
                          final now = DateTime.now();
                          final months = [
                            'Januari',
                            'Februari',
                            'Maret',
                            'April',
                            'Mei',
                            'Juni',
                            'Juli',
                            'Agustus',
                            'September',
                            'Oktober',
                            'November',
                            'Desember',
                          ];
                          final dateStr =
                              "${now.day} ${months[now.month - 1]} ${now.year}";
                          final kode =
                              '#BM-${1000 + (now.millisecondsSinceEpoch % 9000)}';

                          ActivityModel primaryOrder;

                          if (widget.product != null) {
                            // Single-product checkout flow
                            final product = widget.product!;
                            primaryOrder = ActivityModel(
                              kodePesanan: kode,
                              tanggal: dateStr,
                              total: product.harga,
                              status: 'Pending',
                              alamat: _selectedAddress,
                              koordinatX: _selectedRx,
                              koordinatY: _selectedRy,
                              namaProduk: product.nama,
                              jumlah: 1,
                              buyerEmail: SessionManager.email,
                            );

                            // Save order to database
                            await DBHelper().addActivity(primaryOrder);

                            // Reduce product stock
                            if (product.id != null) {
                              await DBHelper().updateProductStock(
                                product.id!,
                                (product.stok - 1).clamp(0, 9999),
                              );
                            }
                          } else if (widget.cartItems != null &&
                              widget.cartItems!.isNotEmpty) {
                            // Multi-item / Cart checkout flow
                            final cartItems = widget.cartItems!;

                            // Create first item as primaryOrder to pass to Invoice/Lacak views
                            final first = cartItems.first;
                            primaryOrder = ActivityModel(
                              kodePesanan: kode,
                              tanggal: dateStr,
                              total: first.productHarga * first.jumlah,
                              status: 'Pending',
                              alamat: _selectedAddress,
                              koordinatX: _selectedRx,
                              koordinatY: _selectedRy,
                              namaProduk: first.productNama,
                              jumlah: first.jumlah,
                              buyerEmail: SessionManager.email,
                            );

                            // Save all items as activities and reduce stock
                            for (int i = 0; i < cartItems.length; i++) {
                              final item = cartItems[i];
                              final orderItem = ActivityModel(
                                kodePesanan: kode,
                                tanggal: dateStr,
                                total: item.productHarga * item.jumlah,
                                status: 'Pending',
                                alamat: _selectedAddress,
                                koordinatX: _selectedRx,
                                koordinatY: _selectedRy,
                                namaProduk: item.productNama,
                                jumlah: item.jumlah,
                                buyerEmail: SessionManager.email,
                              );
                              await DBHelper().addActivity(orderItem);

                              // Reduce stock for each product
                              final prod = await DBHelper().getProductById(
                                item.productId,
                              );
                              if (prod != null) {
                                await DBHelper().updateProductStock(
                                  item.productId,
                                  (prod.stok - item.jumlah).clamp(0, 9999),
                                );
                              }
                            }
                          } else {
                            return; // Nothing to checkout
                          }

                          if (!mounted) return;

                          // Show invoice, then navigate to tracking
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InvoiceA4View(
                                order: primaryOrder,
                                product: widget.product,
                                address: _selectedAddress,
                                koordinatX: _selectedRx,
                                koordinatY: _selectedRy,
                                isReadOnly: false,
                              ),
                            ),
                          );

                          if (!mounted) return;

                          // After invoice, go directly to tracking screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LacakPesananView(order: primaryOrder),
                            ),
                          );
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLocationSelected
                            ? "Lanjut ke Checkout"
                            : "Pilih Lokasi Terlebih Dahulu",
                        style: TextStyle(
                          color: _isLocationSelected
                              ? Colors.white
                              : Colors.white60,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _isLocationSelected
                            ? Colors.white
                            : Colors.white60,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControlIcon(IconData icon, VoidCallback onTap) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Icon(icon, color: const Color(0xFF5F6368), size: 20),
        ),
      ),
    );
  }
}
