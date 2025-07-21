import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';
import '../widgets/theme_responsive_icon.dart';

/// Standalone floating header icons component
/// Positioned independently from other content for precise control
class WireframeHeaderIcons extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onContactTap;
  final VoidCallback onLinkedInTap;
  final VoidCallback onResumeTap;
  final double? iconSize;
  final double? spacing;
  final MainAxisAlignment alignment;
  final bool isLargeIconMode;

  const WireframeHeaderIcons({
    Key? key,
    required this.isMobile,
    required this.onContactTap,
    required this.onLinkedInTap,
    required this.onResumeTap,
    this.iconSize,
    this.spacing,
    this.alignment = MainAxisAlignment.center,
    this.isLargeIconMode = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileIcons(context);
    } else {
      return _buildDesktopIcons(context);
    }
  }

  Widget _buildMobileIcons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = iconSize ?? WireframeLayoutConstants.getResponsiveIconSize(
      screenWidth, 
      baseSize: 32.0,
      minSize: 24.0,
      maxSize: 40.0,
    );
    final size = isLargeIconMode ? baseSize * 1.5 : baseSize;
    final iconSpacing = spacing ?? WireframeLayoutConstants.getResponsiveSpacing(
      WireframeLayoutConstants.spacingSmall, 
      screenWidth,
    );
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        WireframeIconAssets.resumeIcon(
          size: size,
          onTap: onResumeTap,
          isMobile: true,
        ),
        SizedBox(width: iconSpacing),
        WireframeIconAssets.linkedinIcon(
          size: size,
          onTap: onLinkedInTap,
          isMobile: true,
        ),
        SizedBox(width: iconSpacing),
        WireframeIconAssets.contactIcon(
          size: size,
          onTap: onContactTap,
          isMobile: true,
        ),
      ],
    );
  }

  Widget _buildDesktopIcons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSpacing = spacing ??
        WireframeLayoutConstants.getResponsiveSpacing(
          WireframeLayoutConstants.spacingMedium,
          screenWidth,
        );
    final baseSize = iconSize ??
        WireframeLayoutConstants.getResponsiveIconSize(
          screenWidth,
          baseSize: 40.0,
          minSize: 32.0,
          maxSize: 56.0,
        );
    final size = isLargeIconMode ? baseSize * 1.5 : baseSize;
    final labelSize = isLargeIconMode
        ? WireframeLayoutConstants.getResponsiveFontSizeWithScale(
            16.0, screenWidth)
        : WireframeLayoutConstants.getResponsiveFontSizeWithScale(
            WireframeLayoutConstants.desktopFontSizeCaption,
            screenWidth,
          );

    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDesktopIconWithLabel(
          context,
          child: WireframeIconAssets.resumeIcon(
            size: size,
            onTap: onResumeTap,
            isMobile: false,
          ),
          label: 'Resume',
          labelSize: labelSize,
        ),
        SizedBox(width: iconSpacing),
        _buildDesktopIconWithLabel(
          context,
          child: WireframeIconAssets.linkedinIcon(
            size: size,
            onTap: onLinkedInTap,
            isMobile: false,
          ),
          label: 'LinkedIn',
          labelSize: labelSize,
        ),
        SizedBox(width: iconSpacing),
        _buildDesktopIconWithLabel(
          context,
          child: WireframeIconAssets.contactIcon(
            size: size,
            onTap: () {
              print('DEBUG: Contact icon tapped - calling onContactTap');
              onContactTap();
            },
            isMobile: false,
          ),
          label: 'Contact',
          labelSize: labelSize,
        ),
      ],
    );
  }

  Widget _buildDesktopIconWithLabel(
    BuildContext context, {
    required Widget child,
    required String label,
    double? labelSize,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = WireframeLayoutConstants.getResponsiveSpacing(
      WireframeLayoutConstants.spacingTiny,
      screenWidth,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        SizedBox(height: responsiveSpacing),
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize ??
                WireframeLayoutConstants.getResponsiveFontSizeWithScale(
                  WireframeLayoutConstants.desktopFontSizeCaption,
                  screenWidth,
                ),
            color: WireframeColorManager.colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Positioned header icons widget for easy placement
class WireframePositionedHeaderIcons extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onContactTap;
  final VoidCallback onLinkedInTap;
  final VoidCallback onResumeTap;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? iconSize;
  final double? spacing;
  final MainAxisAlignment alignment;

  const WireframePositionedHeaderIcons({
    Key? key,
    required this.isMobile,
    required this.onContactTap,
    required this.onLinkedInTap,
    required this.onResumeTap,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.iconSize,
    this.spacing,
    this.alignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: WireframeHeaderIcons(
        isMobile: isMobile,
        onContactTap: onContactTap,
        onLinkedInTap: onLinkedInTap,
        onResumeTap: onResumeTap,
        iconSize: iconSize,
        spacing: spacing,
        alignment: alignment,
      ),
    );
  }
}

/// URL launcher utility methods
class WireframeHeaderIconsUtils {
  static void launchLinkedIn() async {
    const url = 'https://www.linkedin.com/in/jeffrey-anderson-pdx/';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching LinkedIn: $e');
    }
  }

  static void launchResume() async {
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

  static void launchEmail() async {
    const email = 'JeffreyAndersonPDX@gmail.com';
    final url = 'mailto:$email';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }
}
