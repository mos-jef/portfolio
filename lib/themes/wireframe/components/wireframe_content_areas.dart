import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_viewer.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/enhanced_social_post.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_about_section.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_settings_section.dart';

import '../cards/wireframe_project_cards.dart';
import '../wireframe_layout_constants.dart';

/// Mobile content area component
class WireframeMobileContentArea extends StatelessWidget {
  final String currentView;
  final String selectedCaseStudy;
  final List<SocialPost> posts;
  final ScrollController scrollController;
  final Function(String) onCaseStudySelected;
  final VoidCallback? onShowMobileContactModal;

  const WireframeMobileContentArea({
    Key? key,
    required this.currentView,
    required this.selectedCaseStudy,
    required this.posts,
    required this.scrollController,
    required this.onCaseStudySelected,
    this.onShowMobileContactModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentView) {
      case 'projects':
        return _buildProjectsList();
      case 'case_study':
        return _buildCaseStudyView();
      case 'about':
        return WireframeAboutSection(isMobile: true);
      case 'settings':
        return WireframeSettingsSection(
          isMobile: true,
          onAnalyticsTap: () {
            // Analytics functionality here
          },
          onThemeChanged: () {
            // This callback will trigger when themes change
            if (context.mounted) {
              (context as Element).markNeedsBuild();
            }
          },
          onShowMobileContactModal: onShowMobileContactModal, // ADD THIS LINE
        );
      default: // home
        return _buildHomeContent();
    }
  }

  Widget _buildProjectsList() {
    return ListView(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
      shrinkWrap: true, // Allow it to size itself
      children: [
        MobileWireframeProjectCard(
          projectId: 'tap-in',
          title: ProjectCardData.getProject('tap-in')['title']!,
          role: ProjectCardData.getProject('tap-in')['role']!,
          description: ProjectCardData.getProject('tap-in')['description']!,
          heroImagePath: ProjectCardData.getProject('tap-in')['heroImage']!,
          onTap: () => onCaseStudySelected('tap-in'),
        ),
        MobileWireframeProjectCard(
          projectId: 'moments',
          title: ProjectCardData.getProject('moments')['title']!,
          role: ProjectCardData.getProject('moments')['role']!,
          description: ProjectCardData.getProject('moments')['description']!,
          heroImagePath: ProjectCardData.getProject('moments')['heroImage']!,
          onTap: () => onCaseStudySelected('moments'),
        ),
        MobileWireframeProjectCard(
          projectId: 'core-ai',
          title: ProjectCardData.getProject('core-ai')['title']!,
          role: ProjectCardData.getProject('core-ai')['role']!,
          description: ProjectCardData.getProject('core-ai')['description']!,
          heroImagePath: ProjectCardData.getProject('core-ai')['heroImage']!,
          onTap: () => onCaseStudySelected('core-ai'),
        ),
        MobileWireframeProjectCard(
          projectId: 'plannie',
          title: ProjectCardData.getProject('plannie')['title']!,
          role: ProjectCardData.getProject('plannie')['role']!,
          description: ProjectCardData.getProject('plannie')['description']!,
          heroImagePath: ProjectCardData.getProject('plannie')['heroImage']!,
          onTap: () => onCaseStudySelected('plannie'),
        ),
      ],
    );
  }

  Widget _buildCaseStudyView() {
    return Column(
      children: [
        // Back button header
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 8.0,
            right: WireframeLayoutConstants.spacingStandard,
            top: WireframeLayoutConstants.spacingSmall,
            bottom: WireframeLayoutConstants.spacingSmall,
          ),
          child: Row(
            children: [
              ClickableWidget(
                onTap: () =>
                    onCaseStudySelected(''), // This will close the case study
                child: Container(
                  padding: EdgeInsets.all(WireframeLayoutConstants.spacingTiny),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: WireframeLayoutConstants.wireframeAccent,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                          color: WireframeLayoutConstants.wireframeAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Case study content
        Expanded(
          child: Container(
            width: double.infinity,
            child: PortfolioViewer(projectId: selectedCaseStudy),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeContent() {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length + 1, // ✅ Add 1 for the "End of posts" item
      itemBuilder: (context, index) {
        if (index == posts.length) {
          // ✅ This is the "End of posts" item
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: WireframeLayoutConstants.spacingLarge,
              horizontal: WireframeLayoutConstants.spacingMedium,
            ),
            decoration: BoxDecoration(
              color: WireframeColorManager
                  .colors.surfaceVariant, // ✅ Theme-responsive background
            ),
            child: Center(
              child: Text(
                'End of posts',
                style: TextStyle(
                  color: WireframeColorManager
                      .colors.textSecondary, // ✅ Theme-responsive text
                  fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        final post = posts[index];
        return _buildMobilePostItem(post);
      },
    );
  }

  Widget _buildMobilePostItem(SocialPost post) {
    return EnhancedSocialPost(
      post: post,
      isMobile: true,
      onPostUpdated: () {
        // Posts will refresh via StreamBuilder
      },
      onPostDeleted: () {
        // Posts will refresh via StreamBuilder
      },
    );
  }

  Widget _buildMobilePostActions() {
    return Row(
      children: [
        _buildMobilePostAction(Icons.favorite_outline, '14'),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildMobilePostAction(Icons.chat_bubble_outline, '2'),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildMobilePostAction(Icons.repeat, ''),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildMobilePostAction(Icons.share_outlined, ''),
      ],
    );
  }

  Widget _buildMobilePostAction(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: WireframeColorManager.colors.info,
        ),
        if (count.isNotEmpty) ...[
          SizedBox(width: WireframeLayoutConstants.spacingTiny),
          Text(
            count,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeCaption,
              color: WireframeColorManager.colors.info,
            ),
          ),
        ],
      ],
    );
  }

  Color _getAvatarColor(String avatarId) {
    final avatarColors = {
      'person': WireframeLayoutConstants.wireframeAccent,
      'face': WireframeLayoutConstants.wireframeSuccess,
      'account_circle': WireframeLayoutConstants.wireframeDanger,
      'sentiment_satisfied': Color(0xFF6F42C1),
      'emoji_people': Color(0xFFFD7E14),
    };
    return avatarColors[avatarId] ?? WireframeLayoutConstants.wireframeAccent;
  }

  IconData _getAvatarIcon(String avatarId) {
    final avatarIcons = {
      'person': Icons.person,
      'face': Icons.face,
      'account_circle': Icons.account_circle,
      'sentiment_satisfied': Icons.sentiment_satisfied,
      'emoji_people': Icons.emoji_people,
    };
    return avatarIcons[avatarId] ?? Icons.person;
  }
}

/// Desktop content area component
class WireframeDesktopContentArea extends StatelessWidget {
  final String selectedSection;
  final String desktopSelectedCaseStudy;
  final List<SocialPost> posts;
  final ScrollController scrollController;
  final Function(String) onCaseStudySelected;
  final VoidCallback? onBackPressed;
  final VoidCallback? onBackFromSettings;

  const WireframeDesktopContentArea({
    Key? key,
    required this.selectedSection,
    required this.desktopSelectedCaseStudy,
    required this.posts,
    required this.scrollController,
    required this.onCaseStudySelected,
    this.onBackPressed,
    this.onBackFromSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedSection == 'Projects') {
      if (desktopSelectedCaseStudy.isNotEmpty) {
        return Column(
          children: [
            // Back button header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 8.0,
                right: WireframeLayoutConstants.spacingStandard,
                top: WireframeLayoutConstants.spacingSmall,
                bottom: WireframeLayoutConstants.spacingSmall,
              ),
              child: Row(
                children: [
                  ClickableWidget(
                    onTap: () => onCaseStudySelected(
                        ''), // This will close the case study
                    child: Container(
                      padding:
                          EdgeInsets.all(WireframeLayoutConstants.spacingTiny),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: WireframeLayoutConstants.wireframeAccent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Back to Projects',
                            style: TextStyle(
                              fontSize:
                                  WireframeLayoutConstants.desktopFontSizeBody,
                              color: WireframeLayoutConstants.wireframeAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Case study content
            Expanded(
              child: PortfolioViewer(projectId: desktopSelectedCaseStudy),
            ),
          ],
        );
      } else {
        return _buildDesktopProjectsList();
      }
    } else if (selectedSection == 'About') {
      return WireframeAboutSection(isMobile: false);
    } else if (selectedSection == 'Settings') {
      return WireframeSettingsSection(
        isMobile: false,
        onAnalyticsTap: () {
          // Analytics functionality here
        },
        onBackPressed: onBackFromSettings, // Use the callback
        onThemeChanged: () {
          // This will help with theme updates
        },
      );
    } else {
      return _buildDesktopHomeContent();
    }
  }

  Widget _buildDesktopProjectsList() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DesktopWireframeProjectCard(
                projectId: 'tap-in',
                title: ProjectCardData.getProject('tap-in')['title']!,
                role: ProjectCardData.getProject('tap-in')['role']!,
                description:
                    ProjectCardData.getProject('tap-in')['description']!,
                heroImagePath:
                    ProjectCardData.getProject('tap-in')['heroImage']!,
                onTap: () => onCaseStudySelected('tap-in'),
              ),
              DesktopWireframeProjectCard(
                projectId: 'moments',
                title: ProjectCardData.getProject('moments')['title']!,
                role: ProjectCardData.getProject('moments')['role']!,
                description:
                    ProjectCardData.getProject('moments')['description']!,
                heroImagePath:
                    ProjectCardData.getProject('moments')['heroImage']!,
                onTap: () => onCaseStudySelected('moments'),
              ),
              DesktopWireframeProjectCard(
                projectId: 'core-ai',
                title: ProjectCardData.getProject('core-ai')['title']!,
                role: ProjectCardData.getProject('core-ai')['role']!,
                description:
                    ProjectCardData.getProject('core-ai')['description']!,
                heroImagePath:
                    ProjectCardData.getProject('core-ai')['heroImage']!,
                onTap: () => onCaseStudySelected('core-ai'),
              ),
              DesktopWireframeProjectCard(
                projectId: 'plannie',
                title: ProjectCardData.getProject('plannie')['title']!,
                role: ProjectCardData.getProject('plannie')['role']!,
                description:
                    ProjectCardData.getProject('plannie')['description']!,
                heroImagePath:
                    ProjectCardData.getProject('plannie')['heroImage']!,
                onTap: () => onCaseStudySelected('plannie'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHomeContent() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<SocialPost>>(
            stream: FirestoreService().getPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading posts: ${snapshot.error}'));
              }

              final posts = snapshot.data ?? [];

              if (posts.isEmpty) {
                return Center(
                  child: Text(
                    'No posts yet.',
                    style: TextStyle(
                      fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                      color: WireframeLayoutConstants.wireframeSecondary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.zero,
                itemCount: posts.length, // Remove the +1
                itemBuilder: (context, index) {
                  final post = posts[index]; // Remove the index - 1
                  return _buildDesktopPostItem(post);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopPostItem(SocialPost post) {
    return EnhancedSocialPost(
      post: post,
      isMobile: false,
      onPostUpdated: () {
        // Desktop posts will refresh via StreamBuilder
      },
      onPostDeleted: () {
        // Desktop posts will refresh via StreamBuilder
      },
    );
  }

  Widget _buildDesktopPostActions() {
    return Row(
      children: [
        _buildDesktopPostAction(Icons.favorite_outline, 'Like', '24'),
        SizedBox(width: WireframeLayoutConstants.spacingLarge),
        _buildDesktopPostAction(Icons.chat_bubble_outline, 'Comment', '8'),
        SizedBox(width: WireframeLayoutConstants.spacingLarge),
        _buildDesktopPostAction(Icons.repeat, 'Repost', ''),
        SizedBox(width: WireframeLayoutConstants.spacingLarge),
        _buildDesktopPostAction(Icons.share_outlined, 'Share', ''),
      ],
    );
  }

  Widget _buildDesktopPostAction(IconData icon, String label, String count) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: WireframeColorManager.colors.info,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Text(
          label,
          style: TextStyle(
            fontSize: WireframeLayoutConstants.desktopFontSizeBody,
            color: WireframeColorManager.colors.info,
          ),
        ),
        if (count.isNotEmpty) ...[
          SizedBox(width: WireframeLayoutConstants.spacingTiny),
          Text(
            count,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.desktopFontSizeBody,
              color: WireframeColorManager.colors.info,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Color _getAvatarColor(String avatarId) {
    final avatarColors = {
      'person': WireframeLayoutConstants.wireframeAccent,
      'face': WireframeLayoutConstants.wireframeSuccess,
      'account_circle': WireframeLayoutConstants.wireframeDanger,
      'sentiment_satisfied': Color(0xFF6F42C1),
      'emoji_people': Color(0xFFFD7E14),
    };
    return avatarColors[avatarId] ?? WireframeLayoutConstants.wireframeAccent;
  }

  IconData _getAvatarIcon(String avatarId) {
    final avatarIcons = {
      'person': Icons.person,
      'face': Icons.face,
      'account_circle': Icons.account_circle,
      'sentiment_satisfied': Icons.sentiment_satisfied,
      'emoji_people': Icons.emoji_people,
    };
    return avatarIcons[avatarId] ?? Icons.person;
  }
}

/// Content area utilities and helpers
class WireframeContentUtils {
  /// Default posts for demo purposes
  static List<Map<String, dynamic>> getDefaultPosts() {
    return [
      {
        'author': 'Aminah',
        'time': '19 hours ago',
        'content':
            'Jeff is a UX/UI Designer from Portland, Oregon. Check out his projects!',
        'avatar': 'person'
      },
      {
        'author': 'Jeffjitsu',
        'time': '19 hours ago',
        'content':
            'Make sure to poke around his profile! It\'s full of fun interactive elements, themes, and modes!',
        'avatar': 'face'
      },
    ];
  }

  /// Get post action icons
  static Map<String, IconData> getPostActionIcons() {
    return {
      'like': Icons.favorite_outline,
      'comment': Icons.chat_bubble_outline,
      'repost': Icons.repeat,
      'share': Icons.share_outlined,
      'bookmark': Icons.bookmark_outline,
      'more': Icons.more_vert,
    };
  }

  /// Get avatar configuration
  static Map<String, Map<String, dynamic>> getAvatarConfig() {
    return {
      'person': {
        'icon': Icons.person,
        'color': WireframeLayoutConstants.wireframeAccent,
      },
      'face': {
        'icon': Icons.face,
        'color': WireframeLayoutConstants.wireframeSuccess,
      },
      'account_circle': {
        'icon': Icons.account_circle,
        'color': WireframeLayoutConstants.wireframeDanger,
      },
      'sentiment_satisfied': {
        'icon': Icons.sentiment_satisfied,
        'color': Color(0xFF6F42C1),
      },
      'emoji_people': {
        'icon': Icons.emoji_people,
        'color': Color(0xFFFD7E14),
      },
    };
  }

  /// Format time strings for posts
  static String formatPostTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Validate content types
  static bool isValidContentType(String type) {
    const validTypes = ['home', 'projects', 'about', 'case_study', 'contact'];
    return validTypes.contains(type);
  }

  /// Get content type display name
  static String getContentTypeDisplayName(String type) {
    const displayNames = {
      'home': 'Home',
      'projects': 'Projects',
      'about': 'About',
      'case_study': 'Case Study',
      'contact': 'Contact',
    };
    return displayNames[type] ?? type;
  }
}
