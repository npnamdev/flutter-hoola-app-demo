import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/core/constants/app_svg_icons.dart';

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
    return SizedBox(
      height: kTopBarHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: kTopBarHeight,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatarUrl)),
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
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: kTopBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2), // optical tweak
                    child: Text(
                      'Chào mừng trở lại,',
                      style: GoogleFonts.lato(
                        color: lightMode ? Colors.grey[600] : Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    userName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      color: lightMode ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: .3,
                      height: 1.05,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: kTopBarHeight,
            child: Row(
              children: [
                if (showSearchIcon)
                  _SvgIconButton(
                    svg: AppSvgIcons.search,
                    onTap: onSearch,
                    lightMode: lightMode,
                  ),
                if (showSearchIcon) const SizedBox(width: 8),
                _SvgIconButton(
                  svg: AppSvgIcons.bell,
                  onTap: onNotification,
                  lightMode: lightMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const double kTopBarHeight = 60.0;

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
