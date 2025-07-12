import 'package:flutter/material.dart';

/// Master color definitions for the entire portfolio application
/// Centralizes all color management for consistency and easy maintenance
class MasterColors {
  MasterColors._(); // Private constructor to prevent instantiation

  // ===== WIREFRAME THEME COLORS =====
  static const Color wireframeBg = Color(0xFFF8F9FA);
  static const Color wireframeBorder = Color(0xFFE1E5E9);
  static const Color wireframeText = Color(0xFF495057);
  static const Color wireframeAccent = Color(0xFF007BFF);
  static const Color wireframeSecondary = Color(0xFF6C757D);
  static const Color wireframeDanger = Color(0xFFDC3545);
  static const Color wireframeSuccess = Color(0xFF28A745);
  static const Color wireframeWarning = Color(0xFFFFC107);
  static const Color wireframeInfo = Color(0xFF17A2B8);
  static const Color wireframeLightGray = Color(0xFFF1F3F4);
  static const Color wireframeOrange = Color(0xFFFF9500);

  // ===== MAIN THEME COLORS =====
  static const Color mainBackground = Color(0xFF2E8BDE);
  static const Color mainDark = Color(0xFF021220);
  static const Color mainAccent = Color(0xFFFF9A62);
  static const Color mainSecondary = Color(0xFF567185);
  static const Color mainHighlight = Color(0xFFCC510F);

  // ===== NES THEME COLORS =====
  static const Color nesGreen = Color(0xFF4EBD5F);
  static const Color nesDark = Color(0xFF2B2A2F);
  static const Color nesLight = Color(0xFFF8E9D2);
  static const Color nesPurple = Color(0xFF9370DB);
  static const Color nesOrange = Color(0xFFED725C);
  static const Color nesBlue = Color(0xFF0B4A9D);

  // ===== COMMON COLORS =====
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // ===== SHADOW COLORS =====
  static const Color shadowLight = Color(0x1A000000); // 10% black
  static const Color shadowMedium = Color(0x33000000); // 20% black
  static const Color shadowDark = Color(0x4D000000); // 30% black

  // ===== GRADIENT COLORS =====
  static const List<Color> wireframeGradient = [
    wireframeBg,
    wireframeLightGray,
  ];

  static const List<Color> mainGradient = [
    mainBackground,
    mainDark,
  ];

  // ===== UTILITY METHODS =====

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get wireframe theme colors as a map
  static Map<String, Color> get wireframeTheme => {
        'background': wireframeBg,
        'border': wireframeBorder,
        'text': wireframeText,
        'accent': wireframeAccent,
        'secondary': wireframeSecondary,
        'danger': wireframeDanger,
        'success': wireframeSuccess,
        'warning': wireframeWarning,
        'info': wireframeInfo,
        'lightGray': wireframeLightGray,
        'orange': wireframeOrange,
      };

  /// Get main theme colors as a map
  static Map<String, Color> get mainTheme => {
        'background': mainBackground,
        'dark': mainDark,
        'accent': mainAccent,
        'secondary': mainSecondary,
        'highlight': mainHighlight,
      };

  /// Get NES theme colors as a map
  static Map<String, Color> get nesTheme => {
        'green': nesGreen,
        'dark': nesDark,
        'light': nesLight,
        'purple': nesPurple,
        'orange': nesOrange,
        'blue': nesBlue,
      };
}
