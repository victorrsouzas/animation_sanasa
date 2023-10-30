import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColors {
  static const int background = 0xFFFAFAFA;
  static const int borderInput = 0xFFE9ECEF;
  static const int _primaryValue = 0xFF1C3985;
  static const int secondValue = 0xFF2161A7;
  static const int textColorCard = 0xFF868E96;

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE5E9F2),
      Color(0xFFF4F4F4),
      Color(0xFFE5E9F2),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(_primaryValue),
      100: Color(_primaryValue),
      200: Color(_primaryValue),
      300: Color(_primaryValue),
      400: Color(_primaryValue),
      500: Color(_primaryValue),
      600: Color(_primaryValue),
      700: Color(_primaryValue),
      800: Color(_primaryValue),
      900: Color(_primaryValue)
    },
  );
}

ThemeData sanasaTheme = ThemeData(
  //useMaterial3: true,
  primaryColor: const Color(ThemeColors._primaryValue),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: ThemeColors.primary),
  textTheme: GoogleFonts.latoTextTheme(),
);
