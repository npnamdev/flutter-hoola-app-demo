import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router.dart';

class HoolaApp extends StatelessWidget {
  const HoolaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      title: 'Hoola App',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
