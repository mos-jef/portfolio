// File: lib/themes/wireframe/components/wireframe_mobile_contact_modal.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/wireframe_color_manager.dart';
import '../widgets/theme_responsive_icon.dart';
import '../wireframe_layout_constants.dart';

/// Mobile contact modal component (bottom sheet style)
class WireframeMobileContactModal extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final AnimationController animationController;
  final VoidCallback onClose;

  const WireframeMobileContactModal({
    Key? key,
    required this.slideAnimation,
    required this.animationController,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        animationController.reverse().then((_) {
          onClose();
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeBlack.withAlpha(20),
        ),
        child: ClickableWidget(
          onTap: () {}, // Prevent tap from bubbling up
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: slideAnimation.value *
                      WireframeLayoutConstants.mobileModalHeight,
                  child: Container(
                    width: double.infinity,
                    height: math.min(
                      WireframeLayoutConstants
                          .mobileModalHeight, // Same as comment modal
                      WireframeLayoutConstants.iPhoneFrameHeight * 0.95,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Same as comment modal
                    decoration: BoxDecoration(
                      color: WireframeColorManager.colors.surface,
                      borderRadius: BorderRadius.circular(
                          WireframeLayoutConstants.radiusSmall),
                      boxShadow: [
                        BoxShadow(
                          color: WireframeLayoutConstants.wireframeBlack.withAlpha(20),
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
                              top: WireframeLayoutConstants.spacingSmall),
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
                            horizontal:
                                WireframeLayoutConstants.spacingStandard,
                            vertical: WireframeLayoutConstants.spacingMedium,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Contact',
                                style: TextStyle(
                                  fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                                  fontWeight: FontWeight.bold,
                                  color: WireframeColorManager.colors.text,
                                ),
                              ),
                              ClickableWidget(
                                onTap: () {
                                  animationController.reverse().then((_) {
                                    onClose();
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: WireframeColorManager.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Contact options - Made scrollable
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  WireframeLayoutConstants.spacingStandard,
                            ),
                            child: Column(
                              children: [
                                
                                // Email contact
                                 _buildContactOption(
                                  customIcon: WireframeIconAssets.emailIcon(
                                    size: 32,
                                    onTap:() {}, // Empty onTap since we handle it in the parent
                                    isMobile: true,
                                  ),
                                  title: 'Email',
                                  subtitle: 'Tap here to Email me!',
                                  onTap: () => _launchEmail(),
                                ),

                                SizedBox(
                                    height:
                                        WireframeLayoutConstants.spacingMedium),

                                // LinkedIn contact with responsive icon
                                _buildContactOption(
                                  customIcon: WireframeIconAssets.linkedinIcon(
                                    size: 32,
                                    onTap: () {}, // Empty onTap since we handle it in the parent
                                    isMobile: true,
                                  ),
                                  title: 'LinkedIn',
                                  subtitle: 'Find me on LinkedIn!',
                                  onTap: () => _launchLinkedIn(),
                                ),

                                SizedBox(height: WireframeLayoutConstants.spacingMedium),

                                // Resume download
                                _buildContactOption(
                                  customIcon: WireframeIconAssets.resumeIcon(
                                    size: 32,
                                    onTap: () {}, // Empty onTap since we handle it in the parent
                                    isMobile: true,
                                  ),
                                  title: 'Resume',
                                  subtitle: 'View my resume',
                                  onTap: () => _launchResume(),
                                ),

                                SizedBox( height:WireframeLayoutConstants.spacingMedium),

                                // Phone contact (add this for more content)
                                _buildContactOption(
                                  customIcon: WireframeIconAssets.phoneIcon(
                                  size: 32,
                                  onTap: () {}, // Empty onTap since we handle it in the parent
                                  isMobile: true,
                                  ),
                                  title: 'Phone',
                                  subtitle: '(503) 282-4647',
                                  onTap: () => _launchPhone(),
                                ),

                                SizedBox(height: WireframeLayoutConstants.spacingMedium),

                                // Website contact (add this for more content)
                                 _buildContactOption(
                                  customIcon: WireframeIconAssets.computerIcon(
                                    size: 32,
                                    onTap:() {}, // Empty onTap since we handle it in the parent
                                    isMobile: true,
                                  ),
                                  title: 'Website',
                                  subtitle: 'jeffpdx.net',
                                  onTap: () => _launchWebsite(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: WireframeLayoutConstants.spacingStandard),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: WireframeColorManager.colors.onPrimary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: WireframeColorManager.colors.border!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: WireframeColorManager.colors.primary.withAlpha(0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: customIcon ??
                      Icon(
                        icon,
                        size: 20,
                        color: WireframeColorManager.colors.primary,
                      ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                        fontWeight: FontWeight.w600,
                        color: WireframeColorManager.colors.text,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize:
                            WireframeLayoutConstants.mobileFontSizeBody,
                        color: WireframeColorManager.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: WireframeColorManager.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
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

  void _launchPhone() async {
    const phone = 'tel:+15032824647';
    try {
      final uri = Uri.parse(phone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  void _launchWebsite() async {
    const url = 'https://jeffpdx.net';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching website: $e');
    }
  }
}
