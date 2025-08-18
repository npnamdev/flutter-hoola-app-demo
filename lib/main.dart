import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'layouts/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoola App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 255, 255),
        ),
        fontFamily: GoogleFonts.lato().fontFamily,
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.lato(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: const Color.fromARGB(255, 57, 39, 214),
              );
            }
            return GoogleFonts.lato(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: const Color.fromARGB(255, 143, 138, 138),
            );
          }),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

