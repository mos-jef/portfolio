import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import '../wireframe_layout_constants.dart';

/// Mobile contact overlay component
class WireframeMobileContactOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const WireframeMobileContactOverlay({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(

      child: GestureDetector(
      onTap: onClose,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(

          decoration: BoxDecoration(
            color: WireframeLayoutConstants.wireframeBlack.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClickableWidget(
              onTap: () {}, // Prevent inner content tap from closing
              child: Container(
                margin: EdgeInsets.all(WireframeLayoutConstants.spacingXLarge),
                height: math.min(
                    300, WireframeLayoutConstants.iPhoneFrameHeight * 0.6),
                constraints: BoxConstraints(
                  maxHeight: WireframeLayoutConstants.iPhoneFrameHeight * 0.6,
                  maxWidth: WireframeLayoutConstants.iPhoneFrameWidth -
                      (WireframeLayoutConstants.spacingXLarge * 2),
                ),
                decoration: BoxDecoration(
                  color: WireframeLayoutConstants.wireframeWhite,
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: WireframeLayoutConstants.wireframeBlack
                          .withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: EdgeInsets.only(
                        top: WireframeLayoutConstants.spacingSmall,
                        bottom: WireframeLayoutConstants.spacingStandard,
                      ),
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                        color: WireframeColorManager.colors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: WireframeLayoutConstants.spacingStandard,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: WireframeLayoutConstants
                                  .mobileFontSizeLargeTitle,
                              fontWeight: FontWeight.bold,
                              color: WireframeColorManager.colors.text,
                            ),
                          ),
                          ClickableWidget(
                            onTap: onClose,
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color:
                                  WireframeLayoutConstants.wireframeSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Contact details
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: WireframeLayoutConstants.spacingStandard,
                          vertical: WireframeLayoutConstants.spacingMedium,
                        ),
                        child: Column(
                          children: [
                            ClickableWidget(
                              onTap: () => _launchEmail('JeffreyAndersonPDX@gmail.com'),
                              child: _buildMobileContactItem(
                                Icons.email,
                                'JeffreyAndersonPDX@gmail.com',
                              ),
                            ),
                            SizedBox(
                                height: WireframeLayoutConstants.spacingSmall),
                            _buildMobileContactItem(
                                Icons.phone, '(503) 282-4647'),
                            SizedBox(
                                height: WireframeLayoutConstants.spacingSmall),
                            ClickableWidget(
                              onTap: () => _launchURL('https://jeffpdx.net'),
                              child: _buildMobileContactItem(
                                  Icons.web, 'JeffPDX.net'),
                            ),
                            SizedBox(
                                height: WireframeLayoutConstants.spacingSmall),
                            _buildMobileContactItem(
                                Icons.location_on, 'Portland, OR'),
                            SizedBox(
                                height:
                                    WireframeLayoutConstants.spacingStandard),
                            ClickableWidget(
                              onTap: () => _launchLinkedIn(),
                              child: Container(
                                width: 24,
                                height: 24,
                                child: Image.asset(
                                  'assets/linked_in_main.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.link,
                                        size: 24,
                                        color: WireframeLayoutConstants.linkedInBlue,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: WireframeLayoutConstants.wireframeAccent,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBody,
              color: WireframeColorManager.colors.text,
            ),
          ),
        ),
      ],
    );
  }

  // Placeholder methods - will be moved to utilities
  void _launchEmail(String email) {
    // Implementation will be in utilities
  }

  void _launchURL(String url) {
    // Implementation will be in utilities
  }

  void _launchLinkedIn() {
    // Implementation will be in utilities
  }
}

  /// Desktop contact modal component

  class WireframeDesktopContactModal extends StatelessWidget {
  final VoidCallback onClose;

  const WireframeDesktopContactModal({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        height: 500,
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: WireframeColorManager.colors.border!,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: WireframeColorManager.colors.text,
                    ),
                  ),
                  GestureDetector(
                    // ← REPLACE ClickableWidget with GestureDetector
                    onTap: onClose,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.close,
                        color: WireframeColorManager.colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contact content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildContactItem(
                      context,
                      'email', // ← SVG identifier
                      'Email',
                      'JeffreyAndersonPDX@gmail.com',
                      () => _launchEmail(),
                    ),
                    SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      'phone', // ← SVG identifier
                      'Phone',
                      '(503) 282-4647',
                      () => _launchPhone(),
                    ),
                    SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      'location', // ← SVG identifier
                      'Location',
                      'Portland, OR',
                      null,
                    ),
                    SizedBox(height: 16),
                    _buildContactItem(
                      context,
                      'linkedin', // ← SVG identifier
                      'LinkedIn',
                      'jeffrey-anderson-pdx',
                      () => _launchLinkedIn(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String iconType, // ← String parameter for SVG type
    String title,
    String value,
    VoidCallback? onTap,
  ) {
    Widget content = Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: WireframeColorManager.colors.border!,
        ),
      ),
      child: Row(
        children: [
          _buildSvgIcon(iconType), // ← Use SVG icon method
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: WireframeColorManager.colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: WireframeColorManager.colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: WireframeColorManager.colors.textSecondary,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: content,
        ),
      );
    }

    return content;
  }

  void _launchEmail() async {
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

  void _launchPhone() async {
    const phone = '5032824647';
    final url = 'tel:$phone';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  void _launchLinkedIn() async {
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
}

  // Placeholder methods - will be moved to utilities
  void _launchEmail(String email) {
    // Implementation will be in utilities
  }

  void _launchURL(String url) {
    // Implementation will be in utilities
  }

  void _launchLinkedIn() {
    // Implementation will be in utilities
  }


/// Contact utilities and helpers
class WireframeContactUtils {
  static const Map<String, String> contactInfo = {
    'email': 'JeffreyAndersonPDX@gmail.com',
    'phone': '(503) 282-4647',
    'website': 'JeffPDX.net',
    'websiteUrl': 'https://jeffpdx.net',
    'location': 'Portland, OR',
    'linkedIn': 'https://www.linkedin.com/in/jeffrey-anderson-pdx/',
  };

  static const Map<String, IconData> contactIcons = {
    'email': Icons.email,
    'phone': Icons.phone,
    'website': Icons.web,
    'location': Icons.location_on,
    'linkedIn': Icons.link,
  };

  static String getContactInfo(String key) {
    return contactInfo[key] ?? '';
  }

  static IconData getContactIcon(String key) {
    return contactIcons[key] ?? Icons.help_outline;
  }

  static List<Map<String, dynamic>> getAllContactItems() {
    return [
      {
        'key': 'email',
        'icon': Icons.email,
        'text': contactInfo['email']!,
        'isClickable': true,
        'action': 'email',
      },
      {
        'key': 'phone',
        'icon': Icons.phone,
        'text': contactInfo['phone']!,
        'isClickable': false,
        'action': null,
      },
      {
        'key': 'website',
        'icon': Icons.web,
        'text': contactInfo['website']!,
        'isClickable': true,
        'action': 'url',
      },
      {
        'key': 'location',
        'icon': Icons.location_on,
        'text': contactInfo['location']!,
        'isClickable': false,
        'action': null,
      },
    ];
  }

  static bool isContactItemClickable(String key) {
    return ['email', 'website', 'linkedIn'].contains(key);
  }
}

Widget _buildSvgIcon(String iconType) {
  String svgPath;

  switch (iconType) {
    case 'email':
      svgPath = SvgIconPaths.emailbasicon; // ← Correct path
      break;
    case 'phone':
      svgPath = SvgIconPaths.phonebasicon; // ← Correct path
      break;
    case 'location':
      svgPath = SvgIconPaths.housebasicon; // ← Using house icon for location
      break;
    case 'linkedin':
      svgPath = SvgIconPaths.linkedbasicon; // ← Correct path
      break;
    default:
      svgPath = SvgIconPaths.contactbasicon; // Fallback
  }

  return SvgIcon(
    assetPath: svgPath,
    size: 20,
    color: WireframeColorManager.colors.primary,
  );
}
