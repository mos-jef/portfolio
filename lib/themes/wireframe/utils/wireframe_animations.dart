import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

/// Animation controllers and configurations for the wireframe theme
/// Provides consistent animation behaviors across all wireframe components
class WireframeAnimations {
  WireframeAnimations._(); // Private constructor

  // ===== ANIMATION DURATIONS =====
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 600);
  static const Duration extraSlowDuration = Duration(milliseconds: 1000);

  // ===== ANIMATION CURVES =====
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve enterCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceEnterCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  // ===== SLIDE ANIMATIONS =====

  /// Creates a slide transition from bottom to top
  static SlideTransition slideFromBottom({
    required Animation<double> animation,
    required Widget child,
    Offset? begin,
    Offset? end,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: begin ?? const Offset(0.0, 1.0),
      end: end ?? const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animation,
      curve: enterCurve,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }

  /// Creates a slide transition from right to left
  static SlideTransition slideFromRight({
    required Animation<double> animation,
    required Widget child,
    double distance = 1.0,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(distance, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animation,
      curve: enterCurve,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }

  /// Creates a slide transition from left to right
  static SlideTransition slideFromLeft({
    required Animation<double> animation,
    required Widget child,
    double distance = 1.0,
  }) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(-distance, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animation,
      curve: enterCurve,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }

  // ===== FADE ANIMATIONS =====

  /// Creates a fade transition
  static FadeTransition fade({
    required Animation<double> animation,
    required Widget child,
    double begin = 0.0,
    double end = 1.0,
  }) {
    final fadeAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: defaultCurve,
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }

  /// Creates a fade in transition with a delay
  static Widget fadeInDelayed({
    required Widget child,
    Duration delay = const Duration(milliseconds: 0),
    Duration duration = normalDuration,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + delay,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Interval(
        delay.inMilliseconds / (duration + delay).inMilliseconds,
        1.0,
        curve: curve,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // ===== SCALE ANIMATIONS =====

  /// Creates a scale transition
  static ScaleTransition scale({
    required Animation<double> animation,
    required Widget child,
    double begin = 0.0,
    double end = 1.0,
    Alignment alignment = Alignment.center,
  }) {
    final scaleAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: bounceEnterCurve,
    ));

    return ScaleTransition(
      scale: scaleAnimation,
      alignment: alignment,
      child: child,
    );
  }

  //// Creates a scale up animation on tap
  static Widget scaleOnTap({
    required Widget child,
    required VoidCallback onTap,
    double scale = 0.95,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: 1.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapDown: (_) {
                // Scale down
              },
              onTapUp: (_) {
                // Scale back up
                onTap();
              },
              onTapCancel: () {
                // Scale back up
              },
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  // ===== ROTATION ANIMATIONS =====

  /// Creates a rotation transition
  static RotationTransition rotate({
    required Animation<double> animation,
    required Widget child,
    double begin = 0.0,
    double end = 1.0,
    Alignment alignment = Alignment.center,
  }) {
    final rotationAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: defaultCurve,
    ));

    return RotationTransition(
      turns: rotationAnimation,
      alignment: alignment,
      child: child,
    );
  }

  // ===== SIZE ANIMATIONS =====

  /// Creates a size transition
  static SizeTransition sizeTransition({
    required Animation<double> animation,
    required Widget child,
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      axis: axis,
      axisAlignment: axisAlignment,
      child: child,
    );
  }

  // ===== COMBINED ANIMATIONS =====

  /// Creates a slide and fade transition
  static Widget slideAndFade({
    required Animation<double> animation,
    required Widget child,
    Offset slideBegin = const Offset(0.0, 1.0),
    Offset slideEnd = const Offset(0.0, 0.0),
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: slideBegin,
        end: slideEnd,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: enterCurve,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: fadeBegin,
          end: fadeEnd,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: defaultCurve,
        )),
        child: child,
      ),
    );
  }

  /// Creates a scale and fade transition
  static Widget scaleAndFade({
    required Animation<double> animation,
    required Widget child,
    double scaleBegin = 0.8,
    double scaleEnd = 1.0,
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: scaleBegin,
        end: scaleEnd,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: bounceEnterCurve,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: fadeBegin,
          end: fadeEnd,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: defaultCurve,
        )),
        child: child,
      ),
    );
  }

  // ===== ANIMATED BUILDERS =====

  /// Creates a staggered animation for a list of children
  static List<Widget> staggeredChildren({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration itemDuration = normalDuration,
    Curve curve = defaultCurve,
    WireframeAnimationType animationType = WireframeAnimationType.fadeInUp,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      final delay = Duration(milliseconds: staggerDelay.inMilliseconds * index);

      return _buildStaggeredItem(
        child: child,
        delay: delay,
        duration: itemDuration,
        curve: curve,
        animationType: animationType,
      );
    }).toList();
  }

  /// Builds a single staggered item
  static Widget _buildStaggeredItem({
    required Widget child,
    required Duration delay,
    required Duration duration,
    required Curve curve,
    required WireframeAnimationType animationType,
  }) {
    switch (animationType) {
      case WireframeAnimationType.fadeIn:
        return fadeInDelayed(
          child: child,
          delay: delay,
          duration: duration,
          curve: curve,
        );

      case WireframeAnimationType.fadeInUp:
        return TweenAnimationBuilder<double>(
          duration: duration + delay,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Interval(
            delay.inMilliseconds / (duration + delay).inMilliseconds,
            1.0,
            curve: curve,
          ),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: child,
        );

      case WireframeAnimationType.slideInLeft:
        return TweenAnimationBuilder<double>(
          duration: duration + delay,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Interval(
            delay.inMilliseconds / (duration + delay).inMilliseconds,
            1.0,
            curve: curve,
          ),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(-50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: child,
        );

      case WireframeAnimationType.scaleIn:
        return TweenAnimationBuilder<double>(
          duration: duration + delay,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Interval(
            delay.inMilliseconds / (duration + delay).inMilliseconds,
            1.0,
            curve: curve,
          ),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: child,
        );
    }
  }

  // ===== ANIMATED CONTAINERS =====

  /// Creates an animated container with hover effects
  static Widget animatedHoverContainer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 200),
    double hoverScale = 1.05,
    Color? hoverColor,
    BoxShadow? hoverShadow,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: duration,
            curve: defaultCurve,
            transform: Matrix4.identity()..scale(isHovered ? hoverScale : 1.0),
            decoration: BoxDecoration(
              color: isHovered ? hoverColor : null,
              boxShadow:
                  isHovered && hoverShadow != null ? [hoverShadow] : null,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Creates an animated card with entrance animation
  static Widget animatedCard({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = normalDuration,
    WireframeAnimationType animationType = WireframeAnimationType.fadeInUp,
  }) {
    return _buildStaggeredItem(
      child: child,
      delay: delay,
      duration: duration,
      curve: defaultCurve,
      animationType: animationType,
    );
  }

  // ===== LOADING ANIMATIONS =====

  /// Creates a shimmer loading effect
  static Widget shimmerLoading({
    required Widget child,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
    Duration period = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      duration: period,
      tween: Tween<double>(begin: -1.0, end: 2.0),
      curve: Curves.linear,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlidingGradientTransform(slidePercent: value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  /// Creates a pulse loading animation
  static Widget pulseLoading({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
    double minOpacity = 0.5,
    double maxOpacity = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: minOpacity, end: maxOpacity),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      onEnd: () {
        // Reverse the animation (this would need to be implemented with AnimationController)
      },
      child: child,
    );
  }

  // ===== PAGE TRANSITIONS =====

  /// Creates a page route with custom transition
  static PageRouteBuilder<T> createPageRoute<T>({
    required Widget page,
    WireframePageTransition transition = WireframePageTransition.slideLeft,
    Duration duration = normalDuration,
    Curve curve = defaultCurve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildPageTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          transition: transition,
          curve: curve,
        );
      },
    );
  }

  /// Builds the page transition based on type
  static Widget _buildPageTransition({
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    required WireframePageTransition transition,
    required Curve curve,
  }) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    switch (transition) {
      case WireframePageTransition.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case WireframePageTransition.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case WireframePageTransition.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case WireframePageTransition.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case WireframePageTransition.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case WireframePageTransition.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.1,
            end: 0.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }

  // ===== UTILITY METHODS =====

  /// Creates an animation controller with the specified duration
  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = normalDuration,
    double? value,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    return AnimationController(
      duration: duration,
      value: value,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: vsync,
    );
  }

  /// Creates a curved animation from a controller
  static CurvedAnimation createCurvedAnimation({
    required AnimationController controller,
    Curve curve = defaultCurve,
    Curve? reverseCurve,
  }) {
    return CurvedAnimation(
      parent: controller,
      curve: curve,
      reverseCurve: reverseCurve,
    );
  }

  /// Disposes a list of animation controllers
  static void disposeControllers(List<AnimationController> controllers) {
    for (final controller in controllers) {
      controller.dispose();
    }
  }
}

// ===== ENUMS =====

/// Animation types for wireframe components
enum WireframeAnimationType {
  fadeIn,
  fadeInUp,
  slideInLeft,
  scaleIn,
}

/// Page transition types
enum WireframePageTransition {
  slideLeft,
  slideRight,
  slideUp,
  fade,
  scale,
  rotation,
}

// ===== HELPER CLASSES =====

/// Custom gradient transform for shimmer effect
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * slidePercent,
      0.0,
      0.0,
    );
  }
}

/// Animation configuration class
class WireframeAnimationConfig {
  final Duration duration;
  final Curve curve;
  final bool enableAnimations;
  final double staggerDelay;

  const WireframeAnimationConfig({
    this.duration = WireframeAnimations.normalDuration,
    this.curve = WireframeAnimations.defaultCurve,
    this.enableAnimations = true,
    this.staggerDelay = 100.0,
  });

  /// Default configuration
  static const defaultConfig = WireframeAnimationConfig();

  /// Fast configuration for quick interactions
  static const fastConfig = WireframeAnimationConfig(
    duration: WireframeAnimations.fastDuration,
    staggerDelay: 50.0,
  );

  /// Slow configuration for dramatic effects
  static const slowConfig = WireframeAnimationConfig(
    duration: WireframeAnimations.slowDuration,
    curve: Curves.elasticOut,
    staggerDelay: 200.0,
  );

  /// Accessibility configuration (reduced animations)
  static const accessibilityConfig = WireframeAnimationConfig(
    duration: WireframeAnimations.fastDuration,
    enableAnimations: false,
    staggerDelay: 0.0,
  );
}
