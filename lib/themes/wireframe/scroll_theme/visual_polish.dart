// File: lib/themes/wireframe/scroll_theme/visual_polish.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../utils/wireframe_color_manager.dart';

/// Advanced visual polish effects for the wireframe scroll experience
class VisualPolish {
  /// Creates ambient lighting effect that follows scroll
  static Widget ambientLighting({
    required Widget child,
    required double scrollProgress,
    Color lightColor = Colors.white,
    double intensity = 0.3,
  }) {
    return _AmbientLightingWidget(
      scrollProgress: scrollProgress,
      lightColor: lightColor,
      intensity: intensity,
      child: child,
    );
  }

  /// Creates dynamic gradient background that shifts with scroll
  static Widget dynamicGradient({
    required Widget child,
    required double scrollProgress,
    List<Color>? colors,
    BlendMode blendMode = BlendMode.overlay,
  }) {
    return _DynamicGradientWidget(
      scrollProgress: scrollProgress,
      colors: colors ??
          [
            WireframeColorManager.colors.background,
            WireframeColorManager.colors.surface,
            WireframeColorManager.colors.primary.withOpacity(0.1),
          ],
      blendMode: blendMode,
      child: child,
    );
  }

  /// Creates sophisticated blur effects for depth
  static Widget adaptiveBlur({
    required Widget child,
    required double scrollProgress,
    double maxBlur = 5.0,
    bool backgroundOnly = true,
  }) {
    return _AdaptiveBlurWidget(
      scrollProgress: scrollProgress,
      maxBlur: maxBlur,
      backgroundOnly: backgroundOnly,
      child: child,
    );
  }

  /// Creates organic noise texture overlay
  static Widget organicNoise({
    required Widget child,
    required double scrollProgress,
    double opacity = 0.03,
    double scale = 1.0,
  }) {
    return _OrganicNoiseWidget(
      scrollProgress: scrollProgress,
      opacity: opacity,
      scale: scale,
      child: child,
    );
  }

  /// Creates premium edge glow effects
  static Widget edgeGlow({
    required Widget child,
    required double scrollProgress,
    Color glowColor = Colors.blue,
    double maxGlowRadius = 20.0,
  }) {
    return _EdgeGlowWidget(
      scrollProgress: scrollProgress,
      glowColor: glowColor,
      maxGlowRadius: maxGlowRadius,
      child: child,
    );
  }

  /// Creates cinematic vignette effect
  static Widget cinematicVignette({
    required Widget child,
    required double scrollProgress,
    double intensity = 0.3,
    Color vignetteColor = Colors.black,
  }) {
    return _CinematicVignetteWidget(
      scrollProgress: scrollProgress,
      intensity: intensity,
      vignetteColor: vignetteColor,
      child: child,
    );
  }

  /// Creates sophisticated color grading
  static Widget colorGrading({
    required Widget child,
    required double scrollProgress,
    ColorGradingProfile profile = ColorGradingProfile.cinematic,
  }) {
    return _ColorGradingWidget(
      scrollProgress: scrollProgress,
      profile: profile,
      child: child,
    );
  }

  /// Creates premium frosted glass effect
  static Widget frostedGlass({
    required Widget child,
    required double scrollProgress,
    double maxFrost = 10.0,
    Color tintColor = Colors.white,
  }) {
    return _FrostedGlassWidget(
      scrollProgress: scrollProgress,
      maxFrost: maxFrost,
      tintColor: tintColor,
      child: child,
    );
  }

  /// Creates professional grid overlay
  static Widget designGrid({
    required Widget child,
    required double scrollProgress,
    bool showGrid = true,
    Color gridColor = Colors.grey,
  }) {
    if (!showGrid) return child;

    return _DesignGridWidget(
      scrollProgress: scrollProgress,
      gridColor: gridColor,
      child: child,
    );
  }
}

/// Ambient lighting widget
class _AmbientLightingWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final Color lightColor;
  final double intensity;

  const _AmbientLightingWidget({
    required this.child,
    required this.scrollProgress,
    required this.lightColor,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Ambient light overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _AmbientLightPainter(
              scrollProgress: scrollProgress,
              lightColor: lightColor,
              intensity: intensity,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dynamic gradient widget
class _DynamicGradientWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final List<Color> colors;
  final BlendMode blendMode;

  const _DynamicGradientWidget({
    required this.child,
    required this.scrollProgress,
    required this.colors,
    required this.blendMode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Dynamic gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
                stops: [
                  0.0,
                  scrollProgress.clamp(0.3, 0.7),
                  1.0,
                ],
                transform: GradientRotation(scrollProgress * 2 * math.pi),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(
                    -0.5 + scrollProgress,
                    -0.5 + scrollProgress * 0.5,
                  ),
                  radius: 1.0 + scrollProgress,
                  colors: [
                    colors.first.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Adaptive blur widget
class _AdaptiveBlurWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final double maxBlur;
  final bool backgroundOnly;

  const _AdaptiveBlurWidget({
    required this.child,
    required this.scrollProgress,
    required this.maxBlur,
    required this.backgroundOnly,
  });

  @override
  Widget build(BuildContext context) {
    final blurAmount = maxBlur * _calculateBlurCurve(scrollProgress);

    if (blurAmount <= 0) return child;

    return Stack(
      children: [
        // Blurred background
        if (backgroundOnly)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: blurAmount,
                sigmaY: blurAmount,
              ),
              child: Container(
                color: WireframeColorManager.colors.background,
              ),
            ),
          ),

        // Sharp content
        backgroundOnly
            ? child
            : ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: blurAmount,
                  sigmaY: blurAmount,
                ),
                child: child,
              ),
      ],
    );
  }

  double _calculateBlurCurve(double progress) {
    // Create a smooth curve for blur intensity
    if (progress < 0.2) return 0.0;
    if (progress > 0.8) return 0.0;

    final normalizedProgress = (progress - 0.2) / 0.6;
    return math.sin(normalizedProgress * math.pi) * 0.5;
  }
}

/// Organic noise widget
class _OrganicNoiseWidget extends StatefulWidget {
  final Widget child;
  final double scrollProgress;
  final double opacity;
  final double scale;

  const _OrganicNoiseWidget({
    required this.child,
    required this.scrollProgress,
    required this.opacity,
    required this.scale,
  });

  @override
  State<_OrganicNoiseWidget> createState() => _OrganicNoiseWidgetState();
}

class _OrganicNoiseWidgetState extends State<_OrganicNoiseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _noiseController;

  @override
  void initState() {
    super.initState();
    _noiseController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    _noiseController.repeat();
  }

  @override
  void dispose() {
    _noiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Noise overlay
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _noiseController,
            builder: (context, child) {
              return CustomPaint(
                painter: _NoisePainter(
                  scrollProgress: widget.scrollProgress,
                  animationValue: _noiseController.value,
                  opacity: widget.opacity,
                  scale: widget.scale,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Edge glow widget
class _EdgeGlowWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final Color glowColor;
  final double maxGlowRadius;

  const _EdgeGlowWidget({
    required this.child,
    required this.scrollProgress,
    required this.glowColor,
    required this.maxGlowRadius,
  });

  @override
  Widget build(BuildContext context) {
    final glowIntensity = _calculateGlowIntensity(scrollProgress);

    return Container(
      decoration: BoxDecoration(
        boxShadow: glowIntensity > 0
            ? [
                BoxShadow(
                  color: glowColor.withOpacity(glowIntensity * 0.3),
                  blurRadius: maxGlowRadius * glowIntensity,
                  spreadRadius: maxGlowRadius * glowIntensity * 0.3,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  double _calculateGlowIntensity(double progress) {
    // Glow peaks during transition phases
    if (progress < 0.2 || progress > 0.8) return 0.0;

    final normalizedProgress = (progress - 0.2) / 0.6;
    return math.sin(normalizedProgress * math.pi);
  }
}

/// Cinematic vignette widget
class _CinematicVignetteWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final double intensity;
  final Color vignetteColor;

  const _CinematicVignetteWidget({
    required this.child,
    required this.scrollProgress,
    required this.intensity,
    required this.vignetteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Vignette overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  vignetteColor.withOpacity(intensity * scrollProgress),
                ],
                stops: [0.3, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Color grading widget
class _ColorGradingWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final ColorGradingProfile profile;

  const _ColorGradingWidget({
    required this.child,
    required this.scrollProgress,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: _getColorFilter(profile, scrollProgress),
      child: child,
    );
  }

  ColorFilter _getColorFilter(ColorGradingProfile profile, double progress) {
    switch (profile) {
      case ColorGradingProfile.cinematic:
        return ColorFilter.matrix(_getCinematicMatrix(progress));
      case ColorGradingProfile.vibrant:
        return ColorFilter.matrix(_getVibrantMatrix(progress));
      case ColorGradingProfile.muted:
        return ColorFilter.matrix(_getMutedMatrix(progress));
      case ColorGradingProfile.none:
        return ColorFilter.matrix(_getIdentityMatrix());
    }
  }

  List<double> _getCinematicMatrix(double progress) {
    final strength = progress * 0.3;
    return [
      1.2 - strength,
      -0.1 * strength,
      -0.1 * strength,
      0,
      0,
      -0.1 * strength,
      1.1 - strength,
      -0.1 * strength,
      0,
      0,
      -0.2 * strength,
      -0.1 * strength,
      1.3 - strength,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  List<double> _getVibrantMatrix(double progress) {
    final strength = progress * 0.4;
    return [
      1.3 - strength,
      0,
      0,
      0,
      0,
      0,
      1.3 - strength,
      0,
      0,
      0,
      0,
      0,
      1.3 - strength,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  List<double> _getMutedMatrix(double progress) {
    final strength = progress * 0.5;
    return [
      0.8 + strength,
      0.1 * strength,
      0.1 * strength,
      0,
      0,
      0.1 * strength,
      0.8 + strength,
      0.1 * strength,
      0,
      0,
      0.1 * strength,
      0.1 * strength,
      0.8 + strength,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  List<double> _getIdentityMatrix() {
    return [
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }
}

/// Frosted glass widget
class _FrostedGlassWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final double maxFrost;
  final Color tintColor;

  const _FrostedGlassWidget({
    required this.child,
    required this.scrollProgress,
    required this.maxFrost,
    required this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final frostAmount = maxFrost * scrollProgress;

    return Stack(
      children: [
        // Frosted background
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: frostAmount,
              sigmaY: frostAmount,
            ),
            child: Container(
              color: tintColor.withOpacity(0.1 * scrollProgress),
            ),
          ),
        ),

        child,
      ],
    );
  }
}

/// Design grid widget
class _DesignGridWidget extends StatelessWidget {
  final Widget child;
  final double scrollProgress;
  final Color gridColor;

  const _DesignGridWidget({
    required this.child,
    required this.scrollProgress,
    required this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Grid overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(
              scrollProgress: scrollProgress,
              gridColor: gridColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painters for effects
class _AmbientLightPainter extends CustomPainter {
  final double scrollProgress;
  final Color lightColor;
  final double intensity;

  _AmbientLightPainter({
    required this.scrollProgress,
    required this.lightColor,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          -1.0 + scrollProgress * 2.0,
          -1.0 + scrollProgress,
        ),
        radius: 1.5,
        colors: [
          lightColor.withOpacity(intensity * scrollProgress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _NoisePainter extends CustomPainter {
  final double scrollProgress;
  final double animationValue;
  final double opacity;
  final double scale;

  _NoisePainter({
    required this.scrollProgress,
    required this.animationValue,
    required this.opacity,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity * scrollProgress);

    final random = math.Random(42); // Fixed seed for consistent noise

    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 * scale;

      // Animate noise particles
      final animatedX = x + math.sin(animationValue * 2 * math.pi + i) * 10;
      final animatedY = y + math.cos(animationValue * 2 * math.pi + i) * 10;

      canvas.drawCircle(
        Offset(animatedX, animatedY),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GridPainter extends CustomPainter {
  final double scrollProgress;
  final Color gridColor;

  _GridPainter({
    required this.scrollProgress,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.1 * scrollProgress)
      ..strokeWidth = 1.0;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Color grading profiles
enum ColorGradingProfile {
  none,
  cinematic,
  vibrant,
  muted,
}
