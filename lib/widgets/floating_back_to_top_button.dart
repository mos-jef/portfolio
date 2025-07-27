// File: lib/widgets/floating_back_to_top_button.dart
import 'package:flutter/material.dart';

class FloatingBackToTopButton extends StatelessWidget {
  final ScrollController scrollController;
  final double? bottom;
  final double? right;
  final double size;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double borderWidth;

  const FloatingBackToTopButton({
    Key? key,
    required this.scrollController,
    this.bottom = 24.0,
    this.right = 24.0,
    this.size = 56.0,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.iconColor = Colors.black,
    this.borderWidth = 1.0,
  }) : super(key: key);

  void _scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Material(
        elevation: 4,
        shape: CircleBorder(
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        color: backgroundColor,
        child: InkWell(
          onTap: _scrollToTop,
          customBorder: CircleBorder(),
          child: Container(
            width: size,
            height: size,
            child: Icon(
              Icons.keyboard_arrow_up,
              color: iconColor,
              size: size * 0.6, // Icon size relative to container
            ),
          ),
        ),
      ),
    );
  }
}
