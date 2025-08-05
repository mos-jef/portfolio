// File: lib/themes/wireframe/wireframe_mobile_standalone.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/themes/wireframe/cards/wireframe_project_cards.dart';
import 'package:portfolio_website/themes/wireframe/components/header_icons.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_comment_modal.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_mobile_contact_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_content_areas.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_profile_header.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/enhanced_social_post.dart';
import 'package:portfolio_website/themes/wireframe/widgets/google_nav_bar.dart'
    as google_nav;
import 'package:portfolio_website/themes/wireframe/widgets/real_time_clock.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_about_section.dart';
import 'package:portfolio_website/themes/wireframe/widgets/wireframe_settings_section.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';
import 'package:portfolio_website/widgets/border_beam.dart';
import 'package:url_launcher/url_launcher.dart';

class WireframeMobileStandalone extends StatefulWidget {
  const WireframeMobileStandalone({Key? key}) : super(key: key);

  @override
  State<WireframeMobileStandalone> createState() =>
      _WireframeMobileStandaloneState();
}

class _WireframeMobileStandaloneState extends State<WireframeMobileStandalone>
    with TickerProviderStateMixin {
  // Navigation state (matching your existing mobile wireframe)
  String mobileCurrentView = 'home';
  String mobilePreviousView = 'home';

  int _mobileNavIndex = 0;

  // Animation controllers (needed for drawer functionality)
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerSlideAnimation;
  bool _showMobileDrawerOverlay = false;

  // Comment modal controllers
  late AnimationController _commentAnimationController;
  late Animation<Offset> _commentSlideAnimation;
  bool _showMobileCommentOverlay = false;

  // NEW: Contact modal controllers
  late AnimationController _contactAnimationController;
  late Animation<Offset> _contactSlideAnimation;
  bool _showMobileContactOverlay = false;

  // NEW: Analytics modal controllers
  late AnimationController _analyticsAnimationController;
  late Animation<Offset> _analyticsSlideAnimation;
  bool _showMobileAnalyticsOverlay = false;

  // Comment form controllers
  late TextEditingController _commentController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  int _commentStep = 0;
  String _selectedAvatar = 'person';

  // Data
  List<SocialPost> _posts = [];

  // Controllers
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Initialize drawer animation controller
    _drawerAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    // FIXED: Proper drawer slide animation (from left edge)
    _drawerSlideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Start off-screen to the left
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize comment modal animation controller
    _commentAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _commentSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _commentAnimationController,
      curve: Curves.easeInOut,
    ));

    // NEW: Initialize contact modal animation controller
    _contactAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _contactSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contactAnimationController,
      curve: Curves.easeInOut,
    ));

    // NEW: Initialize analytics modal animation controller
    _analyticsAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _analyticsSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _analyticsAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize comment form controllers
    _commentController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    _loadPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _drawerAnimationController.dispose();
    _commentAnimationController.dispose();
    _contactAnimationController.dispose(); // NEW
    _analyticsAnimationController.dispose(); // NEW
    _commentController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await FirestoreService().getPosts();
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Error loading posts: $e');
      // Add some default posts if Firestore fails
      setState(() {
        _posts = [
          SocialPost(
            id: '1',
            authorName: 'Jeff',
            authorAvatar: 'person',
            content:
                'Check out my color theme modes, dark/light mode, and Cartoon and NES Themes in the settings!',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
            likeCount: 14,
            commentCount: 2,
            comments: [],
            authorId: 'jeff-author-id',
          ),
        ];
      });
    }
  }

  // NEW: Contact modal methods
  void _showMobileContactModal() {
    setState(() {
      _showMobileContactOverlay = true;
    });
    _contactAnimationController.forward();
  }

  void _hideMobileContactModal() {
    _contactAnimationController.reverse().then((_) {
      setState(() {
        _showMobileContactOverlay = false;
      });
    });
  }

  // NEW: Analytics modal methods
  void _showMobileAnalyticsModal() {
    setState(() {
      _showMobileAnalyticsOverlay = true;
    });
    _analyticsAnimationController.forward();
  }

  void _hideMobileAnalyticsModal() {
    _analyticsAnimationController.reverse().then((_) {
      setState(() {
        _showMobileAnalyticsOverlay = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      print(
          '🔍 Building WireframeMobileStandalone, currentView: $mobileCurrentView');

      return Scaffold(
        backgroundColor:
            WireframeColorManager.colors.background ?? Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              // MAIN CONTENT
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 1. STATUS BAR AREA (50px top space with hamburger)
                  SliverToBoxAdapter(
                    child: Container(
                      height:
                          50, // ADJUSTABLE: More space above UX/UI background
                      color: WireframeColorManager.colors.background ??
                          Colors.black,
                      child: Row(
                        children: [
                          // Hamburger menu (in the top space)
                          ClickableWidget(
                            onTap: _toggleDrawer,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: WireframeColorManager.colors.primary ??
                                    WireframeLayoutConstants.wireframeAccent,
                              ),
                            ),
                          ),
                          Spacer(),
                          // Time and status icons
                          RealtimeClock(
                            format: 'h:mm a',
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: WireframeColorManager.colors.text ??
                                  Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),

                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),

                  // 2. PROFILE SECTION (background image + avatar + text)
                  if (mobileCurrentView != 'settings')
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          // Background image container
                          Container(
                            width: double.infinity,
                            height:
                                280, // ADJUSTABLE: Total profile section height (increased)
                            child: Column(
                              children: [
                                // UX/UI Background image (doesn't go to top anymore)
                                Container(
                                  width: double.infinity,
                                  height:
                                      80, // ADJUSTABLE: Background image height
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/uxui_bg.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // Profile info area (below background)
                                Expanded(
                                  child: Container(
                                    color: WireframeColorManager.colors.surface,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Avatar with BorderBeam (CIRCULAR - positioned over background/profile area)
                          Positioned(
                            top: 40, // ADJUSTABLE: Avatar vertical position
                            left: 20, // ADJUSTABLE: Avatar horizontal position
                            child: Container(
                              width: 80, // ADJUSTABLE: Avatar size
                              height: 80, // ADJUSTABLE: Avatar size
                              child: BorderBeam(
                                duration:
                                    10, // Slower animation like in mockups
                                borderWidth: 3,
                                colorFrom: WireframeColorManager.colors.primary,
                                colorTo:
                                    WireframeColorManager.colors.secondary ??
                                        WireframeColorManager.colors.primary,
                                staticBorderColor:
                                    WireframeColorManager.colors.surface,
                                borderRadius: BorderRadius.circular(
                                    40), // Half of width/height = circular
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/me_avatar.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Profile text (below avatar) - MORE SPACE TO PREVENT CUTOFF
                          Positioned(
                            top:
                                150, // ADJUSTABLE: Text vertical position (more space below avatar)
                            left: 20, // ADJUSTABLE: Text horizontal position
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jeff Anderson',
                                  style: TextStyle(
                                    fontSize: 22, // ADJUSTABLE: Name font size
                                    fontWeight: FontWeight.bold,
                                    color: WireframeColorManager.colors.focused,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        6), // ADJUSTABLE: Spacing between lines
                                Text(
                                  'UX/UI Designer',
                                  style: TextStyle(
                                    fontSize: 16, // ADJUSTABLE: Title font size
                                    fontWeight: FontWeight.w500,
                                    color:
                                        WireframeColorManager.colors.primary ??
                                            WireframeLayoutConstants
                                                .wireframeAccent,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        4), // ADJUSTABLE: Spacing between lines
                                Text(
                                  '"OPEN TO NEW OPPORTUNITIES"',
                                  style: TextStyle(
                                    fontSize:
                                        11, // ADJUSTABLE: Subtitle font size
                                    fontStyle: FontStyle.italic,
                                    color: WireframeColorManager
                                        .colors.onSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Header icons (right side) - ADJUSTABLE POSITIONS AND SIZES
                          Positioned(
                            top:
                                100, // ADJUSTABLE: Icons vertical position  - higher is lower (more from top)
                            right: 15, // ADJUSTABLE: Icons horizontal position
                            child: WireframeHeaderIcons(
                              isMobile: true,
                              iconSize:
                                  40, // ADJUSTABLE: Icon size (reduced for better fit)
                              spacing:
                                  8, // ADJUSTABLE: Spacing between icons (reduced)
                              onContactTap:
                                  _showMobileContactModal, // NOW WORKING!
                              onLinkedInTap: _launchLinkedIn,
                              onResumeTap: _launchResume,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 3. STICKY NAVIGATION
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: WireframeColorManager.colors.surface ??
                        Colors.grey[900],
                    elevation: 0,
                    toolbarHeight: 56,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMobileNavItem('Home', 'home'),
                          _buildMobileNavItem('Projects', 'projects'),
                          _buildMobileNavItem('About', 'about'),
                        ],
                      ),
                    ),
                  ),

                  // 4. SEPARATOR LINE
                  SliverToBoxAdapter(
                    child: Container(
                      height: 1,
                      color: WireframeColorManager.colors.border ??
                          Colors.grey.withOpacity(0.3),
                      margin: EdgeInsets.symmetric(
                        horizontal: WireframeLayoutConstants.spacingMedium,
                      ),
                    ),
                  ),

                  // 5. CONTENT AREA
                  _buildContentSliver(context),
                ],
              ),

              // BOTTOM NAVIGATION
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildWireframeGoogleNav(),
              ),

              // OVERLAYS
              if (_showMobileDrawerOverlay) _buildDrawerOverlay(),
              if (_showMobileCommentOverlay) _buildCommentModalOverlay(),

              // NEW: Contact overlay
              if (_showMobileContactOverlay)
                Positioned.fill(
                  child: WireframeMobileContactModal(
                    slideAnimation: _contactSlideAnimation,
                    animationController: _contactAnimationController,
                    onClose: _hideMobileContactModal,
                  ),
                ),

              // NEW: Analytics overlay
              if (_showMobileAnalyticsOverlay)
                Positioned.fill(
                  child: WireframeMobileAnalyticsModal(
                    slideAnimation: _analyticsSlideAnimation,
                    animationController: _analyticsAnimationController,
                    onClose: _hideMobileAnalyticsModal,
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('❌ Error in WireframeMobileStandalone build: $e');
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Error: $e', style: TextStyle(color: Colors.white)),
        ),
      );
    }
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
                onTap: () => _navigateToCaseStudy(project.id),
              );
            }).toList(),
          ),
        );

      case 'about':
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: WireframeAboutSection(isMobile: true),
          ),
        );

      case 'settings':
        return SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: WireframeSettingsSection(
              isMobile: true,
              onAnalyticsTap: _showMobileAnalyticsModal, // NOW WORKING!
              onThemeChanged: () {
                // Handle theme change
              },
              onShowMobileContactModal: _showMobileContactModal, // NOW WORKING!
            ),
          ),
        );

      case 'home':
      default:
        return SliverList(
          delegate: SliverChildListDelegate(
            _posts.map((post) => _buildMobilePostItem(post)).toList(),
          ),
        );
    }
  }

  Widget _buildMobilePostItem(SocialPost post) {
    return EnhancedSocialPost(
      post: post,
      isMobile: true,
      onPostUpdated: () {
        // Posts will refresh
      },
      onPostDeleted: () {
        // Posts will refresh
      },
    );
  }

  Widget _buildWireframeGoogleNav() {
    return Container(
      height: 60,
      child: google_nav.WireframeSvgNavBar(
        selectedIndex: _mobileNavIndex,
        onTabChange: _handleMobileNavigation,
        items: google_nav.GoogleWireframeNavItems.portfolio(),
        theme: google_nav.WireframeGoogleNavTheme.borderOnlyTheme(),
      ),
    );
  }

  // FIXED DRAWER - Complete working implementation
  Widget _buildDrawerOverlay() {
    return GestureDetector(
      onTap: _hideDrawer,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: SlideTransition(
          position: _drawerSlideAnimation,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: double.infinity,
              decoration: BoxDecoration(
                color: WireframeColorManager.colors.surface ?? Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drawer Header
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: WireframeColorManager.colors.border ??
                              Colors.grey,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: WireframeColorManager.colors.text ??
                                Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu Items (matching mobile mockup)
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildDrawerItem('Home', 'home', Icons.home),
                        _buildDrawerItem('Projects', 'projects', Icons.work),
                        _buildDrawerItem('About', 'about', Icons.person),
                        _buildDrawerItem(
                            'Settings', 'settings', Icons.settings),

                        // Divider
                        Divider(color: WireframeColorManager.colors.border),

                        // Additional actions (like mobile mockup) - NOW WORKING!
                        _buildDrawerActionItem('Analytics', Icons.analytics,
                            () {
                          _hideDrawer();
                          _showMobileAnalyticsModal(); // NOW WORKING!
                        }),
                        _buildDrawerActionItem('Contact', Icons.contact_mail,
                            () {
                          _hideDrawer();
                          _showMobileContactModal(); // NOW WORKING!
                        }),
                        _buildDrawerActionItem('LinkedIn', Icons.link, () {
                          _hideDrawer();
                          _launchLinkedIn();
                        }),
                        _buildDrawerActionItem('Resume', Icons.description, () {
                          _hideDrawer();
                          _launchResume();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, String view, IconData icon) {
    final isActive = mobileCurrentView == view;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            mobileCurrentView = view;
            // Update nav index to match
            switch (view) {
              case 'home':
                _mobileNavIndex = 0;
                break;
              case 'projects':
                _mobileNavIndex = 1;
                break;
              case 'about':
                _mobileNavIndex = 3;
                break;
              case 'settings':
                _mobileNavIndex = 4;
                break;
            }
          });
          _hideDrawer();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isActive
                ? (WireframeColorManager.colors.primary ?? Colors.orange)
                    .withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive
                    ? (WireframeColorManager.colors.primary ?? Colors.orange)
                    : (WireframeColorManager.colors.text ?? Colors.white),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? (WireframeColorManager.colors.primary ?? Colors.orange)
                      : (WireframeColorManager.colors.text ?? Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerActionItem(
      String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color:
                    WireframeColorManager.colors.textSecondary ?? Colors.grey,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      WireframeColorManager.colors.textSecondary ?? Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Comment modal methods
  void _showMobileCommentModal() {
    setState(() {
      _showMobileCommentOverlay = true;
    });
    _commentAnimationController.forward();
  }

  void _hideMobileCommentModal() {
    _commentAnimationController.reverse().then((_) {
      setState(() {
        _showMobileCommentOverlay = false;
      });
    });
  }

  void _resetCommentModal() {
    setState(() {
      _commentStep = 0;
      _commentController.clear();
      _nameController.clear();
      _emailController.clear();
      _selectedAvatar = 'person';
      _showMobileCommentOverlay = false;
    });
  }

  void _updateCommentStep(int step) {
    setState(() {
      _commentStep = step;
    });
  }

  void _updateSelectedAvatar(String avatar) {
    setState(() {
      _selectedAvatar = avatar;
    });
  }

  Future<void> _addMobileComment() async {
    try {
      await FirestoreService().addPost(
        content: _commentController.text,
        authorName:
            _nameController.text.isEmpty ? 'Anonymous' : _nameController.text,
        authorAvatar: _selectedAvatar,
      );
      _resetCommentModal();
      _loadPosts(); // Refresh posts
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Widget _buildCommentModalOverlay() {
    return WireframeMobileCommentModal(
      commentSlideAnimation: _commentSlideAnimation,
      commentAnimationController: _commentAnimationController,
      commentController: _commentController,
      nameController: _nameController,
      emailController: _emailController,
      commentStep: _commentStep,
      selectedAvatar: _selectedAvatar,
      onAddComment: _addMobileComment,
      onResetModal: _resetCommentModal,
      onUpdateStep: _updateCommentStep,
      onUpdateAvatar: _updateSelectedAvatar,
    );
  }

  Widget _buildMobileNavItem(String title, String view) {
    final isActive = mobileCurrentView == view;
    return GestureDetector(
      onTap: () {
        setState(() {
          mobileCurrentView = view;
          // Update the nav index to match the view
          switch (view) {
            case 'home':
              _mobileNavIndex = 0;
              break;
            case 'projects':
              _mobileNavIndex = 1;
              break;
            case 'about':
              _mobileNavIndex = 3;
              break;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive
                ? (WireframeColorManager.colors.primary ?? Colors.orange)
                : (WireframeColorManager.colors.text ?? Colors.white),
          ),
        ),
      ),
    );
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

  void _toggleDrawer() {
    setState(() {
      _showMobileDrawerOverlay = !_showMobileDrawerOverlay;
    });
    if (_showMobileDrawerOverlay) {
      _drawerAnimationController.forward();
    } else {
      _drawerAnimationController.reverse();
    }
  }

  void _hideDrawer() {
    setState(() {
      _showMobileDrawerOverlay = false;
    });
    _drawerAnimationController.reverse();
  }

  void _handleMobileNavigation(int index) {
    setState(() {
      _mobileNavIndex = index;
      // Store previous view before changing
      if (mobileCurrentView != 'settings') {
        mobilePreviousView = mobileCurrentView;
      }

      switch (index) {
        case 0:
          mobileCurrentView = 'home';
          break;
        case 1:
          mobileCurrentView = 'projects';
          break;
        case 2:
          // Show comment modal
          _showMobileCommentModal();
          break;
        case 3:
          mobileCurrentView = 'about';
          break;
        case 4:
          mobileCurrentView = 'settings';
          break;
      }
    });
  }

  String _getViewTitle(String view) {
    switch (view) {
      case 'home':
        return 'Home';
      case 'projects':
        return 'Projects';
      case 'about':
        return 'About';
      case 'settings':
        return 'Settings';
      case 'case_study':
        return 'Case Study';
      default:
        return 'Portfolio';
    }
  }

  void _navigateToCaseStudy(String projectId) {
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
        print('Unknown project ID: $projectId');
    }
  }
}
