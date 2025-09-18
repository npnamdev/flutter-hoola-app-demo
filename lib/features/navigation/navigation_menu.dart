import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/app/router.dart';
import 'package:my_app/core/constants/app_svg_icons.dart';

class NavigationMenu extends StatefulWidget {
  final Widget child;
  const NavigationMenu({Key? key, required this.child}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  static const _routes = [
    AppRoutes.homeShell,
    AppRoutes.schedule,
    AppRoutes.learning,
    AppRoutes.notification,
    AppRoutes.profile,
  ];

  int _currentIndexFromLocation(String location) {
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  String _currentLocation(BuildContext context) {
    final router = GoRouter.of(context);
    final config = router.routerDelegate.currentConfiguration;
    try {
      return config.uri.toString();
    } catch (_) {
      return AppRoutes.homeShell;
    }
  }

  void _onTap(int index, BuildContext context) {
    final target = _routes[index];
    final loc = _currentLocation(context);
    if (loc != target) {
      context.go(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = _currentLocation(context);
    final currentIndex = _currentIndexFromLocation(location);

    return Scaffold(
      body: widget.child,

      // ✅ Nút Học nổi lên một chút
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 12), // chỉnh số âm để nổi cao hơn, dương để hạ thấp
        child: _LearningFloatingButton(
          active: currentIndex == 2,
          onTap: () => _onTap(2, context),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 224, 220, 220),
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          height: 70,
          elevation: 0,
          indicatorColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onTap(index, context),
          destinations: [
            NavigationDestination(
              icon: SvgIcon(AppSvgIcons.home, color: AppColors.neutral, size: 24),
              selectedIcon: SvgIcon(AppSvgIcons.home, color: AppColors.primary, size: 24),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: SvgIcon(AppSvgIcons.calendar, color: AppColors.neutral, size: 24),
              selectedIcon: SvgIcon(AppSvgIcons.calendar, color: AppColors.primary, size: 24),
              label: 'Lịch học',
            ),
            const NavigationDestination(
              icon: SizedBox.shrink(),
              selectedIcon: SizedBox.shrink(),
              label: '',
            ),
            NavigationDestination(
              icon: SvgIcon(AppSvgIcons.bell, color: AppColors.neutral, size: 24),
              selectedIcon: SvgIcon(AppSvgIcons.bell, color: AppColors.primary, size: 24),
              label: 'Thông báo',
            ),
            NavigationDestination(
              icon: SvgIcon(AppSvgIcons.user, color: AppColors.neutral, size: 24),
              selectedIcon: SvgIcon(AppSvgIcons.user, color: AppColors.primary, size: 24),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningFloatingButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _LearningFloatingButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: active ? 1 : 0.94,
        curve: Curves.easeOut,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: active ? 1 : 0,
                duration: const Duration(milliseconds: 320),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.white.withOpacity(.38), Colors.transparent],
                      radius: .85,
                    ),
                  ),
                ),
              ),
              SvgIcon(AppSvgIcons.book, color: Colors.white, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
