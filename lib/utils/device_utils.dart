// lib/utils/device_utils.dart

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // For web user agent detection

class DeviceUtils {
  // Increased breakpoint to include virtually all mobile devices
  static const double MOBILE_BREAKPOINT = 1100;

  // iPhone models breakpoints (in landscape)
  static const Map<String, Map<String, double>> IPHONE_DIMENSIONS = {
    'iPhone 15 Pro Max': {'width': 932, 'height': 430},
    'iPhone 14 Pro Max': {'width': 932, 'height': 430},
    'iPhone 13 Pro Max': {'width': 926, 'height': 428},
    'iPhone 12 Pro Max': {'width': 926, 'height': 428},
    'iPhone 11 Pro Max': {'width': 896, 'height': 414},
    'iPhone XS Max': {'width': 896, 'height': 414},
    'iPhone XR': {'width': 896, 'height': 414},
    'iPhone X/XS': {'width': 812, 'height': 375},
    'iPhone 8 Plus': {'width': 736, 'height': 414},
  };

  // Android flagship models (in landscape)
  static const Map<String, Map<String, double>> ANDROID_DIMENSIONS = {
    'Samsung Galaxy S23 Ultra': {'width': 915, 'height': 412},
    'Samsung Galaxy S22 Ultra': {'width': 915, 'height': 412},
    'Samsung Galaxy S21 Ultra': {'width': 915, 'height': 412},
    'Google Pixel 7 Pro': {'width': 915, 'height': 412},
    'Google Pixel 6 Pro': {'width': 915, 'height': 412},
    'OnePlus 10 Pro': {'width': 915, 'height': 412},
  };

  // Super comprehensive mobile detection
  static bool isMobileDevice(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Check if device dimensions match known iPhone or Android models
    bool matchesKnownDimensions = false;

    // Check iPhone dimensions
    IPHONE_DIMENSIONS.forEach((model, dimensions) {
      // Check in both landscape and portrait orientations with some wiggle room (±2px)
      if ((width >= dimensions['width']! - 2 &&
              width <= dimensions['width']! + 2 &&
              height >= dimensions['height']! - 2 &&
              height <= dimensions['height']! + 2) ||
          (height >= dimensions['width']! - 2 &&
              height <= dimensions['width']! + 2 &&
              width >= dimensions['height']! - 2 &&
              width <= dimensions['height']! + 2)) {
        matchesKnownDimensions = true;
      }
    });

    // Check Android dimensions
    ANDROID_DIMENSIONS.forEach((model, dimensions) {
      // Check in both landscape and portrait orientations with some wiggle room (±2px)
      if ((width >= dimensions['width']! - 2 &&
              width <= dimensions['width']! + 2 &&
              height >= dimensions['height']! - 2 &&
              height <= dimensions['height']! + 2) ||
          (height >= dimensions['width']! - 2 &&
              height <= dimensions['width']! + 2 &&
              width >= dimensions['height']! - 2 &&
              width <= dimensions['height']! + 2)) {
        matchesKnownDimensions = true;
      }
    });

    // Check if screen width is below our higher mobile threshold
    final isMobileWidth = width < MOBILE_BREAKPOINT;

    // Check diagonal size (phones typically < 7 inches)
    final diagonal = _calculateDiagonalInches(context);
    final isPhoneByDiagonal = diagonal < 7.0;

    // On web, also check user agent for mobile indicators
    if (kIsWeb) {
      try {
        final userAgent = html.window.navigator.userAgent.toLowerCase();
        final isMobileUserAgent = userAgent.contains('mobi') ||
            userAgent.contains('android') ||
            userAgent.contains('iphone') ||
            userAgent.contains('ipod') ||
            userAgent.contains('silk') ||
            userAgent.contains('iemobile') ||
            userAgent.contains('blackberry') ||
            userAgent.contains('samsung') ||
            userAgent.contains('nokia') ||
            userAgent.contains('lg') ||
            userAgent.contains('htc') ||
            userAgent.contains('pixel');

        return isMobileWidth ||
            isMobileUserAgent ||
            matchesKnownDimensions ||
            isPhoneByDiagonal;
      } catch (e) {
        // If user agent check fails, fall back to dimension check
        return isMobileWidth || matchesKnownDimensions || isPhoneByDiagonal;
      }
    }

    // On native platforms, use Platform
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        return true;
      }
    } catch (e) {
      // Platform detection failed, fall back to screen size
    }

    return isMobileWidth || matchesKnownDimensions || isPhoneByDiagonal;
  }

  // Ultra-sensitive detection for iPhone Pro Max models
  static bool isIphoneProMax(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Pro Max dimensions with generous wiggle room (±8px)
    final proMaxModels = [
      IPHONE_DIMENSIONS['iPhone 15 Pro Max']!,
      IPHONE_DIMENSIONS['iPhone 14 Pro Max']!,
      IPHONE_DIMENSIONS['iPhone 13 Pro Max']!,
      IPHONE_DIMENSIONS['iPhone 12 Pro Max']!,
    ];

    // Check if dimensions match any Pro Max model (in landscape or portrait)
    for (var dimensions in proMaxModels) {
      if ((width >= dimensions['width']! - 8 &&
              width <= dimensions['width']! + 8 &&
              height >= dimensions['height']! - 8 &&
              height <= dimensions['height']! + 8) ||
          (height >= dimensions['width']! - 8 &&
              height <= dimensions['width']! + 8 &&
              width >= dimensions['height']! - 8 &&
              width <= dimensions['height']! + 8)) {
        return true;
      }
    }

    // Also detect by generic size range for Pro Max models (helps with browser inconsistencies)
    bool matchesProMaxDimensions =
        (width >= 920 && width <= 940 && height >= 420 && height <= 440) ||
            (height >= 920 && height <= 940 && width >= 420 && width <= 440);

    // Also check for user agent if on web
    if (kIsWeb) {
      try {
        final userAgent = html.window.navigator.userAgent.toLowerCase();
        // Additional check: if user agent contains iPhone AND screen size is large
        if (userAgent.contains('iphone') &&
            ((width > 800) ||
                (height > 800) ||
                (width >= 400 && height >= 800) ||
                (height >= 400 && width >= 800))) {
          return true;
        }
      } catch (e) {
        // User agent check failed
      }
    }

    return matchesProMaxDimensions;
  }

  // Detect large Android flagship phones
  static bool isLargeAndroid(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Latest flagship Android dimensions
    final flagshipModels = ANDROID_DIMENSIONS.values.toList();

    // Check if dimensions match any flagship model
    for (var dimensions in flagshipModels) {
      if ((width >= dimensions['width']! - 8 &&
              width <= dimensions['width']! + 8 &&
              height >= dimensions['height']! - 8 &&
              height <= dimensions['height']! + 8) ||
          (height >= dimensions['width']! - 8 &&
              height <= dimensions['width']! + 8 &&
              width >= dimensions['height']! - 8 &&
              width <= dimensions['height']! + 8)) {
        return true;
      }
    }

    // Also check for user agent if on web
    if (kIsWeb) {
      try {
        final userAgent = html.window.navigator.userAgent.toLowerCase();
        // Check if Android and screen size is large
        if (userAgent.contains('android') &&
            ((width > 800) ||
                (height > 800) ||
                (width >= 400 && height >= 800) ||
                (height >= 400 && width >= 800))) {
          return true;
        }
      } catch (e) {
        // User agent check failed
      }
    }

    return false;
  }

  // Check if device is a tablet
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final diagonalInches = _calculateDiagonalInches(context);

    // Tablets typically have diagonal > 7 inches and < 13 inches
    final bool isTabletSize = diagonalInches > 7 && diagonalInches < 13;

    // Check if iPad specifically (if on web)
    if (kIsWeb) {
      try {
        final userAgent = html.window.navigator.userAgent.toLowerCase();
        if (userAgent.contains('ipad')) {
          return true;
        }
      } catch (e) {
        // User agent check failed
      }
    }

    // Or check based on size - anything larger than mobile threshold but smaller than desktop
    return (width >= MOBILE_BREAKPOINT && width < 1200) || isTabletSize;
  }

  // Calculate approximate diagonal size in inches
  static double _calculateDiagonalInches(BuildContext context) {
    final data = MediaQuery.of(context);
    final size = data.size;
    final width = size.width;
    final height = size.height;
    final pixelRatio = data.devicePixelRatio;

    // Convert logical pixels to physical pixels
    final physicalWidth = width * pixelRatio;
    final physicalHeight = height * pixelRatio;

    // Calculate diagonal in pixels using Pythagorean theorem
    final diagonalPixels = _pythagoras(physicalWidth, physicalHeight);

    // Convert to inches (assuming 160 PPI as a very rough estimate)
    // This is not perfectly accurate but gives an approximation
    return diagonalPixels / 160;
  }

  // Helper for Pythagorean theorem calculation
  static double _pythagoras(double a, double b) {
    return sqrt(a * a + b * b);
  }

  // Simple square root implementation
  static double sqrt(double x) {
    if (x < 0) return 0;
    double z = x;
    double prev = 0;
    while (z != prev) {
      prev = z;
      z = (z + x / z) / 2;
    }
    return z;
  }

  // Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.height > size.width;
  }

  // Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  // Get appropriate padding based on device type
  static EdgeInsets getDevicePadding(BuildContext context) {
    if (isMobileDevice(context)) {
      return const EdgeInsets.all(8.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(12.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  // Debug method to help determine device characteristics
  static String getDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final diagonal = _calculateDiagonalInches(context);

    String userAgentInfo = "User agent not available";
    if (kIsWeb) {
      try {
        userAgentInfo = html.window.navigator.userAgent;
      } catch (e) {
        userAgentInfo = "Error getting user agent: $e";
      }
    }

    return """
    Width: ${size.width.toStringAsFixed(2)}
    Height: ${size.height.toStringAsFixed(2)}
    Pixel Ratio: ${pixelRatio.toStringAsFixed(2)}
    Estimated Diagonal: ${diagonal.toStringAsFixed(2)} inches
    Is Mobile: ${isMobileDevice(context)}
    Is iPhone Pro Max: ${isIphoneProMax(context)}
    Is Large Android: ${isLargeAndroid(context)}
    Is Tablet: ${isTablet(context)}
    Is Portrait: ${isPortrait(context)}
    Is Landscape: ${isLandscape(context)}
    User Agent: $userAgentInfo
    """;
  }
}
