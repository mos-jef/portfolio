import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_viewer.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/cards/wireframe_project_cards.dart';
import 'package:portfolio_website/themes/wireframe/components/header_icons.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/enhanced_social_post.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_about_section.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_custom_logo.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_settings_section.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/wireframe_comment_modal.dart';
import 'components/wireframe_floating_actions.dart';
import 'components/wireframe_navigation.dart';
import 'components/wireframe_profile_header.dart';
import 'wireframe_layout_constants.dart';

class WireframeDesktopMockup extends StatelessWidget {
  // State management props
  final String selectedSection;
  final String hoveredItem;
  final String desktopCurrentView;
  final String desktopSelectedCaseStudy;

  // Overlay states
  final bool showDesktopInlineComment;
  final bool showDesktopAvatarFullScreen;
  final VoidCallback onShowDesktopAvatarFullScreen;
  final VoidCallback onHideDesktopAvatarFullScreen;

  // Controllers
  final TextEditingController desktopCommentController;
  final TextEditingController mobileNameController;
  final TextEditingController mobileEmailController;
  final ScrollController desktopScrollController;

  // Comment state
  final int commentStep;
  final String selectedAvatar;

  // Data
  final List<SocialPost> posts;

  // Callbacks
  final Function(String) onSectionChanged;
  final Function(String) onHoveredItemChanged;
  final Function(String) onDesktopCaseStudySelected;
  final VoidCallback onShowInlineDesktopCommentModal;
  final VoidCallback onHideInlineDesktopCommentModal;
  final VoidCallback onAddDesktopComment;
  final Function(int) onUpdateCommentStep;
  final Function(String) onUpdateSelectedAvatar;
  final Function(BuildContext)? onShowAnalyticsModal;
  final VoidCallback? onBackFromSettings;
  final Function(BuildContext)? onShowContactModal;

  const WireframeDesktopMockup({
    Key? key,
    required this.selectedSection,
    required this.hoveredItem,
    required this.desktopCurrentView,
    required this.desktopSelectedCaseStudy,
    required this.showDesktopInlineComment,
    required this.desktopCommentController,
    required this.mobileNameController,
    required this.mobileEmailController,
    required this.desktopScrollController,
    required this.commentStep,
    required this.selectedAvatar,
    required this.posts,
    required this.onSectionChanged,
    required this.onHoveredItemChanged,
    required this.onDesktopCaseStudySelected,
    required this.onShowInlineDesktopCommentModal,
    required this.onHideInlineDesktopCommentModal,
    required this.onAddDesktopComment,
    required this.onUpdateCommentStep,
    required this.onUpdateSelectedAvatar,
    required this.showDesktopAvatarFullScreen,
    required this.onShowDesktopAvatarFullScreen,
    required this.onHideDesktopAvatarFullScreen,
    this.onShowAnalyticsModal,
    this.onBackFromSettings,
    this.onShowContactModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Desktop Header
          _buildSectionHeader('Desktop', ''),

          const SizedBox(height: 20),

          // Desktop MacBook Frame
          Expanded(
            child: AspectRatio(
              aspectRatio: 16 /
                  10, // Adjust this to change MacBook proportions (width/height)
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 50,
                      offset: const Offset(0, 20),
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Desktop content with explicit width/height control
                    Positioned(
                      top: 75, // Vertical position from top
                      left: 30, // Horizontal position from left
                      child: Container(
                        width:
                            980, // EXACT WIDTH: Change this to make wider/narrower
                        height:
                            610, // EXACT HEIGHT: Change this to make taller/shorter
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: WireframeColorManager.colors.onPrimary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: WireframeColorManager.colors.border,
                              width: 2),
                        ),
                        child: Column(
                          children: [
                            // Desktop Content
                            Expanded(
                              child: Row(
                                children: [
                                  // Left Sidebar
                                  _buildLeftSidebar(),

                                  // Main Content
                                  Expanded(
                                    flex: desktopSelectedCaseStudy.isNotEmpty
                                        ? 3
                                        : 2,
                                    child: Stack(
                                      children: [
                                        // Main scrollable content - hide when comment modal is open
                                        if (!showDesktopInlineComment)
                                          CustomScrollView(
                                            controller: desktopScrollController,
                                            slivers: [
                                              // Profile Header as sliver with floating icons - HIDE FOR SETTINGS
                                              if (selectedSection != 'Settings')
                                                SliverToBoxAdapter(
                                                  child: Stack(
                                                    children: [
                                                      // Profile header
                                                      WireframeProfileHeader(
                                                        isMobile: false,
                                                        currentView:
                                                            selectedSection
                                                                .toLowerCase(),
                                                        onContactTap: () =>
                                                            onShowContactModal
                                                                ?.call(context),
                                                        onLinkedInTap: () =>
                                                            _launchLinkedIn(),
                                                        onResumeTap: () =>
                                                            _launchResume(),
                                                        onAvatarTap:
                                                            onShowDesktopAvatarFullScreen,
                                                      ),

                                                      // Floating header icons that scroll with content
                                                      Positioned(
                                                        top: 200,
                                                        right: 50,
                                                        child:
                                                            WireframeHeaderIcons(
                                                          isMobile: false,
                                                          spacing: 16,
                                                          onContactTap: () =>
                                                              onShowContactModal
                                                                  ?.call(
                                                                      context), // FIXED: Use the callback parameter
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

                                              // Navigation as sliver
                                              SliverToBoxAdapter(
                                                child:
                                                    WireframeDesktopNavigation(
                                                  selectedSection:
                                                      selectedSection,
                                                  onSectionChanged:
                                                      onSectionChanged,
                                                ),
                                              ),

                                              // Separator line as sliver
                                              SliverToBoxAdapter(
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      WireframeLayoutConstants
                                                          .wireframeBorder,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                ),
                                              ),

                                              // REPLACE CONTENT AREA WITH DIRECT SLIVER CONTENT
                                              ..._buildDesktopContentSlivers(
                                                  context),
                                            ],
                                          ),

                                        // Inline comment modal - show when active
                                        if (showDesktopInlineComment)
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: WireframeColorManager
                                                .colors.onPrimary,
                                            child: Stack(
                                              children: [
                                                // Content area with top padding to avoid close button
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 60,
                                                    left: 24,
                                                    right: 24,
                                                    bottom: 24,
                                                  ),
                                                  child:
                                                      WireframeDesktopCommentModal(
                                                    commentController:
                                                        desktopCommentController,
                                                    nameController:
                                                        mobileNameController,
                                                    emailController:
                                                        mobileEmailController,
                                                    commentStep: commentStep,
                                                    selectedAvatar:
                                                        selectedAvatar,
                                                    onAddComment:
                                                        onAddDesktopComment,
                                                    onUpdateStep:
                                                        onUpdateCommentStep,
                                                    onUpdateAvatar:
                                                        onUpdateSelectedAvatar,
                                                  ),
                                                ),

                                                // Close button in top right
                                                Positioned(
                                                  top: 16,
                                                  right: 16,
                                                  child: IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: WireframeLayoutConstants
                                                            .wireframeSecondary),
                                                    onPressed:
                                                        onHideInlineDesktopCommentModal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        // Floating Comment Button - Show unless in Settings, About, or Projects
                                        if (!['Settings', 'About', 'Projects'].contains(selectedSection) &&
                                            desktopSelectedCaseStudy.isEmpty &&
                                            !showDesktopInlineComment)
                                          Positioned(
                                            bottom: 30,
                                            right: 30,
                                            child: SimpleFloatingCommentButton(
                                              onTap:onShowInlineDesktopCommentModal,
                                              hasAnimation: true,
                                              hasEnhancedShadow: true,
                                              animationDuration:Duration(milliseconds: 300),
                                              size: 56.0,
                                              hasPulseAnimation: true,
                                              hasHoverAnimation: true,
                                            ),
                                          ),

                                        // Desktop Avatar full-screen overlay
                                        if (showDesktopAvatarFullScreen)
                                          Positioned.fill(
                                            child: ClickableWidget(
                                              onTap:
                                                  onHideDesktopAvatarFullScreen,
                                              child: Container(
                                                color: Colors.black
                                                    .withValues(alpha: 0.9),
                                                child: Stack(
                                                  children: [
                                                    // Full-screen avatar image
                                                    Center(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child: Image.asset(
                                                          'assets/me_avatar.png',
                                                          fit: BoxFit.contain,
                                                          alignment:
                                                              Alignment.center,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              color: WireframeLayoutConstants
                                                                  .wireframeAccent,
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons.person,
                                                                  size: 150,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),

                                                    // Close button

                                                    Positioned(
                                                      top: 30,
                                                      right: 30,
                                                      child: ClickableWidget(
                                                        onTap:
                                                            onHideDesktopAvatarFullScreen,
                                                        child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withValues(
                                                                    alpha: 0.5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons.close,
                                                            color:
                                                                WireframeColorManager
                                                                    .colors
                                                                    .onPrimary,
                                                            size: 30,
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

                                  // Right Sidebar
                                  Container(
                                    width: desktopSelectedCaseStudy.isNotEmpty
                                        ? 100
                                        : 200,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Color(0xFFE1E5E9))),
                                    ),
                                    child: Container(
                                      color: WireframeColorManager
                                          .colors.onPrimary,
                                      // Blank space for future use
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // MacBook frame ON TOP (masks around the content)
                    Positioned(
                      top:
                          0, // Negative value moves MacBook UP, positive moves DOWN
                      left: 30,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        // This lets touches pass through to content below
                        child: Transform.scale(
                          scale:
                              1.00, // Change this value: 1.0 = normal, 1.2 = 20% larger, 0.8 = 20% smaller
                          child: Image.asset(
                            'assets/chrome_dark.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(
                                        0xFFE8E8E8), // MacBook silver color
                                    width: 20,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Debug overlay (only shows when _debugMacBookAlignment is true)
                    _buildDebugOverlay(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizableBrowserChrome() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingLarge,
        vertical: WireframeLayoutConstants.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: _getBrowserChromeColor(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE1E5E9)),
        ),
      ),
      child: Row(
        children: [
          // Customizable traffic lights
          _buildCustomTrafficLights(),

          const Spacer(),

          // URL bar
          Container(
            width: 200, // Fixed width for demo
            padding: EdgeInsets.symmetric(
              horizontal: WireframeLayoutConstants.spacingMedium,
              vertical: WireframeLayoutConstants.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: WireframeColorManager.colors.onPrimary,
              borderRadius:
                  BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
              border: const Border.fromBorderSide(
                  BorderSide(color: Color(0xFFE1E5E9))),
            ),
            child: const Text(
              'Jeffjitsu.com',
              style: TextStyle(
                color: Color(0xFF6C757D),
                fontSize: 14,
              ),
            ),
          ),

          const Spacer(),

          // Browser actions
          Row(
            children: [
              _buildBrowserButton(Icons.home, null),
              SizedBox(width: WireframeLayoutConstants.spacingMedium),
              _buildBrowserButton(Icons.folder, null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTrafficLights() {
    final dotSize = _getTrafficLightSize();

    return Row(
      children: [
        ClickableWidget(
          onTap: _toggleTrafficLightTheme,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getTrafficLightColor('red'),
            ),
          ),
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getTrafficLightColor('yellow'),
          ),
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getTrafficLightColor('green'),
          ),
        ),
      ],
    );
  }

  Widget _buildBrowserButton(IconData icon, VoidCallback? onPressed) {
    return ClickableWidget(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(WireframeLayoutConstants.spacingTiny),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF6C757D),
        ),
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
        const Spacer(),
        
      ],
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE1E5E9))),
      ),
      child: Column(
        children: [
          // Profile Header (replacing home icon section)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.transparent)),
            ),
            child: Center(
              child: Container(
                width: 240,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 0, 123, 255).withAlpha(0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color.fromARGB(0, 0, 123, 255).withAlpha(0)),
                ),
                child: WireframeCustomLogo(
                  isMobile: false,
                  width: 240,
                  height: 60,
                ),
              ),
            ),
          ),

          // Sidebar Menu
          Expanded(
            child: WireframeDesktopSidebar(
              selectedSection: selectedSection,
              hoveredItem: hoveredItem,
              onSectionChanged: onSectionChanged,
              onHoveredItemChanged: onHoveredItemChanged,
              onResumePressed: () => _launchResume(),
              onLinkedInPressed: () => _launchLinkedIn(),
            ),
          ),
        ],
      ),
    );
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

  // Browser chrome customization state - these would normally be state variables
  final int _trafficLightTheme = 0;

  double _getTrafficLightSize() {
    switch (_trafficLightTheme % 4) {
      case 0:
        return 12.0; // default
      case 1:
        return 10.0; // small
      case 2:
        return 14.0; // medium
      case 3:
        return 16.0; // large
    }
    return 12.0;
  }

  Color _getBrowserChromeColor() {
    switch (_trafficLightTheme % 4) {
      case 0:
        return const Color(0xFFF1F3F4);
      case 1:
        return const Color(0xFF2D3748); // dark
      case 2:
        return const Color(0xFFF0F8FF); // light blue
      case 3:
        return const Color(0xFFF5F5F5); // light gray
    }
    return const Color(0xFFF1F3F4);
  }

  Color _getTrafficLightColor(String type) {
    final theme = _trafficLightTheme % 4;

    switch (type) {
      case 'red':
        return theme == 1 ? const Color(0xFF7F1D1D) : const Color(0xFFFF5F57);
      case 'yellow':
        return theme == 1 ? const Color(0xFF7C2D12) : const Color(0xFFFFBD2E);
      case 'green':
        return theme == 1 ? const Color(0xFF14532D) : const Color(0xFF28CA42);
    }
    return WireframeColorManager.colors.textSecondary;
  }

  void _toggleTrafficLightTheme() {
    // This would normally call setState, but since this is StatelessWidget,
    // we'll need to handle this differently in a future update
    debugPrint('Traffic light theme toggle - would need StatefulWidget');
  }

  // MacBook frame positioning helpers
  double _getMacBookScreenTop() {
    // Adjust this value based on the MacBook image's top bezel
    // Typical values: 15-30 for MacBook images
    return 25.0;
  }

  double _getMacBookScreenLeft() {
    // Adjust this value based on the MacBook image's left bezel
    // Typical values: 20-35 for MacBook images
    return 30.0;
  }

  double _getMacBookScreenRight() {
    // Adjust this value based on the MacBook image's right bezel
    // Should match left for symmetry
    return 30.0;
  }

  double _getMacBookScreenBottom() {
    // Adjust this value based on the MacBook image's bottom bezel
    // MacBooks typically have larger bottom bezels: 60-100
    return 85.0;
  }

  // Optional: Add screen corner radius to match MacBook screen
  double _getMacBookScreenRadius() {
    // MacBook screens have slightly rounded corners
    return 6.0;
  }

  // Debug helper - set to true to see alignment guides
  bool get _debugMacBookAlignment => false; // Change to true for debugging

  Widget _buildDebugOverlay() {
    if (!_debugMacBookAlignment) return const SizedBox.shrink();

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: WireframeColorManager.colors.error, width: 2),
          ),
          child: Column(
            children: [
              Container(
                  height: _getMacBookScreenTop(),
                  color: WireframeColorManager.colors.error
                      .withValues(alpha: 0.3)),
              Expanded(
                child: Row(
                  children: [
                    Container(
                        width: _getMacBookScreenLeft(),
                        color: Colors.blue.withValues(alpha: 0.3)),
                    Expanded(
                        child: Container(
                            color: Colors.green.withValues(alpha: 0.1))),
                    Container(
                        width: _getMacBookScreenRight(),
                        color: Colors.blue.withValues(alpha: 0.3)),
                  ],
                ),
              ),
              Container(
                  height: _getMacBookScreenBottom(),
                  color: WireframeColorManager.colors.error
                      .withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  // Add these methods at the end of the WireframeDesktopMockup class

  List<Widget> _buildDesktopContentSlivers(BuildContext context) {
    if (selectedSection == 'Settings') {
      return [
        SliverToBoxAdapter(
          child: Container(
            height: 500, // Fixed height to prevent layout issues
            child: WireframeSettingsSection(
              isMobile: false,
              onAnalyticsTap: onShowAnalyticsModal != null
                  ? () => onShowAnalyticsModal!(context)
                  : null,
              onBackPressed: onBackFromSettings,
              onThemeChanged: () {
                // Handle theme changes
              },
            ),
          ),
        ),
      ];
    } else if (selectedSection == 'Projects') {
      if (desktopSelectedCaseStudy.isNotEmpty) {
        return [
          // Back button as sliver
          SliverToBoxAdapter(
            child: Container(
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
                    onTap: () => onDesktopCaseStudySelected(''),
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
          ),
          // Case study content as sliver
          SliverFillRemaining(
            child: PortfolioViewer(projectId: desktopSelectedCaseStudy),
          ),
        ];
      } else {
        return [
          SliverToBoxAdapter(
            child: _buildDesktopProjectsList(),
          ),
        ];
      }
    } else if (selectedSection == 'About') {
      return [
        SliverToBoxAdapter(
          child: Container(
            height: 600, // Fixed height like mobile
            child: WireframeAboutSection(isMobile: false),
          ),
        ),
      ];
    } else {
      // Home section with posts
      return [
        StreamBuilder<List<SocialPost>>(
          stream: FirestoreService().getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
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
                child: Center(
                  child: Text(
                    'No posts yet.',
                    style: TextStyle(
                      fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                      color: WireframeLayoutConstants.wireframeSecondary,
                    ),
                  ),
                ),
              );
            }

            // Build posts list as slivers
            final postWidgets = posts
                .map((post) => SliverToBoxAdapter(
                      child: EnhancedSocialPost(
                        post: post,
                        isMobile: false,
                        onPostUpdated: () {
                          // Posts will refresh via StreamBuilder
                        },
                        onPostDeleted: () {
                          // Posts will refresh via StreamBuilder
                        },
                      ),
                    ))
                .toList();

            return SliverList(
              delegate: SliverChildListDelegate(postWidgets
                  .map((w) => (w as SliverToBoxAdapter).child!)
                  .toList()),
            );
          },
        ),
      ];
    }
  }

  Widget _buildDesktopProjectsList() {
    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
      child: Column(
        children: [
          DesktopWireframeProjectCard(
            projectId: 'tap-in',
            title: 'Tap In',
            role:
                'Senior Software Engineer, Senior UX/UI Designer & Researcher for B2C application',
            description:
                'An inclusive mobile app that caters to the increasing demand for a unified integration of diverse Jiu-Jitsu training and cultural aspects.',
            heroImagePath: 'assets/tapin_card.png', // Same as mobile
            onTap: () => onDesktopCaseStudySelected('tap-in'),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingStandard),
          DesktopWireframeProjectCard(
            projectId: 'moments',
            title: 'Moments',
            role: 'UX/UI Designer & Researcher (5-member team)',
            description:
                'A burgeoning B2C social media application aiming to redefine the landscape',
            heroImagePath: 'assets/moments_card.png', // Same as mobile
            onTap: () => onDesktopCaseStudySelected('moments'),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingStandard),
          DesktopWireframeProjectCard(
            projectId: 'core-ai',
            title: 'CoreAi',
            role: 'UX/UI Designer (5-member team)',
            description:
                'An innovative B2B SaaS AI platform that analyzes associate metrics and offers actionable insights for continuous improvement',
            heroImagePath: 'assets/coreai_card.png', // Same as mobile
            onTap: () => onDesktopCaseStudySelected('core-ai'),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingStandard),
          DesktopWireframeProjectCard(
            projectId: 'plannie',
            title: 'Plannie',
            role: 'UX/UI Designer for B2C enhancement project',
            description:
                'Event planning platform that seamlessly connects planners and clients through an intuitive interface',
            heroImagePath: 'assets/plannie_card.png', // Same as mobile
            onTap: () => onDesktopCaseStudySelected('plannie'),
          ),
        ],
      ),
    );
  }
}
