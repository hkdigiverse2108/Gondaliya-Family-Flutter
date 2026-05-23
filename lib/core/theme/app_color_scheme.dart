import 'package:flutter/material.dart';
import '../values/colors.dart';

/// A centralized, mode-aware color scheme for the app.
///
/// Instead of writing `isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary`
/// everywhere, use `context.appColors.textPrimary` — the correct variant is resolved
/// automatically based on the current [ThemeMode].
///
/// Usage:
/// ```dart
/// final colors = context.appColors;
/// color: colors.textPrimary,
/// backgroundColor: colors.card,
/// boxShadow: colors.neumorphicShadow(),
/// ```
class AppColorScheme {
  // ── Brand ──────────────────────────────────────────────────────────────

  /// Main brand color — navy blue. Same for both modes.
  final Color primary;

  /// Lighter variant of primary. Same for both modes.
  final Color primaryVariant;

  /// Dark variant of primary.
  final Color primaryDark;

  /// Deepest variant of primary.
  final Color primaryDeep;

  /// Secondary brand color — emerald green. Same for both modes.
  final Color secondary;

  /// Lighter variant of secondary.
  final Color secondaryVariant;

  /// Dark variant of secondary.
  final Color secondaryDark;

  /// Glow variant of secondary.
  final Color secondaryGlow;

  // ── Surfaces ───────────────────────────────────────────────────────────

  /// Scaffold / page background.
  final Color background;

  /// Card & container fill color.
  final Color card;

  /// Divider / border color.
  final Color divider;

  // ── Text ────────────────────────────────────────────────────────────────

  /// Primary text color (headings, body).
  final Color textPrimary;

  /// Secondary text color (captions, hints).
  final Color textSecondary;

  // ── Shadows ─────────────────────────────────────────────────────────────

  /// Base shadow color.
  final Color shadow;

  // ── Semantic Accents ────────────────────────────────────────────────────

  /// General accent — used for active elements, links, highlights.
  /// Maps to `primary` in light mode, `secondaryLight` in dark mode.
  final Color accent;

  /// Active icon tint (nav bars, icon buttons).
  final Color iconActive;

  // ── Design Accents & Bridges ────────────────────────────────────────────

  /// Teal bridge color. Same for both modes.
  final Color tealBridge;

  /// Gold accent color. Same for both modes.
  final Color goldAccent;

  /// Coral accent color. Same for both modes.
  final Color coralAccent;

  // ── Status ──────────────────────────────────────────────────────────────

  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  // ── Absolute ────────────────────────────────────────────────────────────

  final Color white;
  final Color black;
  final Color transparent;

  // ── Mode flag ───────────────────────────────────────────────────────────

  /// `true` when the current theme is dark mode.
  final bool isDark;

  // ── Constructor ─────────────────────────────────────────────────────────

  // ignore: unused_element
  const AppColorScheme._({
    required this.primary,
    required this.primaryVariant,
    required this.primaryDark,
    required this.primaryDeep,
    required this.secondary,
    required this.secondaryVariant,
    required this.secondaryDark,
    required this.secondaryGlow,
    required this.background,
    required this.card,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.shadow,
    required this.accent,
    required this.iconActive,
    required this.tealBridge,
    required this.goldAccent,
    required this.coralAccent,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.white,
    required this.black,
    required this.transparent,
    required this.isDark,
  });

  // ── Light Mode ──────────────────────────────────────────────────────────

  /// All colors resolved for **light** mode.
  const AppColorScheme.light()
    : primary = AppColors.primary,
      primaryVariant = AppColors.primaryLight,
      primaryDark = AppColors.primaryDark,
      primaryDeep = AppColors.primaryDeep,
      secondary = AppColors.secondary,
      secondaryVariant = AppColors.secondaryLight,
      secondaryDark = AppColors.secondaryDark,
      secondaryGlow = AppColors.secondaryGlow,
      background = AppColors.bgLight,
      card = AppColors.cardLight,
      divider = AppColors.dividerLight,
      textPrimary = AppColors.textLightPrimary,
      textSecondary = AppColors.textLightSecondary,
      shadow = AppColors.shadowLight,
      accent = AppColors.primary,
      iconActive = AppColors.primaryLight,
      tealBridge = AppColors.tealBridge,
      goldAccent = AppColors.goldAccent,
      coralAccent = AppColors.coralAccent,
      error = AppColors.error,
      success = AppColors.success,
      warning = AppColors.warning,
      info = AppColors.info,
      white = AppColors.white,
      black = AppColors.black,
      transparent = AppColors.transparent,
      isDark = false;

  // ── Dark Mode ───────────────────────────────────────────────────────────

  /// All colors resolved for **dark** mode.
  const AppColorScheme.dark()
    : primary = AppColors.primary,
      primaryVariant = AppColors.primaryLight,
      primaryDark = AppColors.primaryDark,
      primaryDeep = AppColors.primaryDeep,
      secondary = AppColors.secondary,
      secondaryVariant = AppColors.secondaryLight,
      secondaryDark = AppColors.secondaryDark,
      secondaryGlow = AppColors.secondaryGlow,
      background = AppColors.bgDark,
      card = AppColors.cardDark,
      divider = AppColors.dividerDark,
      textPrimary = AppColors.textDarkPrimary,
      textSecondary = AppColors.textDarkSecondary,
      shadow = AppColors.shadowDark,
      accent = AppColors.secondaryLight,
      iconActive = AppColors.secondaryLight,
      tealBridge = AppColors.tealBridge,
      goldAccent = AppColors.goldAccent,
      coralAccent = AppColors.coralAccent,
      error = AppColors.error,
      success = AppColors.success,
      warning = AppColors.warning,
      info = AppColors.info,
      white = AppColors.white,
      black = AppColors.black,
      transparent = AppColors.transparent,
      isDark = true;

  // ── Neumorphic Shadow Helpers ───────────────────────────────────────────

  /// Outer neumorphic shadow — auto-resolves light/dark variant.
  List<BoxShadow> neumorphicShadow({double blur = 15, double distance = 5}) {
    return isDark
        ? AppColors.neumorphicShadowDark(blur: blur, distance: distance)
        : AppColors.neumorphicShadowLight(blur: blur, distance: distance);
  }

  /// Inset neumorphic shadow — auto-resolves light/dark variant.
  List<BoxShadow> neumorphicInsetShadow({
    double blur = 12,
    double distance = 4,
  }) {
    return isDark
        ? AppColors.neumorphicInsetShadowDark(blur: blur, distance: distance)
        : AppColors.neumorphicInsetShadowLight(blur: blur, distance: distance);
  }

  /// Press-state neumorphic shadow — auto-resolves light/dark variant.
  List<BoxShadow> neumorphicPressShadow({
    double blur = 8,
    double distance = 2,
  }) {
    return isDark
        ? AppColors.neumorphicPressShadowDark(blur: blur, distance: distance)
        : AppColors.neumorphicPressShadowLight(blur: blur, distance: distance);
  }
  // ── Gradient Helpers ──────────────────────────────────────────────────────────

  /// Primary gradient — auto-resolves light/dark variant.
  List<Color> get primaryGradient {
    return isDark
        ? [
            primaryVariant,
            tealBridge,
            secondaryVariant,
          ] // Luminous tones for dark mode
        : [primary, tealBridge, secondary];
  }
}

// ── BuildContext Extension ──────────────────────────────────────────────────

/// Provides [AppColorScheme] via `context.appColors`.
///
/// ```dart
/// Widget build(BuildContext context) {
///   final colors = context.appColors;
///   return Container(color: colors.card);
/// }
/// ```
extension AppColorSchemeExtension on BuildContext {
  /// Returns the [AppColorScheme] matching the current theme brightness.
  AppColorScheme get appColors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? const AppColorScheme.dark()
        : const AppColorScheme.light();
  }
}
