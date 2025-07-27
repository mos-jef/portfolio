import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_contact_overlay.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_desktop_analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wireframe_layout_constants.dart';

/// Mobile navigation component with underline style
class WireframeMobileNavigation extends StatelessWidget {
  final String currentView;
  final Function(String) onViewChanged;

  const WireframeMobileNavigation({
    Key? key,
    required this.currentView,
    required this.onViewChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingTiny,
        vertical: WireframeLayoutConstants.spacingSmall - 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMobileNavItem('Home', 'home'),
          _buildMobileNavItem('Projects', 'projects'),
          _buildMobileNavItem('About', 'about'),
        ],
      ),
    );
  }

  Widget _buildMobileNavItem(String title, String view) {
    final isActive = currentView == view;

    return ClickableWidget(
      onTap: () => onViewChanged(view),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? WireframeLayoutConstants.wireframeAccent
                  : WireframeLayoutConstants.wireframeSecondary,
              fontSize: WireframeLayoutConstants.mobileFontSizeBodyLarge,
            ),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingTiny),
          Container(
            height: 2,
            width: 20,
            color: isActive
                ? WireframeLayoutConstants.wireframeAccent
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

/// Desktop navigation component with underline style
class WireframeDesktopNavigation extends StatelessWidget {
  final String selectedSection;
  final Function(String) onSectionChanged;

  const WireframeDesktopNavigation({
    Key? key,
    required this.selectedSection,
    required this.onSectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: WireframeLayoutConstants.spacingTiny),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDesktopTab('Home', 'Home'),
          SizedBox(width: 70),
          _buildDesktopTab('Projects', 'Projects'),
          SizedBox(width: 70),
          _buildDesktopTab('About', 'About'),
        ],
      ),
    );
  }

  Widget _buildDesktopTab(String title, String section) {
    final isActive = selectedSection == section;

    return ClickableWidget(
      onTap: () => onSectionChanged(section),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? WireframeLayoutConstants.wireframeAccent
                  : WireframeLayoutConstants.wireframeSecondary,
              fontSize: WireframeLayoutConstants.desktopFontSizeBodyLarge,
            ),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingSmall - 2),
          Container(
            height: 2,
            width: 30,
            color: isActive
                ? WireframeLayoutConstants.wireframeAccent
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

/// Desktop sidebar navigation with neumorphic style
class WireframeDesktopSidebar extends StatelessWidget {
  final String selectedSection;
  final String hoveredItem;
  final Function(String) onSectionChanged;
  final Function(String) onHoveredItemChanged;
  final VoidCallback? onResumePressed;
  final VoidCallback? onLinkedInPressed;

  const WireframeDesktopSidebar({
    Key? key,
    required this.selectedSection,
    required this.hoveredItem,
    required this.onSectionChanged,
    required this.onHoveredItemChanged,
    this.onResumePressed,
    this.onLinkedInPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Home at the top
        _buildNeumorphicSidebarItem(
          null,
          'Home',
          svgIconPath: SvgIconPaths.home3Line,
          onTap: () => onSectionChanged('Home'),
        ),

        _buildNeumorphicSidebarItem(
          null,
          'Contact',
          svgIconPath: SvgIconPaths.contacts3Line,
          onTap: () {
            // Show desktop contact modal
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) => Material(
                  type: MaterialType.transparency,
                  child: WireframeDesktopContactModal(
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              );
            }
          },
        ),

        _buildNeumorphicSidebarItem(
          null,
          'Analytics',
          svgIconPath: SvgIconPaths.chartBar2Line,
          onTap: () {
            // Show analytics modal
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) => WireframeDesktopAnalyticsModal(
                  onClose: () => Navigator.of(context).pop(),
                ),
              );
            }
          },
        ),
        _buildNeumorphicSidebarItem(
          null,
          'Projects',
          svgIconPath: SvgIconPaths.displayLine,
          onTap: () => onSectionChanged('Projects'),
        ),
        _buildNeumorphicSidebarItem(
          null,
          'Resume',
          svgIconPath: SvgIconPaths.documentLine,
          onTap: () => _launchResume(),
        ),
        _buildNeumorphicSidebarItem(
          null,
          'Settings',
          svgIconPath: SvgIconPaths.settings3Line,
          onTap: () => onSectionChanged('Settings'),
        ),
        _buildNeumorphicSidebarItem(
          null,
          'About',
          svgIconPath: SvgIconPaths.userLine,
          onTap: () => onSectionChanged('About'),
        ),
        _buildNeumorphicSidebarItem(
          null,
          'LinkedIn',
          svgIconPath: SvgIconPaths.linkedinFill,
          onTap: () => _launchLinkedIn(),
        ),
      ],
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

  Widget _buildNeumorphicSidebarItem(
    IconData? icon,
    String title, {
    bool isSelected = false,
    String? svgIconPath,
    VoidCallback? onTap, // ADD THIS PARAMETER
  }) {
    // Get selection state
    final itemIsSelected = isSelected || selectedSection == title;
    final itemIsHovered = hoveredItem == title;

    return MouseRegion(
      onEnter: (_) => onHoveredItemChanged(title),
      onExit: (_) => onHoveredItemChanged(''),
      child: ClickableWidget(
        onTap: onTap ?? () => onSectionChanged(title), // USE onTap if provided
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          margin:
              EdgeInsets.only(bottom: WireframeLayoutConstants.spacingMedium),
          padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
            color: itemIsSelected
                ? WireframeColorManager.colors.primary.withAlpha(0)
                : itemIsHovered
                    ? WireframeColorManager.colors.hover.withAlpha(20)    // affects hover only
                    : WireframeColorManager.colors.surface.withAlpha(20),
            border: Border.all(
              color: itemIsSelected
                  ? WireframeColorManager.colors.primary.withAlpha(0) // affects visibility of border around category
                  : WireframeColorManager.colors.border.withAlpha(0),
              width: itemIsSelected ? 3 : 1,
            ),
            boxShadow: itemIsHovered || itemIsSelected
                ? [
                    BoxShadow(
                      color: WireframeColorManager.colors.hover.withAlpha(0),  // affects hover but also the selected category
                      blurRadius: 0,
                      offset: Offset(0, 0),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Icon
              if (svgIconPath != null)
                SvgIcon(
                  assetPath: svgIconPath,
                  size: 20,
                  color: itemIsSelected
                      ? WireframeColorManager.colors.primary.withAlpha(250) // affects color of selected icon/svg
                      : WireframeColorManager.colors.textSecondary.withAlpha(250), // affects color of un-selected icon/svg
                )
              else if (icon != null)
                Icon(
                  icon,
                  size: 20,
                  color: itemIsSelected
                      ? WireframeColorManager.colors.primary
                      : WireframeColorManager.colors.textSecondary,
                ),

              SizedBox(width: WireframeLayoutConstants.spacingMedium),

              // Text
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      itemIsSelected ? FontWeight.w700 : FontWeight.normal,
                  color: itemIsSelected
                      ? WireframeColorManager.colors.primary
                      : WireframeColorManager.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Case study navigation bar for mobile
class WireframeCaseStudyNavBar extends StatelessWidget {
  final String selectedCaseStudy; // <-- Make it final
  final VoidCallback onBackPressed;

  const WireframeCaseStudyNavBar({
    Key? key,
    this.selectedCaseStudy = '', // <-- Add as constructor parameter
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: WireframeLayoutConstants.curvedNavHeight,
      color: WireframeLayoutConstants.wireframeWhite,
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingStandard,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          ClickableWidget(
            onTap: onBackPressed,
            child: Row(
              children: [
                SvgIcon(
                  assetPath: SvgIconPaths.arrowLeftCircleLine,
                  size: 20,
                  color: WireframeLayoutConstants.wireframeAccent,
                ),
                SizedBox(width: WireframeLayoutConstants.spacingSmall),
                Text(
                  'Back',
                  style: TextStyle(
                    color: WireframeLayoutConstants.wireframeAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: WireframeLayoutConstants.mobileFontSizeLargeTitle,
                  ),
                ),
              ],
            ),
          ),

          // Project title
          Text(
            _getCaseStudyTitle(selectedCaseStudy),
            style: TextStyle(
              color: WireframeColorManager.colors.text,
              fontWeight: FontWeight.w600,
              fontSize: WireframeLayoutConstants.mobileFontSizeLargeTitle,
            ),
          ),

          // Share or more options
          Icon(
            Icons.more_vert,
            color: WireframeLayoutConstants.wireframeSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _getCaseStudyTitle(String projectId) {
    switch (projectId) {
      case 'tap-in':
        return 'Tap In';
      case 'moments':
        return 'Moments';
      case 'core-ai':
        return 'CoreAi';
      case 'plannie':
        return 'Plannie';
      default:
        return 'Case Study';
    }
  }
}

/// Navigation utilities and helpers
class WireframeNavigationUtils {
  static const Map<String, String> sectionSvgIcons = {
    // New SVG mapping
    'Home': SvgIconPaths.home3Line,
    'Projects': SvgIconPaths.componentLine,
    'About': SvgIconPaths.userLine,
    'Resume': SvgIconPaths.documentLine,
    'Settings': SvgIconPaths.settings3Line,
  };

  static const Map<String, IconData> sectionIcons = {
    // Keep as fallback
    'Home': Icons.home,
    'Projects': Icons.work,
    'About': Icons.person,
    'Resume': Icons.description,
    'Fun Stuff': Icons.extension,
    'Settings': Icons.settings, // Can keep this as fallback
  };

  static const Map<String, String> mobileViewMappings = {
    'home': 'Home',
    'projects': 'Projects',
    'about': 'About',
    'contact': 'Contact',
    'case_study': 'Case Study',
  };

  static IconData getIconForSection(String section) {
    return sectionIcons[section] ?? Icons.help_outline;
  }

  static String getMobileViewTitle(String view) {
    return mobileViewMappings[view] ?? view;
  }

  static bool isValidMobileView(String view) {
    return mobileViewMappings.containsKey(view);
  }

  static bool isValidDesktopSection(String section) {
    return sectionIcons.containsKey(section);
  }
}
