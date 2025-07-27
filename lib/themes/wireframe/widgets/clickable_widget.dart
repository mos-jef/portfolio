// File: lib/widgets/clickable_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouse_follower/mouse_follower.dart';

/// A reusable widget that makes any child clickable with proper cursor behavior
class ClickableWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final SystemMouseCursor cursor;
  final bool enabled;
  final bool enableMouseFollowerHover; // Add option to disable if needed

  const ClickableWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
    this.enableMouseFollowerHover = true, // Default to true
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

    // Build the base interactive widget
    Widget interactiveWidget = child;

    // Wrap with GestureDetector if any interactions are provided
    if (onTap != null || onLongPress != null || onDoubleTap != null) {
      interactiveWidget = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        child: child,
      );
    }

    // Check if we're on mobile to disable MouseFollower effects
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Always wrap with MouseOnHoverEvent for hover effects (unless disabled or on mobile)
    if (enableMouseFollowerHover &&
        !isMobile &&
        (onTap != null || onLongPress != null || onDoubleTap != null)) {
      try {
        return MouseOnHoverEvent(
          onHoverMouseCursor: cursor,
          child: interactiveWidget,
        );
      } catch (e) {
        // Fallback to regular MouseRegion if MouseFollowerProvider isn't available
        return MouseRegion(
          cursor: cursor,
          child: interactiveWidget,
        );
      }
    }

// If no mouse follower hover or on mobile, just use MouseRegion
    return MouseRegion(
      cursor: isMobile ? SystemMouseCursors.basic : cursor,
      child: interactiveWidget,
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
  final bool enableMouseFollowerHover;

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
    this.enableMouseFollowerHover = true,
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

    // Use MouseOnHoverEvent for clickable containers
    if (enableMouseFollowerHover) {
      return MouseOnHoverEvent(
        onHoverMouseCursor: cursor,
        child: GestureDetector(
          onTap: onTap,
          child: container,
        ),
      );
    }

    // Fallback to regular MouseRegion
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
  final bool enableMouseFollowerHover;

  const ClickableText({
    Key? key,
    required this.text,
    this.onTap,
    this.style,
    this.hoverStyle,
    this.cursor = SystemMouseCursors.click,
    this.enabled = true,
    this.enableMouseFollowerHover = true,
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

    // Use MouseOnHoverEvent for clickable text
    if (enableMouseFollowerHover) {
      return MouseOnHoverEvent(
        onHoverMouseCursor: cursor,
        child: GestureDetector(
          onTap: onTap,
          child: textWidget,
        ),
      );
    }

    // Fallback to regular implementation
    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: onTap,
        child: textWidget,
      ),
    );
  }
}
