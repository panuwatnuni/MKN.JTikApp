import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class JTikTheme {
  static ThemeData dark() {
    final scheme = FlexColorScheme.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFFC5A253),
        primaryContainer: Color(0xFF8E7433),
        secondary: Color(0xFFE8C987),
        secondaryContainer: Color(0xFF5A4316),
        tertiary: Color(0xFF8F6B3F),
        tertiaryContainer: Color(0xFF3E2B10),
        appBarColor: Color(0xFF0B0B0B),
        error: Color(0xFFFF6F61),
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      appBarStyle: FlexAppBarStyle.primary,
      swapColors: true,
      scaffoldBackground: const Color(0xFF0B0B0B),
      fontFamily: 'Roboto',
    );
    return scheme.toTheme.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: scheme.toTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.4),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1F1F1F),
        selectedColor: const Color(0xFFC5A253),
        labelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF1F1F1F),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
