import 'package:flutter/material.dart';

/// Centralized color management system for wireframe theme
/// Controls all colors and provides multiple theme options
class WireframeColorManager {
  WireframeColorManager._();

  // Available theme names
  static const String defaultTheme = 'default';
  static const String darkTheme = 'dark';
  static const String corporateTheme = 'corporate';
  static const String creativeTheme = 'creative';
  static const String accessibilityTheme = 'accessibility';
  static const String athleteLightTheme = 'athlete_light';
  static const String athleteDarkTheme = 'athlete_dark';
  static const String ninjaLightTheme = 'ninja_light';
  static const String ninjaDarkTheme = 'ninja_dark';

  // Current active theme (can be changed dynamically)
  static String _currentTheme = defaultTheme;

  /// Get the current active theme name
  static String get currentTheme => _currentTheme;

  /// Set the active theme
  static void setTheme(String themeName) {
    if (_colorThemes.containsKey(themeName)) {
      _currentTheme = themeName;
    }
  }

  // Theme mode management
  static bool _isDarkMode = false;

  /// Get current theme mode
  static bool get isDarkMode => _isDarkMode;

  /// Toggle between light and dark mode
  static void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    // Update current theme based on mode
    if (_isDarkMode) {
      if (_currentTheme == defaultTheme) {
        _currentTheme = darkTheme;
      } else if (_currentTheme == athleteLightTheme) {
        _currentTheme = athleteDarkTheme;
      } else if (_currentTheme == ninjaLightTheme) {
        _currentTheme = ninjaDarkTheme;
      }
    } else {
      if (_currentTheme == darkTheme) {
        _currentTheme = defaultTheme;
      } else if (_currentTheme == athleteDarkTheme) {
        _currentTheme = athleteLightTheme;
      } else if (_currentTheme == ninjaDarkTheme) {
        _currentTheme = ninjaLightTheme;
      }
    }
  }

  /// Set dark mode explicitly
  static void setDarkMode(bool darkMode) {
    _isDarkMode = darkMode;
    // Update current theme based on mode
    if (_isDarkMode) {
      if (_currentTheme == defaultTheme) {
        _currentTheme = darkTheme;
      } else if (_currentTheme == athleteLightTheme) {
        _currentTheme = athleteDarkTheme;
      } else if (_currentTheme == ninjaLightTheme) {
        _currentTheme = ninjaDarkTheme;
      }
    } else {
      if (_currentTheme == darkTheme) {
        _currentTheme = defaultTheme;
      } else if (_currentTheme == athleteDarkTheme) {
        _currentTheme = athleteLightTheme;
      } else if (_currentTheme == ninjaDarkTheme) {
        _currentTheme = ninjaLightTheme;
      }
    }
  }

  /// Get the appropriate theme based on current mode
  static String getThemeForMode(String baseTheme) {
    if (_isDarkMode && baseTheme == defaultTheme) {
      return darkTheme;
    } else if (!_isDarkMode && baseTheme == darkTheme) {
      return defaultTheme;
    } else if (_isDarkMode && baseTheme == athleteLightTheme) {
      return athleteDarkTheme;
    } else if (!_isDarkMode && baseTheme == athleteDarkTheme) {
      return athleteLightTheme;
    } else if (_isDarkMode && baseTheme == ninjaLightTheme) {
      return ninjaDarkTheme;
    } else if (!_isDarkMode && baseTheme == ninjaDarkTheme) {
      return ninjaLightTheme;
    }
    return baseTheme;
  }

  /// Get all available theme names
  static List<String> get availableThemes => _colorThemes.keys.toList();

  /// Get available base themes (without light/dark variants)
  static List<String> get availableBaseThemes =>
      ['default', 'corporate', 'creative', 'accessibility', 'athlete', 'ninja'];

  // Master color schemes for all themes
  static const Map<String, WireframeColorScheme> _colorThemes = {
    defaultTheme: WireframeColorScheme(

      // background colors

      background: Color(0xFF233d4d), //
      surface: Color(0xFF233d4d), //  main color of app also needs to be same as OnPrimary
      surfaceVariant: Color(0xFF233d4d), //

      // Primary colors - Teal as shown in style guide
      primary: Color(0xFFD8FA69), //  affects selected nav icons and selected headers on top (and titles for mobile)
      onPrimary: Color( 0xFF233d4d), // onprimary and surface ought to be the same for total color coordination
      secondary: Color(0xFFf5BC74), // affects unselected upper nav titles
      onSecondary: Color(0xFFF3F3F2), // affects "open for opportunities"

      // Text colors
      text: Color(0xFFCAD0D3), // Main text
      textSecondary: Color(0xFFf5BC74), // affects unselected nav icons
      textOnSurface: Color(0xFF2C2C2C),

      // Border and outline colors
      border: Color( 0xFFF4A15D), // affects Jeff Anderson line dividing mobile/desktop and line beneath home/projects/about header
      outline: Color(0xFF3C3836),

      // Status colors
      success: Color(0xFF28A745),
      warning: Color(0xFFFFBD2E), // 
      error: Color(0xFFDC3545),
      info: Color(0xFF6A8F8A), // affects lower likes/comments/reposts etc icons

      // Interactive colors
      hover: Color(0xFFF8F8F8),
      pressed: Color(0xFFE5E5E5),
      focused: Color(0xFFF4A15D), // affects names in posts
      disabled: Color(0xFF818488), // affects timestamps

      // Project-specific colors
      tapInColor: Color(0xFF28A745),
      momentsColor: Color(0xFF148D80),
      coreAiColor: Color(0xFF6F42C1),
      plannieColor: Color(0xFFDC3545),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFE5E5E5),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    // ATHLETE LIGHT THEME
    athleteLightTheme: WireframeColorScheme(

      background: Color(0xFFFFF4E3), // 
      surface: Color(0xFFFFF4E3), //  main color of app also needs to be same as OnPrimary
      surfaceVariant: Color(0xFFFFF4E3), // 

      // Primary colors - Teal as shown in style guide
      primary: Color(0xFFCB3920), //  affects nav icons and headers  (and titles for mobile)
      onPrimary: Color( 0xFFFFF4E3), // onprimary and surface ought to be the same for total color coordination
      secondary: Color(0xFF881593), // affects 
      onSecondary: Color(0xFF3E6E9D),

      // Text colors
      text: Color(0xFF3C3836), // Dark charcoal text
      textSecondary: Color(0xFF881593),  // affects nav titles
      textOnSurface: Color(0xFF2C2C2C),

      // Border and outline colors
      border: Color(0xFF3E6E9D), // affects Jeff Anderson line dividing mobile/desktop and line beneath home/projects/about header
      outline: Color(0xFFE5E5E5),

      // Status colors
      success: Color(0xFF28A745),
      warning: Color(0xFFFFBD2E), // 
      error: Color(0xFFDC3545),
      info: Color(0xFF9E6450), // affects lower likes/comments/reposts etc icons

      // Interactive colors
      hover: Color(0xFFF8F8F8),
      pressed: Color(0xFFE5E5E5),
      focused: Color(0xFF148D80), // affects names in posts
      disabled: Color(0xFF818488),  // affects timestamps

      // Project-specific colors
      tapInColor: Color(0xFF28A745),
      momentsColor: Color(0xFF148D80),
      coreAiColor: Color(0xFF6F42C1),
      plannieColor: Color(0xFFDC3545),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFE5E5E5),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    // ATHLETE DARK THEME
    athleteDarkTheme: WireframeColorScheme(
      background: Color(0xFF373737), // 
      surface: Color(0xFF373737), // 
      surfaceVariant: Color(0xFF373737), // 

      // Primary colors - Lime green accent
      primary: Color(0xFFFE8019), // 
      onPrimary: Color(0xFF373737),
      secondary: Color(0xFF6A8F8A), // 
      onSecondary: Color(0xFF30bac4),

      // Text colors
      text: Color(0xFFFFFFFF), // 
      textSecondary: Color(0xFFCBD5E1),
      textOnSurface: Color(0xFFFFFFFF),

      // Border and outline colors
      border: Color(0xFF30bac4),
      outline: Color(0xFF64748B),

      // Status colors
      success: Color(0xFF10B981),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFF87171),
      info: Color(0xFFD8FA69),

      // Interactive colors
      hover: Color(0xFF374151),
      pressed: Color(0xFF1F2937),
      focused: Color(0xFFD8BD2F),
      disabled: Color(0xFFD6D5D1),

      // Project-specific colors
      tapInColor: Color(0xFF10B981),
      momentsColor: Color(0xFF3B82F6),
      coreAiColor: Color(0xFF8B5CF6),
      plannieColor: Color(0xFFF87171),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFF374151),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    // NINJA LIGHT THEME
    ninjaLightTheme: WireframeColorScheme(
      // background colors

      background: Color(0xFFF8F8F8), //
      surface: Color( 0xFFF8F8F8), //  main color of app also needs to be same as OnPrimary
      surfaceVariant: Color(0xFFF8F8F8), //

      // Primary colors - Teal as shown in style guide
      primary: Color(0xFF046252), //  affects nav icons and headers  (and titles for mobile)
      onPrimary: Color(0xFFF8F8F8), // onprimary and surface ought to be the same for total color coordination
      secondary: Color(0xFFC74600), // affects
      onSecondary: Color(0xFF36490E), // affects "open for opportunities"

      // Text colors
      text: Color(0xFF3C3836), // Dark charcoal text
      textSecondary: Color(0xFFC74600), // affects nav titles
      textOnSurface: Color(0xFF2C2C2C),

      // Border and outline colors
      border: Color(0xFF36490E), // affects line dividing mobile/desktop and line beneath home/projects/about header
      outline: Color(0xFFE5E5E5),

      // Status colors
      success: Color(0xFF28A745),
      warning: Color(0xFFFFBD2E), // Mustard yellow
      error: Color(0xFFDC3545),
      info: Color(0xFF36490E), // affects lower likes/comments/reposts etc icons

      // Interactive colors
      hover: Color(0xFFF8F8F8),
      pressed: Color(0xFFE5E5E5),
      focused: Color(0xFF931535), // affects names in posts and "Jeff Anderson"
      disabled: Color(0xFF818488), // affects timestamps

      // Project-specific colors
      tapInColor: Color(0xFF28A745),
      momentsColor: Color(0xFF148D80),
      coreAiColor: Color(0xFF6F42C1),
      plannieColor: Color(0xFFDC3545),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFE5E5E5),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    // NINJA DARK THEME
    ninjaDarkTheme: WireframeColorScheme(


      // background colors

      background: Color(0xFF233d4d), //
      surface: Color(0xFF233d4d), //  main color of app also needs to be same as OnPrimary
      surfaceVariant: Color(0xFF233d4d), //

      // Primary colors - Teal as shown in style guide
      primary: Color( 0xFFD8FA69), //  affects selected nav icons and selected headers on top (and titles for mobile)
      onPrimary: Color( 0xFF233d4d), // onprimary and surface ought to be the same for total color coordination
      secondary: Color(0xFFf5BC74), // affects unselected upper nav titles
      onSecondary: Color(0xFFF3F3F2), // affects "open for opportunities"

      // Text colors
      text: Color(0xFFCAD0D3), // Main text
      textSecondary: Color(0xFFf5BC74), // affects unselected nav icons
      textOnSurface: Color(0xFF2C2C2C),

      // Border and outline colors
      border: Color(0xFFf5BC74), // affects Jeff Anderson line dividing mobile/desktop and line beneath home/projects/about header
      outline: Color(0xFF3C3836),

      // Status colors
      success: Color(0xFF28A745),
      warning: Color(0xFFFFBD2E), //
      error: Color(0xFFDC3545),
      info: Color(0xFF6A8F8A), // affects lower likes/comments/reposts etc icons

      // Interactive colors
      hover: Color(0xFFF8F8F8),
      pressed: Color(0xFFE5E5E5),
      focused: Color(0xFFF4A15D), // affects names in posts
      disabled: Color(0xFF818488), // affects timestamps

      // Project-specific colors
      tapInColor: Color(0xFF28A745),
      momentsColor: Color(0xFF148D80),
      coreAiColor: Color(0xFF6F42C1),
      plannieColor: Color(0xFFDC3545),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFE5E5E5),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    corporateTheme: WireframeColorScheme(
      // Background colors
      background: Color(0xFFF8FAFC),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFEDF2F7),

      // Primary colors (Professional Blue)
      primary: Color(0xFF2B6CB0),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF4A5568),
      onSecondary: Color(0xFFFFFFFF),

      // Text colors
      text: Color(0xFF2D3748),
      textSecondary: Color(0xFF4A5568),
      textOnSurface: Color(0xFF1A202C),

      // Border and outline colors
      border: Color(0xFFCBD5E0),
      outline: Color(0xFFE2E8F0),

      // Status colors (Corporate appropriate)
      success: Color(0xFF38A169),
      warning: Color(0xFFD69E2E),
      error: Color(0xFFE53E3E),
      info: Color(0xFF3182CE),

      // Interactive colors
      hover: Color(0xFFEBF8FF),
      pressed: Color(0xFFBEE3F8),
      focused: Color(0xFF2B6CB0),
      disabled: Color(0xFFF7FAFC),

      // Project-specific colors (Professional palette)
      tapInColor: Color(0xFF38A169),
      momentsColor: Color(0xFF3182CE),
      coreAiColor: Color(0xFF553C9A),
      plannieColor: Color(0xFFD53F8C),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFEDF2F7),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    creativeTheme: WireframeColorScheme(
      // Background colors (Vibrant and creative)
      background: Color(0xFFFFF7ED),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFFEF3C7),

      // Primary colors (Creative Orange)
      primary: Color(0xFFEA580C),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF7C2D12),
      onSecondary: Color(0xFFFFFFFF),

      // Text colors
      text: Color(0xFF431407),
      textSecondary: Color(0xFF92400E),
      textOnSurface: Color(0xFF1C1917),

      // Border and outline colors
      border: Color(0xFFFED7AA),
      outline: Color(0xFFFFEDD5),

      // Status colors (Creative palette)
      success: Color(0xFF059669),
      warning: Color(0xFFD97706),
      error: Color(0xFFDC2626),
      info: Color(0xFF0284C7),

      // Interactive colors
      hover: Color(0xFFFFF7ED),
      pressed: Color(0xFFFFEDD5),
      focused: Color(0xFFEA580C),
      disabled: Color(0xFFFEF3C7),

      // Project-specific colors (Creative variations)
      tapInColor: Color(0xFF10B981),
      momentsColor: Color(0xFF3B82F6),
      coreAiColor: Color(0xFF8B5CF6),
      plannieColor: Color(0xFFEC4899),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFFEF3C7),
      browserChromeRed: Color(0xFFFF5F57),
      browserChromeYellow: Color(0xFFFFBD2E),
      browserChromeGreen: Color(0xFF28CA42),
    ),

    accessibilityTheme: WireframeColorScheme(
      // Background colors (High contrast)
      background: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFF0F0F0),

      // Primary colors (High contrast blue)
      primary: Color(0xFF0000FF),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF000000),
      onSecondary: Color(0xFFFFFFFF),

      // Text colors (Maximum contrast)
      text: Color(0xFF000000),
      textSecondary: Color(0xFF333333),
      textOnSurface: Color(0xFF000000),

      // Border and outline colors (Strong borders)
      border: Color(0xFF000000),
      outline: Color(0xFF333333),

      // Status colors (High contrast)
      success: Color(0xFF006600),
      warning: Color(0xFFFF6600),
      error: Color(0xFFCC0000),
      info: Color(0xFF0066CC),

      // Interactive colors
      hover: Color(0xFFE6E6E6),
      pressed: Color(0xFFCCCCCC),
      focused: Color(0xFF0000FF),
      disabled: Color(0xFFCCCCCC),

      // Project-specific colors (High contrast)
      tapInColor: Color(0xFF006600),
      momentsColor: Color(0xFF0066CC),
      coreAiColor: Color(0xFF6600CC),
      plannieColor: Color(0xFFCC0000),

      // Chrome/browser colors
      browserChromeBackground: Color(0xFFE6E6E6),
      browserChromeRed: Color(0xFFCC0000),
      browserChromeYellow: Color(0xFFFFCC00),
      browserChromeGreen: Color(0xFF00CC00),
    ),
  };

  /// Get the active color scheme
  static WireframeColorScheme get colors {
    return _colorThemes[_currentTheme] ?? _colorThemes[defaultTheme]!;
  }

  /// Utility methods for color management
  static Color getStatusColor(WireframeStatus status) {
    switch (status) {
      case WireframeStatus.success:
        return colors.success;
      case WireframeStatus.warning:
        return colors.warning;
      case WireframeStatus.error:
        return colors.error;
      case WireframeStatus.info:
        return colors.info;
      case WireframeStatus.neutral:
        return colors.secondary;
    }
  }

  static Color getInteractionColor(WireframeInteraction interaction) {
    switch (interaction) {
      case WireframeInteraction.hover:
        return colors.hover;
      case WireframeInteraction.pressed:
        return colors.pressed;
      case WireframeInteraction.focused:
        return colors.focused;
      case WireframeInteraction.disabled:
        return colors.disabled;
      case WireframeInteraction.selected:
        return colors.primary;
    }
  }

  static Color getProjectColor(String projectId) {
    switch (projectId) {
      case 'tap-in':
        return colors.tapInColor;
      case 'moments':
        return colors.momentsColor;
      case 'core-ai':
        return colors.coreAiColor;
      case 'plannie':
        return colors.plannieColor;
      default:
        return colors.primary;
    }
  }

  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  static ColorScheme toFlutterColorScheme() {
    return ColorScheme(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      error: colors.error,
      onError: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.text,
      background: colors.background,
      onBackground: colors.text,
    );
  }
}

/// Color scheme data class for wireframe theme
class WireframeColorScheme {
  // Background colors
  final Color background;
  final Color surface;
  final Color surfaceVariant;

  // Primary colors
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;

  // Text colors
  final Color text;
  final Color textSecondary;
  final Color textOnSurface;

  // Border and outline colors
  final Color border;
  final Color outline;

  // Status colors
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Interactive colors
  final Color hover;
  final Color pressed;
  final Color focused;
  final Color disabled;

  // Project-specific colors
  final Color tapInColor;
  final Color momentsColor;
  final Color coreAiColor;
  final Color plannieColor;

  // Browser chrome colors
  final Color browserChromeBackground;
  final Color browserChromeRed;
  final Color browserChromeYellow;
  final Color browserChromeGreen;

  const WireframeColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.text,
    required this.textSecondary,
    required this.textOnSurface,
    required this.border,
    required this.outline,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.hover,
    required this.pressed,
    required this.focused,
    required this.disabled,
    required this.tapInColor,
    required this.momentsColor,
    required this.coreAiColor,
    required this.plannieColor,
    required this.browserChromeBackground,
    required this.browserChromeRed,
    required this.browserChromeYellow,
    required this.browserChromeGreen,
  });
}

/// Status types for color selection
enum WireframeStatus {
  success,
  warning,
  error,
  info,
  neutral,
}

/// Interaction states for color selection
enum WireframeInteraction {
  hover,
  pressed,
  focused,
  disabled,
  selected,
}
