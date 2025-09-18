import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/app/router.dart';

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
    // Match by prefix so that nested paths still highlight the tab
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0; // default
  }

  String _currentLocation(BuildContext context) {
    final router = GoRouter.of(context);
    // Fallback approach: use router.routerDelegate.currentConfiguration to derive path
    final config = router.routerDelegate.currentConfiguration;
    try {
      // currentConfiguration is a RouteMatchList; toString often contains path, but safer to use uri.toString()
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
          height: 80,
          elevation: 0,
          indicatorColor: Colors.transparent,
          overlayColor: MaterialStateProperty.resolveWith<Color?>((
            Set<MaterialState> states,
          ) {
            return Colors.transparent;
          }),
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onTap(index, context),
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home_2, color: AppColors.neutral),
              selectedIcon: Icon(Iconsax.home_2, color: AppColors.primary),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.calendar_2, color: AppColors.neutral),
              selectedIcon: Icon(Iconsax.calendar_2, color: AppColors.primary),
              label: 'Lịch học',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.book_saved, color: AppColors.neutral),
              selectedIcon: Icon(Iconsax.book_saved, color: AppColors.primary),
              label: 'Học tập',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.notification_bing, color: AppColors.neutral),
              selectedIcon: Icon(
                Iconsax.notification_bing,
                color: AppColors.primary,
              ),
              label: 'Thông báo',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user, color: AppColors.neutral),
              selectedIcon: Icon(Iconsax.user, color: AppColors.primary),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}
