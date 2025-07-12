import 'package:flutter/material.dart';
import 'utils/wireframe_color_manager.dart';

/// Shared layout constants and wireframe theme colors for the wireframe theme
/// Centralizes all layout dimensions, breakpoints, and color definitions
/// Now uses WireframeColorManager for all colors
class WireframeLayoutConstants {
  WireframeLayoutConstants._(); // Private constructor to prevent instantiation

  // ===== LAYOUT DIMENSIONS =====

  // Container constraints
  static const double maxContainerWidth = 1400.0;
  static const double minContainerWidth = 1200.0;
  static const double desktopBreakpoint = 1200.0;

  // NEW: Modern desktop mockup dimensions (more squat/rectangular)
  static const double desktopMockupAspectRatio = 16.0 / 9.0; // Modern monitor ratio
  static const double desktopMockupWidth = 800.0; // Wider
  static const double desktopMockupHeight = 450.0; // More squat (800/450 = 16:9)

  // Mobile mockup dimensions - iPhone frame container
    static const double iPhoneFrameWidth = 320.0; // Larger to accommodate iPhone shell
    static const double iPhoneFrameHeight = 635.0; // Larger to accommodate iPhone shell
    static const double mobileFrameRadius = 25.0;

  // Content area within iPhone frame
    static const double mobileContentWidth = 380.0; // Your original content size
    static const double mobileContentHeight = 600.0; // Your original content size

  // iPhone frame positioning offsets
    static const double iPhoneContentTop = 20.0; // Space from top of iPhone to content
    static const double iPhoneContentLeft = 20.0; // Space from left of iPhone to content
    static const double iPhoneContentRight = 20.0; // Space from right of iPhone to content
    static const double iPhoneContentBottom = 20.0; // Space from bottom of iPhone to content;

  // Fixed iPhone frame positioning
  static const double iPhoneScreenTop = 45.0;
  static const double iPhoneScreenLeft = 15.0;
  static const double iPhoneScreenRight = 15.0;
  static const double iPhoneScreenBottom = 85.0;
  static const double iPhoneContentRadius = 20.0;

  // Desktop mockup dimensions (updated for modern aspect ratio)
  static const double desktopSidebarWidth = 160.0; // Proportionally smaller
  static const double desktopRightSidebarWidthNormal = 160.0;
  static const double desktopRightSidebarWidthCompact = 80.0;

  // Navigation dimensions
  static const double curvedNavHeight = 50.0;
  static const double mobileNavHeight = 40.0;
  static const double desktopNavHeight = 50.0;

  // Header dimensions (updated for squat layout)
  static const double mobileHeaderHeight = 140.0;
  static const double desktopHeaderHeight =120.0; // Shorter header for squat layout
  static const double browserChromeHeight = 40.0; // Shorter chrome for squat layout

  // Avatar dimensions
  static const double mobileAvatarSize = 60.0;
  static const double desktopAvatarSize = 80.0;
  static const double smallAvatarSize = 32.0;
  static const double mediumAvatarSize = 40.0;

  // Card dimensions
  static const double mobileCardImageHeight = 120.0;
  static const double desktopCardImageHeight = 160.0;
  static const double cardBorderRadius = 8.0;

  // Animation boundary constraints
  static const double maxDrawerSlideRatio = 0.8; // 60% of container width
  static const double maxModalHeightRatio = 0.8; // 80% of container height
  static const double maxOverlayWidthRatio = 0.9; // 90% of container width

  // ===== MISSING DIMENSIONS =====

  // Drawer dimensions
  static const double drawerWidth = 260.0;

  // Modal dimensions
  static const double mobileModalHeight = 400.0;

  // ===== SPACING SYSTEM =====

  static const double spacingTiny = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingStandard = 16.0;
  static const double spacingLarge = 20.0;
  static const double spacingXLarge = 24.0;
  static const double spacingXXLarge = 32.0;

  // ===== BORDER RADIUS SYSTEM =====

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  // ===== FONT SIZES =====

  // Mobile font sizes
  static const double mobileFontSizeCaption = 14.0;
  static const double mobileFontSizeBody = 12.0;
  static const double mobileFontSizeBodyLarge = 14.0;
  static const double mobileFontSizeTitle = 16.0;
  static const double mobileFontSizeLargeTitle = 18.0;

  // Desktop font sizes
  static const double desktopFontSizeCaption = 12.0;
  static const double desktopFontSizeBody = 14.0;
  static const double desktopFontSizeBodyLarge = 16.0;
  static const double desktopFontSizeTitle = 18.0;
  static const double desktopFontSizeLargeTitle = 24.0;

  // ===== MISSING FONT SIZE ACCESSOR =====
  static double get fontSizeCaption => mobileFontSizeCaption;

  // ===== SHADOW SYSTEM =====

  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x0D000000), // 5% opacity
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1A000000), // 10% opacity
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x26000000), // 15% opacity
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // ===== MISSING SHADOW ACCESSORS =====
  static List<BoxShadow> get shadowLight => shadowSmall;

  // ===== ANIMATION CONSTANTS =====

  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  static const Curve animationCurveStandard = Curves.easeInOut;

  // ===== COLOR ACCESSORS (Using WireframeColorManager) =====

  // Background colors
  static Color get wireframeBg => WireframeColorManager.colors.background;
  static Color get wireframeWhite => WireframeColorManager.colors.surface;
  static Color get wireframeLightGray => WireframeColorManager.colors.surfaceVariant;

  // Primary colors
  static Color get wireframeAccent => WireframeColorManager.colors.primary;
  static Color get wireframeSecondary => WireframeColorManager.colors.secondary;

  // Text colors
  static Color get wireframeText => WireframeColorManager.colors.text;
  static Color get wireframeTextSecondary => WireframeColorManager.colors.textSecondary;

  // Border colors
  static Color get wireframeBorder => WireframeColorManager.colors.border;
  static Color get wireframeOutline => WireframeColorManager.colors.outline;

  // Status colors
  static Color get wireframeSuccess => WireframeColorManager.colors.success;
  static Color get wireframeWarning => WireframeColorManager.colors.warning;
  static Color get wireframeDanger => WireframeColorManager.colors.error;
  static Color get wireframeInfo => WireframeColorManager.colors.info;

  // Interactive colors
  static Color get wireframeHover => WireframeColorManager.colors.hover;
  static Color get wireframePressed => WireframeColorManager.colors.pressed;
  static Color get wireframeFocused => WireframeColorManager.colors.focused;
  static Color get wireframeDisabled => WireframeColorManager.colors.disabled;

  // Project colors
  static Color get tapInColor => WireframeColorManager.colors.tapInColor;
  static Color get momentsColor => WireframeColorManager.colors.momentsColor;
  static Color get coreAiColor => WireframeColorManager.colors.coreAiColor;
  static Color get plannieColor => WireframeColorManager.colors.plannieColor;

  // Browser chrome colors
  static Color get browserChromeBackground =>
      WireframeColorManager.colors.browserChromeBackground;
  static Color get browserChromeRed =>
      WireframeColorManager.colors.browserChromeRed;
  static Color get browserChromeYellow =>
      WireframeColorManager.colors.browserChromeYellow;
  static Color get browserChromeGreen =>
      WireframeColorManager.colors.browserChromeGreen;

  // ===== MISSING COLOR ACCESSORS =====

  static Color get wireframeBlack => const Color(0xFF000000);
  static Color get wireframeOrange => WireframeColorManager.colors.warning;
  static Color get linkedInBlue => const Color(0xFF0077B5);

  // ===== MISSING BUTTON STYLE METHODS =====

  /// Gets primary button style for wireframe theme
  static ButtonStyle getPrimaryButtonStyle({bool isMobile = false}) {
    return TextButton.styleFrom(
      backgroundColor: wireframeAccent,
      foregroundColor: wireframeWhite,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? spacingMedium : spacingStandard,
        vertical: isMobile ? spacingSmall : spacingMedium,
      ),
      minimumSize: Size(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
      ),
    );
  }

  /// Gets secondary button style for wireframe theme
  static ButtonStyle getSecondaryButtonStyle({bool isMobile = false}) {
    return TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: wireframeSecondary,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? spacingMedium : spacingStandard,
        vertical: isMobile ? spacingSmall : spacingMedium,
      ),
      minimumSize: Size(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        side: BorderSide(color: wireframeBorder),
      ),
    );
  }

  // ===== RESPONSIVE BREAKPOINTS =====

  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopSmallBreakpoint = 1200.0;
  static const double desktopLargeBreakpoint = 1600.0;

  // ===== ANIMATION DURATIONS =====

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ===== UTILITY METHODS =====

  /// Get spacing value by name
  static double getSpacing(String spacingName) {
    switch (spacingName.toLowerCase()) {
      case 'tiny':
        return spacingTiny;
      case 'small':
        return spacingSmall;
      case 'medium':
        return spacingMedium;
      case 'standard':
        return spacingStandard;
      case 'large':
        return spacingLarge;
      case 'xlarge':
        return spacingXLarge;
      case 'xxlarge':
        return spacingXXLarge;
      default:
        return spacingStandard;
    }
  }

  /// Get radius value by name
  static double getRadius(String radiusName) {
    switch (radiusName.toLowerCase()) {
      case 'small':
        return radiusSmall;
      case 'medium':
        return radiusMedium;
      case 'large':
        return radiusLarge;
      case 'xlarge':
        return radiusXLarge;
      default:
        return radiusMedium;
    }
  }

  /// Get responsive font size based on device type
  static double getResponsiveFontSize(String sizeType, bool isMobile) {
    switch (sizeType.toLowerCase()) {
      case 'caption':
        return isMobile ? mobileFontSizeCaption : desktopFontSizeCaption;
      case 'body':
        return isMobile ? mobileFontSizeBody : desktopFontSizeBody;
      case 'bodylarge':
        return isMobile ? mobileFontSizeBodyLarge : desktopFontSizeBodyLarge;
      case 'title':
        return isMobile ? mobileFontSizeTitle : desktopFontSizeTitle;
      case 'largetitle':
        return isMobile ? mobileFontSizeLargeTitle : desktopFontSizeLargeTitle;
      default:
        return isMobile ? mobileFontSizeBody : desktopFontSizeBody;
    }
  }

  /// Check if screen width is mobile
  static bool isMobile(double screenWidth) {
    return screenWidth < mobileBreakpoint;
  }

  /// Check if screen width is tablet
  static bool isTablet(double screenWidth) {
    return screenWidth >= mobileBreakpoint && screenWidth < desktopBreakpoint;
  }

  /// Check if screen width is desktop
  static bool isDesktop(double screenWidth) {
    return screenWidth >= desktopBreakpoint;
  }

  /// Get current device type based on screen width
  static String getDeviceType(double screenWidth) {
    if (isMobile(screenWidth)) return 'mobile';
    if (isTablet(screenWidth)) return 'tablet';
    return 'desktop';
  }

  /// Get appropriate avatar size for device
  static double getAvatarSize(String deviceType) {
    switch (deviceType) {
      case 'mobile':
        return mobileAvatarSize;
      case 'tablet':
        return desktopAvatarSize * 0.8;
      case 'desktop':
      default:
        return desktopAvatarSize;
    }
  }

  /// Get appropriate header height for device
  static double getHeaderHeight(String deviceType) {
    switch (deviceType) {
      case 'mobile':
        return mobileHeaderHeight;
      case 'tablet':
        return desktopHeaderHeight * 0.9;
      case 'desktop':
      default:
        return desktopHeaderHeight;
    }
  }
}
