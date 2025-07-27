import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouse_follower/mouse_follower.dart';
import 'dart:async';

/// Enum to control mouse follower behavior in different zones
enum MouseFollowerMode {
  full, // Full effects (default)
  simplified, // Basic cursor only, no hover effects
  disabled, // Completely disabled
}

/// A debounced mouse region that prevents excessive updates
class DebouncedMouseRegion extends StatefulWidget {
  final Widget child;
  final Duration debounceDuration;
  final double movementThreshold;
  final Function(PointerHoverEvent)? onHover;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;

  const DebouncedMouseRegion({
    Key? key,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 16), // ~60fps
    this.movementThreshold = 2.0, // Ignore movements smaller than 2 pixels
    this.onHover,
    this.onEnter,
    this.onExit,
  }) : super(key: key);

  @override
  State<DebouncedMouseRegion> createState() => _DebouncedMouseRegionState();
}

class _DebouncedMouseRegionState extends State<DebouncedMouseRegion> {
  Timer? _debounceTimer;
  Offset? _lastPosition;

  void _handleMouseMove(PointerHoverEvent event) {
    final currentPosition = event.position;

    // Check if movement is significant enough
    if (_lastPosition != null) {
      final distance = (currentPosition - _lastPosition!).distance;
      if (distance < widget.movementThreshold) {
        return; // Ignore tiny movements
      }
    }

    _lastPosition = currentPosition;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set up new debounced call
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onHover?.call(event);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onEnter?.call(),
      onExit: (_) {
        _debounceTimer?.cancel();
        _lastPosition = null;
        widget.onExit?.call();
      },
      onHover: _handleMouseMove,
      child: widget.child,
    );
  }
}

/// Widget that creates a dead zone for mouse follower effects
class MouseFollowerDeadZone extends StatelessWidget {
  final Widget child;
  final MouseFollowerMode mode;
  final bool addRepaintBoundary;

  const MouseFollowerDeadZone({
    Key? key,
    required this.child,
    this.mode = MouseFollowerMode.simplified,
    this.addRepaintBoundary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Add repaint boundary if requested
    if (addRepaintBoundary) {
      result = RepaintBoundary(child: result);
    }

    // Apply mouse follower modifications based on mode
    switch (mode) {
      case MouseFollowerMode.disabled:
        // Completely disable mouse follower in this zone
        return MouseFollower(
          isVisible: false,
          child: result,
        );

      case MouseFollowerMode.simplified:
        // Use simplified mouse styles in this zone
        return MouseFollower(
          mouseStylesStack: [
            MouseStyle(
              size: const Size(8, 8),
              latency: const Duration(milliseconds: 0),
              opacity: 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              visibleOnHover: false,
            ),
          ],
          // Disable hover effects
          onHoverMouseStylesStack: [],
          child: result,
        );

      case MouseFollowerMode.full:
        // No modifications needed
        return result;
    }
  }
}

/// Performance-optimized mouse region for heavy widgets
class PerformantMouseRegion extends StatelessWidget {
  final Widget child;
  final bool enableHover;
  final VoidCallback? onTap;

  const PerformantMouseRegion({
    Key? key,
    required this.child,
    this.enableHover = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!enableHover && onTap == null) {
      return child;
    }

    return DebouncedMouseRegion(
      debounceDuration:
          const Duration(milliseconds: 32), // Slower updates for performance
      movementThreshold: 5.0, // Higher threshold
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
