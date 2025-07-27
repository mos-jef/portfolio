// File: lib/themes/wireframe/scroll_theme/scroll_controller_manager.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Manages scroll controllers and position clamping for wireframe theme
class ScrollControllerManager {
  final ScrollController mainController;
  final ScrollController? mobileController;
  final ScrollController? desktopController;

  bool _isInBottomSection = false;
  double _clampPosition = 0.0;
  double _lastMainPosition = 0.0;
  bool _isHijacked = false;
  bool mainScrollDisabled = false;

  // Callbacks
  VoidCallback? onBottomSectionEntered;
  VoidCallback? onBottomSectionExited;
  Function(double)? onScrollRedirected;

  ScrollControllerManager({
    required this.mainController,
    this.mobileController,
    this.desktopController,
    this.onBottomSectionEntered,
    this.onBottomSectionExited,
    this.onScrollRedirected,
  }) {
    _initializeListeners();
  }

  void _initializeListeners() {
    mainController.addListener(_onMainScroll);
  }

  void _onMainScroll() {
    // Don't process if main scroll is disabled
    if (mainScrollDisabled) {
      return;
    }

    if (_isHijacked) {
      // Prevent main scroll changes when hijacked
      _revertMainScrollPosition();
      return;
    }

    final currentPosition = mainController.offset;
    final delta = currentPosition - _lastMainPosition;
    _lastMainPosition = currentPosition;

    // Check if entering/exiting bottom section
    final wasInBottomSection = _isInBottomSection;
    _isInBottomSection = currentPosition >= _clampPosition;

    if (_isInBottomSection != wasInBottomSection) {
      if (_isInBottomSection) {
        _enterBottomSection();
      } else {
        _exitBottomSection();
      }
    }

    // If in bottom section and scrolling down, hijack control
    if (_isInBottomSection && delta > 0) {
      _hijackScrollControl();
      _redirectScrollToWireframes(delta);
    }
  }

  /// Control main scroll state from external components
  void setMainScrollEnabled(bool enabled) {
    mainScrollDisabled = !enabled;
    print(
        '📱 Main scroll ${enabled ? 'ENABLED' : 'DISABLED'} via ScrollControllerManager');
  }

  void _enterBottomSection() {
    print('📱 Entering bottom section - activating scroll control');
    onBottomSectionEntered?.call();
  }

  void _exitBottomSection() {
    print('📱 Exiting bottom section - releasing scroll control');
    _releaseScrollControl();
    onBottomSectionExited?.call();
  }

  void _hijackScrollControl() {
    if (!_isHijacked) {
      _isHijacked = true;
      print('🔒 Hijacking main scroll control');
    }
  }

  void _releaseScrollControl() {
    if (_isHijacked) {
      _isHijacked = false;
      print('🔓 Releasing main scroll control');
    }
  }

  void _revertMainScrollPosition() {
    // Force main controller back to clamp position
    final targetPosition =
        math.min(_clampPosition, mainController.position.maxScrollExtent);

    if ((mainController.offset - targetPosition).abs() > 0.5) {
      mainController.jumpTo(targetPosition);
    }
  }

  void _redirectScrollToWireframes(double delta) {
    print('↗️ Redirecting scroll delta: $delta to wireframes');
    onScrollRedirected?.call(delta);

    // Apply scroll to wireframe controllers
    _applyScrollToWireframes(delta);
  }

  void _applyScrollToWireframes(double delta) {
    // Apply to mobile controller
    if (mobileController != null && mobileController!.hasClients) {
      final currentMobile = mobileController!.offset;
      final newMobile = (currentMobile + delta)
          .clamp(0.0, mobileController!.position.maxScrollExtent);
      if ((newMobile - currentMobile).abs() > 0.1) {
        mobileController!.jumpTo(newMobile);
      }
    }

    // Apply to desktop controller
    if (desktopController != null && desktopController!.hasClients) {
      final currentDesktop = desktopController!.offset;
      final newDesktop = (currentDesktop + delta)
          .clamp(0.0, desktopController!.position.maxScrollExtent);
      if ((newDesktop - currentDesktop).abs() > 0.1) {
        desktopController!.jumpTo(newDesktop);
      }
    }
  }

  /// Update the clamp position (call this when layout changes)
  void updateClampPosition(double newClampPosition) {
    _clampPosition = newClampPosition;
    print('📏 Updated clamp position to: $_clampPosition');
  }

  /// Force release of scroll control (emergency method)
  void forceRelease() {
    _releaseScrollControl();
    _isInBottomSection = false;
  }

  /// Check if currently in bottom section
  bool get isInBottomSection => _isInBottomSection;

  /// Get current clamp position
  double get clampPosition => _clampPosition;

  /// Dispose method
  void dispose() {
    mainController.removeListener(_onMainScroll);
    _releaseScrollControl();
  }
}
