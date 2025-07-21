import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';
import 'package:portfolio_website/models/theme_provider.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_contact_overlay.dart';
import 'package:portfolio_website/themes/wireframe/components/wireframe_desktop_analytics_modal.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/grid_background.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_desktop_mockup.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_main_theme.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_mobile_mockup.dart';
import 'package:provider/provider.dart';

class WireframeDesktopTheme extends StatefulWidget {
  final bool isScrollableMode;
  final double? fixedHeight;
  final ScrollController? externalScrollController;
  final GlobalKey? mobileTargetKey; //
  final GlobalKey? desktopTargetKey; //
  final GlobalKey? targetKey;

  const WireframeDesktopTheme({
    Key? key,
    this.isScrollableMode = false,
    this.fixedHeight,
    this.externalScrollController,
    this.mobileTargetKey, //
    this.desktopTargetKey, //
    this.targetKey,
  }) : super(key: key);

  @override
  State<WireframeDesktopTheme> createState() => _WireframeDesktopThemeState();
}

class _WireframeDesktopThemeState extends State<WireframeDesktopTheme>
    with TickerProviderStateMixin {
  // Core state management
  String selectedSection = 'Home';
  String hoveredItem = '';
  String desktopPreviousSection = 'Home';
  bool showMobileView = true;
  bool _showAvatarFullScreen = false;
  bool _showDesktopAvatarFullScreen = false;
  bool _isLargeTextMode = false;

  // Mobile navigation state
  String mobileCurrentView = 'home';
  String mobilePreviousView = 'home';
  String selectedCaseStudy = '';
  int _mobileNavIndex = 0;

  // Desktop navigation state
  String desktopCurrentView = 'home';
  String desktopSelectedCaseStudy = '';

  // Overlay states
  bool _showMobileDrawerOverlay = false;
  bool _showMobileCommentOverlay = false;
  bool _showDesktopInlineComment = false;
  bool _showMobileContactOverlay = false;
  bool _showMobileAnalyticsOverlay = false; //
  bool _showDesktopAnalyticsOverlay = false; //
  bool _showBottomGrid = true; // Toggle for grid visibility

  // Target tracking keys for perfect alignment
  final GlobalKey _mobileTargetKey = GlobalKey(debugLabel: 'desktop_theme_mobile_target');
  final GlobalKey _desktopTargetKey = GlobalKey(debugLabel: 'desktop_theme_desktop_target');

  // Dynamic grid controls - matches top section exactly
  double _gridSize = WireframeLayoutConstants.masterGridSize;
  double _gridOpacity = WireframeLayoutConstants.masterGridOpacity;
  double _gridStrokeWidth = WireframeLayoutConstants.masterGridStrokeWidth;
  Color _gridColor = WireframeColorManager.colors.text;

  // Controllers
  final TextEditingController _mobileCommentController =
      TextEditingController();
  final TextEditingController _mobileNameController = TextEditingController();
  final TextEditingController _mobileEmailController = TextEditingController();
  final TextEditingController _desktopCommentController =
      TextEditingController();
  final ScrollController _mobileScrollController = ScrollController();
  final ScrollController _desktopScrollController = ScrollController();

  // Comment modal state
  int _commentStep = 0;
  String _selectedAvatar = '';

  // Animation controllers
  late AnimationController _drawerAnimationController;
  late Animation<Offset> _drawerSlideAnimation;
  late AnimationController _commentAnimationController;
  late Animation<Offset> _commentSlideAnimation;
  late AnimationController _analyticsAnimationController; //
  late Animation<Offset> _analyticsSlideAnimation; //
  late AnimationController _contactAnimationController; //
  late Animation<Offset> _contactSlideAnimation;

  // Mock posts data
  List<Map<String, dynamic>> _posts = [
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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAnalytics();
  }

  void _initializeAnimations() {
    // Initialize drawer animation controller
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _drawerSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.37, 0.0),
    ).animate(CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize comment animation controller
    _commentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _commentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _commentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize analytics animation controller
    _analyticsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _analyticsSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _analyticsAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize contact animation controller
    _contactAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _contactSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _contactAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _initializeAnalytics() async {
    try {
      await AnalyticsService().initialize();
      // Track initial page load
      await AnalyticsService().trackPageView('Portfolio Home');
    } catch (e) {
      print('Error initializing analytics: $e');
    }
  }

  @override
  void dispose() {
    _mobileCommentController.dispose();
    _mobileNameController.dispose();
    _mobileEmailController.dispose();
    _desktopCommentController.dispose();
    _mobileScrollController.dispose();
    _desktopScrollController.dispose();
    _drawerAnimationController.dispose();
    _commentAnimationController.dispose();
    _analyticsAnimationController.dispose(); //
    _contactAnimationController.dispose(); //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🔍 DEBUG: WireframeDesktopTheme.build() called with isScrollableMode: ${widget.isScrollableMode}');

    return widget.isScrollableMode
        ? _buildScrollableContent(context)
        : _buildStandardContent(context);
  }

  Widget _buildScrollableContent(BuildContext context) {
    // For scrollable mode, return just the content without Scaffold
    return LayoutBuilder(builder: _buildContent);
  }

  Widget _buildStandardContent(BuildContext context) {
    // For standard mode, wrap in Scaffold
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(builder: _buildContent),
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen =
        screenSize.width < WireframeLayoutConstants.desktopBreakpoint;

    // Force rebuild when theme changes by reading current theme
    final currentTheme = WireframeColorManager.currentTheme;
    final currentBackground = WireframeColorManager.colors.background;

    if (isSmallScreen) {
      return _buildMobileFallback();
    }

    return Stack(
      children: [
        // Full screen grid background
        if (_showBottomGrid)
          Positioned.fill(
            child: GridBackground(
              gridColor: Color(0xFF202124),
              gridOpacity: _gridOpacity,
              gridSize: _gridSize,
              strokeWidth: _gridStrokeWidth,
              backgroundColor:
                  Color(0xFFF5E9D8), // grid background color for bottom
              child: Container(),
            ),
          ),

        // Content container (without competing background)
        Container(
          width: double.infinity,
          height: widget.fixedHeight ?? double.infinity,
          child: Center(
            child: Container(
              width: 1600, // Change this value to make entire container wider/narrower
              height: widget.fixedHeight != null
                  ? widget.fixedHeight! -
                      (screenSize.height * 0.04) // 4% margins
                  : math.min(screenSize.height * 0.8,
                      900), // 80% of screen height, max 900

              margin: EdgeInsets.symmetric(
                horizontal: math.max(
                  screenSize.width * 0.02, // 2% minimum margin
                  (screenSize.width -
                          (WireframeLayoutConstants.maxContainerWidth *
                              WireframeLayoutConstants.getResponsiveScale(
                                  screenSize.width))) /
                      2,
                ),
                vertical: widget.isScrollableMode
                    ? screenSize.height * 0.02 // 2% of screen height
                    : math.max(
                        screenSize.height * 0.02,
                        (screenSize.height -
                                (800 *
                                    WireframeLayoutConstants.getResponsiveScale(
                                        screenSize.width))) /
                            2),
              ),
              child: Row(
                children: [
                  // Mobile Mockup Section
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: WireframeMobileMockup(
                        // State management props
                        mobileCurrentView: mobileCurrentView,
                        selectedCaseStudy: selectedCaseStudy,
                        mobileNavIndex: _mobileNavIndex,
                        showAvatarFullScreen: _showAvatarFullScreen,
                        onShowAvatarFullScreen: _showAvatarFullScreenMethod,
                        onHideAvatarFullScreen: _hideAvatarFullScreenMethod,
                        onShowMobileAnalyticsModal: _showMobileAnalyticsModal,
                        onHideMobileAnalyticsModal: _hideMobileAnalyticsModal,
                        onShowMobileContactModal: _showMobileContactModal,
                        onHideMobileContactModal: _hideMobileContactModal,
                        showMobileAnalyticsOverlay: _showMobileAnalyticsOverlay,
                        contactSlideAnimation: _contactSlideAnimation,
                        analyticsSlideAnimation: _analyticsSlideAnimation,
                        contactAnimationController: _contactAnimationController,
                        analyticsAnimationController:
                            _analyticsAnimationController,

                        // Overlay states
                        showMobileDrawerOverlay: _showMobileDrawerOverlay,
                        showMobileCommentOverlay: _showMobileCommentOverlay,
                        showMobileContactOverlay: _showMobileContactOverlay,

                        // Animation controllers
                        drawerSlideAnimation: _drawerSlideAnimation,
                        drawerAnimationController: _drawerAnimationController,
                        commentSlideAnimation: _commentSlideAnimation,
                        commentAnimationController: _commentAnimationController,

                        // Controllers
                        mobileCommentController: _mobileCommentController,
                        mobileNameController: _mobileNameController,
                        mobileEmailController: _mobileEmailController,
                        mobileScrollController:
                            widget.externalScrollController ??
                                _mobileScrollController,

                        // Comment state
                        commentStep: _commentStep,
                        selectedAvatar: _selectedAvatar,

                        // Data
                        posts: _posts
                            .map((postData) => _convertToSocialPost(postData))
                            .toList(),

                        // Callbacks
                        onMobileNavigation: _handleMobileNavigation,
                        onCaseStudySelected: _handleCaseStudySelection,
                        onShowMobileDrawer: _showMobileDrawer,
                        onHideMobileDrawer: _hideMobileDrawer,
                        onShowMobileCommentModal: _showMobileCommentModal,
                        onShowContactBottomSheet:
                            _showContactBottomSheetInMobile,
                        onHideContactOverlay: _hideMobileContactOverlay,
                        onAddMobileComment: _addMobileComment,
                        onResetCommentModal: _resetCommentModal,
                        onUpdateCommentStep: _updateCommentStep,
                        onUpdateSelectedAvatar: _updateSelectedAvatar,
                        onGoBackFromSettings: _goBackFromSettings,
                        targetKey: widget.mobileTargetKey,
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    margin: EdgeInsets.symmetric(vertical: 40),
                    color: WireframeColorManager.colors.border,
                  ),

                  // Desktop Mockup Section
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: WireframeDesktopMockup(
                        // State management props
                        selectedSection: selectedSection,
                        hoveredItem: hoveredItem,
                        desktopCurrentView: desktopCurrentView,
                        desktopSelectedCaseStudy: desktopSelectedCaseStudy,

                        // Overlay states
                        showDesktopInlineComment: _showDesktopInlineComment,
                        showDesktopAvatarFullScreen:
                            _showDesktopAvatarFullScreen,
                        onShowDesktopAvatarFullScreen:
                            _showDesktopAvatarFullScreenMethod,
                        onHideDesktopAvatarFullScreen:
                            _hideDesktopAvatarFullScreenMethod,
                        onShowContactModal: _showDesktopContactModal,

                        // Controllers
                        desktopCommentController: _desktopCommentController,
                        mobileNameController: _mobileNameController,
                        mobileEmailController: _mobileEmailController,
                        desktopScrollController:
                            widget.externalScrollController ??
                                _desktopScrollController,

                        // Comment state
                        commentStep: _commentStep,
                        selectedAvatar: _selectedAvatar,

                        // Data
                        posts: _posts
                            .map((postData) => _convertToSocialPost(postData))
                            .toList(),

                        // Callbacks
                        onSectionChanged: _handleSectionChange,
                        onHoveredItemChanged: _updateHoveredItem,
                        onDesktopCaseStudySelected:
                            _handleDesktopCaseStudySelection,
                        onShowInlineDesktopCommentModal:
                            _showInlineDesktopCommentModal,
                        onHideInlineDesktopCommentModal:
                            _hideInlineDesktopCommentModal,
                        onAddDesktopComment: _addDesktopComment,
                        onUpdateCommentStep: _updateCommentStep,
                        onUpdateSelectedAvatar: _updateSelectedAvatar,
                        onBackFromSettings: _goBackFromDesktopSettings,
                        targetKey: widget.desktopTargetKey,
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
  }

  Widget _buildMobileFallback() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio - Wireframe Theme'),
        backgroundColor: WireframeColorManager.colors.surface,
        foregroundColor: WireframeColorManager.colors.text,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.desktop_windows),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Wireframe theme optimized for desktop screens (1200px+)'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: WireframeLayoutConstants.wireframeBg,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.desktop_windows,
                size: 64,
                color: WireframeLayoutConstants.wireframeSecondary,
              ),
              SizedBox(height: 20),
              Text(
                'Wireframe Theme',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: WireframeColorManager.colors.text,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'This theme is optimized for desktop screens',
                style: TextStyle(
                  color: WireframeLayoutConstants.wireframeSecondary,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  themeProvider.toggleNesTheme(false);
                },
                child: Text('Switch to Main Theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Event handlers
  void _handleMobileNavigation(int index) {
    // ✅ Close comment modal if it's open when navigating (but still navigate)
    if (_showMobileCommentOverlay && index != 2) {
      _resetCommentModal();
      // Don't return - continue with navigation below
    }

    setState(() {
      // Store the current view as previous before changing
      if (mobileCurrentView != 'settings') {
        mobilePreviousView = mobileCurrentView;
      }

      switch (index) {
        case 0:
          mobileCurrentView = 'home';
          _mobileNavIndex = 0;
          AnalyticsService().trackPageView('Mobile Home');
          break;
        case 1:
          mobileCurrentView = 'projects';
          _mobileNavIndex = 1;
          AnalyticsService().trackPageView('Mobile Projects');
          break;
        case 2:
          _showMobileCommentModal(context);
          AnalyticsService().trackInteraction('tap', 'comment_button');
          break;
        case 3:
          mobileCurrentView = 'about';
          _mobileNavIndex = 3;
          AnalyticsService().trackPageView('Mobile About');
          break;
        case 4:
          mobileCurrentView = 'settings';
          _mobileNavIndex = 4;
          AnalyticsService().trackPageView('Mobile Settings');
          setState(() {});
          break;
      }
    });
  }

  void _goBackFromSettings() {
    setState(() {
      mobileCurrentView = mobilePreviousView;
      // Update the nav index to match the view
      switch (mobilePreviousView) {
        case 'home':
          _mobileNavIndex = 0;
          AnalyticsService().trackPageView('Mobile Home');
          break;
        case 'projects':
          _mobileNavIndex = 1;
          AnalyticsService().trackPageView('Mobile Projects');
          break;
        case 'about':
          _mobileNavIndex = 3;
          AnalyticsService().trackPageView('Mobile About');
          break;
        default:
          _mobileNavIndex = 0;
          AnalyticsService().trackPageView('Mobile Home');
      }
    });
  }

  void _goBackFromDesktopSettings() {
    setState(() {
      selectedSection =
          desktopPreviousSection; // Go back to the stored previous section
    });
  }

  // Mobile Avatar full-screen methods
  void _showAvatarFullScreenMethod() {
    setState(() {
      _showAvatarFullScreen = true;
    });
  }

  void _hideAvatarFullScreenMethod() {
    setState(() {
      _showAvatarFullScreen = false;
    });
  }

  // Desktop Avatar full-screen methods
  void _showDesktopAvatarFullScreenMethod() {
    setState(() {
      _showDesktopAvatarFullScreen = true;
    });
  }

  void _hideDesktopAvatarFullScreenMethod() {
    setState(() {
      _showDesktopAvatarFullScreen = false;
    });
  }

  void _handleCaseStudySelection(String caseStudyId) {
    setState(() {
      selectedCaseStudy = caseStudyId;
      mobileCurrentView = 'case_study';
    });
  }

  void _handleSectionChange(String section) {
    setState(() {
      // Store the current section as previous before changing (except when going from settings)
      if (selectedSection != 'Settings') {
        desktopPreviousSection = selectedSection;
      }

      selectedSection = section;
      if (section != 'Projects') {
        desktopSelectedCaseStudy = '';
      }

      // Track page view
      AnalyticsService().trackPageView('Desktop $section');
    });
  }

  void _handleDesktopCaseStudySelection(String caseStudyId) {
    setState(() {
      desktopSelectedCaseStudy = caseStudyId;
    });
  }

  void _updateHoveredItem(String item) {
    setState(() {
      hoveredItem = item;
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

  // Modal and overlay methods
  void _showMobileDrawer(BuildContext context) {
    setState(() {
      _showMobileDrawerOverlay = true;
    });
    _drawerAnimationController.forward();
  }

  void _hideMobileDrawer() {
    _drawerAnimationController.reverse().then((_) {
      setState(() {
        _showMobileDrawerOverlay = false;
      });
    });
  }

  void _showMobileCommentModal(BuildContext context) {
    setState(() {
      _showMobileCommentOverlay = true;
    });
    _commentAnimationController.forward();
  }

  void _showContactBottomSheetInMobile(BuildContext context) {
    setState(() {
      _showMobileContactOverlay = !_showMobileContactOverlay;
    });
  }

  void _hideMobileContactOverlay() {
    setState(() {
      _showMobileContactOverlay = false;
    });
  }

  void _showInlineDesktopCommentModal() {
    setState(() {
      _showDesktopInlineComment = true;
      _resetCommentModal();
    });
  }

  void _hideInlineDesktopCommentModal() {
    setState(() {
      _showDesktopInlineComment = false;
      _resetCommentModal();
    });
  }

  void _showAnalyticsModal(BuildContext context) {
    // Analytics modal implementation will be moved to appropriate component
  }

  // Comment methods
  Future<void> _addMobileComment() async {
    if (_mobileCommentController.text.trim().isNotEmpty &&
        _mobileNameController.text.trim().isNotEmpty) {
      try {
        // Update user if needed
        await FirestoreService().updateUser(
          name: _mobileNameController.text.trim(),
          avatar: _selectedAvatar.isEmpty ? 'person' : _selectedAvatar,
        );

        // Create the post in Firestore
        await FirestoreService().addPost(
          content: _mobileCommentController.text.trim(),
          authorName: _mobileNameController.text.trim(),
          authorAvatar: _selectedAvatar.isEmpty ? 'person' : _selectedAvatar,
        );

        // Clear the form and close modal
        setState(() {
          _mobileCommentController.clear();
          _mobileNameController.clear();
          _mobileEmailController.clear();
          _selectedAvatar = '';
          _commentStep = 0;
        });

        _commentAnimationController.reverse().then((_) {
          setState(() {
            _showMobileCommentOverlay = false;
          });
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post created successfully!')),
        );

        // Scroll to bottom after a delay to allow new post to appear
        Future.delayed(Duration(milliseconds: 500), () {
          _mobileScrollController.animateTo(
            _mobileScrollController.position.maxScrollExtent + 100,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  Future<void> _addDesktopComment() async {
    if (_desktopCommentController.text.trim().isNotEmpty &&
        _mobileNameController.text.trim().isNotEmpty) {
      try {
        // Update user if needed
        await FirestoreService().updateUser(
          name: _mobileNameController.text.trim(),
          avatar: _selectedAvatar.isEmpty ? 'person' : _selectedAvatar,
        );

        // Create the post in Firestore
        await FirestoreService().addPost(
          content: _desktopCommentController.text.trim(),
          authorName: _mobileNameController.text.trim(),
          authorAvatar: _selectedAvatar.isEmpty ? 'person' : _selectedAvatar,
        );

        // Clear the form and close modal
        setState(() {
          _desktopCommentController.clear();
          _mobileNameController.clear();
          _mobileEmailController.clear();
          _selectedAvatar = '';
          _commentStep = 0;
          _showDesktopInlineComment = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post created successfully!')),
        );

        // Scroll to bottom after a delay
        Future.delayed(Duration(milliseconds: 500), () {
          _desktopScrollController.animateTo(
            _desktopScrollController.position.maxScrollExtent + 100,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  void _resetCommentModal() {
    _commentAnimationController.reverse().then((_) {
      setState(() {
        _showMobileCommentOverlay = false;
        _mobileCommentController.clear();
        _mobileNameController.clear();
        _mobileEmailController.clear();
        _selectedAvatar = '';
        _commentStep = 0;
      });
    });
  }

  // Analytics modal methods
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

  void _showDesktopAnalyticsModal(BuildContext context) {
    setState(() {
      _showDesktopAnalyticsOverlay = true;
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WireframeDesktopAnalyticsModal(
          onClose: () {
            Navigator.of(context).pop();
            setState(() {
              _showDesktopAnalyticsOverlay = false;
            });
          },
        );
      },
    ).then((_) {
      setState(() {
        _showDesktopAnalyticsOverlay = false;
      });
    });
  }

  void _toggleBottomGrid() {
    setState(() {
      _showBottomGrid = !_showBottomGrid;
    });
  }

// Contact modal methods
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

  // Desktop contact modal
  // Desktop contact modal
  void _showDesktopContactModal(BuildContext context) {
    print('DEBUG: _showDesktopContactModal called with context: $context');
    try {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          print('DEBUG: Building WireframeDesktopContactModal');
          return WireframeDesktopContactModal(
            onClose: () {
              print('DEBUG: Contact modal close button pressed');
              Navigator.of(context).pop();
            },
          );
        },
      );
      print('DEBUG: showDialog called successfully');
    } catch (e) {
      print('DEBUG: Error in _showDesktopContactModal: $e');
    }
  }

  // method after _addDesktopComment method
  SocialPost _convertToSocialPost(Map<String, dynamic> postData) {
    return SocialPost(
      id: postData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: postData['author'] ?? '',
      authorAvatar: postData['avatar'] ?? 'person',
      content: postData['content'] ?? '',
      createdAt: DateTime.now().subtract(Duration(hours: 19)), // Mock timestamp
      likeCount: postData['likeCount'] ?? 0,
      commentCount: postData['commentCount'] ?? 0,
      likedByUsers: [],
      comments: [],
    );
  }
}
