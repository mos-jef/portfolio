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
      child: ClickableWidget(
        onTap: onClose, // Allow tap outside to close
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
      backgroundColor: WireframeLayoutConstants.wireframeWhite,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
      ),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(WireframeLayoutConstants.spacingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize:
                        WireframeLayoutConstants.desktopFontSizeLargeTitle,
                    fontWeight: FontWeight.bold,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: WireframeLayoutConstants.wireframeSecondary,
                  ),
                  onPressed: onClose,
                  style: IconButton.styleFrom(
                    padding:
                        EdgeInsets.all(WireframeLayoutConstants.spacingSmall),
                    minimumSize: Size(32, 32),
                  ),
                ),
              ],
            ),

            SizedBox(height: WireframeLayoutConstants.spacingLarge),

            // Contact details
            _buildDesktopContactItem(
              Icons.email,
              'JeffreyAndersonPDX@gmail.com',
              onTap: () => _launchEmail('JeffreyAndersonPDX@gmail.com'),
            ),
            _buildDesktopContactItem(Icons.phone, '(503) 282-4647'),
            _buildDesktopContactItem(
              Icons.web,
              'JeffPDX.net',
              onTap: () => _launchURL('https://jeffpdx.net'),
            ),
            _buildDesktopContactItem(Icons.location_on, 'Portland, OR'),

            SizedBox(height: WireframeLayoutConstants.spacingLarge),

            // LinkedIn
            ClickableWidget(
            onTap: () => _launchLinkedIn(),
              child: SvgIcon(
                assetPath: SvgIconPaths.linkedbasicon,
                color: WireframeColorManager.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }




// Add these URL launcher methods:
  void _launchEmail(String email) async {
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

  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
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

  Widget _buildDesktopContactItem(IconData icon, String text, {VoidCallback? onTap}) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: WireframeLayoutConstants.wireframeAccent,
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                  color: WireframeColorManager.colors.text,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: WireframeColorManager.colors.textSecondary,
              ),
          ],
        ),
      ),
    );
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
