// File: lib/themes/wireframe/scroll_theme/advanced_scroll_animations.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/wireframe_color_manager.dart';


/// Advanced scroll-triggered animations and effects
class AdvancedScrollAnimations {
  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Creates floating particle effect during wireframe transition
  static Widget floatingParticles({
    required Widget child,
    required double scrollProgress,
    int particleCount = 20,
    Color? particleColor,
  }) {
    return Stack(
      children: [
        child,
        ...List.generate(particleCount, (index) {
          return _FloatingParticle(
            key: ValueKey('particle_$index'),
            scrollProgress: scrollProgress,
            index: index,
            totalParticles: particleCount,
            color: particleColor ??
                WireframeColorManager.colors.primary.withOpacity(0.3),
          );
        }),
      ],
    );
  }

  /// Creates morphing wireframe effect
  static Widget morphingWireframe({
    required Widget staticWireframe,
    required Widget interactiveWireframe,
    required double scrollProgress,
    Duration morphDuration = defaultDuration,
  }) {
    // Create intermediate morphing states
    final morphProgress = _calculateMorphProgress(scrollProgress);

    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(morphProgress),
      builder: (context, child) {
        return Stack(
          children: [
            // Static wireframe with distortion effects
            Transform(
              transform: _calculateMorphTransform(morphProgress),
              child: Opacity(
                opacity: (1.0 - morphProgress).clamp(0.0, 1.0),
                child: _MorphingFilter(
                  morphProgress: morphProgress,
                  child: staticWireframe,
                ),
              ),
            ),

            // Interactive wireframe emerging
            Transform.scale(
              scale: 0.8 + (0.2 * morphProgress),
              child: Opacity(
                opacity: morphProgress.clamp(0.0, 1.0),
                child: interactiveWireframe,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Creates wireframe construction animation
  static Widget wireframeConstruction({
    required Widget child,
    required double scrollProgress,
    Duration constructionDuration = const Duration(milliseconds: 2000),
  }) {
    return _WireframeConstructionEffect(
      scrollProgress: scrollProgress,
      child: child,
    );
  }

  /// Creates depth parallax scrolling effect
  static Widget parallaxLayer({
    required Widget child,
    required double scrollProgress,
    double parallaxIntensity = 0.5,
    ParallaxDirection direction = ParallaxDirection.vertical,
  }) {
    final offset = scrollProgress * 100 * parallaxIntensity;

    return Transform.translate(
      offset: direction == ParallaxDirection.vertical
          ? Offset(0, offset)
          : Offset(offset, 0),
      child: child,
    );
  }

  /// Creates elastic wireframe bounce effect
  static Widget elasticTransition({
    required Widget child,
    required double scrollProgress,
    double elasticIntensity = 0.3,
  }) {
    final elasticValue =
        _calculateElasticValue(scrollProgress, elasticIntensity);

    return Transform.scale(
      scale: 1.0 + elasticValue,
      child: Transform.rotate(
        angle: elasticValue * 0.1,
        child: child,
      ),
    );
  }

  /// Creates glitch effect during transition
  static Widget glitchTransition({
    required Widget child,
    required double scrollProgress,
    double glitchIntensity = 0.2,
  }) {
    if (scrollProgress < 0.3 || scrollProgress > 0.7) {
      return child;
    }

    return _GlitchEffect(
      intensity: glitchIntensity,
      child: child,
    );
  }

  /// Creates typewriter text reveal effect
  static Widget typewriterReveal({
    required String text,
    required double scrollProgress,
    TextStyle? textStyle,
    Duration typingSpeed = const Duration(milliseconds: 50),
  }) {
    return _TypewriterText(
      text: text,
      revealProgress: scrollProgress,
      textStyle: textStyle,
      typingSpeed: typingSpeed,
    );
  }

  /// Creates liquid morphing background
  static Widget liquidBackground({
    required Widget child,
    required double scrollProgress,
    List<Color>? colors,
  }) {
    return Stack(
      children: [
        _LiquidMorphBackground(
          scrollProgress: scrollProgress,
          colors: colors ??
              [
                WireframeColorManager.colors.background,
                WireframeColorManager.colors.surface,
                WireframeColorManager.colors.primary.withOpacity(0.1),
              ],
        ),
        child,
      ],
    );
  }

  // Helper methods
  static double _calculateMorphProgress(double scrollProgress) {
    if (scrollProgress < 0.3) return 0.0;
    if (scrollProgress > 0.7) return 1.0;
    return (scrollProgress - 0.3) / 0.4;
  }

  static Matrix4 _calculateMorphTransform(double progress) {
    return Matrix4.identity()
      ..setEntry(3, 2, 0.001) // Perspective
      ..rotateX(progress * 0.3)
      ..rotateY(progress * 0.2)
      ..scale(1.0 + progress * 0.1);
  }

  static double _calculateElasticValue(double progress, double intensity) {
    if (progress < 0.4 || progress > 0.8) return 0.0;

    final normalizedProgress = (progress - 0.4) / 0.4;
    return math.sin(normalizedProgress * math.pi * 3) *
        intensity *
        (1 - normalizedProgress);
  }
}

/// Individual floating particle widget
class _FloatingParticle extends StatefulWidget {
  final double scrollProgress;
  final int index;
  final int totalParticles;
  final Color color;

  const _FloatingParticle({
    Key? key,
    required this.scrollProgress,
    required this.index,
    required this.totalParticles,
    required this.color,
  }) : super(key: key);

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  late double _startX;
  late double _startY;
  late double _endX;
  late double _endY;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.index * 100)),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _initializeParticlePositions();

    if (widget.scrollProgress > 0.2 && widget.scrollProgress < 0.8) {
      _animationController.repeat(reverse: true);
    }
  }

  void _initializeParticlePositions() {
    final random = math.Random(widget.index);
    _startX = random.nextDouble() * 400;
    _startY = random.nextDouble() * 600;
    _endX = _startX + (random.nextDouble() - 0.5) * 200;
    _endY = _startY + (random.nextDouble() - 0.5) * 200;
  }

  @override
  void didUpdateWidget(_FloatingParticle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scrollProgress > 0.2 && widget.scrollProgress < 0.8) {
      if (!_animationController.isAnimating) {
        _animationController.repeat(reverse: true);
      }
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollProgress < 0.2 || widget.scrollProgress > 0.8) {
      return SizedBox.shrink();
    }

    final opacity = _calculateParticleOpacity();

    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        final currentX = _startX + (_endX - _startX) * _floatAnimation.value;
        final currentY = _startY + (_endY - _startY) * _floatAnimation.value;

        return Positioned(
          left: currentX,
          top: currentY,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 4 + (widget.index % 3) * 2,
              height: 4 + (widget.index % 3) * 2,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateParticleOpacity() {
    final transitionProgress = (widget.scrollProgress - 0.2) / 0.6;
    return (math.sin(transitionProgress * math.pi) * 0.8).clamp(0.0, 1.0);
  }
}

/// Morphing filter effect
class _MorphingFilter extends StatelessWidget {
  final double morphProgress;
  final Widget child;

  const _MorphingFilter({
    required this.morphProgress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6),
          ],
          stops: [
            0.0,
            morphProgress,
            1.0,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}

/// Wireframe construction effect
class _WireframeConstructionEffect extends StatefulWidget {
  final double scrollProgress;
  final Widget child;

  const _WireframeConstructionEffect({
    required this.scrollProgress,
    required this.child,
  });

  @override
  State<_WireframeConstructionEffect> createState() =>
      _WireframeConstructionEffectState();
}

class _WireframeConstructionEffectState
    extends State<_WireframeConstructionEffect> with TickerProviderStateMixin {
  late AnimationController _constructionController;
  late List<AnimationController> _lineControllers;

  @override
  void initState() {
    super.initState();

    _constructionController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create multiple line drawing animations
    _lineControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );
  }

  @override
  void didUpdateWidget(_WireframeConstructionEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scrollProgress > 0.3 && widget.scrollProgress < 0.7) {
      _constructionController.forward();

      // Stagger line animations
      for (int i = 0; i < _lineControllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          if (mounted) _lineControllers[i].forward();
        });
      }
    } else {
      _constructionController.reset();
      for (final controller in _lineControllers) {
        controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _constructionController.dispose();
    for (final controller in _lineControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Construction line overlays
        ...List.generate(_lineControllers.length, (index) {
          return AnimatedBuilder(
            animation: _lineControllers[index],
            builder: (context, child) {
              return CustomPaint(
                painter: _ConstructionLinePainter(
                  progress: _lineControllers[index].value,
                  lineIndex: index,
                  color: WireframeColorManager.colors.primary,
                ),
                size: Size.infinite,
              );
            },
          );
        }),
      ],
    );
  }
}

/// Glitch effect widget
class _GlitchEffect extends StatefulWidget {
  final double intensity;
  final Widget child;

  const _GlitchEffect({
    required this.intensity,
    required this.child,
  });

  @override
  State<_GlitchEffect> createState() => _GlitchEffectState();
}

class _GlitchEffectState extends State<_GlitchEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _glitchController;

  @override
  void initState() {
    super.initState();

    _glitchController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );

    _glitchController.repeat();
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        final random = math.Random(_glitchController.value.hashCode);
        final offsetX = (random.nextDouble() - 0.5) * widget.intensity * 10;
        final offsetY = (random.nextDouble() - 0.5) * widget.intensity * 10;

        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: widget.child,
        );
      },
    );
  }
}

/// Typewriter text effect
class _TypewriterText extends StatefulWidget {
  final String text;
  final double revealProgress;
  final TextStyle? textStyle;
  final Duration typingSpeed;

  const _TypewriterText({
    required this.text,
    required this.revealProgress,
    this.textStyle,
    required this.typingSpeed,
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();

    _cursorController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _cursorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersToShow =
        (widget.text.length * widget.revealProgress).round();
    final visibleText = widget.text.substring(0, charactersToShow);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          visibleText,
          style: widget.textStyle,
        ),

        // Blinking cursor
        if (widget.revealProgress > 0 && widget.revealProgress < 1)
          AnimatedBuilder(
            animation: _cursorController,
            builder: (context, child) {
              return Opacity(
                opacity: _cursorController.value,
                child: Text(
                  '|',
                  style: widget.textStyle,
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Liquid morphing background
class _LiquidMorphBackground extends StatefulWidget {
  final double scrollProgress;
  final List<Color> colors;

  const _LiquidMorphBackground({
    required this.scrollProgress,
    required this.colors,
  });

  @override
  State<_LiquidMorphBackground> createState() => _LiquidMorphBackgroundState();
}

class _LiquidMorphBackgroundState extends State<_LiquidMorphBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _morphController;

  @override
  void initState() {
    super.initState();

    _morphController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _morphController.repeat();
  }

  @override
  void dispose() {
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _morphController,
      builder: (context, child) {
        return CustomPaint(
          painter: _LiquidPainter(
            animationValue: _morphController.value,
            scrollProgress: widget.scrollProgress,
            colors: widget.colors,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for construction lines
class _ConstructionLinePainter extends CustomPainter {
  final double progress;
  final int lineIndex;
  final Color color;

  _ConstructionLinePainter({
    required this.progress,
    required this.lineIndex,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw animated construction lines based on line index
    switch (lineIndex) {
      case 0:
        _drawHorizontalLine(canvas, size, paint);
        break;
      case 1:
        _drawVerticalLine(canvas, size, paint);
        break;
      case 2:
        _drawDiagonalLine(canvas, size, paint);
        break;
      case 3:
        _drawCurvedLine(canvas, size, paint);
        break;
      case 4:
        _drawCircleLine(canvas, size, paint);
        break;
    }
  }

  void _drawHorizontalLine(Canvas canvas, Size size, Paint paint) {
    final startX = 0.0;
    final endX = size.width * progress;
    final y = size.height * 0.3;

    canvas.drawLine(
      Offset(startX, y),
      Offset(endX, y),
      paint,
    );
  }

  void _drawVerticalLine(Canvas canvas, Size size, Paint paint) {
    final x = size.width * 0.2;
    final startY = 0.0;
    final endY = size.height * progress;

    canvas.drawLine(
      Offset(x, startY),
      Offset(x, endY),
      paint,
    );
  }

  void _drawDiagonalLine(Canvas canvas, Size size, Paint paint) {
    final startX = 0.0;
    final endX = size.width * progress;
    final startY = size.height;
    final endY = size.height * (1 - progress);

    canvas.drawLine(
      Offset(startX, startY),
      Offset(endX, endY),
      paint,
    );
  }

  void _drawCurvedLine(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final controlPoint1 = Offset(size.width * 0.25, size.height * 0.2);
    final controlPoint2 = Offset(size.width * 0.75, size.height * 0.8);
    final endPoint = Offset(size.width * progress, size.height * 0.5);

    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  void _drawCircleLine(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.7, size.height * 0.7);
    final radius = 50.0 * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for liquid morphing background
class _LiquidPainter extends CustomPainter {
  final double animationValue;
  final double scrollProgress;
  final List<Color> colors;

  _LiquidPainter({
    required this.animationValue,
    required this.scrollProgress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient that morphs based on scroll and animation
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: [
        0.0,
        scrollProgress.clamp(0.3, 0.7),
        1.0,
      ],
      transform: GradientRotation(animationValue * 2 * math.pi),
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    // Draw morphing liquid shapes
    final path = Path();
    _createLiquidPath(path, size);

    canvas.drawPath(path, paint);
  }

  void _createLiquidPath(Path path, Size size) {
    final waveHeight = 50 + (scrollProgress * 30);
    final waveFrequency = 2 + (animationValue * 2);

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height -
          waveHeight +
          (math.sin((x / size.width) * waveFrequency * math.pi +
                  animationValue * 2 * math.pi) *
              waveHeight *
              0.5);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Enum for parallax direction
enum ParallaxDirection {
  vertical,
  horizontal,
}
