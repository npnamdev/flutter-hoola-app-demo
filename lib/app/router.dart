import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/navigation/navigation_menu.dart';
import 'package:my_app/features/home/presentation/pages/home_screen.dart';
// Replaced legacy LearningScreen with MyCoursesScreen as the primary learning tab
import 'package:my_app/features/schedule/presentation/pages/schedule_screen.dart';
import 'package:my_app/features/notification/presentation/pages/notification_screen.dart';
import 'package:my_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:my_app/features/splash/splash_screen.dart';
import 'package:my_app/features/auth/presentation/pages/login_screen.dart';
import 'package:my_app/features/search/presentation/pages/search_screen.dart';
import 'package:my_app/features/learning/presentation/pages/my_courses_screen.dart';

// Route names constants
class AppRoutes {
  static const splash = '/';
  static const homeShell = '/home';
  static const login = '/login';
  static const schedule = '/schedule';
  static const learning = '/learning';
  static const notification = '/notification';
  static const profile = '/profile';
  static const search = '/search';
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
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => NavigationMenu(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.homeShell,
            name: 'home',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.schedule,
            name: 'schedule',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const ScheduleScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.learning,
            name: 'learning',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const MyCoursesScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.notification,
            name: 'notification',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const NotificationScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

// Helper to build a fade transition page (no horizontal slide)
CustomTransitionPage _buildFadePage({required LocalKey key, required Widget child}) {
  return CustomTransitionPage(
    key: key,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}
