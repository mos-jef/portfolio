// File: lib/themes/wireframe/scroll_theme/scroll_animation_controller.dart
import 'package:flutter/material.dart';

class ScrollAnimationController {
  final TickerProvider tickerProvider;
  final ScrollController scrollController;

  // Animation controllers for different effects
  late AnimationController _positionAnimationController;
  late AnimationController _opacityAnimationController;
  late AnimationController _scaleAnimationController;

  // Animations
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  // Notifiers for real-time updates
  final ValueNotifier<double> scrollProgressNotifier =
      ValueNotifier<double>(0.0);
  final ValueNotifier<ScrollPhase> currentPhaseNotifier =
      ValueNotifier<ScrollPhase>(ScrollPhase.static);

  // Animation configuration
  static const Duration _animationDuration = Duration(milliseconds: 300);

  ScrollAnimationController({
    required this.tickerProvider,
    required this.scrollController,
  }) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Position animation controller
    _positionAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: tickerProvider,
    );

    // Opacity animation controller
    _opacityAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: tickerProvider,
    );

    // Scale animation controller
    _scaleAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: tickerProvider,
    );

    // Create animations with curves
    _positionAnimation = CurvedAnimation(
      parent: _positionAnimationController,
      curve: Curves.easeInOut,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _opacityAnimationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.elasticOut,
    );
  }

  /// Update scroll progress and trigger appropriate animations
  void updateScrollProgress(double progress) {
    scrollProgressNotifier.value = progress;

    // Determine current scroll phase
    ScrollPhase newPhase;
    if (progress < 0.2) {
      newPhase = ScrollPhase.static;
    } else if (progress < 0.7) {
      newPhase = ScrollPhase.transitioning;
    } else {
      newPhase = ScrollPhase.interactive;
    }

    // Update phase if changed
    if (currentPhaseNotifier.value != newPhase) {
      currentPhaseNotifier.value = newPhase;
      _onPhaseChanged(newPhase);
    }

    // Update animation controllers based on progress
    _updateAnimationControllers(progress);
  }

  void _onPhaseChanged(ScrollPhase phase) {
    switch (phase) {
      case ScrollPhase.static:
        // Reset to static state
        _positionAnimationController.reset();
        _opacityAnimationController.reset();
        _scaleAnimationController.reset();
        break;

      case ScrollPhase.transitioning:
        // Start transition animations
        _positionAnimationController.forward();
        _opacityAnimationController.forward();
        break;

      case ScrollPhase.interactive:
        // Complete transition to interactive state
        _positionAnimationController.forward();
        _opacityAnimationController.forward();
        _scaleAnimationController.forward();
        break;
    }
  }

  void _updateAnimationControllers(double progress) {
    // Map scroll progress to animation values

    // Position animation: 0.0 to 0.7 scroll progress
    final positionProgress = (progress / 0.7).clamp(0.0, 1.0);
    _positionAnimationController.value = positionProgress;

    // Opacity animation: static elements fade out 0.0-0.5, interactive fade in 0.3-0.8
    final staticOpacityProgress = (1.0 - progress * 2.0).clamp(0.0, 1.0);
    final interactiveOpacityProgress = ((progress - 0.3) / 0.5).clamp(0.0, 1.0);
    _opacityAnimationController.value = interactiveOpacityProgress;

    // Scale animation: subtle scale effect during transition
    final scaleProgress = _calculateScaleProgress(progress);
    _scaleAnimationController.value = scaleProgress;
  }

  double _calculateScaleProgress(double scrollProgress) {
    // Create a subtle scaling effect during the transition phase
    if (scrollProgress < 0.2 || scrollProgress > 0.8) {
      return 0.0; // No scaling at start or end
    }

    // Scale peaks at middle of transition (around 0.5 progress)
    final transitionProgress = (scrollProgress - 0.2) / 0.6; // Normalize to 0-1
    final scaleCurve = Curves.easeInOut.transform(transitionProgress);

    // Create a bell curve effect
    return 4 * scaleCurve * (1 - scaleCurve);
  }

  /// Get current static wireframe opacity
  double get staticWireframeOpacity {
    final progress = scrollProgressNotifier.value;
    return (1.0 - progress * 2.0).clamp(0.0, 1.0);
  }

  /// Get current interactive wireframe opacity
  double get interactiveWireframeOpacity {
    final progress = scrollProgressNotifier.value;
    return ((progress - 0.3) / 0.5).clamp(0.0, 1.0);
  }

  /// Get current wireframe scale
  double get wireframeScale {
    final baseScale = 1.0;
    final scaleModifier = _scaleAnimation.value * 0.1; // Subtle scaling
    return baseScale + scaleModifier;
  }

  /// Calculate interpolated position for wireframe elements
  Offset interpolatePosition({
    required Offset startPosition,
    required Offset endPosition,
    double? customProgress,
  }) {
    final progress = customProgress ?? _positionAnimation.value;
    return Offset.lerp(startPosition, endPosition, progress) ?? startPosition;
  }

  /// Calculate interpolated rotation for wireframe elements
  double interpolateRotation({
    required double startRotation,
    required double endRotation,
    double? customProgress,
  }) {
    final progress = customProgress ?? _positionAnimation.value;
    return startRotation + (endRotation - startRotation) * progress;
  }

  /// Get transition hint opacity
  double get transitionHintOpacity {
    final progress = scrollProgressNotifier.value;
    if (progress < 0.1) return 1.0;
    if (progress > 0.4) return 0.0;
    return (0.4 - progress) / 0.3;
  }

  /// Check if scroll is in specific phase
  bool isInPhase(ScrollPhase phase) {
    return currentPhaseNotifier.value == phase;
  }

  /// Get smooth easing value for custom animations
  double getEasedProgress({
    Curve curve = Curves.easeInOut,
    double startThreshold = 0.0,
    double endThreshold = 1.0,
  }) {
    final progress = scrollProgressNotifier.value;
    final normalizedProgress =
        ((progress - startThreshold) / (endThreshold - startThreshold))
            .clamp(0.0, 1.0);
    return curve.transform(normalizedProgress);
  }

  void dispose() {
    _positionAnimationController.dispose();
    _opacityAnimationController.dispose();
    _scaleAnimationController.dispose();
    scrollProgressNotifier.dispose();
    currentPhaseNotifier.dispose();
  }
}

/// Enum representing different phases of the scroll animation
enum ScrollPhase {
  static, // Initial state with static wireframes
  transitioning, // Wireframes are moving and transitioning
  interactive, // Full interactive wireframe theme visible
}

/// Configuration class for scroll animation settings
class ScrollAnimationConfig {
  final double staticPhaseEnd;
  final double transitionPhaseStart;
  final double transitionPhaseEnd;
  final double interactivePhaseStart;
  final Duration animationDuration;
  final Curve positionCurve;
  final Curve opacityCurve;
  final Curve scaleCurve;

  const ScrollAnimationConfig({
    this.staticPhaseEnd = 0.2,
    this.transitionPhaseStart = 0.2,
    this.transitionPhaseEnd = 0.7,
    this.interactivePhaseStart = 0.7,
    this.animationDuration = const Duration(milliseconds: 300),
    this.positionCurve = Curves.easeInOut,
    this.opacityCurve = Curves.easeIn,
    this.scaleCurve = Curves.elasticOut,
  });

  /// Default configuration
  static const defaultConfig = ScrollAnimationConfig();

  /// Fast configuration for quick transitions
  static const fastConfig = ScrollAnimationConfig(
    staticPhaseEnd: 0.15,
    transitionPhaseStart: 0.15,
    transitionPhaseEnd: 0.6,
    interactivePhaseStart: 0.6,
    animationDuration: Duration(milliseconds: 200),
  );

  /// Slow configuration for dramatic effect
  static const slowConfig = ScrollAnimationConfig(
    staticPhaseEnd: 0.3,
    transitionPhaseStart: 0.25,
    transitionPhaseEnd: 0.8,
    interactivePhaseStart: 0.75,
    animationDuration: Duration(milliseconds: 500),
    positionCurve: Curves.elasticOut,
  );
}
