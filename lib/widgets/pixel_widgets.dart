import 'package:flutter/material.dart';

class PixelContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final Color borderColor;

  const PixelContainer({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(12.0),
    this.borderWidth = 4.0,
    this.borderColor = const Color(0xFF2B2A2F),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      padding: padding,
      child: child,
    );
  }
}

class PixelButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isPrimary;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width; // Added width parameter
  final Color? backgroundColor; // Custom background color
  final Color? textColor; // Custom text color
  final double borderWidth; // Control border width
  final Color borderColor; // Control border color
  final double borderRadius; // Control corner radius
  final bool showShadow; // Toggle shadow on/off

  const PixelButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.isPrimary = false,
    this.padding,
    this.height,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderWidth = 2.0,
    this.borderColor = const Color(0xFF2B2A2F),
    this.borderRadius = 8.0, // Default to square corners
    this.showShadow = true, // Default to showing shadow
  }) : super(key: key);

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use provided padding or default
    final buttonPadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    // Get background color based on state

    Color getButtonColor() {

      // If custom background color is provided, use it with state opacity

      if (widget.backgroundColor != null) {
        if (_isPressed) {
          return widget.backgroundColor!.withAlpha(255);
        } else if (_isHovered) {
          return widget.backgroundColor!.withAlpha(255);
        } else {
          return widget.backgroundColor!;
        }
      } else {
        // Otherwise, use theme colors based on primary state
        if (_isPressed) {
          return widget.isPrimary
              ? theme.colorScheme.primary.withAlpha(255)
              : theme.cardColor.withAlpha(255);
        } else if (_isHovered) {
          return widget.isPrimary
              ? theme.colorScheme.primary.withAlpha(255)
              : theme.cardColor.withAlpha(255);
        } else {
          return widget.isPrimary ? theme.colorScheme.primary : theme.cardColor;
        }
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: buttonPadding,
          decoration: BoxDecoration(
            color: getButtonColor(),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
            boxShadow: widget.showShadow && !_isPressed
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 0,
                    )
                  ]
                : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 12,
              color: widget.textColor ??
                  (widget.isPrimary
                      ? const Color(0xFF191A19)      // color of text in primary buttons?
                      : theme.textTheme.bodyMedium?.color),
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

class PixelIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const PixelIcon({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.iconTheme.color;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor,
        border: Border.all(
          color: Color(0xFF2B2A2F),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: size * 0.6,
        color: Color(0xFF2B2A2F),
      ),
    );
  }
}
