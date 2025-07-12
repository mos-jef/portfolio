import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';

import '../utils/wireframe_color_manager.dart';

/// Custom icon widget that responds to theme changes
/// Supports PNG assets with color filtering and multi-tone effects
class ThemeResponsiveIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isCircular;
  final bool showShadow;
  final String? label;
  final bool isMobile;
  final IconColorMode colorMode;

  const ThemeResponsiveIcon({
    Key? key,
    required this.assetPath,
    required this.size,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.isCircular = true,
    this.showShadow = true,
    this.label,
    this.isMobile = false,
    this.colorMode = IconColorMode.iconOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(8),
          color: _getBackgroundColor(),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 0.5,
                    offset: Offset(-2, 6),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.00), //
          child: _buildIconContent(),
        ),
      ),
    );
  }

  Widget _buildIconContent() {
    switch (colorMode) {
      case IconColorMode.iconOnly:
        return _buildColoredIcon();
      case IconColorMode.backgroundOnly:
        return _buildWhiteIcon();
      case IconColorMode.both:
        return _buildColoredIcon();
    }
  }

  Widget _buildColoredIcon() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        iconColor ?? _getThemeIconColor(),
        BlendMode.srcIn,
      ),
      child: Image.asset(
        assetPath,
        width: size * 0.7,
        height: size * 0.7,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildWhiteIcon() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        assetPath,
        width: size * 0.7,
        height: size * 0.7,
        fit: BoxFit.contain,
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (colorMode) {
      case IconColorMode.iconOnly:
        return Colors.transparent; // No background when coloring icon
      case IconColorMode.backgroundOnly:
        return backgroundColor ?? _getThemeIconColor();
      case IconColorMode.both:
        return backgroundColor ?? _getThemeIconColor().withOpacity(0.1);
    }
  }

  Color _getThemeIconColor() {
    return iconColor ?? WireframeColorManager.colors.primary;
  }
}

/// Icon coloring modes
enum IconColorMode {
  iconOnly, // Color only the icon content, transparent background
  backgroundOnly, // Color only the background, white icon
  both, // Color both icon and background
}

/// Predefined icon configurations for your assets
class WireframeIconAssets {
  /// LinkedIn icon with theme-responsive colors
  static Widget linkedinIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.linkedbasicon,
          size: size,
          color: _getLinkedInColor(),
        ),
      ),
    );
  }

  /// Resume icon with theme-responsive colors
  static Widget resumeIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.resumebasicon,
          size: size,
          color: _getResumeColor(),
        ),
      ),
    );
  }

  /// Contact icon with theme-responsive colors
  static Widget contactIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.contactbasicon,
          size: size,
          color: _getContactColor(),
        ),
      ),
    );
  }

  /// Email icon with theme-responsive colors
  static Widget emailIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.emailbasicon,
          size: size,
          color: _getEmailColor(),
        ),
      ),
    );
  }

  /// Phone icon with theme-responsive colors
  static Widget phoneIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.phonebasicon,
          size: size,
          color: _getPhoneColor(),
        ),
      ),
    );
  }

  /// Computer icon with theme-responsive colors
  static Widget computerIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.computerbasicon,
          size: size,
          color: _getComputerColor(),
        ),
      ),
    );
  }

  /// Chart icon with theme-responsive colors
  static Widget chartIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.chartbasicon,
          size: size,
          color: _getChartColor(),
        ),
      ),
    );
  }

  /// Person icon with theme-responsive colors
  static Widget personIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.personbasicon,
          size: size,
          color: _getPersonColor(),
        ),
      ),
    );
  }

  /// Settings icon with theme-responsive colors
  static Widget settingsIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.settingsbasicon,
          size: size,
          color: _getSettingsColor(),
        ),
      ),
    );
  }

  /// House icon with theme-responsive colors
  static Widget houseIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.housebasicon,
          size: size,
          color: _getHouseColor(),
        ),
      ),
    );
  }

  /// House icon with theme-responsive colors
  static Widget commentIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.commentbasicon,
          size: size,
          color: _getCommentColor(),
        ),
      ),
    );
  }

  /// House icon with theme-responsive colors
  static Widget addIcon({
    required double size,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: SvgIcon(
          assetPath: SvgIconPaths.addbasicon,
          size: size,
          color: _getAddColor(),
        ),
      ),
    );
  }

  // Theme-responsive color methods
  static Color _getLinkedInColor() {
    // LinkedIn can stay its brand color or follow theme
    return WireframeIconTheme.getIconColor('linkedin');
  }

  static Color _getResumeColor() {
    // Resume color follows theme
    return WireframeIconTheme.getIconColor('resume');
  }

  static Color _getContactColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('contact');
  }

  static Color _getComputerColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('computer');
  }

  static Color _getPhoneColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('phone');
  }

  static Color _getEmailColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('email');
  }

  static Color _getSettingsColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('settings');
  }

  static Color _getPersonColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('person');
  }

  static Color _getChartColor() {
    // Contact color follows theme
    return WireframeIconTheme.getIconColor('chart');
  }

  static Color _getHouseColor() {
    // LinkedIn can stay its brand color or follow theme
    return WireframeIconTheme.getIconColor('house');
  }

  static Color _getAddColor() {
    // LinkedIn can stay its brand color or follow theme
    return WireframeIconTheme.getIconColor('add');
  }

  static Color _getCommentColor() {
    // LinkedIn can stay its brand color or follow theme
    return WireframeIconTheme.getIconColor('comment');
  }

}

/// Theme-aware color configuration
class WireframeIconTheme {
  /// Get icon colors based on current wireframe theme and mode
  static Map<String, Color> getIconColors() {
    final currentTheme = WireframeColorManager.currentTheme;

    switch (currentTheme) {
      // Default themes
      case 'default':
        return {
          'linkedin': Color(0xFF8FDBFB), // Some kind of blue that works
          'resume': Color(0xFFFF9A62), //  
          'contact': Color(0xFFF097A3), //
          'email': Color(0xFFFFDA62), //
          'computer': Color(0xFF5EC394), //
          'phone': Color(0xFFF5BC74), //
          'settings': Color(0xFFAAA997),
          'person': Color(0xFFD493EC),
          'chart': Color(0xFFFD6DA7),
          'house': Color(0xFFFD6DA7),
          'add': Color(0xFFFD6DA7),
          'comment': Color(0xFFFD6DA7),
        };
      case 'dark':
        return {
          'linkedin': Color(0xFF8FDBFB), // LinkedIn blue
          'resume': Color(0xFFFF9A62), // Dark theme primary
          'contact': Color(0xFFf5BC74), // Dark theme secondary
          'liked_shaka': Color(0xFFD8FA69), // Default lime green for liked
          'unliked_shaka': Color(0xFF8B8B8B), // Gray for unliked
          'add_message':
              Color(0xFFD8FA69), // Default lime green for add message
        };

      // Athlete themes
      case 'athlete_light':
        return {
          'linkedin': Color(0xFF0077B5), // LinkedIn blue
          'resume': Color(0xFFCB3920), // Athlete light primary
          'contact': Color(0xFF881593), // Athlete light secondary
          'liked_shaka': Color(0xFFCB3920), // Athlete red for liked
          'unliked_shaka': Color(0xFF8B8B8B), // Gray for unliked
          'add_message': Color(0xFFCB3920), // Athlete red for add message
        };
      case 'athlete_dark':
        return {
          'linkedin': Color(0xFF0077B5), // LinkedIn blue
          'resume': Color(0xFFFE8019), // Athlete dark primary
          'contact': Color(0xFF6A8F8A), // Athlete dark secondary
          'liked_shaka': Color(0xFFFE8019), // Athlete orange for liked
          'unliked_shaka': Color(0xFF8B8B8B), // Gray for unliked
          'add_message': Color(0xFFFE8019), // Athlete orange for add message
        };

      // Ninja themes
      case 'ninja_light':
        return {
          'linkedin': Color(0xFF0077B5), // LinkedIn blue
          'resume': Color(0xFF046252), // Ninja light primary (teal)
          'contact': Color(0xFFC74600), // Ninja light secondary (orange)
          'liked_shaka': Color(0xFF046252), // Ninja teal for liked
          'unliked_shaka': Color(0xFF8B8B8B), // Gray for unliked
          'add_message': Color(0xFF046252), // Ninja teal for add message
        };
      case 'ninja_dark':
        return {
          'linkedin': Color(0xFF0077B5), // LinkedIn blue
          'resume': Color(0xFF13EFDC), // Ninja dark primary (bright teal)
          'contact': Color(0xFFE77A1E), // Ninja dark secondary (bright orange)
          'liked_shaka': Color(0xFF13EFDC), // Ninja bright teal for liked
          'unliked_shaka': Color(0xFF8B8B8B), // Gray for unliked
          'add_message': Color(0xFF13EFDC), // Ninja bright teal for add message
        };

      // Other themes (corporate, creative, accessibility)
      default:
        return {
          'linkedin': Color(0xFF0077B5), // LinkedIn blue
          'resume': WireframeColorManager.colors.primary, // Use theme primary
          'contact': WireframeColorManager.colors.secondary ??
              WireframeColorManager.colors.primary, // Use theme secondary
          'liked_shaka':
              WireframeColorManager.colors.primary, // Theme primary for liked
          'unliked_shaka': Color(0xFF8B8B8B), // Gray for unliked
          'add_message': WireframeColorManager
              .colors.primary, // Theme primary for add message
        };
    }
  }

  /// Get specific icon color for current theme
  static Color getIconColor(String iconType) {
    final colors = getIconColors();
    return colors[iconType] ?? WireframeColorManager.colors.primary;
  }

  /// Check if current theme is dark mode
  static bool get isDarkMode => WireframeColorManager.isDarkMode;

  /// Get current theme name
  static String get currentTheme => WireframeColorManager.currentTheme;
}
