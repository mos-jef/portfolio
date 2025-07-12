import 'package:flutter/material.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_desktop_analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wireframe_layout_constants.dart';

/// Mobile drawer overlay component
class WireframeMobileDrawer extends StatelessWidget {
  final VoidCallback onHideDrawer;
  final Function(BuildContext) onShowContactBottomSheet;
  final Function(int) onMobileNavigation;

  const WireframeMobileDrawer({
    Key? key,
    required this.onHideDrawer,
    required this.onShowContactBottomSheet,
    required this.onMobileNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -WireframeLayoutConstants.drawerWidth,
      top: 0,
      bottom: 0,
      child: Container(
        width: WireframeLayoutConstants.drawerWidth,
        height: double.infinity,
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeWhite,
          boxShadow: [
            BoxShadow(
              color: WireframeLayoutConstants.wireframeBlack.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(2, 0),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Drawer header
            _buildDrawerHeader(),

            // Drawer content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    // Contact
                    _buildDrawerButtonSVG(
                      SvgIconPaths.contacts3Line,
                      'Contact',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        onShowContactBottomSheet(context);
                      },
                    ),
                    SizedBox(height: WireframeLayoutConstants.spacingMedium),

                    // Analytics - FIXED TO USE REAL ANALYTICS
                    _buildDrawerButtonSVG(
                      SvgIconPaths.chartBar2Line,
                      'Analytics',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        _showAnalyticsModal(
                            context); // Now calls the real analytics modal
                      },
                    ),
                    SizedBox(height: WireframeLayoutConstants.spacingMedium),

                    // Projects
                    _buildDrawerButtonSVG(
                      SvgIconPaths.displayLine,
                      'Projects',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        onMobileNavigation(1); // Navigate to projects
                      },
                    ),
                    SizedBox(height: WireframeLayoutConstants.spacingMedium),

                    // Resume
                    _buildDrawerButtonSVG(
                      SvgIconPaths.documentLine,
                      'Resume',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        _launchResume();
                      },
                    ),
                    SizedBox(height: WireframeLayoutConstants.spacingMedium),

                    // Settings
                    _buildDrawerButtonSVG(
                      SvgIconPaths.settings3Line,
                      'Settings',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        onMobileNavigation(4); // Navigate to settings
                      },
                    ),
                    SizedBox(height: WireframeLayoutConstants.spacingMedium),

                    // About
                    _buildDrawerButtonSVG(
                      SvgIconPaths.personbasicon,
                      'About',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        onMobileNavigation(3); // Navigate to about
                      },
                    ),
                    SizedBox(height: WireframeLayoutConstants.spacingMedium),

                    // LinkedIn
                    _buildDrawerButtonSVG(
                      SvgIconPaths.linkedinFill,
                      'LinkedIn',
                      WireframeColorManager.colors.secondary,
                      () {
                        onHideDrawer();
                        _launchLinkedIn();
                      },
                    ),

                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: WireframeColorManager.colors.border),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  fontSize: WireframeLayoutConstants.mobileFontSizeBodyLarge,
                  fontWeight: FontWeight.bold,
                  color: WireframeColorManager.colors.text,
                ),
              ),
              Spacer(),
              ClickableWidget(
                onTap: onHideDrawer,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: WireframeLayoutConstants.wireframeSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              ClickableWidget(
                onTap: onHideDrawer,
                child: Row(
                  children: [
                    SvgIcon(
                      assetPath: SvgIconPaths.arrowLeftCircleLine,
                      size: 14,
                      color: WireframeColorManager.colors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 12,
                        color: WireframeColorManager.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerButtonSVG(
    String svgPath,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    // ===== QUICK CONFIGURATION TOGGLES =====

    final bool useCircleBackground = true; // Toggle circles on/off
    final int circleOpacity = 30; // 0-255 opacity level
    final bool useBorder = false; // Toggle border on/off
    final bool useShadowEffects = false; // Toggle shadows/glow on/off
    final bool useGradientBackground = false; // Toggle gradient vs solid
    final bool adaptToCurrentTheme = true; // Use theme-specific colors

    // ===== COLOR LOGIC =====

    Color getThemeColor() {
      if (!adaptToCurrentTheme) return WireframeColorManager.colors.primary;

      // Theme-specific color mapping
      final currentTheme = WireframeColorManager.currentTheme;
      switch (currentTheme) {
        case 'ninjaDarkTheme':
          return WireframeColorManager.colors.primary; // Yellow-green in dark
        case 'ninjaLightTheme':
          return WireframeColorManager.colors.primary; // Teal in light
        case 'athleteDarkTheme':
          return WireframeColorManager.colors.primary; // Orange in dark
        case 'athleteLightTheme':
          return WireframeColorManager.colors.primary; // Red in light
        case 'corporateTheme':
          return WireframeColorManager.colors.primary; // Professional blue
        case 'creativeTheme':
          return WireframeColorManager.colors.secondary; // Creative orange
        default:
          return WireframeColorManager.colors.primary;
      }
    }

    // ===== DECORATION BUILDER =====

    final themeColor = getThemeColor();
    final isDarkTheme = WireframeColorManager.currentTheme.contains('Dark');

    BoxDecoration buildDecoration() {
      // Background
      Color? backgroundColor;
      Gradient? gradient;

      if (useGradientBackground) {
        gradient = LinearGradient(
          colors: [
            themeColor.withAlpha(circleOpacity),
            WireframeColorManager.colors.secondary
                .withAlpha(circleOpacity ~/ 2),
          ],
        );
      } else if (useCircleBackground) {
        backgroundColor = themeColor.withAlpha(circleOpacity);
      } else {
        backgroundColor = Colors.transparent;
      }

      // Border
      Border? border;
      if (useBorder) {
        border = Border.all(
          color: isDarkTheme
              ? themeColor.withAlpha(150)
              : WireframeColorManager.colors.border,
          width: 1.0,
        );
      }

      // Shadow/glow
      List<BoxShadow>? boxShadow;
      if (useShadowEffects && isDarkTheme) {
        // Glow for dark themes
        boxShadow = [
          BoxShadow(
            color: themeColor.withAlpha(60),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ];
      } else if (useShadowEffects) {
        // Subtle shadow for light themes
        boxShadow = [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ];
      }

      return BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        gradient: gradient,
        border: border,
        boxShadow: boxShadow,
      );
    }

    // ===== WIDGET =====

    return ClickableWidget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: buildDecoration(),
              child: Center(
                child: SvgIcon(
                  assetPath: svgPath,
                  size: 18,
                  color: themeColor,
                ),
              ),
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            Text(
              label,
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(
    IconData? icon, // Make this nullable
    String label,
    Color color,
    VoidCallback onTap, {
    String? svgIconPath, // Add SVG path parameter
  }) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: svgIconPath != null
                    ? SvgIcon(
                        assetPath: svgIconPath,
                        size: 18,
                        color: Colors.white,
                      )
                    : Icon(
                        icon ?? Icons.help_outline,
                        size: 18,
                        color: Colors.white,
                      ),
              ),
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            Text(
              label,
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // URL launcher methods
  void _launchResume() async {
    const url =
        'https://storage.googleapis.com/uxfolio/643d6d8beaacf70002256d70/Resume_avP.pdf';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching resume: $e');
    }
  }

  void _launchLinkedIn() async {
    const url = 'https://www.linkedin.com/in/jeffrey-anderson-pdx/';
    try {
      // Track contact attempt
      await AnalyticsService().trackContactAttempt('linkedin');

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching LinkedIn: $e');
    }
  }

  // REAL ANALYTICS MODAL - Uses your existing WireframeDesktopAnalyticsModal
  void _showAnalyticsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WireframeDesktopAnalyticsModal(
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
