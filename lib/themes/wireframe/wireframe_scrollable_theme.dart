// File: lib/themes/wireframe/wireframe_scrollable_theme.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/themes/wireframe/widgets/about_modal.dart';
import 'package:portfolio_website/themes/wireframe/widgets/case_motion.dart';
import 'package:portfolio_website/themes/wireframe/widgets/contact_modal.dart';
import 'package:portfolio_website/themes/wireframe/widgets/desktop_animated_desktop_frame.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/widgets/border_beam.dart';
import 'package:portfolio_website/widgets/mouse_performance_utils.dart';
import 'package:portfolio_website/widgets/scroll_gesture_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/books.dart';
import 'package:portfolio_website/themes/wireframe/widgets/grid_background.dart';
import 'package:portfolio_website/themes/wireframe/widgets/responsive_device_frame.dart';
import 'package:portfolio_website/themes/wireframe/widgets/retro_grid_background.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_desktop_theme.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';
import 'scroll_theme/scroll_animation_controller.dart';
import 'scroll_theme/scroll_performance_optimizer.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_website/themes/wireframe/scroll_theme/wireframe_scroll_physics.dart';
import 'package:portfolio_website/themes/wireframe/scroll_theme/scroll_controller_manager.dart';

class WireframeScrollableTheme extends StatefulWidget {
  const WireframeScrollableTheme({Key? key}) : super(key: key);

  @override
  State<WireframeScrollableTheme> createState() =>
      _WireframeScrollableThemeState();
}

class _WireframeScrollableThemeState extends State<WireframeScrollableTheme>
    with TickerProviderStateMixin {
  // Scroll controller for the main page
  late ScrollController _mainScrollController;
  late ScrollController _desktopThemeScrollController;

  // Target keys for homing beacon system
  final GlobalKey _mobileTargetKey = GlobalKey();
  final GlobalKey _desktopTargetKey = GlobalKey();

  // Animation controller for scroll-triggered animations
  late ScrollAnimationController _scrollAnimationController;

  // Smooth animation controls
  late AnimationController _smoothnessController;
  late Animation<double> _smoothAnimation;

  // Layout dimensions
  late double _topHalfHeight;
  late double _bottomHalfHeight;
  late double _totalHeight;
  late double _transitionZoneHeight;

  // ===== SCROLL VARIABLES HERE =====
  double _lastScrollOffset = 0.0;
  bool _isScrolling = false;
  Timer? _scrollTimer;
  bool _hasReachedBottomSection = false;

  // Scroll control manager
  late ScrollControllerManager _scrollManager;


  // ===== SECTION HEIGHT CONFIGURATION =====

  // Adjust these values to control section sizes
  static const double topSectionMultiplier = 1.2; // 1.2x screen height (more reasonable)
  static const double transitionSectionMultiplier = 0.001; // Keep minimal transition
  static const double bottomSectionMultiplier = 0.8; // 80% of screen height

  // ===== ANIMATION TIMING CONTROLS =====
  static const double animationStartProgress = 0.3; // Start animation at 30% scroll
  static const double animationEndProgress = 1.0; // Complete animation at 100% scroll
  static const bool useEasingCurves = true; // Enable smooth easing
  static const double easingStrength = 1.0; // Higher = more dramatic easing

  // Animation smoothness controls
  static const double animationSmoothnessMultiplier =
      2.0; // Higher = slower, smoother

  static const bool useEaseInOutCurve =
      true; // Smooth acceleration/deceleration

  bool _hasAnimationCompleted = false; //  One-Time Only Animation
  bool _shouldReset = false; // Add this

  // ===== WIREFRAME VISIBILITY CONTROLS =====
  static const double wireframeHideThreshold = 9.5; // Change this to control when wireframes disappear
  static const bool disableAutoHide = false; // Set to true to keep wireframes always visible

  // ===== STATIC WIREFRAME CUSTOMIZATION =====

  // Mobile wireframe settings
  static const double mobileWireframeWidth = 175.0;
  static const double mobileWireframeHeight = 340.0;
  static const double mobileWireframeTilt = -5.0; // Degrees (negative = tilt left)
  static const Color mobileLoFiColor = Color(0xFF3498DB); // Blue
  static const double mobileWireframeLeftOffset = 0.0; // Additional left/right adjustment
  static const double mobileWireframeTopOffset =  0.0; // Additional up/down adjustment

  // Desktop wireframe settings
  static const double desktopWireframeWidth = 920.0;
  static const double desktopWireframeHeight = 480.0;
  static const double desktopWireframeTilt = 3.0; // Degrees (positive = tilt right)
  static const Color desktopLoFiColor = Color(0xFF2ECC71); // Green
  static const double desktopWireframeLeftOffset = 0.0; // Additional left/right adjustment
  static const double desktopWireframeTopOffset =  0.0; // Additional up/down adjustment

  // Wireframe content colors
  static const Color wireframeBackgroundColor = Color(0xFFF8F9FA);
  static const Color wireframeBorderColor = Color(0xFF6C757D);
  static const Color wireframeElementColor = Color(0xFFDEE2E6);

  // ===== MANUAL ALIGNMENT ADJUSTMENTS =====

  // Change these numbers to fine-tune alignment
  static const double mobileXOffset =
      0.0; // was 102.0 // Negative = left, Positive = right
  static const double mobileYOffset =
      0.0; // was -480.0 // Negative = up, Positive = down
  static const double desktopXOffset =
      0.0; // was 20.0 // Negative = left, Positive = right
  static const double desktopYOffset =
      0.0; // was -480.0 // Negative = up, Positive = down

  // ===== WIREFRAME CUSTOMIZATION CONSTANTS =====

  static const Color mobileWireframeColor = Colors.blue;
  static const double mobileWireframeOpacity = 0.8;

  // Desktop wireframe size controls (now responsive)
  static const Color desktopWireframeColor = Colors.green;
  static const double desktopWireframeOpacity = 0.8;

  // ===== TRULY RESPONSIVE POSITION CONSTANTS =====

  @override
  void initState() {
    super.initState();

    _mainScrollController = ScrollController();
    _desktopThemeScrollController = ScrollController();

    _scrollAnimationController = ScrollAnimationController(
      tickerProvider: this,
      scrollController: _mainScrollController,
    );

    // Simple direct listener - no optimization
    _mainScrollController.addListener(_onScrollChanged);

    // Add smooth animation controller
    _smoothnessController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Adjust for speed
      vsync: this,
    );

    _smoothAnimation = CurvedAnimation(
      parent: _smoothnessController,
      curve: Curves.easeInOutCubic, // Very smooth curve
    );
  }

  @override
  void dispose() {
    // EMERGENCY CLEANUP - prevent controller conflicts
    try {
      _mainScrollController.removeListener(_onScrollChanged);
      _mainScrollController.dispose();
    } catch (e) {
      print('Main controller cleanup error: $e');
    }

    try {
      _desktopThemeScrollController.dispose();
    } catch (e) {
      print('Desktop controller cleanup error: $e');
    }

    _scrollAnimationController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _onScrollChanged() {
    // EMERGENCY: Remove all scroll controller conflicts
    if (_mainScrollController.hasClients != true) {
      return;
    }
    if (!mounted) return;

    ScrollPerformanceMonitor.recordFrame();

    final scrollOffset = _mainScrollController.offset;
    final maxScrollOffset = _mainScrollController.position.maxScrollExtent;
    final rawProgress = (scrollOffset / maxScrollOffset).clamp(0.0, 1.0);

    // 🔥 FORCE BOTTOM SECTION DETECTION HERE - BYPASS BROKEN _updateScrollPosition
    final forceBottomThreshold = maxScrollOffset * 1.3; // 80% of max scroll
    final shouldBeInBottomSection = scrollOffset >= forceBottomThreshold;

    if (shouldBeInBottomSection != _hasReachedBottomSection) {
      setState(() {
        _hasReachedBottomSection = shouldBeInBottomSection;
      });
      print(
          '🔥 FORCED BOTTOM SECTION: $_hasReachedBottomSection at offset: $scrollOffset (max: $maxScrollOffset)');
    }

    // STOP ALL ANIMATION PROCESSING IF IN BOTTOM SECTION
    if (_hasReachedBottomSection) {
      print('🚫 IN BOTTOM SECTION - BLOCKING ALL SCROLL ANIMATIONS');
      return;
    }

    print(
        '✅ Processing scroll animations - offset: $scrollOffset, progress: $rawProgress');

    // Reset logic: if user scrolls back to top, reset the animation
    if (rawProgress < 0.1 && _hasAnimationCompleted) {
      _hasAnimationCompleted = false;
      _shouldReset = true;
    } else {
      _shouldReset = false;
    }

    // Use locked progress if animation completed, otherwise use smooth progress
    final scrollProgress =
        _hasAnimationCompleted ? 1.0 : _applySmoothEasing(rawProgress);

    // Once animation completes, lock it
    if (rawProgress >= 1.00 && !_hasAnimationCompleted) {
      _hasAnimationCompleted = true;
    }

    // Update animation controller with scroll progress
    _scrollAnimationController.updateScrollProgress(scrollProgress);
  }

  // ===== ANIMATION CALCULATION METHODS =====

  Offset _calculateMobileTargetPosition(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final responsiveScale =
        WireframeLayoutConstants.getResponsiveScale(screenSize.width);

    // Calculate container dimensions
    final containerWidth = math.min(
      WireframeLayoutConstants.maxContainerWidth * responsiveScale,
      screenSize.width * 0.95,
    );
    final containerMargin = (screenSize.width - containerWidth) / 2;

    // Mobile area is flex: 1 in a Row with total flex: 4 (1 mobile + 3 desktop)
    // So mobile takes 25% of the container width
    final mobileAreaWidth = containerWidth * 0.25; // 25% of container

    // Center of the mobile area
    final mobileTargetX = containerMargin + (mobileAreaWidth * 0.5);
    final mobileTargetY =
        (_topHalfHeight + _transitionZoneHeight + (_bottomHalfHeight * 0.3));

    return Offset(mobileTargetX, mobileTargetY);
  }

  Offset _calculateMobileStartPosition(BuildContext context) {
    final target = _calculateMobileTargetPosition(context);

    // Create an interesting "up and out" starting position
    return Offset(
      target.dx - 150, // Move left from target
      400, // Start higher up
    );
  }

  // Debug method for lo-fi overlays
  Widget _buildPositionDebugOverlay(BoxConstraints constraints) {
    // ← Changed name
    final screenSize = MediaQuery.of(context).size;
    final bottomSectionOffset = _topHalfHeight + _transitionZoneHeight;

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: DebugPositionPainter(
            bottomSectionOffset: bottomSectionOffset,
            screenSize: screenSize,
          ),
        ),
      ),
    );
  }

  //  Smooth Progress Calculator Method
  double _calculateSmoothAnimationProgress(double rawScrollProgress) {
    // Map scroll progress to animation range
    if (rawScrollProgress < animationStartProgress) return 0.0;
    if (rawScrollProgress > animationEndProgress) return 1.0;

    // Normalize to 0-1 within the animation range
    final normalizedProgress = (rawScrollProgress - animationStartProgress) /
        (animationEndProgress - animationStartProgress);

    if (useEasingCurves) {
      // Apply smooth easing curve
      return _applyEasingCurve(normalizedProgress);
    }

    return normalizedProgress;
  }

  double _applyEasingCurve(double progress) {
    // Use Flutter's built-in smooth curves instead of manual math
    //return Curves.easeInOutCubic.transform(progress);

    // Alternative: Even smoother cubic bezier curve
    // return Curves.easeInOutQuart.transform(progress);

    // Alternative: For very smooth motion
    return Curves.easeInOutSine.transform(progress);
  }

  // Add this NEW METHOD to calculate where the hi-fi wireframes actually appear
  Map<String, Offset> _calculateHiFiPositions(BoxConstraints constraints) {
    final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
    final responsiveScale =
        WireframeLayoutConstants.getResponsiveScale(screenSize.width);

    // Calculate the main container dimensions (same logic as your hi-fi section)
    final containerWidth = math.min(
      WireframeLayoutConstants.maxContainerWidth * responsiveScale,
      screenSize.width * 0.95,
    );
    final containerMargin = (screenSize.width - containerWidth) / 2;

    // Calculate Y position of bottom section
    final bottomSectionY = _topHalfHeight + _transitionZoneHeight;

    // Mobile area: flex 1 out of total flex 4 (1 + 3)
    final mobileAreaWidth = containerWidth * 0.25; // 25%
    final mobileAreaCenterX = containerMargin + (mobileAreaWidth * 0.5);

    // Desktop area: starts after mobile + divider, takes flex 3
    const dividerWidth = 1.0;
    final desktopAreaStart = containerMargin + mobileAreaWidth + dividerWidth;
    final desktopAreaWidth = containerWidth * 0.75; // 75%
    final desktopAreaCenterX = desktopAreaStart + (desktopAreaWidth * 0.5);

    // Calculate responsive device sizes
    final mobileDeviceSize = _calculateResponsiveDeviceSize(
      deviceSize: const Size(320.0, 635.0),
      constraints: constraints,
    );
    final desktopDeviceSize = _calculateResponsiveDeviceSize(
      deviceSize: const Size(1440.0, 974.0),
      constraints: constraints,
    );

    // Account for content insets from DeviceFrameConfigs
    final mobileContentInsets =
        const EdgeInsets.only(top: 8.0, left: 10.0, right: 15.0, bottom: 8.0);
    final desktopContentInsets =
        const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0);

    // Calculate device scaling (same as ResponsiveDeviceFrame)
    final mobileScale =
        mobileDeviceSize.width / 320.0; // Original iPhone frame width
    final desktopScale =
        desktopDeviceSize.width / 1440.0; // Original Chrome frame width

    // Calculate content positioning within device frames
    final mobileContentOffsetX =
        (mobileContentInsets.left - mobileContentInsets.right) *
            mobileScale *
            0.5;
    final desktopContentOffsetX =
        (desktopContentInsets.left - desktopContentInsets.right) *
            desktopScale *
            0.5;

    // Manual alignment offsets (easy to adjust)
    final mobileDebugOffsetX = mobileXOffset;
    final mobileDebugOffsetY = mobileYOffset;
    final desktopDebugOffsetX = desktopXOffset;
    final desktopDebugOffsetY = desktopYOffset;

    // Calculate final positions with all adjustments combined (NO DUPLICATES)
    final finalMobileTargetX = mobileAreaCenterX -
        (mobileDeviceSize.width * 0.5) +
        mobileContentOffsetX +
        mobileDebugOffsetX;
    final calculatedMobileY = bottomSectionY +
        (200) +
        mobileDebugOffsetY; // 200px into bottom section
    final finalMobileTargetY = calculateSafeY(calculatedMobileY);

    final finalDesktopTargetX = desktopAreaCenterX -
        (desktopDeviceSize.width * 0.5) +
        desktopContentOffsetX +
        desktopDebugOffsetX;
    final calculatedDesktopY = bottomSectionY +
        (200) +
        desktopDebugOffsetY; // 200px into bottom section
    final finalDesktopTargetY = calculateSafeY(calculatedDesktopY);

    // Add debug output
    debugPositionCalculation();

    return {
      'mobile': Offset(finalMobileTargetX, finalMobileTargetY),
      'desktop': Offset(finalDesktopTargetX, finalDesktopTargetY),
    };
  }

  // Add this NEW METHOD to your _WireframeScrollableThemeState class:
  Size _calculateResponsiveDeviceSize({
    required Size deviceSize,
    required BoxConstraints constraints,
    double paddingFactor = 0.9,
  }) {
    double deviceAspectRatio = deviceSize.width / deviceSize.height;
    double containerAspectRatio = constraints.maxWidth / constraints.maxHeight;

    double scale;
    if (containerAspectRatio > deviceAspectRatio) {
      scale = constraints.maxHeight / deviceSize.height;
    } else {
      scale = constraints.maxWidth / deviceSize.width;
    }

    scale = (scale * paddingFactor).clamp(0.1, 1.0);

    return Size(
      deviceSize.width * scale,
      deviceSize.height * scale,
    );
  }

  

  bool _onScrollNotification(ScrollNotification notification) {
    print(
        '🎯 _onScrollNotification: depth=${notification.depth}, metrics=${notification.metrics?.pixels}');

    _updateScrollPosition();

    if (_hasReachedBottomSection) {
      print('🚫 CONSUMING scroll in bottom section');
      return true; // Consume all scroll events
    }

    if (notification.depth == 0) {
      print('✅ Processing main scroll');
      _onScrollChanged();
    }

    return false;
  }

  bool _isInBottomSection() {
    final scrollOffset =
        _mainScrollController.hasClients ? _mainScrollController.offset : 0.0;

    // Consider bottom section as anything past the transition zone
    return scrollOffset >= (_topHalfHeight + _transitionZoneHeight - 100);
  }

  bool _isMouseOverDeviceContent(Offset mousePosition) {
    // Get the positions of your mobile and desktop target keys
    final mobileBox =
        _mobileTargetKey.currentContext?.findRenderObject() as RenderBox?;
    final desktopBox =
        _desktopTargetKey.currentContext?.findRenderObject() as RenderBox?;

    if (mobileBox != null) {
      final mobileRect = mobileBox.localToGlobal(Offset.zero) & mobileBox.size;
      if (mobileRect.contains(mousePosition)) return true;
    }

    if (desktopBox != null) {
      final desktopRect =
          desktopBox.localToGlobal(Offset.zero) & desktopBox.size;
      if (desktopRect.contains(mousePosition)) return true;
    }

    return false; // This ensures the method always returns a bool
  }

  // Desktop positioning system
  Offset _calculateSimpleDesktopPosition(double scrollProgress, Size screenSize,
      [BoxConstraints? dynamicConstraints]) {
    final constraints = dynamicConstraints ??
        BoxConstraints(
            maxWidth: screenSize.width, maxHeight: screenSize.height);

    // Use EXACT same responsive logic as hi-fi section
    final responsiveScale =
        WireframeLayoutConstants.getResponsiveScale(constraints.maxWidth);
    final containerWidth = math.min(
      WireframeLayoutConstants.maxContainerWidth * responsiveScale,
      constraints.maxWidth * 0.95,
    );
    final containerMargin = (constraints.maxWidth - containerWidth) / 2;

    // Desktop gets 75% of container (flex: 3 out of 4), starts after mobile area
    final mobileAreaWidth = containerWidth * 0.25;
    final desktopAreaWidth = containerWidth * 0.75;
    final desktopAreaCenterX =
        containerMargin + mobileAreaWidth + (desktopAreaWidth * 0.5);

    // Simple start position at hi-fi location
    final bottomSectionY = _topHalfHeight + _transitionZoneHeight;
    final startY = bottomSectionY +
        (constraints.maxHeight * 0.10); // 10% into bottom section

    // Animate upward
    final endY = _topHalfHeight * 0.2;
    final smoothProgress = _calculateSmoothAnimationProgress(scrollProgress);
    final currentY = startY + (endY - startY) * smoothProgress;

    return Offset(desktopAreaCenterX, currentY);
  }

  // So Animations Move at Same Speed
  double _getAnimationDistance(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  double _normalizeAnimationSpeed(
      double scrollProgress, double totalDistance, double baseDistance) {
    // Normalize animation speed based on travel distance
    final speedMultiplier = baseDistance / totalDistance;
    return (scrollProgress * speedMultiplier).clamp(0.0, 1.0);
  }

  Widget _buildMirrorLayout(BoxConstraints constraints, double scrollProgress) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(

        child: Container(
          width: math.min(1600, screenSize.width * 0.9),
          height: 900.0 - (screenSize.height * 0.04),
          margin: EdgeInsets.symmetric(
            horizontal: math.max(
              screenSize.width * 0.02,
              (screenSize.width -
                      (WireframeLayoutConstants.maxContainerWidth *
                          WireframeLayoutConstants.getResponsiveScale(
                              screenSize.width))) /
                  2,
            ),
            vertical: screenSize.height * 0.02,
          ),
          child: Row(
            children: [
              // Mobile floating wireframe
              Expanded(
                flex: 1,
                child: Center(
                  child: _buildFloatingMobileWireframe(
                      constraints, scrollProgress),
                ),
              ),

              // Divider (matching bottom section)
              Container(
                width: 1,
                height: double.infinity,
                color: Colors.grey.withAlpha(0),
              ),

              // Desktop floating wireframe
              Expanded(
                flex: 3,
                child: Center(
                  child: _buildFloatingDesktopWireframe(
                      constraints, scrollProgress),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // END OF BUILD METHODS TO BE PRESERVED

  @override
  Widget build(BuildContext context) {
    print(
        '🔍 DEBUG: WireframeScrollableTheme.build() called - WEB SMOOTH SCROLL VERSION');

    // Initialize dimensions
    _calculateDimensions(BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    ));

 

    debugWireframePositioning();

  return Scaffold(
  backgroundColor: Colors.transparent,
  body: Stack(
    children: [

       // WebSmoothScroll wrapped around CustomScrollView

          _hasReachedBottomSection
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Color(0xFF2B2A2F), // Match your background
                  child: RetroGridBackground(
                    angle: 65,
                    child: Container(
                      key: _desktopTargetKey,
                      child: WireframeDesktopTheme(
                        isScrollableMode: true,
                        fixedHeight: MediaQuery.of(context).size.height,
                        externalScrollController: _desktopThemeScrollController,
                        mobileTargetKey: _mobileTargetKey,
                        desktopTargetKey: _desktopTargetKey,
                      ),
                    ),
                  ),
                )
              : WebSmoothScroll(
                  controller: _mainScrollController,
                  scrollSpeed: 2.1,
                  scrollAnimationLength: 800,
                  curve: Curves.easeInOutCirc,
                  child: CustomScrollView(
                    controller: _mainScrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [

                     // HERO SECTION

                      SliverToBoxAdapter(
                        child: SizedBox(
                          height:
                              _topHalfHeight, // Use calculated height instead of hardcoded
                          width: double.infinity,
                          child: Stack(
                            children: [

                        // Base grid background

                        GridBackground(
                          gridColor: Color(0xFFF5E9D8),
                          gridOpacity: 0.05,
                          gridSize: 30.0,
                          strokeWidth: 1.0,
                          backgroundColor: Color(0xFF2B2A2F),
                          child: Container(), // Empty container for grid only
                        ),

                        // Fade gradient overlay near bottom

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: MediaQuery.of(context).size.height * 0.3, // Fade the bottom 30%
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(
                                      0xFF2B2A2F), // Match your background color
                                ],
                                stops: const [0.0, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Main hero content

                        Container(
                          padding:
                              EdgeInsets.only(top: 100, left: 40, right: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Header row with title and navigation

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // Left side - Main title

                                  Text(
                                    'Jeff Anderson',
                                    style: TextStyle(
                                      fontFamily: 'KOMIKAX_',
                                      fontSize: 64,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFFFF9A62),
                                      height: 1.1,
                                    ),
                                  ),

                              
                                        // Right side - About and Contact CTAs
                                        Row(
                                          children: [
                                            _buildHeaderCTA('About', () {
                                              _showAboutModal(context);
                                            }),
                                            const SizedBox(width: 30),
                                            _buildHeaderCTA('Contact', () {
                                              _showContactModal(context);
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),

                              const SizedBox(height: 16),
                              // Subtitle
                              Text(
                                'UX/UI Designer',
                                style: TextStyle(
                                  fontFamily: 'KOMIKAX_',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFE1F200),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Description
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 600),
                                child: Text(
                                  'Crafting digital experiences...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: WireframeColorManager
                                        .colors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: 60), // More space after description
                            ],
                          ),
                        ),

                        // STATIC WIREFRAMES - FIXED RESPONSIVE POSITIONING

                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate responsive container dimensions (same logic as bottom section)
                            final responsiveScale = WireframeLayoutConstants.getResponsiveScale(
                                    constraints.maxWidth);
                            final containerWidth = math.min(WireframeLayoutConstants.maxContainerWidth *
                                  responsiveScale,
                              constraints.maxWidth * 0.95,
                            );
                            final containerMargin =
                                (constraints.maxWidth - containerWidth) / 2;

                            // Calculate available space for each wireframe
                            final availableWidth = constraints.maxWidth - containerMargin * 2;
                            final mobileSpace = availableWidth * 0.50; // Give mobile % of space
                            final desktopSpace = availableWidth * 0.50; // Give desktop % of space

                            // Mobile wireframe positioning with responsive offset

                                  final mobileXOffset = constraints.maxWidth <
                                          1200
                                      ? 150.0
                                      : 350.0; // Smaller offset for smaller screens
                                  final mobileX = containerMargin +
                                      (mobileSpace * 0.4) -
                                      (mobileWireframeWidth * 0.2);
                                  final safeMobileX =
                                      (mobileX + mobileXOffset).clamp(
                                    containerMargin +
                                        10.0, // Reduced margin for small screens
                                    containerMargin +
                                        mobileSpace -
                                        mobileWireframeWidth -
                                        5.0, // Reduced margin
                                  );

                            // Desktop wireframe positioning with extra offset

                            final desktopStartX = containerMargin + mobileSpace + 3.0; 
                            final desktopCenterX = desktopStartX +
                                (desktopSpace * 0.7) -
                                (desktopWireframeWidth * 0.5);
                            final safeDesktopX = (desktopCenterX - 260.0).clamp(// ← Subtract #px to move left
                              desktopStartX, // Don't go into mobile area
                              constraints.maxWidth - desktopWireframeWidth - 10.0, // At least #px from right edge
                            );

                            print('🔍 Wireframe Debug:');
                            print('- Screen width: ${constraints.maxWidth}');
                            print('- Container width: $containerWidth');
                            print(
                                '- Mobile X: $safeMobileX (width: $mobileWireframeWidth)');
                            print(
                                '- Desktop X: $safeDesktopX (width: $desktopWireframeWidth)');
                            print(
                                '- Gap between: ${safeDesktopX - (safeMobileX + mobileWireframeWidth)}');

                            return Stack(
                              children: [

                                // Mobile wireframe - left side

                                Positioned(
                                  left: safeMobileX,
                                  top:
                                      MediaQuery.of(context).size.height * 0.45,
                                  child: Container(
                                    // Debug container to see if mobile wireframe is rendering
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent, width: 1),
                                    ),
                                    child: _buildStaticMobileWireframe(),
                                  ),
                                ),

                                // Desktop wireframe - right side
                                
                                Positioned(
                                  left: safeDesktopX,
                                  top:
                                      MediaQuery.of(context).size.height * 0.45,
                                  child: Container(
                                    // Debug container to see if desktop wireframe is rendering
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent, width: 1),
                                    ),
                                    child: _buildStaticDesktopWireframe(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),


                        // Work section with books - ONLY WORK TEXT CENTERED

                        Positioned(
                          left: 80, // ⭐ Keep original position
                          top: MediaQuery.of(context).size.height * 0.4, // ⭐ Back to original position
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // ⭐ Keep books left-aligned
                            children: [
                              // Work section title - CENTERED WITHIN ITS OWN SPACE
                              Container(
                                width: 400, // ⭐ Set width to span across both books (2 books × 180px + spacing)
                                child: Center( // ⭐ Center only the text within this container
                                  child: Text(
                                    'Work',
                                    style: TextStyle(
                                      fontFamily: 'KOMIKAX_',
                                      fontSize: 24, // Keep the improved size
                                      fontWeight: FontWeight.w600, // Keep the improved weight
                                      color: Color(0xFFFF9A62),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40), // ⭐ Keep the increased spacing

                              // Case Study Motion Grid - KEEP IN ORIGINAL POSITION
                              Container(
                                child: CaseStudyMotionGrid(
                                  cardWidth: 180.0,
                                  cardHeight: 240.0,
                                  spacing: 20.0,
                                  borderRadius: 12.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BOTTOM SECTION - Hi Fidelity Wireframe Desktop Theme with Animated Grid

                SliverToBoxAdapter(

                        child: Container(
                          height:
                              _bottomHalfHeight, // Use calculated height instead of hardcoded
                          width: double.infinity,
                          color: Color(0xFF2B2A2F), // Force background color
                          
                          child: RetroGridBackground(
                            angle: 65,
                            child: Container(
                              key: _desktopTargetKey,
                              child: WireframeDesktopTheme(
                                isScrollableMode: true,
                                fixedHeight: 900,
                                externalScrollController:
                                    _desktopThemeScrollController,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), 
          
          //  everyting below here unchanged in update

          
          // ✅ CORRECTED DEBUG BLOCK
          LayoutBuilder(
            builder: (context, constraints) {
              return _buildPositionDebugOverlay(constraints);
            },
          ),
        ],
      ),
    );
  }

  void _calculateDimensions(BoxConstraints constraints) {
    final screenHeight = constraints.maxHeight;

    // Add safety check for invalid constraints
    if (screenHeight <= 0) {
      print('⚠️ WARNING: Invalid screen height: $screenHeight');
      return;
    }

    // Use the multiplier constants instead of hardcoded values
    _topHalfHeight = math.max(200, screenHeight * topSectionMultiplier);
    _transitionZoneHeight = screenHeight * transitionSectionMultiplier;
    _bottomHalfHeight = math.max(200, screenHeight * bottomSectionMultiplier);

    _totalHeight = _topHalfHeight + _transitionZoneHeight + _bottomHalfHeight;

    print('🔧 SECTION HEIGHTS:');
    print(
        '- Top: ${_topHalfHeight.toStringAsFixed(0)}px (${(topSectionMultiplier * 100).toStringAsFixed(0)}% of screen)');
    print(
        '- Transition: ${_transitionZoneHeight.toStringAsFixed(0)}px (${(transitionSectionMultiplier * 100).toStringAsFixed(0)}% of screen)');
    print(
        '- Bottom: ${_bottomHalfHeight.toStringAsFixed(0)}px (${(bottomSectionMultiplier * 100).toStringAsFixed(0)}% of screen)');
    print('- Total: ${_totalHeight.toStringAsFixed(0)}px');
  }

  double _applySmoothEasing(double progress) {
    // Add animation smoothness controls
    const bool useEaseInOutCurve = true;

    if (useEaseInOutCurve) {
      // Smooth ease-in-out curve
      return progress < 0.5
          ? 2 * progress * progress
          : 1 - math.pow(-2 * progress + 2, 3) / 2;
    }
    return progress; // Linear (current behavior)
  }

  Offset _calculateMobileWireframePosition(
      BoxConstraints constraints, double scrollProgress) {
    // Use EXACT same responsive logic as hi-fi section
    final responsiveScale =
        WireframeLayoutConstants.getResponsiveScale(constraints.maxWidth);
    final containerWidth = math.min(
      WireframeLayoutConstants.maxContainerWidth * responsiveScale,
      constraints.maxWidth * 0.95,
    );
    final containerMargin = (constraints.maxWidth - containerWidth) / 2;

    // Mobile gets 25% of container (flex: 1 out of 4 total)
    final mobileAreaWidth = containerWidth * 0.25;
    final mobileAreaCenterX = containerMargin + (mobileAreaWidth * 0.5);

    // Simple start position at hi-fi location
    final bottomSectionY = _topHalfHeight + _transitionZoneHeight;
    final startY = bottomSectionY +
        (constraints.maxHeight * 0.3); // 30% into bottom section

    // Animate upward
    final endY = _topHalfHeight * 0.3;
    final smoothProgress = _calculateSmoothAnimationProgress(scrollProgress);
    final currentY = startY + (endY - startY) * smoothProgress;

    return Offset(mobileAreaCenterX, currentY);
  }

  double _calculateMobileRotation(double scrollProgress) {
    // Start tilted, rotate to straight as scroll progresses
    final startRotation = -25 * (math.pi / 180); // Start at -25 degrees
    final endRotation = 0.0; // End perfectly straight
    return startRotation + (endRotation - startRotation) * scrollProgress;
  }

  double _calculateSimpleDesktopRotation(double scrollProgress) {
    // Start tilted, rotate to straight as scroll progresses (similar to mobile)
    final startRotation = 20.0 * (math.pi / 180); // Start at 20 degrees
    final endRotation = 0.0; // End perfectly straight
    return startRotation + (endRotation - startRotation) * scrollProgress;
  }

  double _calculateDesktopRotation(double scrollProgress) {
    // Start tilted, rotate to straight as scroll progresses (similar to mobile)
    final startRotation = 20.0 * (math.pi / 180); // Start at 20 degrees
    final endRotation = 0.0; // End perfectly straight
    return startRotation + (endRotation - startRotation) * scrollProgress;
  }

  void _updateScrollPosition() {
    if (_mainScrollController.hasClients) {
      final maxScrollExtent = _mainScrollController.position.maxScrollExtent;
      final currentOffset = _mainScrollController.offset;
      final viewportHeight = MediaQuery.of(context).size.height;
      final bottomThreshold =
          _topHalfHeight + _transitionZoneHeight - (viewportHeight * 0.3);

      print(
          '📍 Position check: offset=$currentOffset, threshold=$bottomThreshold');

      final newHasReachedBottomSection = currentOffset >= bottomThreshold;

      if (newHasReachedBottomSection != _hasReachedBottomSection) {
        setState(() {
          _hasReachedBottomSection = newHasReachedBottomSection;
        });

        if (_hasReachedBottomSection) {
          print('🚫 ENTERED BOTTOM SECTION - SHOULD BLOCK MAIN SCROLL');
        } else {
          print('✅ EXITED BOTTOM SECTION - MAIN SCROLL ENABLED');
        }
      }
    }
  }

  

  Widget _buildFloatingMobileWireframe(
      BoxConstraints constraints, double scrollProgress) {
    debugWireframePositioning(constraints, scrollProgress);

    // Calculate the exact container layout matching the bottom section
    final screenSize = MediaQuery.of(context).size;
    final responsiveScale =
        WireframeLayoutConstants.getResponsiveScale(screenSize.width);

    // Calculate container dimensions
    final containerWidth = math.min(
      WireframeLayoutConstants.maxContainerWidth * responsiveScale,
      screenSize.width * 0.95,
    );

    // Mobile area is flex: 1 in a Row with total flex: 4 (1 mobile + 3 desktop)
    final mobileAreaWidth = containerWidth * 0.25; // 25% of container

    // Calculate device scale exactly like ResponsiveDeviceFrame
    const deviceWidth = 375.0; // iPhone width
    const deviceHeight = 812.0; // iPhone height

    // Scale based on available mobile area
    final mobileAreaConstraints = BoxConstraints(
      maxWidth: mobileAreaWidth,
      maxHeight: 900.0 - (screenSize.height * 0.04),
    );

    double deviceAspectRatio = deviceWidth / deviceHeight;
    double areaAspectRatio =
        mobileAreaConstraints.maxWidth / mobileAreaConstraints.maxHeight;

    double scale;
    if (areaAspectRatio > deviceAspectRatio) {
      scale = mobileAreaConstraints.maxHeight / deviceHeight;
    } else {
      scale = mobileAreaConstraints.maxWidth / deviceWidth;
    }

    scale = (scale * 0.9).clamp(0.1, 1.0);

    double scaledWidth = deviceWidth * scale;
    double scaledHeight = deviceHeight * scale;

    // Animation progress
    final smoothProgress = _calculateSmoothAnimationProgress(scrollProgress);

    // Vertical animation
    final startY = 1000.0;
    final endY = -(_topHalfHeight * 0.1);
    final currentY = startY + (endY - startY) * smoothProgress;

    // Fade out when wireframes reach their resting position
    final restingThreshold = 2.5;
    final fadeOutProgress = smoothProgress >= restingThreshold
        ? (smoothProgress - restingThreshold) / (1.0 - restingThreshold)
        : 0.0;

    const mobileWireframeOpacity = 0.8;
    final opacity = smoothProgress >= 2.0
        ? 0.0
        : (mobileWireframeOpacity * (1.0 - fadeOutProgress)).clamp(0.0, 1.0);

    return SizedBox(
      width: scaledWidth,
      height: scaledHeight,
      child: Transform.translate(
        offset: Offset(0, currentY),
        child: Transform.rotate(
          angle: _calculateMobileRotation(scrollProgress),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 16),
            curve: Curves.easeOut,
            opacity: opacity,
            child: IPhoneFrame(
              content: Container(
                color: Colors.blue.withOpacity(opacity),
                child: const Center(
                  child: Text(
                    'MOBILE\nFLOATING',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingDesktopWireframe(
      BoxConstraints constraints, double scrollProgress) {
    // Calculate the exact container layout matching the bottom section
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = 1600.0; // Same as bottom section
    final containerHeight = 900.0 - (screenSize.height * 0.04);

    // Desktop area gets flex 3 of 4 (75% of container width)
    final desktopAreaWidth = containerWidth * 0.75;

    // Calculate device scale exactly like ResponsiveDeviceFrame
    const deviceWidth = 1440.0;
    const deviceHeight = 974.0;

    // Scale based on available desktop area, not full constraints
    final desktopAreaConstraints = BoxConstraints(
      maxWidth: desktopAreaWidth,
      maxHeight: containerHeight,
    );

    double deviceAspectRatio = deviceWidth / deviceHeight;
    double areaAspectRatio =
        desktopAreaConstraints.maxWidth / desktopAreaConstraints.maxHeight;

    double scale;
    if (areaAspectRatio > deviceAspectRatio) {
      scale = desktopAreaConstraints.maxHeight / deviceHeight;
    } else {
      scale = desktopAreaConstraints.maxWidth / deviceWidth;
    }

    scale = (scale * 0.9).clamp(0.1, 1.0);

    double scaledWidth = deviceWidth * scale;
    double scaledHeight = deviceHeight * scale;

    // Animation progress
    final smoothProgress = _calculateSmoothAnimationProgress(scrollProgress);

    // Vertical animation
    final startY = 1400.0;
    final endY = -(_topHalfHeight * 0.1);
    final currentY = startY + (endY - startY) * smoothProgress;

    // Fade out when wireframes reach their resting position
    final restingThreshold = 2.5;
    final fadeOutProgress = smoothProgress >= restingThreshold
        ? (smoothProgress - restingThreshold) / (1.0 - restingThreshold)
        : 0.0;

    const desktopWireframeOpacity = 0.8;
    final opacity = smoothProgress >= 2.0
        ? 0.0
        : (desktopWireframeOpacity * (1.0 - fadeOutProgress)).clamp(0.0, 1.0);

    return SizedBox(
      width: scaledWidth,
      height: scaledHeight,
      child: Transform.translate(
        offset: Offset(0, currentY),
        child: Transform.rotate(
          angle: _calculateDesktopRotation(scrollProgress),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 16),
            curve: Curves.easeOut,
            opacity: opacity,
            child: DesktopFrame(
              content: Container(
                color: Colors.green.withOpacity(opacity),
                child: const Center(
                  child: Text(
                    'DESKTOP\nFLOATING',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ADD THESE NEW METHODS HERE:
  double calculateSafeY(double calculatedY) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return calculatedY.clamp(
      safeAreaTop,
      screenHeight -
          safeAreaBottom -
          300, // 300 = estimated device frame height
    );
  }

  void debugPositionCalculation() {
    print('=== POSITION DEBUG ===');
    print('Screen height: ${MediaQuery.of(context).size.height}');
    print('bottomSectionY: ${_topHalfHeight + _transitionZoneHeight}');
    print('900 * 0.5: ${900 * 0.5}');
    print('mobileDebugOffsetY: $mobileYOffset');

    if (_topHalfHeight + _transitionZoneHeight >
        MediaQuery.of(context).size.height) {
      print('❌ WARNING: Position is off-screen!');
    }
  }

  void debugWireframePositioning(
      [BoxConstraints? constraints, double? scrollProgress]) {
    print('🔍 WIREFRAME POSITIONING DEBUG:');
    print('- _topHalfHeight: $_topHalfHeight');
    print('- _transitionZoneHeight: $_transitionZoneHeight');
    print('- bottomSectionOffset: ${_topHalfHeight + _transitionZoneHeight}');
    print(
        '- Hero section actual height: ${MediaQuery.of(context).size.height * 2.5}');
    if (constraints != null) {
      print(
          '- Constraints: ${constraints.maxWidth} x ${constraints.maxHeight}');
    }
    if (scrollProgress != null) {
      print('- Scroll progress: $scrollProgress');
    }
  }

  /// Build hero section with animated book
  Widget _buildHeroSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Section title
        Text(
          title,
          style: TextStyle(
            fontFamily: 'KOMIKAX_',
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFF9A62),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 20), // Reduced from 40 to bring books closer
      ],
    );
  }

  /// Build header CTA buttons (About, Contact) with BorderBeam animation
  Widget _buildHeaderCTA(String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: BorderBeam(
          duration: title == 'Contact' ? 2 : 4,
          borderWidth: 2.0,
          colorFrom: Color(0xFFFF9A62), // Same color for both (orange)
          colorTo: Color(0xFFFFFFFF), // White
          staticBorderColor: Color(0xFFFF9A62), // Same color for both (orange)
          borderRadius:
              BorderRadius.circular(20), // Rounded corners as you wanted
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius:
                  BorderRadius.circular(80), // Match the BorderBeam radius
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'KOMIKAX_',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF9A62), // Same color for both (orange)
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Show About modal
  void _showAboutModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 600,
            height: 500,
            decoration: BoxDecoration(
              color: Color(0xFF413F3B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'About Jeff',
                        style: TextStyle(
                          fontFamily: 'KOMIKAX_',
                          fontSize: 24,
                          color: Color(0xFFF5E9D8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFFF5E9D8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Image
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Color(0xFFF5E9D8), width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/about/beard.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Color(0xFFF5E9D8),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF413F3B)),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        // Text
                        Expanded(
                          child: Text(
                            ' You probably figured out I am a UX/UI Designer.  I also do a bit of backend/development, although it is not my focus\n\nIn my free time I love doing BJJ (I am a brown belt), spending time with my wife of 19 years and 2 boys. I love getting out in to nature as much as possible...',
                            style: TextStyle(
                              fontFamily: 'KOMIKAX_',
                              fontSize: 16,
                              color: Color(0xFFF5E9D8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Show Contact modal
  void _showContactModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              color: WireframeColorManager.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: WireframeColorManager.colors.border!, width: 1),
            ),
            child: Column(
              children: [
                // Header with close button
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: WireframeColorManager.colors.border!,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: WireframeColorManager.colors.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(
                            Icons.close,
                            color: WireframeColorManager.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contact content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactItem(
                          context,
                          'email',
                          'Email',
                          'JeffreyAndersonPDX@gmail.com',
                          () => _launchEmail(),
                        ),
                        SizedBox(height: 16),
                        _buildContactItem(
                          context,
                          'phone',
                          'Phone',
                          '(503) 282-4647',
                          () => _launchPhone(),
                        ),
                        SizedBox(height: 16),
                        _buildContactItem(
                          context,
                          'location',
                          'Location',
                          'Portland, OR',
                          null,
                        ),
                        SizedBox(height: 16),
                        _buildContactItem(
                          context,
                          'linkedin',
                          'LinkedIn',
                          'jeffrey-anderson-pdx',
                          () => _launchLinkedIn(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String iconType,
    String title,
    String value,
    VoidCallback? onTap,
  ) {
    Widget content = Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: WireframeColorManager.colors.border!,
        ),
      ),
      child: Row(
        children: [
          _buildSvgIcon(iconType),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: WireframeColorManager.colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: WireframeColorManager.colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: WireframeColorManager.colors.textSecondary,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildSvgIcon(String iconType) {
    String svgPath;

    switch (iconType) {
      case 'email':
        svgPath = SvgIconPaths.emailbasicon;
        break;
      case 'phone':
        svgPath = SvgIconPaths.phonebasicon;
        break;
      case 'location':
        svgPath = SvgIconPaths.housebasicon;
        break;
      case 'linkedin':
        svgPath = SvgIconPaths.linkedbasicon;
        break;
      default:
        svgPath = SvgIconPaths.contactbasicon;
    }

    return SvgIcon(
      assetPath: svgPath,
      size: 20,
      color: WireframeColorManager.colors.primary,
    );
  }

  void _launchEmail() async {
    const email = 'JeffreyAndersonPDX@gmail.com';
    final url = 'mailto:$email';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  void _launchPhone() async {
    const phone = '5032824647';
    final url = 'tel:$phone';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
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


  /// Build compact bookshelf for sidebar placement
  Widget _buildCompactBookshelf() {
    return Column(
      children: [
        // Book 1 - Tap In (interactive)
        _buildCompactBook(
          title: 'Tap In',
          author: 'Case Study',
          coverAsset: 'assets/1_stoic.png',
          spineAsset: 'assets/tapin_spine.png',
          backgroundColor: Color(0xFF2FBF71),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TapInCaseStudy(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        // Book 2 - Moments Case Study
        _buildCompactBook(
          title: 'Moments',
          author: 'Case Study',
          coverAsset: 'assets/moments_front.png',
          spineAsset: 'assets/2_moon_spine.png',
          backgroundColor: Color(0xFF4ECDC4),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MomentsCaseStudy(),
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        // Book 3 - Coming soon
        _buildCompactBook(
          title: 'Moon Pacha',
          author: 'Korean BBQ',
          coverAsset: 'assets/pacha_front.png',
          spineAsset: 'assets/pacha_back.png',
          backgroundColor: Color(0xFFFF6B6B),
          onTap: () => print('Project 3 - Coming Soon'),
        ),
        const SizedBox(height: 8),

        // Book 4 - Coming soon
        _buildCompactBook(
          title: 'Ronin Jiu Jitsu',
          author: 'Premier BJJ Training',
          coverAsset: 'assets/ronin_front.png',
          spineAsset: 'assets/ronin_back.png',
          backgroundColor: Color(0xFF9B59B6),
          onTap: () => print('Project 4 - Coming Soon'),
        ),
      ],
    );
  }

  /// Build individual compact book widget
  Widget _buildCompactBook({
    required String title,
    required String author,
    required String coverAsset,
    required String spineAsset,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, // Much smaller than original
        height: 120, // Much smaller than original
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            coverAsset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Build static mobile lo-fi wireframe with restored background wireframes
  Widget _buildStaticMobileWireframe() {
    return Transform.translate(
      offset: Offset(mobileWireframeLeftOffset, mobileWireframeTopOffset),
      child: Transform.rotate(
        angle: mobileWireframeTilt * (math.pi / 180),
        child: Container(
          width: mobileWireframeWidth,
          height: mobileWireframeHeight,
          clipBehavior: Clip.none,
          child: Tilt(
            tiltConfig: TiltConfig(
              angle: 15.0,
              enableReverse: false,
              filterQuality: FilterQuality.medium,
              enableGestureSensors: true,
              enableGestureHover: true,
              enableGestureTouch: true,
              enableRevert: true,
              moveDuration: Duration(milliseconds: 250),
              leaveDuration: Duration(milliseconds: 600),
            ),

            lightConfig: LightConfig(
              disable: false,
              color: const Color(0xFFFFFFFF),
              minIntensity: 0.0,
              maxIntensity: 0.25,
              spreadFactor: 2.5,
            ),

            shadowConfig: ShadowConfig(
              disable: false,
              color: Color(0xFF000000),
              minIntensity: 0.1,
              maxIntensity: 0.4,
              offsetFactor: 0.08,
              minBlurRadius: 5,
              maxBlurRadius: 12,
            ),

            borderRadius: BorderRadius.circular(20),

            // RESTORED: Lo-fi wireframe behind the med-fi one
            childLayout: ChildLayout(
              behind: [
                Positioned(
                  top: 10, // Moderate offset for mobile
                  left: 10,
                  child: TiltParallax(
                    size: const Offset(-25, -20), // Moderate parallax
                    child: Container(
                      width: mobileWireframeWidth - 20,
                      height: mobileWireframeHeight - 20,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(3, 5),
                          ),
                        ],
                      ),
                      // RESTORED: Lo-fi wireframe painter
                      child: CustomPaint(
                        painter: MobileLoFiPainter(
                          primaryColor: mobileLoFiColor.withOpacity(0.7),
                          elementColor: wireframeElementColor,
                          borderColor: wireframeBorderColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Med-fi wireframe (front layer)
            child: GestureDetector(
              onTap: () => _scrollToBottomSection(),
              child: Container(
                width: mobileWireframeWidth,
                height: mobileWireframeHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RepaintBoundary(
                    child: Container(
                      width: mobileWireframeWidth,
                      height: mobileWireframeHeight,
                      child: Image.asset(
                        'assets/med_wireframe1.webp',
                        fit: BoxFit.fill,
                        width: mobileWireframeWidth * 2, // ⭐ Force 2x rendering
                        height: mobileWireframeHeight * 2, // ⭐ Force 2x rendering
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        cacheWidth: (mobileWireframeWidth * 2).round(), // ⭐ Cache at 2x resolution
                        cacheHeight: (mobileWireframeHeight * 2).round(), // ⭐ Cache at 2x resolution
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: mobileLoFiColor.withOpacity(0.1),
                          child: Center(
                              child: Text('MOBILE WIREFRAME\nNOT FOUND')),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build static desktop lo-fi wireframe with restored background wireframes
  Widget _buildStaticDesktopWireframe() {
    return Transform.translate(
      offset: Offset(desktopWireframeLeftOffset, desktopWireframeTopOffset),
      child: Transform.rotate(
        angle: desktopWireframeTilt * (math.pi / 180),
        child: Container(
          width: desktopWireframeWidth, // Now using larger 920.0 width
          height: desktopWireframeHeight, // Now using larger 480.0 height
          clipBehavior: Clip.none,
          child: Tilt(
            tiltConfig: TiltConfig(
              angle: 15.0,
              enableReverse: false,
              filterQuality: FilterQuality.medium,
              enableGestureSensors: true,
              enableGestureHover: true,
              enableGestureTouch: true,
              enableRevert: true,
              moveDuration: Duration(milliseconds: 250),
              leaveDuration: Duration(milliseconds: 600),
            ),

            lightConfig: LightConfig(
              disable: false,
              color: const Color(0xFFFFFFFF),
              minIntensity: 0.0,
              maxIntensity: 0.15,
              spreadFactor: 2.5,
            ),

            shadowConfig: ShadowConfig(
              disable: false,
              color: Color(0xFF000000),
              minIntensity: 0.1,
              maxIntensity: 0.4,
              offsetFactor: 0.08,
              minBlurRadius: 5,
              maxBlurRadius: 12,
            ),

            borderRadius: BorderRadius.circular(8),

            // RESTORED: Lo-fi wireframe behind the med-fi one
            childLayout: ChildLayout(
              behind: [
                Positioned(
                  top: 20, // Moderate offset for depth
                  left: 20,
                  child: TiltParallax(
                    size: const Offset( -50, -40), // Moderate parallax for stability
                    child: Container(
                      width: desktopWireframeWidth -40, // Match the new larger size
                      height: desktopWireframeHeight - 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: wireframeBorderColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(3, 5),
                          ),
                        ],
                      ),
                      // RESTORED: Lo-fi wireframe painter
                      child: CustomPaint(
                        painter: DesktopLoFiPainter(
                          primaryColor: desktopLoFiColor.withOpacity(0.7),
                          elementColor: wireframeElementColor,
                          borderColor: wireframeBorderColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Med-fi wireframe (front layer) - now larger
            child: GestureDetector(
              onTap: () => _scrollToBottomSection(),
              child: Container(
                width: desktopWireframeWidth, // Larger size
                height: desktopWireframeHeight, // Larger size
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: RepaintBoundary(
                    child: Container(
                      width: desktopWireframeWidth,
                      height: desktopWireframeHeight,
                      child: Image.asset(
                        'assets/med_wireframe2.webp',
                        fit: BoxFit.fill,
                        width:
                            desktopWireframeWidth * 2, // ⭐ Force 2x rendering
                        height:
                            desktopWireframeHeight * 2, // ⭐ Force 2x rendering
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        cacheWidth: (desktopWireframeWidth * 2)
                            .round(), // ⭐ Cache at 2x resolution
                        cacheHeight: (desktopWireframeHeight * 2)
                            .round(), // ⭐ Cache at 2x resolution
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: desktopLoFiColor.withOpacity(0.1),
                          child: Center(
                              child: Text('DESKTOP WIREFRAME\nNOT FOUND')),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Scroll to bottom section when wireframes are tapped
  void _scrollToBottomSection() {
    final targetPosition =
        MediaQuery.of(context).size.height * 2.4; // Hero section height

    _mainScrollController.animateTo(
      targetPosition,
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Build bookshelf with four books - compact version for inline display
  Widget _buildBookshelf() {
    return // Four books in a ROW for side-by-side display
        Row(
      children: [


        // Book 1 - Tap In (interactive) - LARGER SIZE, NO CONTAINER CONSTRAINT
        WireframeAnimatedBook(
          title: 'Tap In',
          author: 'Case Study',
          coverAsset: 'assets/tapin_cover.png',
          spineAsset: 'assets/tapin_spine.png',
          backgroundColor: Color(0xFF2FBF71),
          textColor: Colors.white,
          width: 180, // Increased from 120
          height: 240, // Increased from 180
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TapInCaseStudy(),
              ),
            );
          },
        ),


        const SizedBox(width: 15),

        // Book 2 - Moments Case Study - LARGER SIZE, NO CONTAINER CONSTRAINT
        WireframeAnimatedBook(
          title: 'Moments',
          author: 'Case Study',
          coverAsset: 'assets/2_moon.png',
          spineAsset: 'assets/2_moon_spine.png',
          backgroundColor: Color(0xFF4ECDC4),
          textColor: Colors.white,
          width: 180, // Increased from 120
          height: 240, // Increased from 180
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MomentsCaseStudy(),
              ),
            );
          },
        ),
        const SizedBox(width: 15),

// Book 3 - Coming soon - LARGER SIZE, NO CONTAINER CONSTRAINT
        WireframeAnimatedBook(
          title: 'Project 3',
          author: 'Coming Soon',
          coverAsset: 'assets/3_dog.png',
          spineAsset: 'assets/3_dog_spine.png',
          backgroundColor: Color(0xFFFF6B6B),
          textColor: Colors.white,
          width: 180, // Increased from 120
          height: 240, // Increased from 180
          onTap: () => print('Project 3 - Coming Soon'),
        ),
        const SizedBox(width: 15),

      // Book 4 - Coming soon - LARGER SIZE, NO CONTAINER CONSTRAINT
        WireframeAnimatedBook(
          title: 'Project 4',
          author: 'Coming Soon',
          coverAsset: 'assets/4_bird.png',
          spineAsset: 'assets/4_bird_spine.png',
          backgroundColor: Color(0xFF9B59B6),
          textColor: Colors.white,
          width: 180, // Increased from 120
          height: 240, // Increased from 180
          onTap: () => print('Project 4 - Coming Soon'),
        ),
      ],
    );
  }

  double _calculateDynamicWireframeOffset(double scrollProgress) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroSectionHeight = screenHeight * 2.5; // Your hero section height
    final currentScrollOffset =
        _mainScrollController.hasClients ? _mainScrollController.offset : 0.0;

    // Start wireframes much higher - at % into hero section
    final wireframeStartPosition = heroSectionHeight * 0.7;

    // Calculate where they should end up (near bottom section)
    final wireframeEndPosition =
        heroSectionHeight + 30; // Adjust this to control end position

    // Calculate current position based on scroll
    final dynamicPosition = wireframeStartPosition -
        currentScrollOffset +
        (scrollProgress * (wireframeEndPosition - wireframeStartPosition));

    return dynamicPosition.clamp(
      -1000.0, // Allow them to go above screen
      screenHeight + 1000.0, // Allow them to go below screen
    );
  }

  double calculateResponsiveY() {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    // Position at 60% of available height (instead of absolute positioning)
    return availableHeight * 0.6;
  }
}

class DebugPositionPainter extends CustomPainter {
  final double bottomSectionOffset;
  final Size screenSize;

  DebugPositionPainter({
    required this.bottomSectionOffset,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    // Draw line at bottomSectionOffset
    canvas.drawLine(
      Offset(0, bottomSectionOffset),
      Offset(size.width, bottomSectionOffset),
      paint,
    );

    // Draw line at bottomSectionOffset + 60
    paint.color = Colors.yellow;
    canvas.drawLine(
      Offset(0, bottomSectionOffset + 60),
      Offset(size.width, bottomSectionOffset + 60),
      paint,
    );

    // Draw text labels
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Bottom Section Start',
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, bottomSectionOffset - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Add this new class for controlled scroll speed
class ControlledScrollPhysics extends ScrollPhysics {
  final double speedMultiplier;
  final double maxScrollSpeed;

  const ControlledScrollPhysics({
    ScrollPhysics? parent,
    this.speedMultiplier = 0.6, // Slow down scrolling by 40%
    this.maxScrollSpeed = 1000.0, // Max pixels per second
  }) : super(parent: parent);

  @override
  ControlledScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ControlledScrollPhysics(
      parent: buildParent(ancestor),
      speedMultiplier: speedMultiplier,
      maxScrollSpeed: maxScrollSpeed,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Limit scroll speed by reducing the offset
    final limitedOffset = offset * speedMultiplier;

    // Clamp to maximum speed if needed
    final clampedOffset = limitedOffset.clamp(
      -maxScrollSpeed / 60, // Convert to per-frame limit
      maxScrollSpeed / 60,
    );

    return super.applyPhysicsToUserOffset(position, clampedOffset);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Also limit ballistic scrolling (momentum scrolling)
    final limitedVelocity =
        velocity * speedMultiplier * 0.5; // Even slower for momentum
    return super.createBallisticSimulation(position, limitedVelocity);
  }
}

/// Custom painter for mobile medium-fi wireframe - yellow lines, no background
class MobileLoFiPainter extends CustomPainter {
  final Color primaryColor;
  final Color elementColor;
  final Color borderColor;

  MobileLoFiPainter({
    required this.primaryColor,
    required this.elementColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color(0xFFFFD700); // Golden yellow lines

    final thinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color(0xFFFFD700); // Golden yellow lines

    // Device outline
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(20)),
      paint,
    );

    // Status bar
    canvas.drawLine(Offset(10, 15), Offset(size.width - 10, 15), thinPaint);

    // Status icons
    canvas.drawCircle(Offset(15, 10), 2, thinPaint);
    canvas.drawCircle(Offset(25, 10), 2, thinPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - 25, 8, 12, 4), thinPaint);

    // Header/navigation bar
    canvas.drawRect(Rect.fromLTWH(10, 25, size.width - 20, 35), thinPaint);

    // Menu icon (hamburger)
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(15, 32 + (i * 4)),
        Offset(25, 32 + (i * 4)),
        thinPaint,
      );
    }

    // Title area
    canvas.drawRect(Rect.fromLTWH(35, 32, 60, 8), thinPaint);

    // Profile icon
    canvas.drawCircle(Offset(size.width - 20, 42), 8, thinPaint);

    // Main content cards
    final cardHeight = 45.0;
    final cardSpacing = 15.0;
    final startY = 75.0;

    for (int i = 0; i < 3; i++) {
      final cardY = startY + (i * (cardHeight + cardSpacing));

      // Card outline
      canvas.drawRRect(
        RRect.fromLTRBR(
            15, cardY, size.width - 15, cardY + cardHeight, Radius.circular(8)),
        thinPaint,
      );

      // Card image placeholder
      canvas.drawRect(Rect.fromLTWH(20, cardY + 5, 30, 20), thinPaint);

      // Card title lines
      canvas.drawLine(
        Offset(55, cardY + 8),
        Offset(size.width - 25, cardY + 8),
        thinPaint,
      );
      canvas.drawLine(
        Offset(55, cardY + 15),
        Offset(size.width - 40, cardY + 15),
        thinPaint,
      );

      // Card subtitle
      canvas.drawLine(
        Offset(55, cardY + 25),
        Offset(size.width - 60, cardY + 25),
        thinPaint,
      );

      // Action button
      canvas.drawRRect(
        RRect.fromLTRBR(size.width - 45, cardY + 30, size.width - 20,
            cardY + 40, Radius.circular(4)),
        thinPaint,
      );
    }

    // Bottom navigation
    canvas.drawLine(Offset(0, size.height - 50),
        Offset(size.width, size.height - 50), paint);

    // Bottom nav items
    final navItemWidth = size.width / 4;
    for (int i = 0; i < 4; i++) {
      final centerX = (i + 0.5) * navItemWidth;
      // Nav icon
      canvas.drawCircle(Offset(centerX, size.height - 35), 6, thinPaint);
      // Nav label
      canvas.drawLine(
        Offset(centerX - 8, size.height - 20),
        Offset(centerX + 8, size.height - 20),
        thinPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for desktop medium-fi wireframe - yellow lines, no background
class DesktopLoFiPainter extends CustomPainter {
  final Color primaryColor;
  final Color elementColor;
  final Color borderColor;

  DesktopLoFiPainter({
    required this.primaryColor,
    required this.elementColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color(0xFFFFD700); // Golden yellow lines

    final thinPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color(0xFFFFD700); // Golden yellow lines

    // Browser window outline
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(8)),
      paint,
    );

    // Browser header
    canvas.drawLine(Offset(0, 25), Offset(size.width, 25), paint);

    // Browser control buttons
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(10 + (i * 15), 12), 4, thinPaint);
    }

    // Address bar
    canvas.drawRRect(
      RRect.fromLTRBR(60, 8, size.width - 20, 20, Radius.circular(10)),
      thinPaint,
    );

    // Navigation/toolbar
    canvas.drawRect(Rect.fromLTWH(0, 25, size.width, 25), thinPaint);

    // Nav items
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(Rect.fromLTWH(10 + (i * 40), 32, 30, 10), thinPaint);
    }

    // Sidebar
    canvas.drawLine(Offset(70, 50), Offset(70, size.height), paint);

    // Sidebar items
    for (int i = 0; i < 6; i++) {
      canvas.drawRect(Rect.fromLTWH(10, 60 + (i * 20), 50, 12), thinPaint);
    }

    // Main content area header
    canvas.drawRect(Rect.fromLTWH(80, 55, size.width - 90, 20), thinPaint);

    // Content grid
    final itemWidth = (size.width - 100) / 3;
    final itemHeight = 35.0;

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 3; col++) {
        final x = 85 + (col * itemWidth);
        final y = 85 + (row * (itemHeight + 10));

        // Content item
        canvas.drawRRect(
          RRect.fromLTRBR(
              x, y, x + itemWidth - 10, y + itemHeight, Radius.circular(4)),
          thinPaint,
        );

        // Item image
        canvas.drawRect(
            Rect.fromLTWH(x + 5, y + 5, itemWidth - 20, 15), thinPaint);

        // Item title
        canvas.drawLine(Offset(x + 5, y + 25),
            Offset(x + itemWidth - 15, y + 25), thinPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
