import 'package:flutter/material.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
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
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/themes/wireframe/widgets/theme_responsive_icon.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_about_section.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_custom_logo.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/wireframe_comment_modal.dart';
import 'components/wireframe_content_areas.dart';
import 'components/wireframe_profile_header.dart';
import 'widgets/wireframe_settings_section.dart';
import 'wireframe_layout_constants.dart';

class WireframeMobileMockup extends StatelessWidget {
  // State management props
  final String mobileCurrentView;
  final String selectedCaseStudy;
  final int mobileNavIndex;

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
  final Function(String) onCaseStudySelected;
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
    required this.selectedCaseStudy,
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
    required this.onCaseStudySelected,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mobile Header
          _buildSectionHeader('Mobile', ''),

          SizedBox(height: 20),

          /// Mobile Device Frame with iPhone Image and drop shadow
          Container(
            width: WireframeLayoutConstants.iPhoneFrameWidth,
            height: WireframeLayoutConstants.iPhoneFrameHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                  offset: Offset(0, 16),
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Your mobile content FIRST (behind the iPhone frame)
                Positioned(
                  top: 8, // Position where iPhone screen would be
                  left: 10, // Position where iPhone screen would be
                  width: 295, // Fixed width instead of right: 25
                  height: 620, // Fixed height instead of bottom: 85
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
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
                                        WireframeLayoutConstants
                                            .iPhoneFrameWidth,
                                    child: Container(
                                      width: WireframeLayoutConstants
                                          .iPhoneFrameWidth,
                                      child: Column(
                                        children: [
                                          // Mobile Status Bar - FIXED at top
                                          _buildMobileStatusBar(),

                                          // Top app bar section with hamburger and title - FIXED at top
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  WireframeLayoutConstants
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
                                                      onShowMobileDrawer(
                                                          context),
                                                  child: Icon(
                                                    Icons.menu,
                                                    size: 24,
                                                    color:
                                                        WireframeLayoutConstants
                                                            .wireframeAccent,
                                                  ),
                                                ),

                                                SizedBox(
                                                    width:
                                                        WireframeLayoutConstants
                                                            .spacingStandard),

                                                // Logo
                                                WireframeCustomLogo(
                                                  isMobile: true,
                                                  width: 120,
                                                  height: 28,
                                                ),

                                                Spacer(),

                                                // Right side icons (notification and profile)
                                               
                                                SizedBox(width: WireframeLayoutConstants.spacingMedium),
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:WireframeLayoutConstants .wireframeAccent.withAlpha(0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // SCROLLABLE CONTENT AREA
                                          if (mobileCurrentView == 'case_study')
                                            // Case study view - keep original behavior
                                            Expanded(
                                              child: WireframeMobileContentArea(
                                                currentView: mobileCurrentView,
                                                selectedCaseStudy:
                                                    selectedCaseStudy,
                                                posts: posts,
                                                scrollController:
                                                    mobileScrollController,
                                                onCaseStudySelected:
                                                    onCaseStudySelected,
                                                onShowMobileContactModal:
                                                    onShowMobileContactModal,
                                              ),
                                            )
                                          else if (mobileCurrentView =='settings')
                                            // Settings view - direct rendering without navigation/profile
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                color: WireframeColorManager
                                                    .colors.background,
                                                child: WireframeSettingsSection(
                                                  isMobile: true,
                                                  onAnalyticsTap:
                                                      onShowAnalyticsModal !=
                                                              null
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
                                            )
                                          else
                                            // Normal views with sticky navigation
                                            Expanded(
                                              child: CustomScrollView(
                                                controller:
                                                    mobileScrollController,
                                                slivers: [
                                                  if (mobileCurrentView !=
                                                      'settings')
                                                    SliverToBoxAdapter(
                                                      child: Stack(
                                                        children: [
                                                          // Profile header
                                                          WireframeProfileHeader(
                                                            isMobile: true,
                                                            currentView:mobileCurrentView,
                                                            onContactTap: () =>onShowMobileContactModal?.call(),
                                                            onLinkedInTap: () => _launchLinkedIn(),
                                                            onResumeTap: () => _launchResume(),
                                                            onAvatarTap: onShowAvatarFullScreen,
                                                            onMenuTap: () =>onShowMobileDrawer(context),
                                                          ),

                                                          // Floating avatar that scrolls with content
                                                          Positioned(
                                                            top:30, // Position relative to profile header
                                                            left: 30,
                                                            child:
                                                                WireframeFloatingAvatar(
                                                              size: 60,
                                                              onTap:
                                                                  onShowAvatarFullScreen,
                                                            ),
                                                          ),

                                                          // Floating header icons that scroll with content
                                                          Positioned(
                                                            top: 70,
                                                            right: 16,
                                                            child:
                                                                WireframeHeaderIcons(
                                                              isMobile: true,
                                                              iconSize: 32,
                                                              spacing: 8,
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
                                                        WireframeLayoutConstants.wireframeWhite,
                                                    elevation: 0,
                                                    toolbarHeight: 42,
                                                    automaticallyImplyLeading: false,
                                                    flexibleSpace: Container(
                                                      padding:EdgeInsets.symmetric(horizontal:WireframeLayoutConstants.spacingTiny,vertical: 4,),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                            children: [_buildMobileNavItem('Home', 'home'),
                                                              _buildMobileNavItem('Projects','projects'),
                                                              _buildMobileNavItem('About','about'),
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
                                                      color:
                                                          WireframeColorManager
                                                              .colors.border,
                                                      margin:
                                                          EdgeInsets.symmetric(
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
                                    commentSlideAnimation:
                                        commentSlideAnimation,
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
                                    animationController:
                                        contactAnimationController,
                                    onClose: onHideMobileContactModal ??
                                        () {}, // Fix callback
                                  ),
                                ),

                              // Analytics overlay - New Modal Style
                              if (showMobileAnalyticsOverlay)
                                Positioned.fill(
                                  child: WireframeMobileAnalyticsModal(
                                    slideAnimation: analyticsSlideAnimation,
                                    animationController:
                                        analyticsAnimationController,
                                    onClose: onHideMobileAnalyticsModal ??
                                        () {}, // Fix callback
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

                // iPhone frame ON TOP (masks around the content)
                Positioned.fill(
                  child: IgnorePointer(
                    // This lets touches pass through to content below
                    child: Transform.scale(
                      scale: 1.027,
                      child: Image.asset(
                        'assets/iphone14_black.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE8D5C4), // iPhone beige color
                                width: 20,
                              ),
                              borderRadius: BorderRadius.circular(35),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Avatar full-screen overlay - CONSTRAINED TO DEVICE SIZE
                if (showAvatarFullScreen)
                  Positioned(
                    top: 5, // Match the device content positioning
                    left: 10,
                    width: 290, // Match device width
                    height: 623, // Match device height
                    child: ClickableWidget(
                      onTap: onHideAvatarFullScreen,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius:
                              BorderRadius.circular(40), // Match device corners
                        ),
                        child: Stack(
                          children: [
                            // Full-screen avatar image
                            Center(
                              child: Container(
                                width: 250, // Constrained width
                                height: 250, // Constrained height
                                child: Image.asset(
                                  'assets/me_avatar.png',
                                  fit: BoxFit
                                      .cover, // Changed to cover for better fit
                                  alignment: Alignment.center,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: WireframeLayoutConstants
                                            .wireframeAccent,
                                        borderRadius: BorderRadius.circular(
                                            125), // Circular fallback
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 120,
                                          color: WireframeColorManager
                                              .colors.surface,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Close button
                            Positioned(
                              top: 20, // Closer to top edge
                              right: 20,
                              child: ClickableWidget(
                                onTap: onHideAvatarFullScreen,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 20),

          
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
                // Drawer content
                Transform.translate(
                  offset:
                      Offset((drawerAnimationController.value - 1) * 160, 0),
                  child: ClickableWidget(
                    onTap: () {}, // Prevent tap from bubbling up to parent
                    child: Container(
                      width: 160,
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
                            padding: EdgeInsets.only(left: 20, top: 40),
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
                                      height: WireframeLayoutConstants.spacingMedium),

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
                                      height: WireframeLayoutConstants.spacingMedium),

                                  // Projects (replacing Comments)
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.displayLine,
                                    'Projects',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onMobileNavigation(1); // Navigate to projects
                                    },
                                  ),
                                  SizedBox(height: WireframeLayoutConstants.spacingMedium),

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
                                      height: WireframeLayoutConstants.spacingMedium),

                                  // Settings
                                  _buildDrawerButtonSVG(
                                    SvgIconPaths.settings3Line,
                                    'Settings',
                                    WireframeColorManager.colors.secondary,
                                    () {
                                      onHideMobileDrawer();
                                      onMobileNavigation(4); // Navigate to settings
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
                                      onMobileNavigation(3); // Navigate to about
                                    },
                                  ),
                                  SizedBox(
                                      height: WireframeLayoutConstants.spacingMedium),

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

  // Helper method to get project card data
  Map<String, String> _getProjectCardData(String projectId) {
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
          delegate: SliverChildListDelegate([
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
              description:
                  ProjectCardData.getProject('moments')['description']!,
              heroImagePath:
                  ProjectCardData.getProject('moments')['heroImage']!,
              onTap: () => onCaseStudySelected('moments'),
            ),
            MobileWireframeProjectCard(
              projectId: 'core-ai',
              title: ProjectCardData.getProject('core-ai')['title']!,
              role: ProjectCardData.getProject('core-ai')['role']!,
              description:
                  ProjectCardData.getProject('core-ai')['description']!,
              heroImagePath:
                  ProjectCardData.getProject('core-ai')['heroImage']!,
              onTap: () => onCaseStudySelected('core-ai'),
            ),
            MobileWireframeProjectCard(
              projectId: 'plannie',
              title: ProjectCardData.getProject('plannie')['title']!,
              role: ProjectCardData.getProject('plannie')['role']!,
              description:
                  ProjectCardData.getProject('plannie')['description']!,
              heroImagePath:
                  ProjectCardData.getProject('plannie')['heroImage']!,
              onTap: () => onCaseStudySelected('plannie'),
            ),
          ]),
        );

      case 'about':
        return SliverToBoxAdapter(
          child: Container(
            height: 600, // Give it a fixed height to ensure it shows
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
