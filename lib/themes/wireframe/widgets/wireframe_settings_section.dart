import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_website/models/theme_provider.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_contact_overlay.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_desktop_analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/themes/wireframe/widgets/custom_settings_item.dart';
import 'package:provider/provider.dart';

class WireframeSettingsSection extends StatefulWidget {
  final bool isMobile;
  final VoidCallback? onAnalyticsTap;
  final VoidCallback? onBackPressed;
  final VoidCallback? onThemeChanged;
  final Function(bool)? onLargeTextModeChanged;
  final Function(BuildContext)? onShowContactModal;
  final VoidCallback? onShowMobileContactModal;

  const WireframeSettingsSection({
    Key? key,
    required this.isMobile,
    this.onAnalyticsTap,
    this.onBackPressed,
    this.onThemeChanged,
    this.onLargeTextModeChanged,
    this.onShowContactModal,
    this.onShowMobileContactModal,
  }) : super(key: key);

  @override
  State<WireframeSettingsSection> createState() =>
      _WireframeSettingsSectionState();
}

class _WireframeSettingsSectionState extends State<WireframeSettingsSection> {
  bool _isDarkMode = false;
  bool _compactMode = false;
  bool _isLargeTextMode = false;
  String _currentBaseTheme = 'default';
  String _currentFullTheme = 'default';

  @override
  void initState() {
    super.initState();
    _isDarkMode = WireframeColorManager.isDarkMode;
    _currentFullTheme = WireframeColorManager.currentTheme;
    _currentBaseTheme = _getBaseTheme(_currentFullTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: WireframeColorManager.colors.background,
      child: Column(
        children: [
          // Settings header (fixed height)
          _buildSettingsHeader(),

          // Settings content using custom settings (flexible height)
          Expanded(
            child: Container(
              color: WireframeColorManager.colors.background,
              child: ListView(
                padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
                children: [
                  // Appearance Settings Group
                  _buildAppearanceSettingsGroup(),

                  SizedBox(height: widget.isMobile ? 16 : 20),

                  // Portfolio Themes Group (Ghibli & NES)
                  _buildPortfolioThemesGroup(),

                  SizedBox(height: widget.isMobile ? 16 : 20),

                  // Wireframe Theme Variants Group
                  _buildWireframeThemeVariantsGroup(),

                  SizedBox(height: widget.isMobile ? 16 : 20),

                  // Analytics & Data Group
                  _buildAnalyticsGroup(),

                  SizedBox(height: widget.isMobile ? 16 : 20),

                  // About Group
                  _buildAboutGroup(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 16 : 24,
        vertical: widget.isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        border: Border(
          bottom: BorderSide(color: WireframeColorManager.colors.border),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: widget.onBackPressed,
            icon: SvgIcon(
              assetPath: SvgIconPaths.arrowLeftCircleLine,
              size: 24,
              color: WireframeColorManager.colors.primary,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: widget.isMobile ? 18 : 22,
                  fontWeight: FontWeight.w600,
                  color: WireframeColorManager.colors.text,
                ),
              ),
            ),
          ),

          // Invisible spacer to center the title
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettingsGroup() {
    return CustomSettingsGroup(
      settingsGroupTitle: "Appearance",
      settingsGroupTitleStyle: TextStyle(
        color: WireframeColorManager.colors.text,
        fontSize: widget.isMobile ? 16 : 18,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: WireframeColorManager.colors.surface,
      items: [
        // Interface Style (Header Only)
        CustomSettingsItem(
          title: 'Interface Style',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(16, 18),
            fontWeight: FontWeight.w700,
          ),
          showIcon: false,
        ),

        // Dark Mode
        CustomSettingsItem(
          onTap: () => _toggleDarkMode(!_isDarkMode),
          title: 'Dark Mode',
          subtitle: _isDarkMode ? 'Dark theme active' : 'Light theme active',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.shadowLine,
          trailing: Switch.adaptive(
            value: _isDarkMode,
            onChanged: (value) => _toggleDarkMode(!_isDarkMode),
            activeColor: WireframeColorManager.colors.primary,
          ),
        ),

        // Large Text Mode
        CustomSettingsItem(
          onTap: () => _toggleLargeTextMode(),
          title: 'Large Text Mode',
          subtitle: _isLargeTextMode
              ? 'Larger text and icons for better readability'
              : 'Standard text and icon sizes',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.fontSizeLine,
          trailing: Switch.adaptive(
            value: _isLargeTextMode,
            onChanged: (value) => _toggleLargeTextMode(),
            activeColor: WireframeColorManager.colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioThemesGroup() {
    return CustomSettingsGroup(
      settingsGroupTitle: "Portfolio Themes",
      settingsGroupTitleStyle: TextStyle(
        color: WireframeColorManager.colors.text,
        fontSize: widget.isMobile ? 16 : 18,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: WireframeColorManager.colors.surface,
      items: [
        // Studio Ghibli Theme
        CustomSettingsItem(
          onTap: () => _switchToGhibliTheme(),
          title: 'Studio Ghibli Theme',
          subtitle: 'Magical and whimsical design',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.fullMoonLine,
          svgIconColor: Color(0xFF4A7C59), // Ghibli green
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF4A7C59),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Go Now!',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(11, 13),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // NES Theme
        CustomSettingsItem(
          onTap: () => _switchToNESTheme(),
          title: 'NES Theme',
          subtitle: 'Retro gaming aesthetic',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.nintendoSwitchLine,
          svgIconColor: Color(0xFF8B5A3C), // NES brown
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF8B5A3C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Go Now!',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(11, 13),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWireframeThemeVariantsGroup() {
    return CustomSettingsGroup(
      settingsGroupTitle: "Wireframe Theme Variants",
      settingsGroupTitleStyle: TextStyle(
        color: WireframeColorManager.colors.text,
        fontSize: widget.isMobile ? 16 : 18,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: WireframeColorManager.colors.surface,
      items: [
        // Default Wireframe Theme
        CustomSettingsItem(
          onTap: () => _switchBaseTheme('default'),
          title: 'Default Wireframe',
          subtitle: 'Clean and minimal design',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
            fontWeight: _currentBaseTheme == 'default'
                ? FontWeight.w600
                : FontWeight.normal,
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.palette2Line,
          svgIconColor: _currentBaseTheme == 'default'
              ? WireframeColorManager.colors.primary
              : WireframeColorManager.colors.textSecondary,
          trailing: Icon(
            _currentBaseTheme == 'default' ? Icons.toggle_on : Icons.toggle_off,
            size: _getResponsiveSize(40, 50),
            color: _currentBaseTheme == 'default'
                ? WireframeColorManager.colors.primary
                : WireframeColorManager.colors.textSecondary,
          ),
        ),

        // Athletic Theme
        CustomSettingsItem(
          onTap: () => _switchBaseTheme('athlete'),
          title: 'Athletic Theme',
          subtitle: 'Energetic teal and sport vibes',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
            fontWeight: _currentBaseTheme == 'athlete'
                ? FontWeight.w600
                : FontWeight.normal,
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.palette2Line,
          svgIconColor: _currentBaseTheme == 'athlete'
              ? Color(0xFF148D80) // Teal from athlete theme
              : WireframeColorManager.colors.textSecondary,
          trailing: Switch.adaptive(
            value: _currentBaseTheme == 'athlete',
            onChanged: (value) => _switchBaseTheme('athlete'),
            activeColor: WireframeColorManager.colors.primary,
          ),
        ),

        // Ninja Theme
        CustomSettingsItem(
          onTap: () => _switchBaseTheme('ninja'),
          title: 'Ninja Theme',
          subtitle: 'Earth tones and orange accents',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
            fontWeight: _currentBaseTheme == 'ninja'
                ? FontWeight.w600
                : FontWeight.normal,
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.palette2Line,
          svgIconColor: _currentBaseTheme == 'ninja'
              ? Color(0xFFEB8019) // Orange from ninja theme
              : WireframeColorManager.colors.textSecondary,
          trailing: Switch.adaptive(
            value: _currentBaseTheme == 'ninja',
            onChanged: (value) => _switchBaseTheme('ninja'),
            activeColor: WireframeColorManager.colors.primary,
          ),
        ),

        // Corporate Theme
        CustomSettingsItem(
          onTap: () => _switchBaseTheme('corporate'),
          title: 'Corporate Theme',
          subtitle: 'Professional blue design',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
            fontWeight: _currentBaseTheme == 'corporate'
                ? FontWeight.w600
                : FontWeight.normal,
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.palette2Line,
          svgIconColor: _currentBaseTheme == 'corporate'
              ? Color(0xFF2B6CB0) // Blue from corporate theme
              : WireframeColorManager.colors.textSecondary,
          trailing: Switch.adaptive(
            value: _currentBaseTheme == 'corporate',
            onChanged: (value) => _switchBaseTheme('corporate'),
            activeColor: WireframeColorManager.colors.primary,
          ),
        ),

        // Creative Theme
        CustomSettingsItem(
          onTap: () => _switchBaseTheme('creative'),
          title: 'Creative Theme',
          subtitle: 'Vibrant and artistic design',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
            fontWeight: _currentBaseTheme == 'creative'
                ? FontWeight.w600
                : FontWeight.normal,
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.palette2Line,
          svgIconColor: _currentBaseTheme == 'creative'
              ? Color(0xFFEA580C) // Orange from creative theme
              : WireframeColorManager.colors.textSecondary,
          trailing: Switch.adaptive(
            value: _currentBaseTheme == 'creative',
            onChanged: (value) => _switchBaseTheme('creative'),
            activeColor: WireframeColorManager.colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsGroup() {
    return CustomSettingsGroup(
      settingsGroupTitle: "Analytics & Data",
      settingsGroupTitleStyle: TextStyle(
        color: WireframeColorManager.colors.text,
        fontSize: widget.isMobile ? 16 : 18,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: WireframeColorManager.colors.surface,
      items: [

        // Site Analytics
        CustomSettingsItem(
          onTap: widget
              .onAnalyticsTap, // This should work for both mobile and desktop
          title: 'Site Analytics',
          subtitle: 'View engagement and traffic data',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.chartBar2Line,
        ),
      ],
    );
  }

  Widget _buildAboutGroup() {
    return CustomSettingsGroup(
      settingsGroupTitle: "About",
      settingsGroupTitleStyle: TextStyle(
        color: WireframeColorManager.colors.text,
        fontSize: widget.isMobile ? 16 : 18,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: WireframeColorManager.colors.surface,
      items: [
        // Portfolio Info
        CustomSettingsItem(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: WireframeColorManager.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    'Portfolio Info',
                    style: TextStyle(
                      color: WireframeColorManager.colors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    'Designed and created by Jeff',
                    style: TextStyle(
                      color: WireframeColorManager.colors.text,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: WireframeColorManager.colors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          title: 'Portfolio Info',
          subtitle: 'About this portfolio',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.info,
        ),

        // Get in Touch
        CustomSettingsItem(
          onTap: widget.isMobile
              ? widget
                  .onShowMobileContactModal // Uses existing mobile contact callback
              : () => widget.onShowContactModal
                  ?.call(context), // Uses existing desktop contact callback
          title: 'Get in Touch',
          subtitle: 'Contact information',
          titleStyle: TextStyle(
            color: WireframeColorManager.colors.text,
            fontSize: _getResponsiveFontSize(14, 16),
          ),
          subtitleStyle: TextStyle(
            color: WireframeColorManager.colors.textSecondary,
            fontSize: _getResponsiveFontSize(12, 14),
          ),
          svgIconPath: SvgIconPaths.contacts3Line,
        ),
      ],
    );
  }

  // Helper methods for responsive sizing
  double _getResponsiveFontSize(double mobileSize, double desktopSize) {
    final baseSize = widget.isMobile ? mobileSize : desktopSize;
    return _compactMode ? baseSize * 0.9 : baseSize;
  }

  double _getResponsiveSize(double mobileSize, double desktopSize) {
    final baseSize = widget.isMobile ? mobileSize : desktopSize;
    return _compactMode ? baseSize * 0.8 : baseSize;
  }

  // Helper method to get base theme from full theme name
  String _getBaseTheme(String fullTheme) {
    if (fullTheme.contains('athlete')) return 'athlete';
    if (fullTheme.contains('ninja')) return 'ninja';
    if (fullTheme.contains('corporate')) return 'corporate';
    if (fullTheme.contains('creative')) return 'creative';
    if (fullTheme.contains('accessibility')) return 'accessibility';
    return 'default';
  }

  // Method to switch base theme
  void _switchBaseTheme(String baseTheme) {
    setState(() {
      _currentBaseTheme = baseTheme;

      // Determine the full theme name based on current mode
      String newTheme;
      if (baseTheme == 'athlete') {
        newTheme = _isDarkMode ? 'athlete_dark' : 'athlete_light';
      } else if (baseTheme == 'ninja') {
        newTheme = _isDarkMode ? 'ninja_dark' : 'ninja_light';
      } else if (baseTheme == 'default') {
        newTheme = _isDarkMode ? 'dark' : 'default';
      } else {
        newTheme = baseTheme; // corporate, creative, accessibility
      }

      _currentFullTheme = newTheme;
      WireframeColorManager.setTheme(newTheme);
    });

    // Notify parent widgets
    widget.onThemeChanged?.call();

    // Force rebuild of parent widgets
    if (mounted) {
      setState(() {});
    }
  }

  // Updated toggle dark mode to work with base themes
  void _toggleDarkMode(bool dark) {
    setState(() {
      _isDarkMode = dark;
      WireframeColorManager.setDarkMode(dark);

      // Update the full theme based on current base theme and new mode
      String newTheme;
      if (_currentBaseTheme == 'athlete') {
        newTheme = dark ? 'athlete_dark' : 'athlete_light';
      } else if (_currentBaseTheme == 'ninja') {
        newTheme = dark ? 'ninja_dark' : 'ninja_light';
      } else if (_currentBaseTheme == 'default') {
        newTheme = dark ? 'dark' : 'default';
      } else {
        newTheme = _currentBaseTheme; // corporate, creative, accessibility
      }

      _currentFullTheme = newTheme;
      WireframeColorManager.setTheme(newTheme);
    });

    // Trigger parent widget rebuild
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleCompactMode() {
    setState(() {
      _compactMode = !_compactMode;
    });
  }

  void _toggleLargeTextMode() {
    setState(() {
      _isLargeTextMode = !_isLargeTextMode;
    });
    widget.onLargeTextModeChanged?.call(_isLargeTextMode);
  }

  void _switchToGhibliTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleNesTheme(false);
    // Add Ghibli theme switching logic here
  }

  void _switchToNESTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleNesTheme(true);
  }

  void _showAnalyticsModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnalyticsModal(isMobile: widget.isMobile);
      },
    );
  }

  // Mobile analytics modal method
  void _showMobileAnalyticsModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnalyticsModal(isMobile: true);
      },
    );
  }

// Desktop analytics modal method
  void _showDesktopAnalyticsModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WireframeDesktopAnalyticsModal(
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

// Mobile contact modal method
  void _showMobileContactModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: WireframeColorManager.colors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Get in Touch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: WireframeColorManager.colors.text,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: WireframeColorManager.colors.text,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Contact Information
                _buildContactItem(Icons.email, 'JeffreyAndersonPDX@gmail.com'),
                SizedBox(height: 12),
                _buildContactItem(Icons.phone, '(503) 282-4647'),
                SizedBox(height: 12),
                _buildContactItem(Icons.web, 'JeffPDX.net'),
                SizedBox(height: 12),
                _buildContactItem(Icons.location_on, 'Portland, OR'),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper method for contact items
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: WireframeColorManager.colors.primary,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: WireframeColorManager.colors.text,
            ),
          ),
        ),
      ],
    );
  }

// Desktop contact modal method
  void _showDesktopContactModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WireframeDesktopContactModal(
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

}
