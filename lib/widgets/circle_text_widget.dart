import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that displays text in a circular pattern with animation.
///
/// This widget arranges text characters around a circle and animates them
/// with a rotating effect.
class CircularText extends StatefulWidget {
  final String text; // The text to display in a circle
  final double radius; // Radius of the circle
  final Color textColor; // Color of the text
  final double fontSize; // Size of the text
  final Duration duration; // Duration of one complete rotation

  const CircularText({
    Key? key,
    required this.text,
    required this.radius,
    this.textColor = Colors.white,
    this.fontSize = 12.0,
    this.duration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<CircularText> createState() => _CircularTextState();
}

class _CircularTextState extends State<CircularText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller with specified duration
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a rotation animation that goes from 0 to 2π (full circle)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_animationController);

    // Start the animation and make it repeat forever
    _animationController.repeat();
  }

  @override
  void dispose() {
    // Clean up the animation controller when the widget is removed
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _CircularTextPainter(
            text: widget.text,
            radius: widget.radius,
            textColor: widget.textColor,
            fontSize: widget.fontSize,
            angle: _rotationAnimation.value,
          ),
          size: Size(widget.radius * 2, widget.radius * 2),
        );
      },
    );
  }
}

/// Custom painter that draws text along a circular path.
class _CircularTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final Color textColor;
  final double fontSize;
  final double angle;

  _CircularTextPainter({
    required this.text,
    required this.radius,
    required this.textColor,
    required this.fontSize,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Move to center of the canvas
    canvas.translate(size.width / 2, size.height / 2);

    // Apply rotation from animation
    canvas.rotate(angle);

    final double textLength = text.length.toDouble();
    final double letterSpacing = 2 * math.pi / textLength;

    // Draw each character of the text around the circle
    for (int i = 0; i < text.length; i++) {
      canvas.save();

      // Position for this letter
      final double currentAngle = i * letterSpacing;
      canvas.rotate(currentAngle);
      canvas.translate(0, -radius);

      // Rotate the letter to face outward
      canvas.rotate(math.pi / 2.0);

      // Create and draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: text[i],
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontFamily: 'Montserrat', // Match your app's font
            fontWeight: FontWeight.normal,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CircularTextPainter oldDelegate) {
    // Only repaint if the angle has changed
    return oldDelegate.angle != angle;
  }
}
