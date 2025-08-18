import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/learning_screen.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/screens/notification_screen.dart';
import 'package:my_app/screens/schedule_screen.dart';

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
              icon: Icon(
                Iconsax.home_2,
                color: Color.fromARGB(255, 159, 155, 155),
              ),
              selectedIcon: Icon(
                Iconsax.home_2,
                color: Color.fromARGB(255, 57, 39, 214),
              ),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.calendar_2,
                color: Color.fromARGB(255, 159, 155, 155),
              ),
              selectedIcon: Icon(
                Iconsax.calendar_2,
                color: Color.fromARGB(255, 57, 39, 214),
              ),
              label: 'Lịch học',
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.book_saved,
                color: Color.fromARGB(255, 159, 155, 155),
              ),
              selectedIcon: Icon(
                Iconsax.book_saved,
                color: Color.fromARGB(255, 57, 39, 214),
              ),
              label: 'Học tập',
            ),

            NavigationDestination(
              icon: Icon(
                Iconsax.notification_bing,
                color: Color.fromARGB(255, 159, 155, 155),
              ),
              selectedIcon: Icon(
                Iconsax.notification_bing,
                color: Color.fromARGB(255, 57, 39, 214),
              ),
              label: 'Thông báo',
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.user,
                color: Color.fromARGB(255, 159, 155, 155),
              ),
              selectedIcon: Icon(
                Iconsax.user,
                color: Color.fromARGB(255, 57, 39, 214),
              ),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}
