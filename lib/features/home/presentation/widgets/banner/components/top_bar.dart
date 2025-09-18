import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart'; // still used for settings icon
import 'package:flutter_svg/flutter_svg.dart';

class TopBar extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback? onNotification;
  final VoidCallback? onSettings;
  final VoidCallback? onSearch;
  final bool showSearchIcon;
  final bool lightMode;
  const TopBar({
    super.key,
    required this.userName,
    required this.avatarUrl,
    this.onNotification,
    this.onSettings,
    this.onSearch,
    this.showSearchIcon = false,
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
            ),
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
            if (showSearchIcon)
              _SvgIconButton(
                svg: _searchSvg,
                onTap: onSearch,
                lightMode: lightMode,
              ),
            if (showSearchIcon) const SizedBox(width: 8),
            _SvgIconButton(
              svg: _searchSvg,
              onTap: onNotification,
              lightMode: lightMode,
            ),
            const SizedBox(width: 10),
            _SvgIconButton(
              svg: _bellSvg,
              onTap: onNotification,
              lightMode: lightMode,
            ),
          ],
        ),
      ],
    );
  }
}

const String _searchSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 24 24" fill="#000000"><g fill="none" stroke="#000000" stroke-width="1.5"><circle cx="11.5" cy="11.5" r="9.5" opacity=".5"/><path stroke-linecap="round" d="M18.5 18.5L22 22"/></g></svg>
''';

const String _bellSvg = '''
<svg aria-hidden="true" role="img" class="iconify iconify--solar MuiBox-root css-0" width="18px" height="18px" viewBox="0 0 24 24"><path fill="currentColor" fill-rule="evenodd" d="M12 1.25A7.75 7.75 0 0 0 4.25 9v.704a3.53 3.53 0 0 1-.593 1.958L2.51 13.385c-1.334 2-.316 4.718 2.003 5.35q1.133.309 2.284.523l.002.005C7.567 21.315 9.622 22.75 12 22.75s4.433-1.435 5.202-3.487l.002-.005a29 29 0 0 0 2.284-.523c2.319-.632 3.337-3.35 2.003-5.35l-1.148-1.723a3.53 3.53 0 0 1-.593-1.958V9A7.75 7.75 0 0 0 12 1.25m3.376 18.287a28.5 28.5 0 0 1-6.753 0c.711 1.021 1.948 1.713 3.377 1.713s2.665-.692 3.376-1.713M5.75 9a6.25 6.25 0 1 1 12.5 0v.704c0 .993.294 1.964.845 2.79l1.148 1.723a2.02 2.02 0 0 1-1.15 3.071a26.96 26.96 0 0 1-14.187 0a2.02 2.02 0 0 1-1.15-3.07l1.15-1.724a5.03 5.03 0 0 0 .844-2.79z" clip-rule="evenodd"></path></svg>
''';

class _SvgIconButton extends StatelessWidget {
  final String svg;
  final VoidCallback? onTap;
  final bool lightMode;
  const _SvgIconButton({required this.svg, this.onTap, this.lightMode = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: lightMode
              ? Colors.grey.shade200
              : Colors.white.withOpacity(.15),
        ),
        child: SvgPicture.string(
          svg,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            lightMode ? Colors.purple : Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
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
          color: lightMode
              ? Colors.grey.shade200
              : Colors.white.withOpacity(.15),
          boxShadow: lightMode
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: glowColor.withOpacity(.55),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Icon(
          icon,
          color: lightMode ? Colors.black87 : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
