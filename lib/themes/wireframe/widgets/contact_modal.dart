import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../wireframe_layout_constants.dart';

class WireframeContactModal extends StatelessWidget {
  final VoidCallback onClose;

  const WireframeContactModal({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onClose,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent tapping modal content from closing
                child: Container(
                  width: 500,
                  height: 400,
                  decoration: BoxDecoration(
                    color: WireframeColorManager.colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: WireframeColorManager.colors.border!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header with close button
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: WireframeColorManager.colors.text,
                              ),
                            ),
                            ClickableWidget(
                              onTap: onClose,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: WireframeColorManager
                                      .colors.textSecondary!
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: WireframeColorManager
                                      .colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildContactItem(
                                context,
                                Icons.email,
                                'jeff@example.com',
                                () => _launchEmail('jeff@example.com'),
                              ),
                              SizedBox(height: 20),
                              _buildContactItem(
                                context,
                                Icons.phone,
                                '+1 (555) 123-4567',
                                () => _launchPhone('+15551234567'),
                              ),
                              SizedBox(height: 20),
                              _buildContactItem(
                                context,
                                Icons.web,
                                'LinkedIn Profile',
                                () => _launchUrl(
                                    'https://linkedin.com/in/yourprofile'),
                              ),
                              SizedBox(height: 20),
                              _buildContactItem(
                                context,
                                Icons.location_on,
                                'Portland, Oregon',
                                null,
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Feel free to reach out for collaboration opportunities or just to say hello!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: WireframeColorManager
                                      .colors.textSecondary,
                                  height: 1.4,
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

  Widget _buildContactItem(
      BuildContext context, IconData icon, String text, VoidCallback? onTap) {
    Widget content = Row(
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
        if (onTap != null)
          Icon(
            Icons.open_in_new,
            size: 16,
            color: WireframeColorManager.colors.textSecondary,
          ),
      ],
    );

    return onTap != null
        ? ClickableWidget(
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: content,
            ),
          )
        : content;
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
