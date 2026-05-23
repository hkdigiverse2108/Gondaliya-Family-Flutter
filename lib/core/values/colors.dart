import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors (Branded Navy Blue)
  static const Color primary = Color(0xFF2B3B82);
  static const Color primaryLight = Color(0xFF4A5BB2);
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color primaryDeep = Color(0xFF0A0A0A);

  // Secondary colors (Branded Emerald Green)
  static const Color secondary = Color(0xFF1BB273);
  static const Color secondaryLight = Color(0xFF52E09F);
  static const Color secondaryDark = Color(0xFF0E6E45);
  static const Color secondaryGlow = Color(0xFF00FF94);

  // Design Accents & Bridges
  static const Color tealBridge = Color(0xFF1B8BA2);
  static const Color goldAccent = Color(0xFFF59E0B);
  static const Color coralAccent = Color(0xFFF43F5E);
  static const Color info = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  // Light Mode Backgrounds & Card
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE2E8F0);

  // Dark Mode System (Polished Black/Charcoal)
  static const Color bgDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color dividerDark = Color(0xFF2C2C2C);

  // Text colors
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF475569);

  static const Color textDarkPrimary = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  // Shadows
  static const Color shadowLight = Color(0x0F0F172A);
  static const Color shadowDark = Color(0x3F000000);

  // General colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Neumorphic shadow utilities
  static List<BoxShadow> neumorphicShadowLight({
    double blur = 6,
    double distance = 2,
  }) {
    return [
      // Soft shadow (bottom-right)
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.1),
        blurRadius: blur,
        offset: Offset(distance, distance),
      ),
      // Highlight shadow (top-left)
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
      ),
    ];
  }

  static List<BoxShadow> neumorphicShadowDark({
    double blur = 6,
    double distance = 2,
  }) {
    return [
      // Dark shadow (bottom-right)
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.6),
        blurRadius: blur,
        offset: Offset(distance, distance),
      ),
      // Light highlight (top-left) - much more subtle for black theme
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.03),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
      ),
    ];
  }

  static List<BoxShadow> neumorphicInsetShadowLight({
    double blur = 4,
    double distance = 1,
  }) {
    return [
      // Inner shadow effect (top-left)
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.8),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
        spreadRadius: -1,
      ),
      // Inner dark shadow (bottom-right)
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.12),
        blurRadius: blur,
        offset: Offset(distance, distance),
        spreadRadius: -1,
      ),
    ];
  }

  static List<BoxShadow> neumorphicInsetShadowDark({
    double blur = 4,
    double distance = 1,
  }) {
    return [
      // Inner highlight (top-left) - subtle for black theme
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.02),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
        spreadRadius: -1,
      ),
      // Inner dark shadow (bottom-right)
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.8),
        blurRadius: blur,
        offset: Offset(distance, distance),
        spreadRadius: -1,
      ),
    ];
  }

  static List<BoxShadow> neumorphicPressShadowLight({
    double blur = 2,
    double distance = 1,
  }) {
    return [
      // Pressed state - reduced shadow
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.08),
        blurRadius: blur,
        offset: Offset(distance, distance),
      ),
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.5),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
      ),
    ];
  }

  static List<BoxShadow> neumorphicPressShadowDark({
    double blur = 2,
    double distance = 1,
  }) {
    return [
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.5),
        blurRadius: blur,
        offset: Offset(distance, distance),
      ),
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.02),
        blurRadius: blur,
        offset: Offset(-distance, -distance),
      ),
    ];
  }
}
