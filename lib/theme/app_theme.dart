import 'package:flutter/material.dart';

/// Tema aplikasi MyWatchlist — Material 3, dark mode, charcoal + teal.
class AppTheme {
  AppTheme._();

  // Warna dasar.
  static const Color _charcoal = Color(0xFF1A1A2E);
  static const Color _charcoalLight = Color(0xFF222240);
  static const Color _surface = Color(0xFF252547);
  static const Color _surfaceVariant = Color(0xFF2D2D52);
  static const Color _teal = Color(0xFF00D9A6);
  static const Color _tealDim = Color(0xFF00B38A);
  static const Color _textPrimary = Color(0xFFF0F0F5);
  static const Color _textSecondary = Color(0xFFA0A0B8);
  static const Color _error = Color(0xFFFF6B6B);

  // Status colors.
  static const Color planToWatchColor = Color(0xFF7C83FD);
  static const Color watchingColor = Color(0xFFFFC107);
  static const Color completedColor = Color(0xFF00D9A6);

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: _teal,
      onPrimary: _charcoal,
      primaryContainer: _tealDim,
      secondary: _teal,
      onSecondary: _charcoal,
      surface: _surface,
      onSurface: _textPrimary,
      onSurfaceVariant: _textSecondary,
      error: _error,
      onError: Colors.white,
      outline: _textSecondary.withValues(alpha: 0.3),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _charcoal,
      fontFamily: 'Inter',

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _charcoal,
        foregroundColor: _textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
      ),

      // NavigationBar (bottom nav)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _charcoalLight,
        indicatorColor: _teal.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _teal, size: 24);
          }
          return const IconThemeData(color: _textSecondary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _teal,
            );
          }
          return const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          );
        }),
        height: 70,
        elevation: 0,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _teal,
        foregroundColor: _charcoal,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceVariant,
        selectedColor: _teal.withValues(alpha: 0.2),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: _textPrimary,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: _textSecondary),
        hintStyle: TextStyle(color: _textSecondary.withValues(alpha: 0.7)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // SegmentedButton
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return _teal.withValues(alpha: 0.15);
            }
            return _surfaceVariant;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return _teal;
            }
            return _textSecondary;
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: _textSecondary.withValues(alpha: 0.2)),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _charcoalLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: _teal,
        inactiveTrackColor: _surfaceVariant,
        thumbColor: _teal,
        overlayColor: _teal.withValues(alpha: 0.12),
        valueIndicatorColor: _teal,
        valueIndicatorTextStyle: const TextStyle(
          color: _charcoal,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          color: _textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          color: _textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: _textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          color: _textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          color: _textPrimary,
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceVariant,
        contentTextStyle: const TextStyle(
          fontFamily: 'Inter',
          color: _textPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
