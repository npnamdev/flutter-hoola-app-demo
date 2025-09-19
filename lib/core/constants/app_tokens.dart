import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized design tokens for spacing, radii, elevations.
class AppRadii {
  AppRadii._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20; // unified large card corner
  static const double xl = 24;
  static const double pill = 1000; // for stadium / circular
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

class AppShadows {
  AppShadows._();
  // Base card shadow used across light surfaces
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: AppColors.elevatedShadow,
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  // Soft shadow for search bar / chips
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
}
