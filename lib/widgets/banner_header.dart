import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class BannerHeader extends StatelessWidget {
  const BannerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🌈 Gradient background
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3927D6), Color(0xFF5E4FF3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // 🌫 Blur Circles
        Positioned(
          top: -50,
          left: -30,
          child: _blurCircle(170, Colors.white.withOpacity(0.2)),
        ),
        Positioned(
          top: 20,
          right: -40,
          child: _blurCircle(180, Colors.white.withOpacity(0.25)),
        ),
        Positioned(
          bottom: -30,
          left: 100,
          child: _blurCircle(100, Colors.white.withOpacity(0.2)),
        ),
        Positioned(
          right: -30,
          bottom: 100,
          child: _blurCircle(100, Colors.white.withOpacity(0.2)),
        ),

        // 🔔 Notification + ⚙️ Setting (glow effect)
        Positioned(
          top: 80,
          right: 20,
          child: Row(
            children: [
              Icon(
                Iconsax.notification_bing,
                color: Colors.white,
                size: 26,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent.withOpacity(0.7),
                    blurRadius: 12,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Icon(
                Iconsax.setting_2,
                color: Colors.white,
                size: 26,
                shadows: [
                  Shadow(
                    color: Colors.purpleAccent.withOpacity(0.7),
                    blurRadius: 12,
                  ),
                ],
              ),
            ],
          ),
        ),

        // 👤 Avatar + Text + Search box
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + Greeting
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=12',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chào mừng trở lại,",
                          style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "Nguyễn Phương Nam",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 🔍 Search box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.search,
                        color: const Color.fromARGB(255, 154, 150, 150),
                        size: 25,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.lato(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm khoá học...",
                            hintStyle: GoogleFonts.lato(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3927D6),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.filter,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}
