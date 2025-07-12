import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../wireframe_layout_constants.dart';

/// Enhanced Mobile Project Card for Social Media Style
class MobileWireframeProjectCard extends StatelessWidget {
  final String projectId;
  final String title;
  final String role;
  final String description;
  final String heroImagePath;
  final VoidCallback onTap;

  const MobileWireframeProjectCard({
    Key? key,
    required this.projectId,
    required this.title,
    required this.role,
    required this.description,
    required this.heroImagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeWhite,
          borderRadius: BorderRadius.circular(0),
          border:
              Border.all(color: WireframeColorManager.colors.border, width: 1),
          boxShadow: WireframeLayoutConstants.shadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and author info
            Padding(
              padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: WireframeLayoutConstants.smallAvatarSize,
                    height: WireframeLayoutConstants.smallAvatarSize,
                    decoration: BoxDecoration(
                      color: WireframeLayoutConstants.wireframeAccent
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                          WireframeLayoutConstants.smallAvatarSize / 2),
                      border: Border.all(
                          color: WireframeLayoutConstants.wireframeAccent),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: WireframeLayoutConstants.wireframeAccent,
                    ),
                  ),
                  SizedBox(width: WireframeLayoutConstants.spacingSmall),

                  // Author info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jeff Anderson',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                WireframeLayoutConstants.mobileFontSizeBody + 1,
                            color: WireframeColorManager.colors.text,
                          ),
                        ),
                        Text(
                          'UX/UI Designer',
                          style: TextStyle(
                            color: WireframeLayoutConstants.wireframeSecondary,
                            fontSize:
                                WireframeLayoutConstants.mobileFontSizeBody - 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // More options
                  Icon(
                    Icons.more_vert,
                    size: 16,
                    color: WireframeLayoutConstants.wireframeSecondary,
                  ),
                ],
              ),
            ),

            // Hero Image
            Container(
              width: double.infinity,
              height: WireframeLayoutConstants.mobileCardImageHeight,
              margin: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    WireframeLayoutConstants.radiusMedium),
                border: Border.all(color: WireframeColorManager.colors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    WireframeLayoutConstants.radiusMedium - 1),
                child: Image.asset(
                  heroImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: WireframeLayoutConstants.wireframeLightGray,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: WireframeLayoutConstants.wireframeSecondary,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          WireframeLayoutConstants.mobileFontSizeLargeTitle,
                      color: WireframeColorManager.colors.text,
                    ),
                  ),
                  SizedBox(height: WireframeLayoutConstants.spacingTiny),

                  // Role
                  Text(
                    role,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                      color: WireframeLayoutConstants.wireframeAccent,
                    ),
                  ),
                  SizedBox(height: WireframeLayoutConstants.spacingSmall),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                      color: WireframeColorManager.colors.text,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Action bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: WireframeLayoutConstants.spacingMedium,
                vertical: WireframeLayoutConstants.spacingSmall,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: WireframeLayoutConstants.wireframeLightGray),
                ),
              ),
              child: Row(
                children: [
                  _buildActionButton(Icons.favorite_outline, ''),
                  SizedBox(width: WireframeLayoutConstants.spacingStandard),
                  _buildActionButton(Icons.chat_bubble_outline, ''),
                  SizedBox(width: WireframeLayoutConstants.spacingStandard),
                  _buildActionButton(Icons.share_outlined, ''),
                  Spacer(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: WireframeLayoutConstants.wireframeSecondary,
        ),
        if (count.isNotEmpty) ...[
          SizedBox(width: WireframeLayoutConstants.spacingTiny),
          Text(
            count,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBody - 1,
              color: WireframeLayoutConstants.wireframeSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Enhanced Desktop Project Card
class DesktopWireframeProjectCard extends StatelessWidget {
  final String projectId;
  final String title;
  final String role;
  final String description;
  final String heroImagePath;
  final VoidCallback onTap;

  const DesktopWireframeProjectCard({
    Key? key,
    required this.projectId,
    required this.title,
    required this.role,
    required this.description,
    required this.heroImagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeWhite,
          borderRadius: BorderRadius.circular(0),
          border:
              Border.all(color: WireframeColorManager.colors.border, width: 1),
          boxShadow: WireframeLayoutConstants.shadowMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and author info
            Padding(
              padding: EdgeInsets.only(
                left: WireframeLayoutConstants.spacingStandard,
                right: WireframeLayoutConstants.spacingStandard,
                top: WireframeLayoutConstants.spacingStandard,
                bottom: WireframeLayoutConstants.spacingSmall,
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: WireframeLayoutConstants.mediumAvatarSize,
                    height: WireframeLayoutConstants.mediumAvatarSize,
                    decoration: BoxDecoration(
                      color: WireframeLayoutConstants.wireframeAccent
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                          WireframeLayoutConstants.mediumAvatarSize / 2),
                      border: Border.all(
                          color: WireframeLayoutConstants.wireframeAccent),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: WireframeLayoutConstants.wireframeAccent,
                    ),
                  ),
                  SizedBox(width: WireframeLayoutConstants.spacingTiny),

                  // Author info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jeff Anderson',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: WireframeLayoutConstants
                                .desktopFontSizeBodyLarge,
                            color: WireframeColorManager.colors.text,
                          ),
                        ),
                        Text(
                          'UX/UI Designer & Developer',
                          style: TextStyle(
                            color: WireframeLayoutConstants.wireframeSecondary,
                            fontSize:
                                WireframeLayoutConstants.desktopFontSizeBody,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Timestamp removed
                  
                  SizedBox(width: WireframeLayoutConstants.spacingSmall),
                  Icon(
                    Icons.more_vert,
                    size: 20,
                    color: WireframeLayoutConstants.wireframeSecondary,
                  ),
                ],
              ),
            ),

            // Hero Image
            Container(
              width: double.infinity,
              height: WireframeLayoutConstants.desktopCardImageHeight,
              margin: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingStandard),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    WireframeLayoutConstants.radiusMedium),
                border: Border.all(color: WireframeColorManager.colors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    WireframeLayoutConstants.radiusMedium - 1),
                child: Image.asset(
                  heroImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: WireframeLayoutConstants.wireframeLightGray,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: WireframeLayoutConstants.wireframeSecondary,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          WireframeLayoutConstants.desktopFontSizeLargeTitle,
                      color: WireframeColorManager.colors.text,
                    ),
                  ),
                  SizedBox(height: WireframeLayoutConstants.spacingSmall),

                  // Role
                  Text(
                    role,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                      color: WireframeLayoutConstants.wireframeAccent,
                    ),
                  ),
                  SizedBox(height: WireframeLayoutConstants.spacingSmall),

                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                      color: WireframeColorManager.colors.text,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Action bar
            Container(
              padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: WireframeLayoutConstants.wireframeLightGray),
                ),
              ),
              child: Row(
                children: [
                  _buildDesktopActionButton(
                      Icons.favorite_outline, 'Like', ''),
                  SizedBox(width: WireframeLayoutConstants.spacingLarge),
                  _buildDesktopActionButton(
                      Icons.chat_bubble_outline, 'Comment', ''),
                  SizedBox(width: WireframeLayoutConstants.spacingLarge),
                  _buildDesktopActionButton(Icons.share_outlined, 'Share', ''),
                  Spacer(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopActionButton(IconData icon, String label, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: WireframeLayoutConstants.wireframeSecondary,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Text(
          label,
          style: TextStyle(
            fontSize: WireframeLayoutConstants.desktopFontSizeBody,
            color: WireframeLayoutConstants.wireframeSecondary,
          ),
        ),
        if (count.isNotEmpty) ...[
          SizedBox(width: WireframeLayoutConstants.spacingTiny),
          Text(
            count,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.desktopFontSizeBody,
              color: WireframeLayoutConstants.wireframeSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Project data helper
class ProjectCardData {
  static Map<String, Map<String, String>> get projects => {
        'tap-in': {
          'title': 'Tap In',
          'role':
              'Senior Software Engineer, Senior UX/UI Designer & Researcher for B2C application',
          'description':
              'An inclusive mobile app that caters to the increasing demand for a unified integration of diverse Jiu-Jitsu training and cultural aspects.',
          'heroImage': 'assets/tapin_card.png',
        },
        'moments': {
          'title': 'Moments',
          'role': 'UX/UI Designer & Researcher (5-member team)',
          'description':
              'A burgeoning B2C social media application aiming to redefine the landscape',
          'heroImage': 'assets/moments_card.png',
        },
        'core-ai': {
          'title': 'CoreAi',
          'role': 'UX/UI Designer (5-member team)',
          'description':
              'An innovative B2B SaaS AI platform that analyzes associate metrics and offers actionable insights for continuous improvement',
          'heroImage': 'assets/coreai_card.png',
        },
        'plannie': {
          'title': 'Plannie',
          'role': 'UX/UI Designer for B2C enhancement project',
          'description':
              'Event planning platform that seamlessly connects planners and clients through an intuitive interface',
          'heroImage': 'assets/plannie_card.png',
        },
      };

  static Map<String, String> getProject(String projectId) {
    return projects[projectId] ?? projects['tap-in']!;
  }

  static List<String> getAllProjectIds() {
    return projects.keys.toList();
  }

  static List<Map<String, String>> getAllProjects() {
    return projects.entries.map((entry) {
      return {
        'id': entry.key,
        ...entry.value,
      };
    }).toList();
  }
}

/// Simple project card for wireframe theme
class WireframeProjectCard extends StatelessWidget {
  final String projectId;
  final String title;
  final String subtitle;
  final String? imagePath;
  final VoidCallback onTap;
  final bool isSelected;

  const WireframeProjectCard({
    Key? key,
    required this.projectId,
    required this.title,
    required this.subtitle,
    this.imagePath,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: WireframeLayoutConstants.spacingMedium),
        padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? WireframeLayoutConstants.wireframeAccent
                : WireframeLayoutConstants.wireframeBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius:
              BorderRadius.circular(WireframeLayoutConstants.radiusMedium),
          color: WireframeLayoutConstants.wireframeWhite,
          boxShadow: WireframeLayoutConstants.shadowLight,
        ),
        child: Row(
          children: [
            // Project thumbnail/icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color:
                    WireframeLayoutConstants.wireframeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                    WireframeLayoutConstants.radiusMedium),
                border:
                    Border.all(color: WireframeLayoutConstants.wireframeAccent),
              ),
              child: imagePath != null && imagePath!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                          WireframeLayoutConstants.radiusMedium - 2),
                      child: Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.work,
                            color: WireframeLayoutConstants.wireframeAccent,
                            size: 24,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.work,
                      color: WireframeLayoutConstants.wireframeAccent,
                      size: 24,
                    ),
            ),

            SizedBox(width: WireframeLayoutConstants.spacingStandard),

            // Project info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          WireframeLayoutConstants.desktopFontSizeBodyLarge,
                      color: WireframeColorManager.colors.text,
                    ),
                  ),
                  SizedBox(height: WireframeLayoutConstants.spacingTiny),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: WireframeLayoutConstants.wireframeSecondary,
                      fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow indicator
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: WireframeLayoutConstants.wireframeSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
