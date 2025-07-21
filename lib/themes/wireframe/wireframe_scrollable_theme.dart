// File: lib/themes/wireframe/wireframe_scrollable_theme.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/desktop_animated_desktop_frame.dart';
import 'package:portfolio_website/themes/wireframe/widgets/folder_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/grid_background.dart';
import 'package:portfolio_website/themes/wireframe/widgets/responsive_device_frame.dart';
import 'package:portfolio_website/themes/wireframe/widgets/vinyl_widget.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_desktop_theme.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';
import 'scroll_theme/scroll_animation_controller.dart';
import 'scroll_theme/scroll_performance_optimizer.dart';


class WireframeScrollableTheme extends StatefulWidget {
  const WireframeScrollableTheme({Key? key}) : super(key: key);

  @override
  State<WireframeScrollableTheme> createState() =>_WireframeScrollableThemeState();
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

  // ===== SECTION HEIGHT CONFIGURATION =====

  // Adjust these values to control section sizes
  static const double topSectionMultiplier = 0.3; // 0.9 = 90% of screen height
  static const double transitionSectionMultiplier = 0.2; // 0.5 = 50% of screen height
  static const double bottomSectionMultiplier = 0.5; // 1.0 = 100% of screen height

  // ===== ANIMATION TIMING CONTROLS =====
  static const double animationStartProgress = 0.3; // Start animation at 30% scroll
  static const double animationEndProgress = 1.1; // Complete animation at 100% scroll
  static const bool useEasingCurves = true; // Enable smooth easing
  static const double easingStrength = 3.0; // Higher = more dramatic easing

  // Animation smoothness controls
  static const double animationSmoothnessMultiplier = 2.0; // Higher = slower, smoother

  static const bool useEaseInOutCurve = true; // Smooth acceleration/deceleration

  bool _hasAnimationCompleted = false; //  One-Time Only Animation
  bool _shouldReset = false; // Add this

  // ===== WIREFRAME VISIBILITY CONTROLS =====
  static const double wireframeHideThreshold = 1.0; // Change this to control when wireframes disappear
  static const bool disableAutoHide = true; // Set to true to keep wireframes always visible

  // ===== MANUAL ALIGNMENT ADJUSTMENTS =====


  // Change these numbers to fine-tune alignment
  static const double mobileXOffset = 0.0; // was 102.0 // Negative = left, Positive = right
  static const double mobileYOffset = 0.0; // was -480.0 // Negative = up, Positive = down
  static const double desktopXOffset = 0.0; // was 20.0 // Negative = left, Positive = right
  static const double desktopYOffset = 0.0; // was -480.0 // Negative = up, Positive = down


  // ===== WIREFRAME SIZE ADJUSTMENTS =====
  static const double mobileSizeMultiplier = 1.0; // Change this to adjust mobile size
  static const double desktopSizeMultiplier = 2.5; // Change this to adjust desktop size

  // ===== RESPONSIVE WIREFRAME SIZING =====
  static const double mobileWidthPercent = 0.15; // 15% of screen width
  static const double mobileHeightPercent = 0.32; // 32% of screen width (maintains aspect)
  static const double desktopWidthPercent = 0.60; // % of screen width
  static const double desktopHeightPercent = 0.37; // % of screen width (maintains aspect)

  // Grid configuration for easy customization
  static const double topGridSize = 30.0;
  static const double topGridOpacity = 0.15;
  static const double topGridStrokeWidth = 1.0;

  static const double middleGridSize = 25.0;
  static const double middleGridOpacity = 0.1;
  static const double middleGridStrokeWidth = 0.8;

  // ===== WIREFRAME CUSTOMIZATION CONSTANTS =====

  // Mobile wireframe size controls (now responsive)
  static double getMobileWireframeWidth(double screenWidth) => screenWidth * 0.151; // 15% of screen width
  static double getMobileWireframeHeight(double screenWidth) => screenWidth * 0.323; // 30% of screen width (maintains aspect ratio)
  static const double mobileCornerRadius = 40.0; // Change this for rounded corners (0 = square)
  static const Color mobileWireframeColor = Colors.blue;
  static const double mobileWireframeOpacity = 0.8;
  static const double mobileBorderWidth = 2.0;
  static const Color mobileBorderColor = Colors.white;

  // Desktop wireframe size controls (now responsive)
  static double getDesktopWireframeWidth(double screenWidth) => screenWidth * 0.603; // 55% of screen width
  static double getDesktopWireframeHeight(double screenWidth) => screenWidth * 0.37; // 35% of screen width (maintains 16:9 aspect ratio)
  static const double desktopCornerRadius = 0.0; // Change this for rounded corners
  static const Color desktopWireframeColor = Colors.green;
  static const double desktopWireframeOpacity = 0.9;
  static const double desktopBorderWidth = 3.0;
  static const Color desktopBorderColor = Colors.red;

  // ===== POSITION CUSTOMIZATION CONSTANTS =====
  // ===== TRULY RESPONSIVE POSITION CONSTANTS =====

  // Mobile wireframe position controls (percentage-based)
  static const double mobileStartXPercent = 0.05; // 5% from left edge
  static const double mobileStartYPercent = 0.25; // 25% from top
  static const double mobileEndXPercent = 0.110; // 11% from left edge (you can change this)
  static const double mobileEndYPercent = 0.210; // e.g. 0.60 is 60% from top

  // Desktop wireframe position controls (percentage-based)
  static const double desktopStartXPercent = 0.75; // 75% from left (25% from right)
  static const double desktopStartYPercent = 0.20; // 20% from top
  static const double desktopEndXPercent = 0.55; // 55% from left edge (matches desktop mockup area)
  static const double desktopEndYPercent = 0.208; // Keep same Y position

  @override
  void initState() {
    super.initState();

    _mainScrollController = ScrollController();
    _desktopThemeScrollController = ScrollController();

    _scrollAnimationController = ScrollAnimationController(
      tickerProvider: this,
      scrollController: _mainScrollController,
    );

    // Add optimized scroll listener with performance monitoring
    ScrollPerformanceOptimizer.addOptimizedScrollListener(
      _mainScrollController,
      _onScrollChanged,
      throttle: true,
    );

    // Add smooth animation controller
    _smoothnessController = AnimationController(
      duration: Duration(milliseconds: 1000), // Adjust for speed
      vsync: this,
    );

    _smoothAnimation = CurvedAnimation(
      parent: _smoothnessController,
      curve: Curves.easeInOutCubic, // Very smooth curve
    );
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onScrollChanged);
    _mainScrollController.dispose();
    _desktopThemeScrollController.dispose();
    _scrollAnimationController.dispose();
    super.dispose();
  }

  void _onScrollChanged() {
    if (!mounted) return;

    ScrollPerformanceMonitor.recordFrame();

    final scrollOffset = _mainScrollController.offset;
    final maxScrollOffset = _mainScrollController.position.maxScrollExtent;
    final rawProgress = (scrollOffset / maxScrollOffset).clamp(0.0, 1.0);

    // Reset logic: if user scrolls back to top, reset the animation
    if (rawProgress < 0.1 && _hasAnimationCompleted) {
      _hasAnimationCompleted = false; // Reset the lock
      _shouldReset = true; // Flag for position calculation
    } else {
      _shouldReset = false;
    }

    // Use locked progress if animation completed, otherwise use smooth progress
    final scrollProgress = _hasAnimationCompleted ? 1.0 : _applySmoothEasing(rawProgress);

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
    final responsiveScale =  WireframeLayoutConstants.getResponsiveScale(screenSize.width);

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
    final mobileTargetY = (_topHalfHeight + _transitionZoneHeight + (_bottomHalfHeight * 0.3));

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
    // Smooth ease-in-out curve with adjustable strength
    if (progress < 0.5) {
      return math.pow(2 * progress, easingStrength) / 2;
    } else {
      return 1 - math.pow(2 * (1 - progress), easingStrength) / 2;
    }
  }

  // Add this NEW METHOD to calculate where the hi-fi wireframes actually appear
  Map<String, Offset> _calculateHiFiPositions(BoxConstraints constraints) {
    final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
    final responsiveScale = WireframeLayoutConstants.getResponsiveScale(screenSize.width);

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
    final dividerWidth = 1.0;
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
    final finalMobileTargetX = mobileAreaCenterX - (mobileDeviceSize.width * 0.5) + mobileContentOffsetX + mobileDebugOffsetX;
    final calculatedMobileY = bottomSectionY + (200) + mobileDebugOffsetY; // 200px into bottom section
    final finalMobileTargetY = calculateSafeY(calculatedMobileY);

    final finalDesktopTargetX = desktopAreaCenterX - (desktopDeviceSize.width * 0.5) + desktopContentOffsetX + desktopDebugOffsetX;
    final calculatedDesktopY = bottomSectionY + (200) + desktopDebugOffsetY; // 200px into bottom section
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

  // Target Position Calculator
  Offset _getTargetPosition(GlobalKey targetKey,
      {Offset fallback = Offset.zero}) {
    try {
      final RenderBox? renderBox =
          targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        return Offset(
            position.dx + size.width * 0.1, position.dy + size.height * 0.2);
      }
    } catch (e) {
      print('🚨 Target position calculation failed: $e');
    }
    return fallback;
  }

  Size _getTargetSize(GlobalKey targetKey,
      {Size fallback = const Size(300, 600)}) {
    try {
      final RenderBox? renderBox =
          targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        return renderBox.size;
      }
    } catch (e) {
      print('🚨 Target size calculation failed: $e');
    }
    return fallback;
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
        (constraints.maxHeight * 0.3); // 30% into bottom section

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
                              screenSize.width))) / 2,
            ),
            vertical: screenSize.height * 0.02,),
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
                color: Colors.grey.withValues(alpha: 0.2),
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

  @override
  Widget build(BuildContext context) {print('🔍 DEBUG: WireframeScrollableTheme.build() called - SIMPLE VERSION');

    // Initialize dimensions
    _calculateDimensions(BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    ));

    // ADD THIS DEBUG CALL
    debugWireframePositioning();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Simple scrollable content
          CustomScrollView(
            controller: _mainScrollController,
            slivers: [

              // NEW HERO SECTION with vinyl animations
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 3.4, // Larger hero area
                  width: double.infinity,
                  child: GridBackground(
                    gridColor: Color(0xFFF5E9D8),
                    gridOpacity: 0.05,
                    gridSize: 30.0,
                    strokeWidth: 1.0,
                    backgroundColor: Color(0xFF2B2A2F),
                    child: Stack(
                      children: [

                       // Main hero content
                        Container(
                          padding:
                              EdgeInsets.only(top: 100, left: 40, right: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main title
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
                                  'Crafting digital experiences through wireframes, prototypes, and thoughtful design systems.',
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
                                  height: 200), // More space after description
                              // Navigation sections with vinyl animations
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3), // Push vinyl sections way down
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildHeroSection('Work'),
                                    _buildHeroSection('About'),
                                    _buildHeroSection('Contact'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // BOTTOM SECTION - Hi Fidelity Wireframe Desktop Theme
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 900,
                  width: double.infinity,
                  child: ColoredBox(
                    color: WireframeColorManager.colors.background,
                    child: Container(
                      key: _desktopTargetKey,
                      child: WireframeDesktopTheme(
                        isScrollableMode: true,
                        fixedHeight: 900,
                        externalScrollController: _desktopThemeScrollController,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating wireframes overlay - using mirrored layout

          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedBuilder(
                animation: _scrollAnimationController
                    .scrollProgressNotifier, // ✅ Match your current structure
                builder: (context, child) {
                  final scrollProgress = _scrollAnimationController
                      .scrollProgressNotifier
                      .value; // ✅ Match your current structure

                  // Keep your auto-hide logic if you want it
                  final hideThreshold =
                      disableAutoHide ? 2.0 : wireframeHideThreshold;
                  final shouldShowWireframes = scrollProgress < hideThreshold;

                  if (!shouldShowWireframes) {
                    return SizedBox.shrink();
                  }

                  // Calculate where the bottom section actually starts
                  final actualBottomSectionStart = MediaQuery.of(context).size.height * 2.5; // Your hero section height

                  return Positioned(
                    left: 0,
                    right: 0,
                    top: actualBottomSectionStart + 100, // Position right after hero section
                    height: 900,
                    child: IgnorePointer(
                      child: _buildMirrorLayout(constraints, scrollProgress),
                    ),
                  );
                },
              );
            },
          ),
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

    // Update to match actual hero section height of 2.5x screen height
    _topHalfHeight = screenHeight * 2.5; // Match your hero section height
    _transitionZoneHeight = screenHeight * transitionSectionMultiplier;
    _bottomHalfHeight = screenHeight * bottomSectionMultiplier;

    _totalHeight = _topHalfHeight + _transitionZoneHeight + _bottomHalfHeight;

    print('🔧 SECTION HEIGHTS:');
    print('- Top: ${_topHalfHeight.toStringAsFixed(0)}px (2.5x screen height)');
    print('- Transition: ${_transitionZoneHeight.toStringAsFixed(0)}px (${(transitionSectionMultiplier * 100).toStringAsFixed(0)}% of screen)');
    print('- Bottom: ${_bottomHalfHeight.toStringAsFixed(0)}px (${(bottomSectionMultiplier * 100).toStringAsFixed(0)}% of screen)');
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

  // Mirror strategy helpers
  Widget _buildFloatingMobileWireframe(
      BoxConstraints constraints, double scrollProgress) {

        debugWireframePositioning(constraints, scrollProgress);

    // Calculate the exact container layout matching the bottom section
    final screenSize = MediaQuery.of(context).size;
    final containerWidth = 1600.0; // Same as bottom section
    final containerHeight = 900.0 - (screenSize.height * 0.04);

    // Mobile area gets flex 1 of 4 (25% of container width)
    final mobileAreaWidth = containerWidth * 0.25;

    // Calculate device scale exactly like ResponsiveDeviceFrame
    const deviceWidth = 320.0;
    const deviceHeight = 635.0;

    // Scale based on available mobile area, not full constraints
    final mobileAreaConstraints = BoxConstraints(
      maxWidth: mobileAreaWidth,
      maxHeight: containerHeight,
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

    // Vertical animation (starts at bottom position, moves up)
    final startY = 1400.0; // Start at its final position
    final endY = -(_topHalfHeight * 0.001); // Move up into top section
    final currentY = startY + (endY - startY) * smoothProgress;

    // Fade out as it reaches final position
    final restingThreshold = 0.99; // Start fading when 95% of animation is complete
    final fadeOutProgress = smoothProgress >= restingThreshold
        ? (smoothProgress - restingThreshold) / (1.0 - restingThreshold)
        : 0.0;

    // Ensure complete transparency at the end
    final opacity = smoothProgress >= 0.99
        ? 0.0 // Completely invisible when 98% complete
        : (desktopWireframeOpacity * (1.0 - fadeOutProgress)).clamp(0.0, 1.0);

    // final opacity = desktopWireframeOpacity; // Always use full opacity

    return SizedBox(
      width: scaledWidth,
      height: scaledHeight,
      child: Transform.translate(
        offset: Offset(0, currentY),
        child: Transform.rotate(
          angle: _calculateMobileRotation(scrollProgress),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: opacity,
            child: IPhoneFrame(
              content: Container(
                color: mobileWireframeColor.withValues(alpha: opacity),
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
    final endY = -(_topHalfHeight * 0.001);
    final currentY = startY + (endY - startY) * smoothProgress;


    // Fade out when wireframes reach their resting position
    final restingThreshold = 0.99; // Start fading when 95% of animation is complete
    final fadeOutProgress = smoothProgress >= restingThreshold
        ? (smoothProgress - restingThreshold) / (1.0 - restingThreshold)
        : 0.0;

    // Ensure complete transparency at the end
    final opacity = smoothProgress >= 0.99
        ? 0.0 // Completely invisible when 98% complete
        : (mobileWireframeOpacity * (1.0 - fadeOutProgress)).clamp(0.0, 1.0);



    // final opacity = desktopWireframeOpacity; // Always use full opacity

    return SizedBox(
      width: scaledWidth,
      height: scaledHeight,
      child: Transform.translate(
        offset: Offset(0, currentY),
        child: Transform.rotate(
          angle: _calculateDesktopRotation(scrollProgress),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: opacity,
            child: ChromeFrame(
              content: Container(
                color: desktopWireframeColor.withValues(alpha: opacity),
                child: Center(
                  child: Text(
                    'DESKTOP FLOATING',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
          safeAreaBottom - 300, // 300 = estimated device frame height
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

  /// Build hero section with vinyl animation
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
        const SizedBox(height: 40),

        // Folder animation container
        if (title == 'Work')
          FolderWidget(
            title: 'Tap In',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TapInCaseStudy(),
                ),
              );
            },
          )
        else
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
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
