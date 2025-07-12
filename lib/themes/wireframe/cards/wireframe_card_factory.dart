import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import '../../../components/projects_registry.dart';
import '../cards/wireframe_case_study_cards.dart';
import '../utils/wireframe_helpers.dart';
// Removed imports for wireframe_project_cards.dart and wireframe_social_cards.dart since they don't exist as static classes

/// Factory class for creating various types of wireframe cards
/// Centralizes card creation logic and provides consistent styling
class WireframeCardFactory {
  WireframeCardFactory._();

  // ===== PROJECT CARD CREATION =====

  /// Creates a list of mobile project cards
  static List<Widget> createMobileProjectCards({
    required Function(String) onProjectSelected,
    bool showSocialStyle = true,
  }) {
    final projects = ProjectsRegistry().getAllProjects();

    return projects.map((project) {
      final projectData = _getProjectCardData(project.id);

      if (showSocialStyle) {
        return _buildMobileSocialCard(
          projectId: project.id,
          title: projectData['title']!,
          role: projectData['role']!,
          description: projectData['description']!,
          heroImagePath: projectData['heroImage']!,
          onTap: () => onProjectSelected(project.id),
        );
      } else {
        return _buildMobileProjectCard(
          projectId: project.id,
          title: project.title,
          subtitle: project.subtitle,
          imagePath: _getProjectThumbnail(project.id),
          onTap: () => onProjectSelected(project.id),
        );
      }
    }).toList();
  }

  /// Creates a list of desktop project cards
  static List<Widget> createDesktopProjectCards({
    required Function(String) onProjectSelected,
    bool showSocialStyle = true,
  }) {
    final projects = ProjectsRegistry().getAllProjects();

    return projects.map((project) {
      final projectData = _getProjectCardData(project.id);

      if (showSocialStyle) {
        return _buildDesktopSocialCard(
          projectId: project.id,
          title: projectData['title']!,
          role: projectData['role']!,
          description: projectData['description']!,
          heroImagePath: projectData['heroImage']!,
          onTap: () => onProjectSelected(project.id),
        );
      } else {
        return _buildDesktopProjectCard(
          projectId: project.id,
          title: project.title,
          subtitle: project.subtitle,
          imagePath: _getProjectThumbnail(project.id),
          onTap: () => onProjectSelected(project.id),
        );
      }
    }).toList();
  }

  // ===== CASE STUDY CARD CREATION =====

  /// Creates a list of case study preview cards
  static List<Widget> createCaseStudyCards({
    required Function(String) onCaseStudySelected,
    bool isMobile = false,
    bool showFullContent = false,
  }) {
    final projects = ProjectsRegistry().getAllProjects();

    return projects.map((project) {
      final projectData = _getProjectCardData(project.id);

      return WireframeCaseStudyCards.buildCaseStudyPreviewCard(
        projectId: project.id,
        title: projectData['title']!,
        subtitle: projectData['role']!,
        description: projectData['description']!,
        heroImagePath: projectData['heroImage']!,
        onTap: () => onCaseStudySelected(project.id),
        isMobile: isMobile,
        showFullContent: showFullContent,
      );
    }).toList();
  }

  /// Creates a list of case study list items
  static List<Widget> createCaseStudyListItems({
    required Function(String) onCaseStudySelected,
    String? selectedCaseStudy,
    bool isMobile = false,
  }) {
    final projects = ProjectsRegistry().getAllProjects();

    return projects.map((project) {
      final projectData = _getProjectCardData(project.id);

      return WireframeCaseStudyCards.buildCaseStudyListItem(
        projectId: project.id,
        title: projectData['title']!,
        subtitle: projectData['role']!,
        onTap: () => onCaseStudySelected(project.id),
        isMobile: isMobile,
        isSelected: selectedCaseStudy == project.id,
      );
    }).toList();
  }

  /// Creates a grid of case study items
  static List<Widget> createCaseStudyGrid({
    required Function(String) onCaseStudySelected,
    bool isMobile = false,
    int crossAxisCount = 2,
  }) {
    final projects = ProjectsRegistry().getAllProjects();

    return projects.map((project) {
      final projectData = _getProjectCardData(project.id);

      return WireframeCaseStudyCards.buildCaseStudyGridItem(
        projectId: project.id,
        title: projectData['title']!,
        subtitle: projectData['role']!,
        heroImagePath: projectData['heroImage']!,
        onTap: () => onCaseStudySelected(project.id),
        isMobile: isMobile,
      );
    }).toList();
  }

  // ===== SOCIAL CARD CREATION =====

  /// Creates social media style posts
  static List<Widget> createSocialPosts({
    required bool isMobile,
    List<Map<String, dynamic>>? customPosts,
  }) {
    final posts = customPosts ?? _getDefaultSocialPosts();

    return posts.map((post) {
      return _buildSocialPost(
        author: post['author']!,
        time: post['time']!,
        content: post['content']!,
        avatar: post['avatar'] ?? 'person',
        likeCount: post['likeCount'] ?? 0,
        commentCount: post['commentCount'] ?? 0,
        isLiked: post['isLiked'] ?? false,
        isMobile: isMobile,
      );
    }).toList();
  }

  /// Creates a user profile card
  static Widget createUserProfileCard({
    required bool isMobile,
    String? avatarPath,
    String? name,
    String? title,
    String? bio,
  }) {
    return _buildUserProfileCard(isMobile: isMobile);
  }

  // ===== UTILITY METHODS =====

  /// Creates cards based on a specific pattern/layout
  static List<Widget> createCardsByPattern({
    required CardPattern pattern,
    required Function(String) onProjectSelected,
    bool isMobile = false,
  }) {
    switch (pattern) {
      case CardPattern.socialFeed:
        return createMobileProjectCards(
          onProjectSelected: onProjectSelected,
          showSocialStyle: true,
        );

      case CardPattern.gridLayout:
        return createCaseStudyGrid(
          onCaseStudySelected: onProjectSelected,
          isMobile: isMobile,
        );

      case CardPattern.listView:
        return createCaseStudyListItems(
          onCaseStudySelected: onProjectSelected,
          isMobile: isMobile,
        );

      case CardPattern.mixedContent:
        return _createMixedContentCards(
          onProjectSelected: onProjectSelected,
          isMobile: isMobile,
        );
    }
  }

  /// Creates themed card sets
  static List<Widget> createThemedCardSet({
    required CardTheme theme,
    required Function(String) onProjectSelected,
    bool isMobile = false,
  }) {
    switch (theme) {
      case CardTheme.professional:
        return createCaseStudyCards(
          onCaseStudySelected: onProjectSelected,
          isMobile: isMobile,
          showFullContent: true,
        );

      case CardTheme.casual:
        return createSocialPosts(isMobile: isMobile);

      case CardTheme.portfolio:
        return createDesktopProjectCards(
          onProjectSelected: onProjectSelected,
          showSocialStyle: false,
        );

      case CardTheme.showcase:
        return createMobileProjectCards(
          onProjectSelected: onProjectSelected,
          showSocialStyle: true,
        );
    }
  }

  // ===== PRIVATE HELPER METHODS =====

  /// Gets project card data for a given project ID
  static Map<String, String> _getProjectCardData(String projectId) {
    final projectData = {
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

    return projectData[projectId] ?? projectData['tap-in']!;
  }

  /// Gets project thumbnail path
  static String? _getProjectThumbnail(String projectId) {
    switch (projectId) {
      case 'tap-in':
        return 'assets/tapin_logo.png';
      case 'moments':
        return 'assets/moments/devices/hero.png';
      case 'core-ai':
        return 'assets/coreai/device1.png';
      case 'plannie':
        return 'assets/plannie/device4.png';
      default:
        return null;
    }
  }

  /// Gets default social posts data
  static List<Map<String, dynamic>> _getDefaultSocialPosts() {
    return [
      {
        'author': 'Aminah',
        'time': '19 hours ago',
        'content':
            'Jeff is a UX/UI Designer from Portland, Oregon. Check out his projects!',
        'avatar': 'person',
        'likeCount': 24,
        'commentCount': 8,
        'isLiked': false,
      },
      {
        'author': 'Jeffjitsu',
        'time': '19 hours ago',
        'content':
            'Make sure to poke around his profile! It\'s full of fun interactive elements, themes, and modes!',
        'avatar': 'face',
        'likeCount': 14,
        'commentCount': 2,
        'isLiked': true,
      },
    ];
  }

  /// Creates mixed content cards combining different types
  static List<Widget> _createMixedContentCards({
    required Function(String) onProjectSelected,
    required bool isMobile,
  }) {
    final mixedCards = <Widget>[];

    // Add user profile card
    mixedCards.add(createUserProfileCard(isMobile: isMobile));

    // Add some social posts
    final socialPosts = createSocialPosts(isMobile: isMobile);
    if (socialPosts.isNotEmpty) {
      mixedCards.addAll(socialPosts.take(2));
    }

    // Add project cards
    final projectCards = createMobileProjectCards(
      onProjectSelected: onProjectSelected,
      showSocialStyle: true,
    );
    mixedCards.addAll(projectCards);

    return mixedCards;
  }

  // ===== CARD BUILDING METHODS =====

  static Widget _buildMobileSocialCard({
    required String projectId,
    required String title,
    required String role,
    required String description,
    required String heroImagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and author info
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: WireframeHelpers.getProjectColor(projectId)
                        .withOpacity(0.1),
                    child: Icon(
                      WireframeHelpers.getProjectIcon(projectId),
                      size: 16,
                      color: WireframeHelpers.getProjectColor(projectId),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jeff Anderson',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        role,
                        style: TextStyle(
                            color: WireframeColorManager.colors.textSecondary,
                            fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Project title
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),

              // Project description
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),

              // Project image placeholder
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: WireframeColorManager.colors.textSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: WireframeColorManager.colors.textSecondary!),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: WireframeColorManager.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDesktopSocialCard({
    required String projectId,
    required String title,
    required String role,
    required String description,
    required String heroImagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and author info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: WireframeHelpers.getProjectColor(projectId)
                        .withOpacity(0.1),
                    child: Icon(
                      WireframeHelpers.getProjectIcon(projectId),
                      size: 20,
                      color: WireframeHelpers.getProjectColor(projectId),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jeff Anderson',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          role,
                          style: TextStyle(
                              color: WireframeColorManager.colors.textSecondary,
                              fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Project title
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 12),

              // Project description
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Project image placeholder
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: WireframeColorManager.colors.textSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: WireframeColorManager.colors.textSecondary!),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 60,
                    color: WireframeColorManager.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildMobileProjectCard({
    required String projectId,
    required String title,
    required String subtitle,
    required String? imagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: WireframeHelpers.getProjectColor(projectId)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: WireframeHelpers.getProjectColor(projectId)),
                ),
                child: Icon(
                  WireframeHelpers.getProjectIcon(projectId),
                  color: WireframeHelpers.getProjectColor(projectId),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                          color: WireframeColorManager.colors.textSecondary,
                          fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: WireframeColorManager.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDesktopProjectCard({
    required String projectId,
    required String title,
    required String subtitle,
    required String? imagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: WireframeHelpers.getProjectColor(projectId)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: WireframeHelpers.getProjectColor(projectId)),
                ),
                child: Icon(
                  WireframeHelpers.getProjectIcon(projectId),
                  color: WireframeHelpers.getProjectColor(projectId),
                  size: 30,
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                    color: WireframeColorManager.colors.textSecondary,
                    fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSocialPost({
    required String author,
    required String time,
    required String content,
    required String avatar,
    required int likeCount,
    required int commentCount,
    required bool isLiked,
    required bool isMobile,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 2),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Icon(
                    avatar == 'sports'
                        ? Icons.sports_martial_arts
                        : Icons.person,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          color: WireframeColorManager.colors.textSecondary,
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked
                      ? WireframeColorManager.colors.error
                      : WireframeColorManager.colors.textSecondary,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text('$likeCount'),
                SizedBox(width: 16),
                Icon(Icons.comment_outlined,
                    color: WireframeColorManager.colors.textSecondary,
                    size: 20),
                SizedBox(width: 4),
                Text('$commentCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildUserProfileCard({required bool isMobile}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: isMobile ? 30 : 40,
              child: Icon(Icons.person, size: isMobile ? 30 : 40),
            ),
            SizedBox(height: 16),
            Text(
              'Jeff Anderson',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'UX/UI Designer & Developer',
              style: TextStyle(
                color: WireframeColorManager.colors.textSecondary,
                fontSize: isMobile ? 12 : 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '"Open to opportunities"',
              style: TextStyle(
                color: WireframeColorManager.colors.onSecondary,
                fontSize: isMobile ? 11 : 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ===== BATCH CREATION METHODS =====

  /// Creates all cards for a complete feed
  static List<Widget> createCompleteFeed({
    required Function(String) onProjectSelected,
    required bool isMobile,
    bool includeUserProfile = true,
    bool includeSocialPosts = true,
    bool includeProjects = true,
  }) {
    final feedCards = <Widget>[];

    // Add user profile at the top
    if (includeUserProfile) {
      feedCards.add(createUserProfileCard(isMobile: isMobile));
    }

    // Add social posts
    if (includeSocialPosts) {
      final socialPosts = createSocialPosts(isMobile: isMobile);
      feedCards.addAll(socialPosts);
    }

    // Add project cards
    if (includeProjects) {
      final projectCards = isMobile
          ? createMobileProjectCards(
              onProjectSelected: onProjectSelected,
              showSocialStyle: true,
            )
          : createDesktopProjectCards(
              onProjectSelected: onProjectSelected,
              showSocialStyle: true,
            );
      feedCards.addAll(projectCards);
    }

    return feedCards;
  }

  /// Creates cards for a specific section
  static List<Widget> createSectionCards({
    required WireframeSection section,
    required Function(String) onProjectSelected,
    required bool isMobile,
    String? selectedItem,
  }) {
    switch (section) {
      case WireframeSection.home:
        return createCompleteFeed(
          onProjectSelected: onProjectSelected,
          isMobile: isMobile,
        );

      case WireframeSection.projects:
        return isMobile
            ? createMobileProjectCards(
                onProjectSelected: onProjectSelected,
                showSocialStyle: true,
              )
            : createDesktopProjectCards(
                onProjectSelected: onProjectSelected,
                showSocialStyle: true,
              );

      case WireframeSection.caseStudies:
        return createCaseStudyCards(
          onCaseStudySelected: onProjectSelected,
          isMobile: isMobile,
          showFullContent: !isMobile,
        );

      case WireframeSection.about:
        return [
          createUserProfileCard(isMobile: isMobile),
          ...createSocialPosts(
            isMobile: isMobile,
            customPosts: _getAboutSocialPosts(),
          ),
        ];
    }
  }

  /// Creates responsive cards based on screen size
  static List<Widget> createResponsiveCards({
    required Function(String) onProjectSelected,
    required double screenWidth,
    CardStyle? style,
  }) {
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    if (isDesktop) {
      return createDesktopProjectCards(
        onProjectSelected: onProjectSelected,
        showSocialStyle: style?.showSocialStyle ?? true,
      );
    } else if (isTablet) {
      return createCaseStudyGrid(
        onCaseStudySelected: onProjectSelected,
        isMobile: false,
        crossAxisCount: 2,
      );
    } else {
      return createMobileProjectCards(
        onProjectSelected: onProjectSelected,
        showSocialStyle: style?.showSocialStyle ?? true,
      );
    }
  }

  /// Gets about section social posts
  static List<Map<String, dynamic>> _getAboutSocialPosts() {
    return [
      {
        'author': 'Jeff Anderson',
        'time': '2 days ago',
        'content':
            'Excited to share my latest UX/UI projects! Always learning and growing in this amazing field.',
        'avatar': 'person',
        'likeCount': 32,
        'commentCount': 12,
        'isLiked': false,
      },
      {
        'author': 'Jeff Anderson',
        'time': '1 week ago',
        'content':
            'Brazilian Jiu-Jitsu teaches me discipline and problem-solving - skills I apply to design every day.',
        'avatar': 'sports',
        'likeCount': 28,
        'commentCount': 5,
        'isLiked': true,
      },
    ];
  }
}

// ===== ENUMS AND CONFIGURATION =====

/// Card pattern types for different layouts
enum CardPattern {
  socialFeed,
  gridLayout,
  listView,
  mixedContent,
}

/// Card theme types for different styling
enum CardTheme {
  professional,
  casual,
  portfolio,
  showcase,
}

/// Wireframe sections
enum WireframeSection {
  home,
  projects,
  caseStudies,
  about,
}

/// Card style configuration
class CardStyle {
  final bool showSocialStyle;
  final bool showFullContent;
  final bool showMetrics;
  final bool showActions;

  const CardStyle({
    this.showSocialStyle = true,
    this.showFullContent = false,
    this.showMetrics = true,
    this.showActions = true,
  });

  /// Professional style for business presentations
  static const professional = CardStyle(
    showSocialStyle: false,
    showFullContent: true,
    showMetrics: true,
    showActions: false,
  );

  /// Casual style for personal portfolios
  static const casual = CardStyle(
    showSocialStyle: true,
    showFullContent: false,
    showMetrics: false,
    showActions: true,
  );

  /// Showcase style for demonstrations
  static const showcase = CardStyle(
    showSocialStyle: true,
    showFullContent: true,
    showMetrics: true,
    showActions: true,
  );
}

/// Card factory configuration
class CardFactoryConfig {
  final CardStyle defaultStyle;
  final bool enableAnimations;
  final bool enableInteractions;
  final Map<String, dynamic> customData;

  const CardFactoryConfig({
    this.defaultStyle = CardStyle.casual,
    this.enableAnimations = true,
    this.enableInteractions = true,
    this.customData = const {},
  });

  /// Default configuration for wireframe theme
  static const wireframeDefault = CardFactoryConfig(
    defaultStyle: CardStyle.casual,
    enableAnimations: true,
    enableInteractions: true,
  );

  /// Configuration for demo purposes
  static const demo = CardFactoryConfig(
    defaultStyle: CardStyle.showcase,
    enableAnimations: true,
    enableInteractions: true,
  );

  /// Configuration for presentations
  static const presentation = CardFactoryConfig(
    defaultStyle: CardStyle.professional,
    enableAnimations: false,
    enableInteractions: false,
  );
}
