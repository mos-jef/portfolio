// File: lib/themes/wireframe/scroll_theme/micro_interactions.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../utils/wireframe_color_manager.dart';

/// Advanced micro-interactions for the wireframe scroll experience
class MicroInteractions {
  /// Creates a magnetic hover effect that attracts cursor to interactive elements
  static Widget magneticHover({
    required Widget child,
    double magnetStrength = 20.0,
    Duration responseDuration = const Duration(milliseconds: 200),
    bool enableHaptics = true,
  }) {
    return _MagneticHoverWidget(
      magnetStrength: magnetStrength,
      responseDuration: responseDuration,
      enableHaptics: enableHaptics,
      child: child,
    );
  }

  /// Creates a ripple effect that follows scroll progression
  static Widget scrollRipple({
    required Widget child,
    required double scrollProgress,
    Color? rippleColor,
    double maxRadius = 100.0,
  }) {
    return _ScrollRippleWidget(
      scrollProgress: scrollProgress,
      rippleColor:
          rippleColor ?? WireframeColorManager.colors.primary.withOpacity(0.3),
      maxRadius: maxRadius,
      child: child,
    );
  }

  /// Creates breathing animation for static wireframes
  static Widget breathingFrame({
    required Widget child,
    Duration breathDuration = const Duration(milliseconds: 3000),
    double breathIntensity = 0.05,
    bool enableBreathing = true,
  }) {
    if (!enableBreathing) return child;

    return _BreathingWidget(
      breathDuration: breathDuration,
      breathIntensity: breathIntensity,
      child: child,
    );
  }

  /// Creates cursor trail effect during scroll
  static Widget cursorTrail({
    required Widget child,
    int trailLength = 10,
    Color? trailColor,
    Duration fadeOutDuration = const Duration(milliseconds: 500),
  }) {
    return _CursorTrailWidget(
      trailLength: trailLength,
      trailColor:
          trailColor ?? WireframeColorManager.colors.primary.withOpacity(0.6),
      fadeOutDuration: fadeOutDuration,
      child: child,
    );
  }

  /// Creates smart scroll hints that appear contextually
  static Widget smartScrollHints({
    required Widget child,
    required double scrollProgress,
    bool showHints = true,
  }) {
    if (!showHints) return child;

    return _SmartScrollHintsWidget(
      scrollProgress: scrollProgress,
      child: child,
    );
  }

  /// Creates depth-aware shadows that respond to scroll
  static Widget depthShadows({
    required Widget child,
    required double scrollProgress,
    double maxElevation = 20.0,
    Color? shadowColor,
  }) {
    return _DepthShadowWidget(
      scrollProgress: scrollProgress,
      maxElevation: maxElevation,
      shadowColor: shadowColor ?? Colors.black.withOpacity(0.3),
      child: child,
    );
  }

  /// Creates anticipatory animations before scroll events
  static Widget anticipatoryResponse({
    required Widget child,
    required ScrollController scrollController,
    Duration anticipationDuration = const Duration(milliseconds: 150),
  }) {
    return _AnticipatoryResponseWidget(
      scrollController: scrollController,
      anticipationDuration: anticipationDuration,
      child: child,
    );
  }

  /// Creates contextual tooltips that appear during interactions
  static Widget contextualTooltips({
    required Widget child,
    required double scrollProgress,
    List<ScrollTooltip> tooltips = const [],
  }) {
    return _ContextualTooltipsWidget(
      scrollProgress: scrollProgress,
      tooltips: tooltips,
      child: child,
    );
  }

  /// Creates progressive disclosure of UI elements
  static Widget progressiveDisclosure({
    required Widget child,
    required double scrollProgress,
    List<DisclosureElement> elements = const [],
  }) {
    return _ProgressiveDisclosureWidget(
      scrollProgress: scrollProgress,
      elements: elements,
      child: child,
    );
  }
}

/// Magnetic hover effect widget
class _MagneticHoverWidget extends StatefulWidget {
  final Widget child;
  final double magnetStrength;
  final Duration responseDuration;
  final bool enableHaptics;

  const _MagneticHoverWidget({
    required this.child,
    required this.magnetStrength,
    required this.responseDuration,
    required this.enableHaptics,
  });

  @override
  State<_MagneticHoverWidget> createState() => _MagneticHoverWidgetState();
}

class _MagneticHoverWidgetState extends State<_MagneticHoverWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Offset _magnetOffset = Offset.zero;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.responseDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onHover,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final offset = _magnetOffset * _animationController.value;
          return Transform.translate(
            offset: offset,
            child: widget.child,
          );
        },
      ),
    );
  }

  void _onEnter(PointerEnterEvent event) {
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _isHovered = true;
    });
    _animationController.forward();
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _isHovered = false;
    });
    _animationController.reverse();
    _magnetOffset = Offset.zero;
  }

  void _onHover(PointerHoverEvent event) {
    if (!_isHovered) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final center = Offset(size.width / 2, size.height / 2);
    final localPosition = renderBox.globalToLocal(event.position);

    final distance = (localPosition - center).distance;
    final maxDistance =
        math.sqrt(size.width * size.width + size.height * size.height) / 2;

    if (distance < maxDistance) {
      final direction = (center - localPosition).normalized;
      final strength = (1 - distance / maxDistance) * widget.magnetStrength;

      setState(() {
        _magnetOffset = direction * strength;
      });
    }
  }
}

/// Scroll ripple effect widget
class _ScrollRippleWidget extends StatefulWidget {
  final Widget child;
  final double scrollProgress;
  final Color rippleColor;
  final double maxRadius;

  const _ScrollRippleWidget({
    required this.child,
    required this.scrollProgress,
    required this.rippleColor,
    required this.maxRadius,
  });

  @override
  State<_ScrollRippleWidget> createState() => _ScrollRippleWidgetState();
}

class _ScrollRippleWidgetState extends State<_ScrollRippleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  List<RippleCircle> _ripples = [];

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_ScrollRippleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Create new ripple when scroll progress changes significantly
    if ((widget.scrollProgress - oldWidget.scrollProgress).abs() > 0.1) {
      _createRipple();
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _createRipple() {
    final ripple = RippleCircle(
      startTime: DateTime.now(),
      position: Offset(
        math.Random().nextDouble() * 400,
        math.Random().nextDouble() * 600,
      ),
      maxRadius: widget.maxRadius,
      color: widget.rippleColor,
    );

    setState(() {
      _ripples.add(ripple);

      // Remove old ripples
      _ripples.removeWhere(
          (r) => DateTime.now().difference(r.startTime).inMilliseconds > 1000);
    });

    _rippleController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Ripple overlays
        ...(_ripples.map((ripple) => AnimatedBuilder(
              animation: _rippleController,
              builder: (context, child) {
                final age =
                    DateTime.now().difference(ripple.startTime).inMilliseconds;
                final progress = (age / 1000.0).clamp(0.0, 1.0);

                return Positioned(
                  left: ripple.position.dx - (ripple.maxRadius * progress),
                  top: ripple.position.dy - (ripple.maxRadius * progress),
                  child: Container(
                    width: ripple.maxRadius * 2 * progress,
                    height: ripple.maxRadius * 2 * progress,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ripple.color.withOpacity(1 - progress),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ))),
      ],
    );
  }
}

/// Breathing animation widget
class _BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration breathDuration;
  final double breathIntensity;

  const _BreathingWidget({
    required this.child,
    required this.breathDuration,
    required this.breathIntensity,
  });

  @override
  State<_BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<_BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();

    _breathController = AnimationController(
      duration: widget.breathDuration,
      vsync: this,
    );

    _breathAnimation = Tween<double>(
      begin: 1.0 - widget.breathIntensity,
      end: 1.0 + widget.breathIntensity,
    ).animate(CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOut,
    ));

    _breathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _breathAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Cursor trail effect widget
class _CursorTrailWidget extends StatefulWidget {
  final Widget child;
  final int trailLength;
  final Color trailColor;
  final Duration fadeOutDuration;

  const _CursorTrailWidget({
    required this.child,
    required this.trailLength,
    required this.trailColor,
    required this.fadeOutDuration,
  });

  @override
  State<_CursorTrailWidget> createState() => _CursorTrailWidgetState();
}

class _CursorTrailWidgetState extends State<_CursorTrailWidget> {
  List<TrailPoint> _trailPoints = [];

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      child: Stack(
        children: [
          widget.child,

          // Trail points
          ...(_trailPoints.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;
            final age =
                DateTime.now().difference(point.timestamp).inMilliseconds;
            final maxAge = widget.fadeOutDuration.inMilliseconds;
            final opacity = (1.0 - age / maxAge).clamp(0.0, 1.0);
            final size = 8.0 * opacity;

            return Positioned(
              left: point.position.dx - size / 2,
              top: point.position.dy - size / 2,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: widget.trailColor.withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          })),
        ],
      ),
    );
  }

  void _onHover(PointerHoverEvent event) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(event.position);

    setState(() {
      _trailPoints.add(TrailPoint(
        position: localPosition,
        timestamp: DateTime.now(),
      ));

      // Remove old points
      _trailPoints.removeWhere((point) =>
          DateTime.now().difference(point.timestamp) > widget.fadeOutDuration);

      // Limit trail length
      if (_trailPoints.length > widget.trailLength) {
        _trailPoints.removeAt(0);
      }
    });
  }
}

/// Smart scroll hints widget
class _SmartScrollHintsWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;

  const _SmartScrollHintsWidget({
    required this.child,
    required this.scrollProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Scroll hint at the beginning
        if (scrollProgress < 0.1)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: _buildScrollHint('Scroll to explore the wireframe journey'),
          ),

        // Transition hint
        if (scrollProgress > 0.2 && scrollProgress < 0.4)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            child: _buildScrollHint('Watch wireframes come to life'),
          ),

        // Interactive hint
        if (scrollProgress > 0.6 && scrollProgress < 0.8)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _buildScrollHint(
                'Now you can interact with the live wireframes'),
          ),
      ],
    );
  }

  Widget _buildScrollHint(String text) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: WireframeColorManager.colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app,
              size: 16,
              color: WireframeColorManager.colors.primary,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: WireframeColorManager.colors.text,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Depth shadow widget
class _DepthShadowWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final double maxElevation;
  final Color shadowColor;

  const _DepthShadowWidget({
    required this.child,
    required this.scrollProgress,
    required this.maxElevation,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final elevation = maxElevation * scrollProgress;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: elevation,
            offset: Offset(0, elevation * 0.5),
            spreadRadius: elevation * 0.1,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Anticipatory response widget
class _AnticipatoryResponseWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration anticipationDuration;

  const _AnticipatoryResponseWidget({
    required this.child,
    required this.scrollController,
    required this.anticipationDuration,
  });

  @override
  State<_AnticipatoryResponseWidget> createState() =>
      _AnticipatoryResponseWidgetState();
}

class _AnticipatoryResponseWidgetState
    extends State<_AnticipatoryResponseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _anticipationController;
  double _lastScrollOffset = 0.0;
  bool _isAnticipating = false;

  @override
  void initState() {
    super.initState();

    _anticipationController = AnimationController(
      duration: widget.anticipationDuration,
      vsync: this,
    );

    widget.scrollController.addListener(_onScrollChange);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollChange);
    _anticipationController.dispose();
    super.dispose();
  }

  void _onScrollChange() {
    final currentOffset = widget.scrollController.offset;
    final velocity = (currentOffset - _lastScrollOffset).abs();

    if (velocity > 5.0 && !_isAnticipating) {
      _startAnticipation();
    }

    _lastScrollOffset = currentOffset;
  }

  void _startAnticipation() {
    setState(() {
      _isAnticipating = true;
    });

    _anticipationController.forward().then((_) {
      if (mounted) {
        setState(() {
          _isAnticipating = false;
        });
        _anticipationController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anticipationController,
      builder: (context, child) {
        final scale = 1.0 + (_anticipationController.value * 0.02);
        return Transform.scale(
          scale: scale,
          child: widget.child,
        );
      },
    );
  }
}

/// Contextual tooltips widget
class _ContextualTooltipsWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final List<ScrollTooltip> tooltips;

  const _ContextualTooltipsWidget({
    required this.child,
    required this.scrollProgress,
    required this.tooltips,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Show relevant tooltips based on scroll progress
        ...tooltips
            .where((tooltip) =>
                scrollProgress >= tooltip.showAtProgress &&
                scrollProgress <= tooltip.hideAtProgress)
            .map((tooltip) => Positioned(
                  left: tooltip.position.dx,
                  top: tooltip.position.dy,
                  child: _buildTooltip(tooltip),
                )),
      ],
    );
  }

  Widget _buildTooltip(ScrollTooltip tooltip) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tooltip.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Progressive disclosure widget
class _ProgressiveDisclosureWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final List<DisclosureElement> elements;

  const _ProgressiveDisclosureWidget({
    required this.child,
    required this.scrollProgress,
    required this.elements,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Show elements progressively
        ...elements.map((element) {
          final shouldShow = scrollProgress >= element.revealAtProgress;
          final opacity = shouldShow ? 1.0 : 0.0;

          return AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: element.position.dx,
            top: element.position.dy,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: opacity,
              child: element.widget,
            ),
          );
        }),
      ],
    );
  }
}

// Helper classes
class RippleCircle {
  final DateTime startTime;
  final Offset position;
  final double maxRadius;
  final Color color;

  RippleCircle({
    required this.startTime,
    required this.position,
    required this.maxRadius,
    required this.color,
  });
}

class TrailPoint {
  final Offset position;
  final DateTime timestamp;

  TrailPoint({
    required this.position,
    required this.timestamp,
  });
}

class ScrollTooltip {
  final String text;
  final Offset position;
  final double showAtProgress;
  final double hideAtProgress;

  const ScrollTooltip({
    required this.text,
    required this.position,
    required this.showAtProgress,
    required this.hideAtProgress,
  });
}

class DisclosureElement {
  final Widget widget;
  final Offset position;
  final double revealAtProgress;

  const DisclosureElement({
    required this.widget,
    required this.position,
    required this.revealAtProgress,
  });
}

// Extension for normalized vectors
extension OffsetExtension on Offset {
  Offset get normalized {
    final magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return this / magnitude;
  }
}
