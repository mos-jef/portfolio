// File: lib/themes/wireframe/widgets/scroll_gesture_interceptor.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ScrollGestureInterceptor extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final bool enableScrollIsolation;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;

  const ScrollGestureInterceptor({
    Key? key,
    required this.child,
    this.scrollController,
    this.enableScrollIsolation = true,
    this.onScrollStart,
    this.onScrollEnd,
  }) : super(key: key);

  @override
  State<ScrollGestureInterceptor> createState() =>
      _ScrollGestureInterceptorState();
}

class _ScrollGestureInterceptorState extends State<ScrollGestureInterceptor> {
  bool _isScrolling = false;
  late ScrollController _internalScrollController;

  @override
  void initState() {
    super.initState();
    _internalScrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _internalScrollController.dispose();
    }
    super.dispose();
  }

  void _handleScrollStart() {
    if (!_isScrolling) {
      _isScrolling = true;
      widget.onScrollStart?.call();
    }
  }

  void _handleScrollEnd() {
    if (_isScrolling) {
      _isScrolling = false;
      widget.onScrollEnd?.call();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.enableScrollIsolation) return;

    _handleScrollStart();

    // Calculate new scroll position
    final currentOffset = _internalScrollController.hasClients
        ? _internalScrollController.offset
        : 0.0;
    final newOffset = currentOffset - details.delta.dy;

    // Apply scroll within bounds
    if (_internalScrollController.hasClients) {
      final maxScroll = _internalScrollController.position.maxScrollExtent;
      final clampedOffset = newOffset.clamp(0.0, maxScroll);

      _internalScrollController.jumpTo(clampedOffset);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _handleScrollEnd();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.enableScrollIsolation) return;

    if (event is PointerScrollEvent && _internalScrollController.hasClients) {
      _handleScrollStart();

      final currentOffset = _internalScrollController.offset;
      final scrollDelta = event.scrollDelta.dy;
      final newOffset = currentOffset + scrollDelta;
      final maxScroll = _internalScrollController.position.maxScrollExtent;
      final clampedOffset = newOffset.clamp(0.0, maxScroll);

      _internalScrollController.jumpTo(clampedOffset);

      // Delay scroll end to allow for continuous scrolling
      Future.delayed(Duration(milliseconds: 100), _handleScrollEnd);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableScrollIsolation) {
      return widget.child;
    }

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: GestureDetector(
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        onTap: () {}, // Consume tap events to prevent bubbling
        child: AbsorbPointer(
          absorbing: false, // Allow internal interactions
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              // Completely consume all scroll notifications to prevent bubbling
              return true;
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
