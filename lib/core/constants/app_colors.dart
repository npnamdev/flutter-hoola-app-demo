import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core brand
  static const primary = Color(0xFF3927D6); // seed
  static const primaryDark = Color(0xFF2C1FA8);
  static const primaryDarker = Color(0xFF21177D);
  static const primaryLight = Color(0xFF5E4FF3); // keep existing
  static const primaryLighter = Color(0xFF8A7CFF);

  // Supporting accents
  static const accentPink = Color(0xFFE960F7);
  static const accentBlue = Color(0xFF4F8DFF);

  // Neutral scale
  static const neutralDark = Color(0xFF222222);
  static const neutral = Color(0xFF8F8A8A);
  static const neutralLight = Color(0xFFD5D5D5);
  static const neutralVeryLight = Color(0xFFF3F3F3);

  static const background = Colors.white;
  static const backgroundAlt = Color(0xFFF8F9FE);

  // Shadows / elevation tokens
  static const cardShadow = Color(0x14000000); // 8% black
  static const elevatedShadow = Color(0x1F000000); // 12% black

  // Gradients
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> primaryGradientAlt = [primaryDark, primary];
  static const List<Color> purpleGlass = [Color(0x663927D6), Color(0x333927D6)];

  // Semantic
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF1C40F);
  static const danger = Color(0xFFE74C3C);
}
