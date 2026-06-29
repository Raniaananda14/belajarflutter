import 'package:flutter/material.dart';
import 'package:flutter_application_1/day_22/database/session_manager.dart';
import 'package:flutter_application_1/day_22/theme/elegant_background.dart';
import 'package:flutter_application_1/day_22/views/cargo_catcher_view.dart';
import 'package:flutter_application_1/day_22/views/tebak_kata_view.dart';
import 'package:flutter_application_1/day_22/views/kuis_bisnis_view.dart';
import 'package:flutter_application_1/day_22/views/game_keuangan_view.dart';

class GameHubView extends StatefulWidget {
  const GameHubView({super.key});

  @override
  State<GameHubView> createState() => _GameHubViewState();
}

class _GameHubViewState extends State<GameHubView> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

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
            "BizGrow Game Center 🎮",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kembangkan Wawasan Bisnis! 🚀",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Belajar bisnis, strategi pemasaran, dan manajemen keuangan menjadi lebih seru dengan game edukatif interaktif kami.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "Pilih Game Anda",
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Games List
              _buildGameCard(
                title: "Tangkap Kargo",
                description: "Tangkap paket kargo dan koin emas yang jatuh untuk memuaskan pelanggan BizGrow. Hindari bom!",
                emoji: "🚚",
                colorStart: const Color(0xFF0F766E),
                colorEnd: const Color(0xFF0D9488),
                highScoreText: "${SessionManager.cargoHighScore} pts",
                iconData: Icons.local_shipping_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CargoCatcherView()),
                  ).then((_) => setState(() {}));
                },
              ),
              const SizedBox(height: 16),

              _buildGameCard(
                title: "Tebak Kata Bisnis",
                description: "Susun huruf-huruf acak menjadi kata penting dalam istilah bisnis, perdagangan, dan keuangan berdasarkan petunjuk.",
                emoji: "🔠",
                colorStart: const Color(0xFFD97706),
                colorEnd: const Color(0xFFF59E0B),
                highScoreText: "${SessionManager.tebakKataHighScore} kata",
                iconData: Icons.spellcheck_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TebakKataView()),
                  ).then((_) => setState(() {}));
                },
              ),
              const SizedBox(height: 16),

              _buildGameCard(
                title: "Kuis Bisnis Pintar",
                description: "Uji wawasan Anda mengenai strategi bisnis, pemasaran, dan manajemen umum dalam kuis interaktif 10 pertanyaan.",
                emoji: "🧠",
                colorStart: const Color(0xFF4F46E5),
                colorEnd: const Color(0xFF6366F1),
                highScoreText: "${SessionManager.kuisBisnisHighScore} pts",
                iconData: Icons.psychology_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KuisBisnisView()),
                  ).then((_) => setState(() {}));
                },
              ),
              const SizedBox(height: 16),

              _buildGameCard(
                title: "Simulasi Keuangan",
                description: "Kelola kas bulanan, investasikan uang di saham atau emas, perluas cabang bisnis Anda, dan capai target kekayaan!",
                emoji: "💰",
                colorStart: const Color(0xFF0891B2),
                colorEnd: const Color(0xFF06B6D4),
                highScoreText: "Rp ${SessionManager.keuanganHighScore.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                iconData: Icons.account_balance_wallet_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameKeuanganView()),
                  ).then((_) => setState(() {}));
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String description,
    required String emoji,
    required Color colorStart,
    required Color colorEnd,
    required String highScoreText,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game Icon/Avatar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorStart, colorEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorStart.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "$title $emoji",
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // High Score Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFBBF24).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.emoji_events_rounded,
                                  color: Color(0xFFD97706),
                                  size: 11,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  highScoreText,
                                  style: const TextStyle(
                                    color: Color(0xFFD97706),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text(
                            "Mainkan Sekarang",
                            style: TextStyle(
                              color: colorStart,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: colorStart,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
