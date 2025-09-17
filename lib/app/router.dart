import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/navigation/navigation_menu.dart';
import 'package:my_app/features/home/presentation/pages/home_screen.dart';
import 'package:my_app/features/learning/presentation/pages/learning_screen.dart';
import 'package:my_app/features/schedule/presentation/pages/schedule_screen.dart';
import 'package:my_app/features/notification/presentation/pages/notification_screen.dart';
import 'package:my_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:my_app/features/splash/splash_screen.dart';

// Route names constants
class AppRoutes {
  static const splash = '/';
  static const homeShell = '/home';
  static const schedule = '/schedule';
  static const learning = '/learning';
  static const notification = '/notification';
  static const profile = '/profile';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => NavigationMenu(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.homeShell,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.schedule,
            name: 'schedule',
            builder: (context, state) => const ScheduleScreen(),
          ),
            GoRoute(
            path: AppRoutes.learning,
            name: 'learning',
            builder: (context, state) => const LearningScreen(),
          ),
          GoRoute(
            path: AppRoutes.notification,
            name: 'notification',
            builder: (context, state) => const NotificationScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
