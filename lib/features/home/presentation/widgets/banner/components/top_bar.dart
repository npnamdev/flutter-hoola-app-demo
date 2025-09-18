import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TopBar extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback? onNotification;
  final VoidCallback? onSettings;
  final bool lightMode;
  const TopBar({
    super.key,
    required this.userName,
    required this.avatarUrl,
    this.onNotification,
    this.onSettings,
    this.lightMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(avatarUrl)),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào mừng trở lại,',
                style: GoogleFonts.lato(
                  color: lightMode ? Colors.grey[600] : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  color: lightMode ? Colors.black87 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  letterSpacing: .3,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _CircleIconButton(
              icon: Iconsax.notification_bing,
              onTap: onNotification,
              glowColor: Colors.blueAccent,
              lightMode: lightMode,
            ),
            const SizedBox(width: 10),
            _CircleIconButton(
              icon: Iconsax.setting_2,
              onTap: onSettings,
              glowColor: Colors.purpleAccent,
              lightMode: lightMode,
            ),
          ],
        )
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color glowColor;
  final bool lightMode;
  const _CircleIconButton({
    required this.icon,
    required this.glowColor,
    this.onTap,
    this.lightMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lightMode ? Colors.grey.shade200 : Colors.white.withOpacity(.15),
          boxShadow: lightMode
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [
                  BoxShadow(
                    color: glowColor.withOpacity(.55),
                    blurRadius: 14,
                    spreadRadius: 1,
                  )
                ],
        ),
        child: Icon(icon, color: lightMode ? Colors.black87 : Colors.white, size: 22),
      ),
    );
  }
}
