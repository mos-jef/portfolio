// File: lib/themes/wireframe/wireframe_mobile_standalone.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_comment_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_content_areas.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_profile_header.dart';
import 'package:portfolio_website/themes/wireframe/widgets/google_nav_bar.dart'
    as google_nav;
import 'package:portfolio_website/themes/wireframe/widgets/real_time_clock.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';
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

// Comment modal controllers (NEW)
  late AnimationController _commentAnimationController;
  late Animation<Offset> _commentSlideAnimation;
  bool _showMobileCommentOverlay = false;

// Comment form controllers (NEW)
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

    _drawerSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize comment modal animation controller (NEW)
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

// Initialize comment form controllers (NEW)
    _commentController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    _loadPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _drawerAnimationController.dispose();
    _commentAnimationController.dispose(); // NEW
    _commentController.dispose(); // NEW
    _nameController.dispose(); // NEW
    _emailController.dispose(); // NEW
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WireframeColorManager.colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main mobile interface
            Column(
              children: [
                // Status Bar (your exact implementation)
                _buildMobileStatusBar(),

                // App Header with hamburger menu (your exact implementation)
                _buildAppHeader(),

                // Main Content Area (your exact WireframeMobileContentArea)
                Expanded(
                  child: WireframeMobileContentArea(
                    currentView: mobileCurrentView,
                    posts: _posts,
                    scrollController: _scrollController,

                    onCaseStudySelected: (caseStudy) =>
                        _navigateToCaseStudy(caseStudy),

                    onShowMobileContactModal: () {
                      // Handle contact modal
                    },
                  ),
                ),

                // Bottom Navigation (your exact google nav implementation)
                _buildWireframeGoogleNav(),
              ],
            ),

            // Comment modal overlay (when comment button is tapped) (NEW)

            if (_showMobileCommentOverlay) _buildCommentModalOverlay(),

            // Drawer overlay (when hamburger menu is tapped)
            if (_showMobileDrawerOverlay) _buildDrawerOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileStatusBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingMedium,
        vertical: WireframeLayoutConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time (using your real-time clock)
          RealtimeClock(
            format: 'h:mm a',
            textStyle: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBodyLarge,
              fontWeight: FontWeight.w500,
              color: WireframeColorManager.colors.textSecondary,
            ),
          ),
          // Status icons (your exact implementation)
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

  Widget _buildAppHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingStandard,
        vertical: WireframeLayoutConstants.spacingTiny,
      ),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        border: Border(
          bottom: BorderSide(color: WireframeColorManager.colors.border!),
        ),
      ),
      child: Row(
        children: [
          // Hamburger menu (your exact implementation)
          GestureDetector(
            onTap: _toggleDrawer,
            child: SvgIcon(
              assetPath: 'assets/icons/svg/menu_line.svg', // Use your SVG
              size: 24,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(width: WireframeLayoutConstants.spacingMedium),
          // Title
          Expanded(
            child: Text(
              _getViewTitle(mobileCurrentView),
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeTitle,
                fontWeight: FontWeight.bold,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildDrawerOverlay() {
    return GestureDetector(
      onTap: _hideDrawer,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: SlideTransition(
          position: _drawerSlideAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            color: WireframeColorManager.colors.surface,
            child: Column(
              children: [

                // Profile header in drawer
                Container(
                  padding: EdgeInsets.all(20),
                  child: WireframeProfileHeader(
                    isMobile: true,
                    onContactTap: () {
                      // Handle contact tap
                      _hideDrawer();
                    },
                    onLinkedInTap: () {
                      // Handle LinkedIn tap - launch URL
                      _launchLinkedIn();
                      _hideDrawer();
                    },
                    onResumeTap: () {
                      // Handle resume tap - launch URL
                      _launchResume();
                      _hideDrawer();
                    },
                    onAvatarTap: () {
                      // Handle avatar tap
                      _hideDrawer();
                    },
                    currentView: mobileCurrentView,
                  ),
                ),

                // Navigation items
                Expanded(
                  child: ListView(
                    children: [
                      _buildDrawerItem(
                          'Home', 'home', 'assets/icons/svg/home_3_line.svg'),
                      _buildDrawerItem('Projects', 'projects',
                          'assets/icons/svg/components_line.svg'),
                      _buildDrawerItem(
                          'About', 'about', 'assets/icons/svg/user_4_line.svg'),
                      _buildDrawerItem('Settings', 'settings',
                          'assets/icons/svg/settings_3_line.svg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, String view, String iconPath) {
    final isActive = mobileCurrentView == view;

    return GestureDetector(
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
              ? WireframeColorManager.colors.primary.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            SvgIcon(
              assetPath: iconPath,
              size: 24,
              color: isActive
                  ? WireframeColorManager.colors.primary
                  : WireframeColorManager.colors.text,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive
                    ? WireframeColorManager.colors.primary
                    : WireframeColorManager.colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Comment modal methods (NEW)
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

  // Add these methods after the _getViewTitle method

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
    const url = 'https://storage.googleapis.com/uxfolio/643d6d8beaacf70002256d70/Resume_avP.pdf';
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
          // Show comment modal (NEW)
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
        print('Case study not implemented yet: $projectId');
        break;
    }
  }

}


