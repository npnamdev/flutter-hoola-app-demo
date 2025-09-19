import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/core/constants/app_svg_icons.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/features/notification/data/unread_notifications_provider.dart';

class TopBar extends ConsumerWidget {
  final String userName;
  final String avatarUrl;
  final VoidCallback? onNotification;
  final VoidCallback? onSettings;
  final VoidCallback? onSearch;
  final bool showSearchIcon;
  final bool lightMode;
  final bool showProfile; // new
  const TopBar({
    super.key,
    required this.userName,
    required this.avatarUrl,
    this.onNotification,
    this.onSettings,
    this.onSearch,
    this.showSearchIcon = false,
    this.lightMode = true,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: kTopBarHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showProfile) ...[
            SizedBox(
              height: kTopBarHeight,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
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
          ] else ...[
            // When profile hidden, push icons to left spacing
            Expanded(child: Container()),
          ],
          SizedBox(
            height: kTopBarHeight,
            child: Row(
              children: [
                if (showSearchIcon)
                  Hero(
                    tag: 'search_bar_hero',
                    flightShuttleBuilder:
                        (context, animation, direction, fromCtx, toCtx) {
                          return FadeTransition(
                            opacity: animation,
                            child: toCtx.widget,
                          );
                        },
                    child: _SvgIconButton(
                      svg: AppSvgIcons.search,
                      onTap: onSearch,
                      lightMode: lightMode,
                    ),
                  ),
                if (showSearchIcon) const SizedBox(width: 8),
                _NotificationBellButton(
                  lightMode: lightMode,
                  onTap: onNotification,
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

class _NotificationBellButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final bool lightMode;
  const _NotificationBellButton({this.onTap, this.lightMode = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadNotificationsCountProvider);
    final show = count > 0;
    final label = count > 9 ? '9+' : '$count';
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightMode
                  ? Colors.grey.shade200
                  : Colors.white.withOpacity(.15),
            ),
            child: SvgPicture.string(
              AppSvgIcons.bell,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                lightMode ? Colors.purple : Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          if (show)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.20),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 16),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      letterSpacing: -.2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
