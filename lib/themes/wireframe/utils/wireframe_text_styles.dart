import 'package:flutter/material.dart';
import 'wireframe_color_manager.dart';

/// Centralized text styles for wireframe theme
/// Automatically adapts to current theme colors
class WireframeTextStyles {
  WireframeTextStyles._();

  // ===== HEADINGS =====

  static TextStyle get h1 => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: WireframeColorManager.colors.text,
        height: 1.2,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: WireframeColorManager.colors.text,
        height: 1.3,
      );

  static TextStyle get h3 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: WireframeColorManager.colors.text,
        height: 1.4,
      );

  static TextStyle get h4 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: WireframeColorManager.colors.text,
        height: 1.4,
      );

  static TextStyle get h5 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: WireframeColorManager.colors.text,
        height: 1.5,
      );

  // ===== BODY TEXT =====

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: WireframeColorManager.colors.text,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: WireframeColorManager.colors.text,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: WireframeColorManager.colors.textSecondary,
        height: 1.4,
      );

  // ===== SECONDARY TEXT =====

  static TextStyle get caption => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: WireframeColorManager.colors.textSecondary,
        height: 1.4,
      );

  static TextStyle get subtitle1 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: WireframeColorManager.colors.textSecondary,
        height: 1.5,
      );

  static TextStyle get subtitle2 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: WireframeColorManager.colors.textSecondary,
        height: 1.4,
      );

  // ===== BUTTON TEXT =====

  static TextStyle get buttonLarge => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: WireframeColorManager.colors.onPrimary,
        height: 1.2,
      );

  static TextStyle get buttonMedium => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: WireframeColorManager.colors.onPrimary,
        height: 1.2,
      );

  static TextStyle get buttonSmall => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: WireframeColorManager.colors.onPrimary,
        height: 1.2,
      );

  // ===== ACCENT TEXT =====

  static TextStyle get accent => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: WireframeColorManager.colors.primary,
        height: 1.4,
      );

  static TextStyle get link => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: WireframeColorManager.colors.primary,
        decoration: TextDecoration.underline,
        height: 1.4,
      );

  // ===== RESPONSIVE HELPERS =====

  /// Get responsive text style based on screen size
  static TextStyle responsive({
    required double mobileSize,
    required double desktopSize,
    required bool isMobile,
    FontWeight? weight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: isMobile ? mobileSize : desktopSize,
      fontWeight: weight ?? FontWeight.normal,
      color: color ?? WireframeColorManager.colors.text,
      height: height ?? 1.4,
    );
  }

  /// Get status-colored text style
  static TextStyle status(WireframeStatus status, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: WireframeColorManager.getStatusColor(status),
      height: 1.4,
    );
  }

  /// Get project-colored text style
  static TextStyle project(String projectId, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: WireframeColorManager.getProjectColor(projectId),
      height: 1.4,
    );
  }
}
