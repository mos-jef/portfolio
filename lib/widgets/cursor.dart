import 'package:flutter/material.dart';
import 'package:mouse_follower/mouse_follower.dart';
import 'package:flutter/foundation.dart';

class BeatRing extends StatefulWidget {
  final double size;
  final Color color;

  const BeatRing({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<BeatRing> createState() => _BeatState();
}

class _BeatState extends State<BeatRing> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final Color color = widget.color;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        final double value = _animationController.value;
        final double strokeWidth = size / 15;
        final bool isVisible = value <= 0.7;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isVisible)
                Visibility(
                  visible: isVisible,
                  child: Transform.scale(
                    scale: Tween(begin: 0.15, end: 1.0)
                        .animate(CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.0, 0.7,
                              curve: Curves.easeInCubic),
                        ))
                        .value,
                    child: Opacity(
                      opacity: Tween(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.0, 0.2),
                          ))
                          .value,
                      child: Ring(
                        color: color,
                        strokeWidth: strokeWidth,
                        size: size,
                      ),
                    ),
                  ),
                ),
              Ring(
                color: color,
                strokeWidth: strokeWidth,
                size: size,
              ),
              if (value <= 0.8 && value >= 0.7)
                Visibility(
                  visible: value <= 0.8 && value >= 0.7,
                  child: Transform.scale(
                    scale: Tween(begin: 1.0, end: 1.15)
                        .animate(CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.7, 0.8),
                        ))
                        .value,
                    child: Ring(
                      color: color,
                      strokeWidth: strokeWidth,
                      size: size,
                    ),
                  ),
                ),
              if (value >= 0.8)
                Visibility(
                  visible: value >= 0.8,
                  child: Transform.scale(
                    scale: Tween(begin: 1.15, end: 1.0)
                        .animate(CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.8, 0.9),
                        ))
                        .value,
                    child: Ring(
                      color: color,
                      strokeWidth: strokeWidth,
                      size: size,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class Ring extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double size;

  const Ring({
    super.key,
    required this.color,
    required this.strokeWidth,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RingPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BeatAnimationCircle extends StatefulWidget {
  final Color color;
  final Color borderColor;

  const BeatAnimationCircle({
    super.key,
    this.color = Colors.transparent,
    this.borderColor = Colors.transparent,
  });

  @override
  State<BeatAnimationCircle> createState() => _BeatAnimationCircleState();
}

class _BeatAnimationCircleState extends State<BeatAnimationCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(color: widget.borderColor),
            ),
          ),
        );
      },
    );
  }
}

// Global Mouse Follower Configuration
class GlobalMouseFollower extends StatelessWidget {
  final Widget child;
  final Color primaryColor;
  final Color hoverColor;
  final String hoverText;

  const GlobalMouseFollower({
    Key? key,
    required this.child,
    this.primaryColor = const Color(0xFF2FBF71), // Default green
    this.hoverColor = const Color(0xFF2FBF71),
    this.hoverText = 'CLICK',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseFollower(
      isVisible: kIsWeb,
      onHoverMouseCursor: SystemMouseCursors.click,
      mouseStylesStack: [
        MouseStyle(
          size: const Size(8, 8),
          latency: const Duration(milliseconds: 15),
          opacity: 1.0,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          visibleOnHover: false,
        ),
        MouseStyle(
          size: const Size(28, 28),
          latency: const Duration(milliseconds: 70),
          visibleOnHover: false,
          opacity: 0.8,
          child: BeatRing(color: primaryColor, size: 28),
        ),
      ],
      onHoverMouseStylesStack: [
        MouseStyle(
          opacity: 0.8,
          size: Size(60, 60),
          latency: Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: hoverColor, width: 3),
              shape: BoxShape.circle,
              color: hoverColor.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                hoverText,
                style: TextStyle(
                  color: hoverColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFPro',
                ),
              ),
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}

// Animated on hover style wrapper for easy reuse
class AnimatedOnHoverStyle extends StatelessWidget {
  final Widget child;
  final Color? hoverColor;
  final String? hoverText;

  const AnimatedOnHoverStyle({
    Key? key,
    required this.child,
    this.hoverColor,
    this.hoverText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseOnHoverEvent(
      onHoverMouseCursor: SystemMouseCursors.click,
      customOnHoverMouseStylesStack: [
        MouseStyle(
          opacity: 0.8,
          size: Size(60, 60),
          latency: Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: hoverColor ?? Color(0xFF2FBF71), width: 3),
              shape: BoxShape.circle,
              color: (hoverColor ?? Color(0xFF2FBF71)).withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                hoverText ?? 'CLICK',
                style: TextStyle(
                  color: hoverColor ?? Color(0xFF2FBF71),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFPro',
                ),
              ),
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}


