import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/models/models.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/invoice_a4_view.dart';

class LacakPesananView extends StatefulWidget {
  final ActivityModel order;
  const LacakPesananView({super.key, required this.order});

  @override
  State<LacakPesananView> createState() => _LacakPesananViewState();
}

class _LacakPesananViewState extends State<LacakPesananView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late String _address;
  late double _destRx;
  late double _destRy;
  final double _whRx = 0.36; // Jakarta warehouse
  final double _whRy = 0.67;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _address = widget.order.alamat ?? "Jl. Basuki Rahmat No. 100, Surabaya, Jawa Timur";
    _destRx = widget.order.koordinatX ?? 0.54;
    _destRy = widget.order.koordinatY ?? 0.71;

    // Center viewport on the route segment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      const double canvasW = 1200;
      const double canvasH = 800;
      
      final targetX = (_whRx + _destRx) / 2 * canvasW;
      final targetY = (_whRy + _destRy) / 2 * canvasH;
      
      final viewportW = MediaQuery.of(context).size.width - 40;
      const double viewportH = 220.0;
      
      // Scale dynamic fit
      double scale = 0.6;
      if (widget.order.koordinatX != null && widget.order.koordinatY != null) {
        // Adjust zoom based on distance
        final dx = (_whRx - _destRx).abs();
        final dy = (_whRy - _destRy).abs();
        if (dx > 0.4 || dy > 0.4) {
          scale = 0.45;
        } else if (dx < 0.15 && dy < 0.15) {
          scale = 1.0;
        }
      }

      final translationMatrix = Matrix4.identity()
        ..translate(
          (viewportW / 2) - targetX * scale,
          (viewportH / 2) - targetY * scale,
        )
        ..scale(scale);
      _transformationController.value = translationMatrix;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.order.status == "Selesai";

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
            "Lacak Pengiriman",
            style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: context.borderColor, height: 1),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Live tracking Map
              Container(
                height: 220,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const double canvasW = 1200;
                      const double canvasH = 800;
                      final warehouseOffset = Offset(_whRx * canvasW, _whRy * canvasH);
                      final destinationOffset = Offset(_destRx * canvasW, _destRy * canvasH);

                      return InteractiveViewer(
                        transformationController: _transformationController,
                        minScale: 0.3,
                        maxScale: 4.0,
                        boundaryMargin: const EdgeInsets.all(400),
                        constrained: false,
                        child: SizedBox(
                          width: canvasW,
                          height: canvasH,
                          child: Stack(
                            children: [
                              // Custom Paint Map
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: MapPainter(markerPosition: destinationOffset),
                                ),
                              ),
                              // Dotted Route line
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: RoutePainter(from: warehouseOffset, to: destinationOffset),
                                ),
                              ),
                              // Warehouse marker (Google Maps style store pin)
                              Positioned(
                                left: warehouseOffset.dx - 14,
                                top: warehouseOffset.dy - 14,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE37405), // Google Maps orange store marker
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 12),
                                ),
                              ),
                              // Destination marker
                              Positioned(
                                left: destinationOffset.dx - 12,
                                top: destinationOffset.dy - 12,
                                child: const Icon(Icons.location_on_rounded, color: Colors.red, size: 28),
                              ),
                              // Route path animator (Delivery vehicle)
                              AnimatedBuilder(
                                animation: _animController,
                                builder: (context, child) {
                                  double t = _animController.value;
                                  if (isDone) {
                                    t = 1.0;
                                  }
                                  final currentPos = Offset(
                                    warehouseOffset.dx + (destinationOffset.dx - warehouseOffset.dx) * t,
                                    warehouseOffset.dy + (destinationOffset.dy - warehouseOffset.dy) * t,
                                  );
                                  return Positioned(
                                    left: currentPos.dx - 14,
                                    top: currentPos.dy - 14,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0D9488),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 14),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 2. Shipment Summary Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: context.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No. Pesanan",
                                style: TextStyle(color: context.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.order.kodePesanan,
                                style: TextStyle(color: context.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFF0D9488).withValues(alpha: 0.1)
                                  : Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isDone ? "Diterima" : "Diproses",
                              style: TextStyle(
                                color: isDone ? const Color(0xFF0D9488) : Colors.amber.shade800,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: context.dividerColor),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_pin, color: context.iconColor, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alamat Pengiriman",
                                  style: TextStyle(color: context.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _address,
                                  style: TextStyle(color: context.textPrimary, fontSize: 13, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Timeline Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "STATUS PENGIRIMAN",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildTimelineStep(
                      title: "Pesanan Diterima",
                      desc: "Kurir telah mengantarkan pesanan ke tujuan.",
                      time: "12:00",
                      isActive: isDone,
                      isLast: true,
                    ),
                    _buildTimelineStep(
                      title: "Dalam Perjalanan",
                      desc: "Driver sedang membawa pesanan Anda menuju alamat tujuan.",
                      time: "11:30",
                      isActive: isDone,
                    ),
                    _buildTimelineStep(
                      title: "Pesanan Dikemas",
                      desc: "Barang sedang dikemas dan dipersiapkan di gudang utama.",
                      time: "10:45",
                      isActive: true,
                    ),
                    _buildTimelineStep(
                      title: "Pembayaran Berhasil",
                      desc: "Transaksi pembayaran telah diverifikasi sistem.",
                      time: "10:15",
                      isActive: true,
                    ),
                    _buildTimelineStep(
                      title: "Pesanan Dibuat",
                      desc: "Tagihan invoice telah berhasil diterbitkan.",
                      time: "10:00",
                      isActive: true,
                      isFirst: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String desc,
    required String time,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Time
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                isActive ? time : "--:--",
                style: TextStyle(
                  color: isActive ? context.textPrimary : context.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Center: Line & Node
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF0D9488) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? const Color(0xFF0D9488) : Colors.grey.shade400,
                    width: 2.5,
                  ),
                ),
                child: isActive
                    ? const Center(
                        child: Icon(Icons.check, size: 8, color: Colors.white),
                      )
                    : null,
              ),
              if (!isFirst)
                Expanded(
                  child: Container(
                    width: 2.5,
                    color: isActive ? const Color(0xFF0D9488) : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Right: Status info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isActive ? context.textPrimary : context.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: isActive ? context.textSecondary : context.textMuted,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  final Offset from;
  final Offset to;
  RoutePainter({required this.from, required this.to});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw outer thick white route border for 3D/timbul effect
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 2. Draw inner primary Google Maps blue route line
    final routePaint = Paint()
      ..color = const Color(0xFF1A73E8) // Google Maps blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..lineTo(to.dx, to.dy);

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) =>
      oldDelegate.from != from || oldDelegate.to != to;
}

