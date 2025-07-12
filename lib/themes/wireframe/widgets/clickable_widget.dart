// File: lib/widgets/clickable_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget that makes any child clickable with proper cursor behavior
class ClickableWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final SystemMouseCursor cursor;
  final bool enabled;

  const ClickableWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If disabled, just return child with forbidden cursor
    if (!enabled) {
      return MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: child,
      );
    }

    // If no interactions provided, just return child with cursor
    if (onTap == null && onLongPress == null && onDoubleTap == null) {
      return MouseRegion(
        cursor: cursor,
        child: child,
      );
    }

    // Return interactive widget
    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: child,
      ),
    );
  }
}

/// A clickable container with built-in styling
class ClickableContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final SystemMouseCursor cursor;
  final bool enabled;

  const ClickableContainer({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );

    if (!enabled) {
      return MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: container,
      );
    }

    if (onTap == null) {
      return container;
    }

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        child: container,
      ),
    );
  }
}

/// A clickable text widget
class ClickableText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle? style;
  final TextStyle? hoverStyle;
  final SystemMouseCursor cursor;
  final bool enabled;

  const ClickableText({
    Key? key,
    required this.text,
    this.onTap,
    this.style,
    this.hoverStyle,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      text,
      style: style,
    );

    if (!enabled || onTap == null) {
      return MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.basic : SystemMouseCursors.forbidden,
        child: textWidget,
      );
    }

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        child: textWidget,
      ),
    );
  }
}
