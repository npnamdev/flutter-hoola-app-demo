import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/learning_screen.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/screens/notification_screen.dart';
import 'package:my_app/screens/schedule_screen.dart';
import 'package:my_app/core/constants/app_colors.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ScheduleScreen(),
    LearningScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
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
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
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
              selectedIcon: Icon(Iconsax.notification_bing, color: AppColors.primary),
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
