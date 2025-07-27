import 'package:flutter/material.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/cards/wireframe_project_cards.dart';
import 'package:portfolio_website/themes/wireframe/components/header_icons.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_floating_avatar.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_mobile_contact_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/enhanced_social_post.dart';
import 'package:portfolio_website/themes/wireframe/widgets/google_nav_bar.dart'
    as google_nav;
import 'package:portfolio_website/themes/wireframe/widgets/real_time_clock.dart';
import 'package:portfolio_website/themes/wireframe/widgets/responsive_device_frame.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/themes/wireframe/widgets/theme_responsive_icon.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_about_section.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_custom_logo.dart';
import 'package:portfolio_website/widgets/scroll_gesture_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'components/wireframe_comment_modal.dart';
import 'components/wireframe_content_areas.dart';
import 'components/wireframe_profile_header.dart';
import 'widgets/wireframe_settings_section.dart';
import 'wireframe_layout_constants.dart';

class WireframeMobileMockup extends StatelessWidget {
  // State management props
  final String mobileCurrentView;
  final int mobileNavIndex;

  // Targeting system
  final GlobalKey? targetKey;

  // Overlay states
  final bool showMobileDrawerOverlay;
  final bool showMobileCommentOverlay;
  final bool showMobileContactOverlay;
  final bool showMobileAnalyticsOverlay;
  final bool showAvatarFullScreen;
  final VoidCallback onShowAvatarFullScreen;
  final VoidCallback onHideAvatarFullScreen;

  // Animation props
  final Animation<Offset> drawerSlideAnimation;
  final Animation<Offset> commentSlideAnimation;
  final Animation<Offset> contactSlideAnimation; //
  final Animation<Offset> analyticsSlideAnimation; //
  final AnimationController commentAnimationController;
  final AnimationController drawerAnimationController;
  final AnimationController contactAnimationController; //
  final AnimationController analyticsAnimationController;

  // Controllers
  final TextEditingController mobileCommentController;
  final TextEditingController mobileNameController;
  final TextEditingController mobileEmailController;
  final ScrollController mobileScrollController;

  // Comment state
  final int commentStep;
  final String selectedAvatar;

  // Data
  final List<SocialPost> posts;

  // Callbacks
  final Function(int) onMobileNavigation;
  final Function(BuildContext) onShowMobileDrawer;
  final VoidCallback onHideMobileDrawer;
  final Function(BuildContext) onShowMobileCommentModal;
  final Function(BuildContext) onShowContactBottomSheet;
  final VoidCallback onHideContactOverlay;
  final VoidCallback onAddMobileComment;
  final VoidCallback onResetCommentModal;
  final Function(int) onUpdateCommentStep;
  final Function(String) onUpdateSelectedAvatar;
  final Function(BuildContext)? onShowAnalyticsModal;
  final VoidCallback? onGoBackFromSettings;
  final VoidCallback? onShowMobileAnalyticsModal;
  final VoidCallback? onHideMobileAnalyticsModal;
  final VoidCallback? onShowMobileContactModal;
  final VoidCallback? onHideMobileContactModal;

  const WireframeMobileMockup({
    Key? key,
    required this.mobileCurrentView,
    required this.mobileNavIndex,
    required this.showMobileDrawerOverlay,
    required this.showMobileCommentOverlay,
    required this.showMobileContactOverlay,
    required this.showMobileAnalyticsOverlay,
    required this.drawerSlideAnimation,
    required this.commentSlideAnimation,
    required this.contactSlideAnimation,
    required this.analyticsSlideAnimation,
    required this.commentAnimationController,
    required this.contactAnimationController,
    required this.analyticsAnimationController,
    required this.mobileCommentController,
    required this.mobileNameController,
    required this.mobileEmailController,
    required this.mobileScrollController,
    required this.commentStep,
    required this.selectedAvatar,
    required this.posts,
    required this.onMobileNavigation,
    required this.onShowMobileDrawer,
    required this.onHideMobileDrawer,
    required this.onShowMobileCommentModal,
    required this.onShowContactBottomSheet,
    required this.onHideContactOverlay,
    required this.onAddMobileComment,
    required this.onResetCommentModal,
    required this.onUpdateCommentStep,
    required this.onUpdateSelectedAvatar,
    required this.drawerAnimationController,
    required this.showAvatarFullScreen,
    required this.onShowAvatarFullScreen,
    required this.onHideAvatarFullScreen,
    this.onShowAnalyticsModal,
    this.onGoBackFromSettings,
    this.onShowMobileAnalyticsModal,
    this.onHideMobileAnalyticsModal,
    this.onShowMobileContactModal,
    this.onHideMobileContactModal,
    this.targetKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mobile Header
          _buildSectionHeader('', ''),

          SizedBox(height: 20),

          /// Mobile Device Frame with iPhone Image and drop shadow - RESPONSIVE VERSION
          Expanded(
            child: IPhoneFrame(
              key: targetKey,
              content: Column(
                children: [
                  // Main content area with overlays
                  Expanded(
                    child: Stack(
                      children: [
                        // Main mobile device content with slide animation
                        AnimatedBuilder(
                          animation: drawerSlideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: drawerSlideAnimation.value *
                                  WireframeLayoutConstants.iPhoneFrameWidth,
                              child: Container(
                                width:
                                    WireframeLayoutConstants.iPhoneFrameWidth,
                                child: Column(
                                  children: [
                                    // Mobile Status Bar - FIXED at top
                                    _buildMobileStatusBar(),

                                    // Top app bar section with hamburger and title - FIXED at top
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: WireframeLayoutConstants
                                            .spacingStandard,
                                        vertical: WireframeLayoutConstants
                                            .spacingTiny,
                                      ),
                                      decoration: BoxDecoration(
                                        color: WireframeLayoutConstants
                                            .wireframeWhite,
                                        // Removed border to eliminate line
                                      ),
                                      child: Row(
                                        children: [
                                          // Hamburger menu
                                          ClickableWidget(
                                            onTap: () =>
                                                onShowMobileDrawer(context),
                                            child: Icon(
                                              Icons.menu,
                                              size: 24,
                                              color: WireframeLayoutConstants
                                                  .wireframeAccent,
                                            ),
                                          ),

                                          SizedBox(
                                              width: WireframeLayoutConstants
                                                  .spacingStandard),

                                          Spacer(),

                                          // Right side icons (notification and profile)
                                          SizedBox(
                                              width: WireframeLayoutConstants
                                                  .spacingMedium),
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: WireframeLayoutConstants
                                                  .wireframeAccent
                                                  .withAlpha(0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // SCROLLABLE CONTENT AREA - UPDATED WITH SCROLL ISOLATION

                                    if (mobileCurrentView == 'case_study')
                                      // Case study view - with scroll isolation
                                      Expanded(
                                        child: ScrollGestureInterceptor(
                                          scrollController: mobileScrollController,
                                          enableScrollIsolation: true,
                                          onScrollStart: () {
                                            print('Mobile case study scroll started');
                                          },
                                          onScrollEnd: () {
                                            print('Mobile case study scroll ended');
                                          },
                                          child: DeviceContentDragBehavior.wrap(
                                            controller: mobileScrollController,
                                            isVertical: true,
                                            child: WireframeMobileContentArea(
                                              currentView: mobileCurrentView,
                                              posts: posts,
                                              scrollController: mobileScrollController,


                                            onCaseStudySelected: (caseStudy) =>
                                                _navigateToCaseStudy(
                                                    context, caseStudy),
                                            onShowMobileContactModal:
                                                onShowMobileContactModal,
                                          ),
                                         ),
                                        ),
                                      )
                                    else if (mobileCurrentView == 'settings')
                                      // Settings view - with scroll isolation
                                      Expanded(
                                        child: ScrollGestureInterceptor(
                                          enableScrollIsolation: true,
                                          onScrollStart: () {
                                            print(
                                                'Mobile settings scroll started');
                                          },
                                          onScrollEnd: () {
                                            print(
                                                'Mobile settings scroll ended');
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: WireframeColorManager
                                                .colors.background,
                                            child: WireframeSettingsSection(
                                              isMobile: true,
                                              onAnalyticsTap:
                                                  onShowAnalyticsModal != null
                                                      ? () =>
                                                          onShowAnalyticsModal!(
                                                              context)
                                                      : null,
                                              onBackPressed:
                                                  onGoBackFromSettings,
                                              onThemeChanged: () {
                                                // Force rebuild when theme changes
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      // Normal views with scroll isolation
                                      Expanded(
                                        child: ScrollGestureInterceptor(
                                          scrollController:
                                              mobileScrollController,
                                          enableScrollIsolation: true,
                                          onScrollStart: () {
                                            print(
                                                'Mobile normal views scroll started: $mobileCurrentView');
                                          },
                                          onScrollEnd: () {
                                            print(
                                                'Mobile normal views scroll ended: $mobileCurrentView');
                                          },
                                          child: CustomScrollView(
                                            controller: mobileScrollController,
                                            slivers: [
                                              if (mobileCurrentView !=
                                                  'settings')
                                                SliverToBoxAdapter(
                                                  child: Stack(
                                                    children: [
                                                      // Profile header
                                                      WireframeProfileHeader(
                                                        isMobile: true,
                                                        currentView:
                                                            mobileCurrentView,
                                                        onContactTap: () =>
                                                            onShowMobileContactModal
                                                                ?.call(),
                                                        onLinkedInTap: () =>
                                                            _launchLinkedIn(),
                                                        onResumeTap: () =>
                                                            _launchResume(),
                                                        onAvatarTap:
                                                            onShowAvatarFullScreen,
                                                        onMenuTap: () =>
                                                            onShowMobileDrawer(
                                                                context),
                                                      ),

                                                      // Floating avatar that scrolls with content
                                                      Positioned(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03, // % from top
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.006, // % from left
                                                        child:
                                                            WireframeFloatingAvatar(
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.03, // e.g. 0.15 is 15% of screen width
                                                          onTap:
                                                              onShowAvatarFullScreen,
                                                        ),
                                                      ),

                                                      // Floating header icons that scroll with content
                                                      Positioned(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.070, // % from top
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.005, // % from right
                                                        child:
                                                            WireframeHeaderIcons(
                                                          isMobile: true,
                                                          iconSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02, // 8% of screen width
                                                          spacing: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.002, // 2% of screen width
                                                          onContactTap: () =>
                                                              onShowMobileContactModal
                                                                  ?.call(), // Fixed to use modal
                                                          onLinkedInTap: () =>
                                                              WireframeHeaderIconsUtils
                                                                  .launchLinkedIn(),
                                                          onResumeTap: () =>
                                                              WireframeHeaderIconsUtils
                                                                  .launchResume(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              // Sticky Navigation (stays below hamburger after scrolling)
                                              SliverAppBar(
                                                pinned: true,
                                                floating: false,
                                                backgroundColor:
                                                    WireframeLayoutConstants
                                                        .wireframeWhite,
                                                elevation: 0,
                                                toolbarHeight: 42,
                                                automaticallyImplyLeading:
                                                    false,
                                                flexibleSpace: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        WireframeLayoutConstants
                                                            .spacingTiny,
                                                    vertical: 4,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          _buildMobileNavItem(
                                                              'Home', 'home'),
                                                          _buildMobileNavItem(
                                                              'Projects',
                                                              'projects'),
                                                          _buildMobileNavItem(
                                                              'About', 'about'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // Separator line (matching desktop)
                                              SliverToBoxAdapter(
                                                child: Container(
                                                  height: 1,
                                                  color: WireframeColorManager
                                                      .colors.border,
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        WireframeLayoutConstants
                                                            .spacingMedium,
                                                  ),
                                                ),
                                              ),

                                              // Mobile Content Area as sliver list
                                              _buildContentSliver(context),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Drawer overlay
                        if (showMobileDrawerOverlay)
                          _buildMobileDrawerOverlay(),

                        // Comment overlay with proper visibility control
                        if (showMobileCommentOverlay)
                          Positioned.fill(
                            child: WireframeMobileCommentModal(
                              commentSlideAnimation: commentSlideAnimation,
                              commentAnimationController:
                                  commentAnimationController,
                              commentController: mobileCommentController,
                              nameController: mobileNameController,
                              emailController: mobileEmailController,
                              commentStep: commentStep,
                              selectedAvatar: selectedAvatar,
                              onAddComment: onAddMobileComment,
                              onResetModal: onResetCommentModal,
                              onUpdateStep: onUpdateCommentStep,
                              onUpdateAvatar: onUpdateSelectedAvatar,
                            ),
                          ),

                        // Contact overlay - New Modal Style
                        if (showMobileContactOverlay)
                          Positioned.fill(
                            child: WireframeMobileContactModal(
                              slideAnimation: contactSlideAnimation,
                              animationController: contactAnimationController,
                              onClose: onHideMobileContactModal ??
                                  () {}, // Fix callback
                            ),
                          ),

                        // Analytics overlay - New Modal Style
                        if (showMobileAnalyticsOverlay)
                          Positioned.fill(
                            child: WireframeMobileAnalyticsModal(
                              slideAnimation: analyticsSlideAnimation,
                              animationController: analyticsAnimationController,
                              onClose: onHideMobileAnalyticsModal ??
                                  () {}, // Fix callback
                            ),
                          ),

                        // Avatar full-screen overlay - FULLY RESPONSIVE
                        if (showAvatarFullScreen)
                          Positioned.fill(
                            // This covers the entire available area responsively
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Get the actual available space
                                final availableWidth = constraints.maxWidth;
                                final availableHeight = constraints.maxHeight;

                                // Calculate responsive sizes
                                final avatarSize = math.min(
                                  availableWidth *
                                      0.6, // 60% of available width
                                  availableHeight *
                                      0.4, // 40% of available height
                                );

                                final closeButtonSize =
                                    availableWidth * 0.09; // % of width
                                final borderRadius =
                                    availableWidth * 0.02; // 8% of width

                                return ClickableWidget(
                                  onTap: onHideAvatarFullScreen,
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(75),
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Full-screen avatar image - responsive size
                                        Center(
                                          child: Container(
                                            width: avatarSize,
                                            height: avatarSize,
                                            child: ClipOval(
                                              child: Image.asset(
                                                'assets/me_avatar.png',
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          WireframeLayoutConstants
                                                              .wireframeAccent,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.person,
                                                        size: avatarSize *
                                                            0.5, // 50% of avatar size
                                                        color:
                                                            WireframeColorManager
                                                                .colors.surface,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Close button - responsive positioning and size
                                        Positioned(
                                          top: availableHeight *
                                              0.03, // 3% from top
                                          right: availableWidth *
                                              0.05, // 5% from right
                                          child: ClickableWidget(
                                            onTap: onHideAvatarFullScreen,
                                            child: Container(
                                              width: closeButtonSize,
                                              height: closeButtonSize,
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withValues(alpha: 0.7),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: math.max(
                                                      1,
                                                      availableWidth *
                                                          0.003), // Responsive border width
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: closeButtonSize *
                                                    0.6, // 60% of button size
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Curved Navigation Bar
                  Container(
                    height: 50,
                    child: _buildWireframeGoogleNav(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.025), // 0.025 is same as 2.5% of screen height
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: WireframeColorManager.colors.text,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildMobileStatusBar([MobileStatusBarTheme? theme]) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingMedium,
        vertical: WireframeLayoutConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color:
            WireframeColorManager.colors.surface, // Add theme-aware background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          RealtimeClock(
            format: 'h:mm a', // Changed to 12-hour format
            textStyle: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBodyLarge,
              fontWeight: FontWeight.w500,
              color: WireframeColorManager.colors.textSecondary,
            ),
          ),

          // Status icons
          Row(
            children: [
              Icon(
                Icons.signal_cellular_4_bar,
                size: 16,
                color: WireframeColorManager.colors.text,
              ),
              SizedBox(width: WireframeLayoutConstants.spacingTiny),
              Icon(
                Icons.wifi,
                size: 16,
                color: WireframeColorManager.colors.text,
              ),
              SizedBox(width: WireframeLayoutConstants.spacingTiny),
              Icon(
                Icons.battery_full,
                size: 16,
                color: WireframeColorManager.colors.text,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWireframeGoogleNav() {
    // Use the SVG-enabled navigation bar
    return google_nav.WireframeSvgNavBar(
      selectedIndex: mobileNavIndex,
      onTabChange: onMobileNavigation,
      items: google_nav.GoogleWireframeNavItems.portfolio(),
      theme: _getNavBarTheme(),
    );
  }

  /// Responsive color theme-ing

  google_nav.WireframeGoogleNavTheme _getNavBarTheme() {
    // Choose/Switch ONE theme by commenting/uncommenting:

    // return google_nav.WireframeGoogleNavTheme.responsiveTheme(); // Filled background
    return google_nav.WireframeGoogleNavTheme
        .borderOnlyTheme(); // Border only, no fill

    // OTHER OPTIONS:
    // return google_nav.WireframeGoogleNavTheme.defaultTheme();
    // return google_nav.WireframeGoogleNavTheme.darkTheme();
    // return google_nav.WireframeGoogleNavTheme.colorfulTheme();
    // return google_nav.WireframeGoogleNavTheme.minimalTheme();
    // return google_nav.WireframeGoogleNavTheme.gradientTheme();
  }

  void _handleNavigationTap(String view) {
    int index = view == 'home'
        ? 0
        : view == 'projects'
            ? 1
            : 3;
    onMobileNavigation(index);
  }

  // URL launching methods
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

  Widget _buildMobileDrawerOverlay() {
    return ClickableWidget(
      onTap: onHideMobileDrawer, // Add outside click to close
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent, // Invisible overlay for outside clicks
        child: AnimatedBuilder(
          animation: drawerAnimationController,
          builder: (context, child) {
            return Row(
              children: [
                // Drawer content - responsive width
                Transform.translate(
                  offset: Offset(
                      (drawerAnimationController.value - 1) *
                          math.min(
                              160, MediaQuery.of(context).size.width * 0.4),
                      0),
                  child: ClickableWidget(
                    onTap: () {},
                    child: Container(
                      width: math.min(
                          160,
                          MediaQuery.of(context).size.width *
                              0.6), // Max 0.6 is 60% of screen
                      height: double.infinity,

                      decoration: BoxDecoration(
                        color: WireframeColorManager.colors.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(2, 0),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Drawer header (without X button)

                          Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width *
                                  0.05, // 5% of screen width
                              top: MediaQuery.of(context).size.height *
                                  0.05, // 5% of screen height
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: WireframeLayoutConstants
                                          .wireframeBorder)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Menu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: WireframeColorManager.colors.text,
                                  ),
                                ),
                                // Removed Spacer() and close button
                              ],
                            ),
                          ),

                          // Drawer content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),

                                  // Contact
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.contacts3Line,
                                    'Contact',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onShowMobileContactModal?.call();
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants
                                          .spacingMedium),

                                  // Analytics
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.chartBar2Line,
                                    'Analytics',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onShowMobileAnalyticsModal?.call();
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants
                                          .spacingMedium),

                                  // Projects (replacing Comments)
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.displayLine,
                                    'Projects',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onMobileNavigation(
                                          1); // Navigate to projects
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants
                                          .spacingMedium),

                                  // Resume
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.documentLine,
                                    'Resume',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      _launchResume();
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants
                                          .spacingMedium),

                                  // Settings
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.settings3Line,
                                    'Settings',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onMobileNavigation(
                                          4); // Navigate to settings
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants
                                          .spacingMedium),

                                  // About
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.userLine,
                                    'About',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onMobileNavigation(
                                          3); // Navigate to about
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants
                                          .spacingMedium),

                                  // LinkedIn
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.linkedinFill,
                                    'LinkedIn',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      _launchLinkedIn();
                                    },
                                  ),

                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color),
                color: WireframeColorManager.colors.onPrimary,
              ),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnalyticsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: WireframeColorManager.colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Site Analytics',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.people, size: 48, color: Colors.blue),
                      SizedBox(height: 12),
                      Text('1,337',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      Text('Total Visitors',
                          style: TextStyle(
                              color:
                                  WireframeColorManager.colors.textSecondary)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('* Demo data for portfolio showcase',
                    style: TextStyle(
                        color: WireframeColorManager.colors.textSecondary,
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build mobile post item
  Widget _buildMobilePostItem(SocialPost post) {
    return EnhancedSocialPost(
      post: post,
      isMobile: true,
      onPostUpdated: () {
        // Mobile posts will refresh via StreamBuilder
      },
      onPostDeleted: () {
        // Mobile posts will refresh via StreamBuilder
      },
    );
  }

  // Helper method to build mobile project card
  Widget _buildMobileProjectCard({
    required String projectId,
    required String title,
    required String role,
    required String description,
    required String heroImagePath,
    required VoidCallback onTap,
  }) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeWhite,
          border:
              Border.all(color: WireframeColorManager.colors.border, width: 1),
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
                            color: WireframeColorManager.colors.focused,
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

            // Title
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingMedium),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: WireframeLayoutConstants.mobileFontSizeLargeTitle,
                  color: WireframeColorManager.colors.text,
                ),
              ),
            ),
            SizedBox(height: WireframeLayoutConstants.spacingTiny),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingMedium),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                  color: WireframeColorManager.colors.text,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: WireframeLayoutConstants.spacingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(String title, String view) {
    final isActive = mobileCurrentView == view;

    return ClickableWidget(
      onTap: () => _handleNavigationTap(view),
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
              fontSize: WireframeLayoutConstants.mobileFontSizeBody,
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

  Widget _buildContentSliver(BuildContext context) {
    switch (mobileCurrentView) {
      case 'projects':
        return SliverList(
          delegate: SliverChildListDelegate(
            ProjectsRegistry().getAllProjects().map((project) {
              return MobileWireframeProjectCard(
                projectId: project.id,
                title: project.title,
                role: 'UX/UI Designer & Developer',
                description: project.subtitle,
                heroImagePath: project.logoImage.isNotEmpty
                    ? project.logoImage
                    : 'assets/backgroundheader.png',
                onTap: () => _navigateToCaseStudy(context, project.id),
              );
            }).toList(),
          ),
        );

      case 'about':
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.6, // 60% of screen height
            child: WireframeAboutSection(isMobile: true),
          ),
        );

      case 'contact':
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Contact Section',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Contact information and form would go here.',
                  style: TextStyle(
                    fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
              ],
            ),
          ),
        );

      case 'settings':
        return SliverFillRemaining(
          hasScrollBody: false,
          child: WireframeSettingsSection(
            isMobile: true,
            onAnalyticsTap: onShowAnalyticsModal != null
                ? () => onShowAnalyticsModal!(context)
                : null,
            onBackPressed: onGoBackFromSettings != null
                ? () => onGoBackFromSettings!()
                : null,
            onShowMobileContactModal: onShowMobileContactModal != null
                ? () => onShowMobileContactModal!()
                : null,
          ),
        );

      case 'home':
      default:
        return StreamBuilder<List<SocialPost>>(
          stream: FirestoreService().getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Text('Error loading posts: ${snapshot.error}'),
                ),
              );
            }

            final posts = snapshot.data ?? [];

            if (posts.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No posts yet.',
                    style: TextStyle(
                      fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                      color: WireframeLayoutConstants.wireframeSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Build posts list
            final postWidgets =
                posts.map((post) => _buildMobilePostItem(post)).toList();
            return SliverList(
              delegate: SliverChildListDelegate(postWidgets),
            );
          },
        );
    }
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

  // Make circles transparent or change color:

  Widget _buildDrawerButtonSVG(
    String svgPath,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // Make transparent
                // color: color.withAlpha(20), // Very light background
                // border: Border.all(color: color, width: 1), // Just border
              ),
              child: Center(
                child: SvgIcon(
                  assetPath: svgPath,
                  size: 18,
                  color: color, // Icon color
                ),
              ),
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            Text(
              label,
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileStatusBarTheme {
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSize;

  const MobileStatusBarTheme({
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w700,
    this.iconSize = 16.0,
  });

  // Predefined themes
  static const MobileStatusBarTheme light = MobileStatusBarTheme(
    textColor: Colors.black,
    iconColor: Colors.black,
    backgroundColor: Colors.transparent,
  );

  static MobileStatusBarTheme dark = MobileStatusBarTheme(
    textColor: WireframeColorManager.colors.onPrimary,
    iconColor: WireframeColorManager.colors.onPrimary,
    backgroundColor: Colors.black,
  );

  static MobileStatusBarTheme wireframe = MobileStatusBarTheme(
    textColor: WireframeColorManager.colors.text, // Using wireframe text color
    iconColor: WireframeColorManager.colors.text,
    backgroundColor: Colors.transparent,
  );

  static const MobileStatusBarTheme colored = MobileStatusBarTheme(
    textColor: Colors.blue,
    iconColor: Colors.green,
    backgroundColor: Color(0xFFF8F9FA),
  );
}
