import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getScaleFactor(BuildContext context, double baseWidth) {
    final currentWidth = MediaQuery.of(context).size.width;
    return currentWidth / baseWidth;
  }

  // Scale a dimension while keeping it within reasonable bounds
  static double getScaledSize(double size, double scaleFactor,
      {double minScale = 0.6, double maxScale = 1.2}) {
    return size * (scaleFactor.clamp(minScale, maxScale));
  }

  // Get appropriate padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(12.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }
}
