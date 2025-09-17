import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3927D6)),
      fontFamily: GoogleFonts.lato().fontFamily,
    );

    return base.copyWith(
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: selected
                ? const Color(0xFF3927D6)
                : const Color(0xFF8F8A8A),
          );
        }),
      ),
    );
  }
}
