import 'package:flutter/material.dart';
import 'wireframe_color_manager.dart';

/// Legacy wireframe colors class - now delegates to WireframeColorManager
/// Keep this file for backward compatibility with existing components
///
/// DEPRECATED: Use WireframeColorManager.colors directly instead
class WireframeColors {
  WireframeColors._();

  // Legacy static color getters - all delegate to the color manager
  static Color get background => WireframeColorManager.colors.background;
  static Color get surface => WireframeColorManager.colors.surface;
  static Color get surfaceBackground =>
      WireframeColorManager.colors.surfaceVariant;

  static Color get primary => WireframeColorManager.colors.primary;
  static Color get accent =>
      WireframeColorManager.colors.primary; // Legacy alias
  static Color get secondary => WireframeColorManager.colors.secondary;

  static Color get primaryText => WireframeColorManager.colors.text;
  static Color get secondaryText => WireframeColorManager.colors.textSecondary;
  static Color get text => WireframeColorManager.colors.text;
  static Color get invertedText => Color(0xFFFFFFFF);

  static Color get border => WireframeColorManager.colors.border;
  static Color get primaryBorder => WireframeColorManager.colors.border;

  static Color get success => WireframeColorManager.colors.success;
  static Color get warning => WireframeColorManager.colors.warning;
  static Color get danger => WireframeColorManager.colors.error;
  static Color get error => WireframeColorManager.colors.error;
  static Color get info => WireframeColorManager.colors.info;

  static Color get hover => WireframeColorManager.colors.hover;
  static Color get pressed => WireframeColorManager.colors.pressed;
  static Color get focused => WireframeColorManager.colors.focused;
  static Color get disabled => WireframeColorManager.colors.disabled;
  static Color get disabledButton => WireframeColorManager.colors.disabled;

  // Project colors
  static Color get tapInColor => WireframeColorManager.colors.tapInColor;
  static Color get momentsColor => WireframeColorManager.colors.momentsColor;
  static Color get coreAiColor => WireframeColorManager.colors.coreAiColor;
  static Color get plannieColor => WireframeColorManager.colors.plannieColor;

  // Additional legacy getters for backward compatibility
  static Color get lightGray => WireframeColorManager.colors.surfaceVariant;
  static Color get wireframeWhite => WireframeColorManager.colors.surface;
  static Color get wireframeLightGray =>
      WireframeColorManager.colors.surfaceVariant;
  static Color get orange => WireframeColorManager.colors.warning;
  static Color get wireframeOrange => WireframeColorManager.colors.warning;
  static Color get white => WireframeColorManager.colors.surface;
  static Color get gray => WireframeColorManager.colors.secondary;
  static Color get darkGray => WireframeColorManager.colors.text;

  // Missing color additions
  static Color get wireframeBlack => const Color(0xFF000000);
  static Color get linkedInBlue => const Color(0xFF0077B5);

  // Legacy color method delegation
  static Color getStatusColor(WireframeStatus status) {
    return WireframeColorManager.getStatusColor(status);
  }

  static Color getInteractionColor(WireframeInteraction interaction) {
    return WireframeColorManager.getInteractionColor(interaction);
  }

  static Color getProjectColor(String projectId) {
    return WireframeColorManager.getProjectColor(projectId);
  }

  // Utility functions
  static Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color getContrastingTextColor(Color backgroundColor) {
    return WireframeColorManager.getContrastingTextColor(backgroundColor);
  }

  // Theme schemes delegation
  static WireframeColorScheme getCurrentScheme([WireframeThemeMode? mode]) {
    // Legacy mode parameter is ignored, use color manager instead
    return WireframeColorManager.colors;
  }

  static ColorScheme toFlutterColorScheme(WireframeColorScheme scheme) {
    return WireframeColorManager.toFlutterColorScheme();
  }
}

// Legacy theme mode enum - kept for compatibility
enum WireframeThemeMode {
  light,
  dark,
  highContrast,
}
