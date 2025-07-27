// File: lib/themes/wireframe/scroll_theme/wireframe_scroll_physics.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom scroll physics that clamps main scroll position and redirects overflow
class WireframeScrollPhysics extends ScrollPhysics {
  final bool isInBottomSection;
  final double clampPosition;
  final Function(double)? onScrollRedirect;

  const WireframeScrollPhysics({
    ScrollPhysics? parent,
    required this.isInBottomSection,
    required this.clampPosition,
    this.onScrollRedirect,
  }) : super(parent: parent);

  @override
  WireframeScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return WireframeScrollPhysics(
      parent: buildParent(ancestor),
      isInBottomSection: isInBottomSection,
      clampPosition: clampPosition,
      onScrollRedirect: onScrollRedirect,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (!isInBottomSection) {
      // Normal scrolling in top section
      return super.applyPhysicsToUserOffset(position, offset);
    }

    // In bottom section - check if we're at clamp position
    final currentPosition = position.pixels;
    final targetPosition = currentPosition + offset;

    if (targetPosition <= clampPosition) {
      // Allow normal scrolling if still below clamp position
      return super.applyPhysicsToUserOffset(position, offset);
    } else {
      // At or above clamp position - redirect scroll delta to wireframes
      final clampedOffset = clampPosition - currentPosition;
      final redirectedDelta = offset - clampedOffset;

      // Send excess scroll to wireframes
      if (redirectedDelta.abs() > 0.1) {
        onScrollRedirect?.call(redirectedDelta);
      }

      // Only allow scroll up to clamp position
      return math.max(0.0, clampedOffset);
    }
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (isInBottomSection && value > clampPosition) {
      // Prevent scrolling beyond clamp position
      return value - clampPosition;
    }
    return super.applyBoundaryConditions(position, value);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (isInBottomSection && position.pixels >= clampPosition) {
      // Stop ballistic scrolling at clamp position
      return null;
    }
    return super.createBallisticSimulation(position, velocity);
  }
}
