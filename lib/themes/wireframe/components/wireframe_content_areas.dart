import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_viewer.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/enhanced_social_post.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_about_section.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_settings_section.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cards/wireframe_project_cards.dart';
import '../wireframe_layout_constants.dart';

/// Enhanced drag behavior for content areas with momentum scrolling
class ContentAreaDragBehavior extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final bool isVertical;
  final bool enableMomentum;

  const ContentAreaDragBehavior({
    Key? key,
    required this.child,
    this.controller,
    this.isVertical = true,
    this.enableMomentum = true,
  }) : super(key: key);

  @override
  State<ContentAreaDragBehavior> createState() =>
      _ContentAreaDragBehaviorState();
}

class _ContentAreaDragBehaviorState extends State<ContentAreaDragBehavior>
    with TickerProviderStateMixin {
  Offset? _startPosition;
  double _initialScrollOffset = 0;
  late AnimationController _momentumController;
  Animation<double>? _momentumAnimation;
  double _velocity = 0;

  @override
  void initState() {
    super.initState();
    _momentumController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _momentumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
    _initialScrollOffset = widget.controller?.offset ?? 0;
    _momentumController.stop();
    _velocity = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startPosition != null && widget.controller != null) {
      final delta = widget.isVertical
          ? _startPosition!.dy - details.localPosition.dy
          : _startPosition!.dx - details.localPosition.dx;

      final newOffset = (_initialScrollOffset + delta * 1.2).clamp(
        0.0,
        widget.controller!.position.maxScrollExtent,
      );

      widget.controller!.jumpTo(newOffset);

      // Calculate velocity for momentum
      _velocity = delta * 0.1;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.enableMomentum &&
        widget.controller != null &&
        _velocity.abs() > 1) {
      final targetOffset = (widget.controller!.offset + _velocity * 10).clamp(
        0.0,
        widget.controller!.position.maxScrollExtent,
      );

      _momentumAnimation = Tween<double>(
        begin: widget.controller!.offset,
        end: targetOffset,
      ).animate(CurvedAnimation(
        parent: _momentumController,
        curve: Curves.decelerate,
      ));

      _momentumAnimation!.addListener(() {
        widget.controller!.jumpTo(_momentumAnimation!.value);
      });

      _momentumController.forward(from: 0);
    }

    _startPosition = null;
    _velocity = 0;
  }
}

/// Custom drag scroll behavior for device content isolation
class DeviceContentDragBehavior {
  static Widget wrap({
    required Widget child,
    required ScrollController controller,
    required bool isVertical,
  }) {
    return _DragScrollWidget(
      controller: controller,
      isVertical: isVertical,
      child: child,
    );
  }
}

class _DragScrollWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final bool isVertical;

  const _DragScrollWidget({
    required this.child,
    required this.controller,
    required this.isVertical,
  });

  @override
  State<_DragScrollWidget> createState() => _DragScrollWidgetState();
}

class _DragScrollWidgetState extends State<_DragScrollWidget>
    with TickerProviderStateMixin {
  Offset? _startPosition;
  double _initialScrollOffset = 0;
  late AnimationController _momentumController;
  Animation<double>? _momentumAnimation;
  double _velocity = 0;

  @override
  void initState() {
    super.initState();
    _momentumController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _momentumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
    _initialScrollOffset = widget.controller.offset;
    _momentumController.stop();
    _velocity = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startPosition != null) {
      final delta = widget.isVertical
          ? _startPosition!.dy - details.localPosition.dy
          : _startPosition!.dx - details.localPosition.dx;
      
      final newOffset = (_initialScrollOffset + delta * 1.2).clamp(
        0.0,
        widget.controller.position.maxScrollExtent,
      );
      
      widget.controller.jumpTo(newOffset);
      
      // Calculate velocity for momentum
      _velocity = delta * 0.1;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_velocity.abs() > 1) {
      final targetOffset = (widget.controller.offset + _velocity * 10).clamp(
        0.0,
        widget.controller.position.maxScrollExtent,
      );
      
      _momentumAnimation = Tween<double>(
        begin: widget.controller.offset,
        end: targetOffset,
      ).animate(CurvedAnimation(
        parent: _momentumController,
        curve: Curves.decelerate,
      ));
      
      _momentumAnimation!.addListener(() {
        widget.controller.jumpTo(_momentumAnimation!.value);
      });
      
      _momentumController.forward(from: 0);
    }
    
    _startPosition = null;
    _velocity = 0;
  }
}


/// Mobile content area component
class WireframeMobileContentArea extends StatelessWidget {
  final String currentView;
  final List<SocialPost> posts;
  final ScrollController scrollController;
  final Function(String) onCaseStudySelected;
  final VoidCallback? onShowMobileContactModal;

  final VoidCallback? onAnalyticsTap;

  const WireframeMobileContentArea({
    Key? key,
    required this.currentView,
    required this.posts,
    required this.scrollController,
    required this.onCaseStudySelected,
    this.onShowMobileContactModal,
    this.onAnalyticsTap,
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _notifyMouseEnterDevice(),
      onExit: (_) => _notifyMouseExitDevice(),
      child: Container(
        // COMPLETE isolation
        width: double.infinity,
        height: double.infinity,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // CONSUME ALL SCROLL NOTIFICATIONS - PREVENT BUBBLING
            return true;
          },
          child: SingleChildScrollView(
            // NO CONTROLLER - prevents conflicts
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  void _notifyMouseEnterDevice() {
    print('Mouse entered mobile device content area');
    // Optional: Add callback to parent if needed
  }

  void _notifyMouseExitDevice() {
    print('Mouse exited mobile device content area');
    // Optional: Add callback to parent if needed
  }

  Widget _buildContent(BuildContext context) {
    switch (currentView) {
      case 'projects':
        return _buildProjectsList(context);
      case 'about':
        return WireframeAboutSection(isMobile: true);

      case 'settings':
        return WireframeSettingsSection(
          isMobile: true,
          onAnalyticsTap: onAnalyticsTap,
          onThemeChanged: () {
            // This callback will trigger when themes change
            if (context.mounted) {
              (context as Element).markNeedsBuild();
            }
          },
          onShowMobileContactModal: onShowMobileContactModal,
        );


      default: // home
        return _buildHomeContent();
    }
  }

  Widget _buildProjectsList(BuildContext context) {
    return ListView(
      // No controller - prevents conflicts
      padding: EdgeInsets.zero,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      children: ProjectsRegistry().getAllProjects().map((project) {
        return MobileWireframeProjectCard(
          projectId: project.id,
          title: project.title,
          role: 'UX/UI Designer & Developer',
          description: project.subtitle,
          heroImagePath: project.logoImage.isNotEmpty
              ? project.logoImage
              : 'assets/images/default_project.png',
          onTap: () => onCaseStudySelected(project.id),
        );
      }).toList(),
    );
  }

  


  Widget _buildHomeContent() {
    return ListView.builder(
      // No controller - prevents conflicts
      padding: EdgeInsets.zero,
      physics: AlwaysScrollableScrollPhysics(),
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

/// Desktop content area component with mouse region detection
class WireframeDesktopContentArea extends StatelessWidget {
  final String selectedSection;
  final List<SocialPost> posts;
  final ScrollController scrollController;
  final Function(String) onCaseStudySelected;
  final VoidCallback? onBackPressed;
  final VoidCallback? onBackFromSettings;

  final VoidCallback? onAnalyticsTap;

  const WireframeDesktopContentArea({
    Key? key,
    required this.selectedSection,
    required this.posts,
    required this.scrollController,
    required this.onCaseStudySelected,
    this.onBackPressed,
    this.onBackFromSettings,
    this.onAnalyticsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _notifyMouseEnterDevice(),
      onExit: (_) => _notifyMouseExitDevice(),
      child: Container(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // CONSUME ALL SCROLL NOTIFICATIONS - PREVENT BUBBLING
            return true;
          },
          child: DeviceContentDragBehavior.wrap(
            controller: scrollController,
            isVertical: true,
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  void _notifyMouseEnterDevice() {
    print('🔵 Mouse entered mobile device content area');
  }

  void _notifyMouseExitDevice() {
    print('🔴 Mouse exited mobile device content area');
  }

  Widget _buildContent(BuildContext context) {
    if (selectedSection == 'Projects') {
      return _buildDesktopProjectsList(context);
    } else if (selectedSection == 'About') {
      return WireframeAboutSection(isMobile: false);

    } else if (selectedSection == 'Settings') {
      return WireframeSettingsSection(
        isMobile: false,
        onAnalyticsTap: onAnalyticsTap,
        onBackPressed: onBackFromSettings,
        onThemeChanged: () {
          // This will help with theme updates
        },
      );
    } else {
      return _buildDesktopHomeContent();
    }
  }

  

  Widget _buildDesktopProjectsList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: ProjectsRegistry().getAllProjects().map((project) {
              return DesktopWireframeProjectCard(
                projectId: project.id,
                title: project.title,
                role: 'UX/UI Designer & Developer', // Use consistent role
                description: project.subtitle, // Use subtitle as description
                heroImagePath: project.logoImage.isNotEmpty
                    ? project.logoImage
                    : 'assets/backgroundheader.png',
                onTap: () => _navigateToCaseStudy(context, project.id),
              );
            }).toList(),
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
                // No controller - prevents conflicts
                padding: EdgeInsets.zero,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
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

void _navigateToCaseStudy(BuildContext context, String projectId) {
  switch (projectId) {
    case 'tap-in':
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TapInCaseStudy(),
        ),
      );
      break;
    case 'moments':
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MomentsCaseStudy(),
        ),
      );
      break;
    default:
      print('Case study not implemented yet: $projectId');
      break;
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

class _ContentAreaScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); // ← Changed to prevent bubbling
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
