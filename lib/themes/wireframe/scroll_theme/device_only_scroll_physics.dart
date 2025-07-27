import 'package:flutter/material.dart';

class DeviceOnlyScrollPhysics extends ScrollPhysics {
  final bool allowScroll;

  const DeviceOnlyScrollPhysics({
    ScrollPhysics? parent,
    this.allowScroll = true,
  }) : super(parent: parent);

  @override
  DeviceOnlyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return DeviceOnlyScrollPhysics(
      parent: buildParent(ancestor),
      allowScroll: allowScroll,
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    if (!allowScroll) {
      return false; // COMPLETELY BLOCK ALL SCROLL
    }
    return super.shouldAcceptUserOffset(position);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (!allowScroll) {
      return 0.0; // ZERO MOVEMENT
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (!allowScroll) {
      return null; // NO MOMENTUM SCROLLING
    }
    return super.createBallisticSimulation(position, velocity);
  }
}
