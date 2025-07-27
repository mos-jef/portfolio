// File: lib/themes/wireframe/widgets/retro_grid_background.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'dart:math' as math;

class RetroGridBackground extends StatefulWidget {
  final double angle;
  final Widget? child;

  const RetroGridBackground({
    Key? key,
    this.angle = 65,
    this.child,
  }) : super(key: key);

  @override
  State<RetroGridBackground> createState() => _RetroGridBackgroundState();
}

class _RetroGridBackgroundState extends State<RetroGridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gridAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Slower for subtle effect
      vsync: this,
    )..repeat();

    _gridAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Color(0xFF2B2A2F),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            children: [
              // Perspective Grid
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: AnimatedBuilder(
                  animation: _gridAnimation,
                  builder: (context, child) => Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.004)
                      ..rotateX(-30 * math.pi / 180)
                      ..scale(2.0, 2.0, 2.0),
                    alignment: Alignment.bottomCenter,
                    child: CustomPaint(
                      size: Size(size.width, size.height),
                      painter: WireframeGridPainter(
                        offset: _gridAnimation.value,
                        colors: WireframeColorManager.colors,
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient Overlay for fade effect
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.transparent,
                        WireframeColorManager.colors.background .withOpacity(0.05),
                      ],
                      stops: const [0.6, 0.8],
                    ),
                  ),
                ),
              ),

              // Content
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

class WireframeGridPainter extends CustomPainter {
  final double offset;
  final dynamic colors; // WireframeColorScheme
  final double gridSize = 40.0;

  WireframeGridPainter({
    required this.offset,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          colors.textSecondary.withOpacity(0.2) // Use wireframe theme colors
      ..strokeWidth = 1.5;

    // Calculate grid lines with animation offset
    final verticalLines = (size.width / gridSize).ceil() + 1;
    final horizontalLines = (size.height / gridSize).ceil() + 1;

    // Draw vertical lines
    for (var i = 0; i < verticalLines; i++) {
      final x = i * gridSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines with animation
    for (var i = 0; i < horizontalLines; i++) {
      final y = (i * gridSize) - (offset * gridSize * 2);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WireframeGridPainter oldDelegate) =>
      offset != oldDelegate.offset;
}
