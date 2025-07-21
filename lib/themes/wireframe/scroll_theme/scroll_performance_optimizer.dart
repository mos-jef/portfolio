// File: lib/themes/wireframe/scroll_theme/scroll_performance_optimizer.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:async' as async_timer;

/// Performance optimization utilities for scroll animations
class ScrollPerformanceOptimizer {
  static const int maxFPS = 60;
  static const Duration frameTime = Duration(milliseconds: 16); // ~60fps

  /// Throttles scroll callback to prevent excessive rebuilds
  static VoidCallback throttleScrollCallback(
    VoidCallback callback, {
    Duration throttleDuration = frameTime,
  }) {
    DateTime? lastCallTime;

    return () {
      final now = DateTime.now();
      if (lastCallTime == null ||
          now.difference(lastCallTime!) >= throttleDuration) {
        lastCallTime = now;
        callback();
      }
    };
  }

  /// Debounces scroll events for expensive operations
    static VoidCallback debounceScrollCallback(
    VoidCallback callback, {
    Duration debounceDuration = const Duration(milliseconds: 100),
  }) {
    async_timer.Timer? debounceTimer;
    
    return () {
      debounceTimer?.cancel();
      debounceTimer = async_timer.Timer(debounceDuration, callback);
    };
  }

  /// Creates optimized scroll listener with frame-rate limiting
  static void addOptimizedScrollListener(
    ScrollController controller,
    VoidCallback callback, {
    bool throttle = true,
    bool debounce = false,
  }) {
    VoidCallback optimizedCallback = callback;

    if (throttle) {
      optimizedCallback = throttleScrollCallback(optimizedCallback);
    }

    if (debounce) {
      optimizedCallback = debounceScrollCallback(optimizedCallback);
    }

    controller.addListener(optimizedCallback);
  }
}

/// Viewport-aware widget that only renders when visible
class ViewportAwareWidget extends StatefulWidget {
  final Widget child;
  final double visibilityThreshold;
  final Widget Function()? placeholderBuilder;
  final bool enableOptimization;

  const ViewportAwareWidget({
    Key? key,
    required this.child,
    this.visibilityThreshold = 0.1,
    this.placeholderBuilder,
    this.enableOptimization = true,
  }) : super(key: key);

  @override
  State<ViewportAwareWidget> createState() => _ViewportAwareWidgetState();
}

class _ViewportAwareWidgetState extends State<ViewportAwareWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enableOptimization) {
      return widget.child;
    }

    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        final isVisible =
            visibilityInfo.visibleFraction >= widget.visibilityThreshold;
        if (isVisible != _isVisible) {
          setState(() {
            _isVisible = isVisible;
          });
        }
      },
      child: _isVisible
          ? widget.child
          : (widget.placeholderBuilder?.call() ?? SizedBox.shrink()),
    );
  }
}

/// Performance-optimized scroll notifier
class OptimizedScrollNotifier extends ChangeNotifier {
  double _scrollProgress = 0.0;
  ScrollPhase _currentPhase = ScrollPhase.static;
  DateTime _lastNotification = DateTime.now();

  static const Duration _notificationThrottle = Duration(milliseconds: 16);

  double get scrollProgress => _scrollProgress;
  ScrollPhase get currentPhase => _currentPhase;

  void updateScroll(double progress, ScrollPhase phase) {
    final now = DateTime.now();
    final shouldNotify =
        now.difference(_lastNotification) >= _notificationThrottle;

    if (shouldNotify || _currentPhase != phase) {
      _scrollProgress = progress;
      _currentPhase = phase;
      _lastNotification = now;
      notifyListeners();
    }
  }
}

/// Memory-efficient animation cache
class AnimationCache {
  static final Map<String, ui.Picture> _pictureCache = {};
  static final Map<String, Matrix4> _transformCache = {};
  static const int maxCacheSize = 50;

  /// Cache a picture for reuse
  static void cachePicture(String key, ui.Picture picture) {
    if (_pictureCache.length >= maxCacheSize) {
      _clearOldestEntry(_pictureCache);
    }
    _pictureCache[key] = picture;
  }

  /// Get cached picture
  static ui.Picture? getCachedPicture(String key) {
    return _pictureCache[key];
  }

  /// Cache a transform matrix
  static void cacheTransform(String key, Matrix4 transform) {
    if (_transformCache.length >= maxCacheSize) {
      _clearOldestEntry(_transformCache);
    }
    _transformCache[key] = transform.clone();
  }

  /// Get cached transform
  static Matrix4? getCachedTransform(String key) {
    return _transformCache[key]?.clone();
  }

  /// Clear all caches
  static void clearAll() {
    _pictureCache.clear();
    _transformCache.clear();
  }

  /// Clear oldest cache entry
  static void _clearOldestEntry<T>(Map<String, T> cache) {
    if (cache.isNotEmpty) {
      final oldestKey = cache.keys.first;
      cache.remove(oldestKey);
    }
  }
}

/// Efficient scroll-based widget builder
class ScrollBasedBuilder extends StatefulWidget {
  final ScrollController scrollController;
  final Widget Function(
      BuildContext context, double scrollProgress, ScrollPhase phase) builder;
  final double scrollThreshold;
  final bool enableCaching;

  const ScrollBasedBuilder({
    Key? key,
    required this.scrollController,
    required this.builder,
    this.scrollThreshold = 0.01,
    this.enableCaching = true,
  }) : super(key: key);

  @override
  State<ScrollBasedBuilder> createState() => _ScrollBasedBuilderState();
}

class _ScrollBasedBuilderState extends State<ScrollBasedBuilder> {
  late OptimizedScrollNotifier _scrollNotifier;
  double _lastScrollOffset = 0.0;
  Widget? _cachedWidget;
  String? _lastCacheKey;

  @override
  void initState() {
    super.initState();
    _scrollNotifier = OptimizedScrollNotifier();

    ScrollPerformanceOptimizer.addOptimizedScrollListener(
      widget.scrollController,
      _onScrollChanged,
      throttle: true,
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollChanged);
    _scrollNotifier.dispose();
    super.dispose();
  }

  void _onScrollChanged() {
    final currentOffset = widget.scrollController.offset;
    final maxOffset = widget.scrollController.position.maxScrollExtent;

    // Only update if significant change
    if ((currentOffset - _lastScrollOffset).abs() > widget.scrollThreshold) {
      final progress =
          maxOffset > 0 ? (currentOffset / maxOffset).clamp(0.0, 1.0) : 0.0;
      final phase = _calculateScrollPhase(progress);

      _scrollNotifier.updateScroll(progress, phase);
      _lastScrollOffset = currentOffset;
    }
  }

  ScrollPhase _calculateScrollPhase(double progress) {
    if (progress < 0.2) return ScrollPhase.static;
    if (progress < 0.7) return ScrollPhase.transitioning;
    return ScrollPhase.interactive;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scrollNotifier,
      builder: (context, child) {
        final progress = _scrollNotifier.scrollProgress;
        final phase = _scrollNotifier.currentPhase;

        // Cache key for widget reuse
        final cacheKey = '${progress.toStringAsFixed(2)}_${phase.name}';

        if (widget.enableCaching &&
            _lastCacheKey == cacheKey &&
            _cachedWidget != null) {
          return _cachedWidget!;
        }

        final newWidget = widget.builder(context, progress, phase);

        if (widget.enableCaching) {
          _cachedWidget = newWidget;
          _lastCacheKey = cacheKey;
        }

        return newWidget;
      },
    );
  }
}

/// Performance monitoring for scroll animations
class ScrollPerformanceMonitor {
  static final List<Duration> _frameTimes = [];
  static final List<double> _memoryUsage = [];
  static const int maxSamples = 100;

  static DateTime? _lastFrameTime;
  static int _frameCount = 0;
  static double _totalFrameTime = 0.0;

  /// Record frame time for performance monitoring
  static void recordFrame() {
    final now = DateTime.now();

    if (_lastFrameTime != null) {
      final frameDuration = now.difference(_lastFrameTime!);
      _frameTimes.add(frameDuration);
      _totalFrameTime += frameDuration.inMicroseconds.toDouble();
      _frameCount++;

      if (_frameTimes.length > maxSamples) {
        final removed = _frameTimes.removeAt(0);
        _totalFrameTime -= removed.inMicroseconds.toDouble();
        _frameCount--;
      }
    }

    _lastFrameTime = now;
  }

  /// Get average frame time in milliseconds
  static double getAverageFrameTime() {
    if (_frameCount == 0) return 0.0;
    return (_totalFrameTime / _frameCount) / 1000.0; // Convert to milliseconds
  }

  /// Get current FPS
  static double getCurrentFPS() {
    final avgFrameTime = getAverageFrameTime();
    return avgFrameTime > 0 ? 1000.0 / avgFrameTime : 0.0;
  }

  /// Check if performance is acceptable
  static bool isPerformanceGood() {
    return getCurrentFPS() >= 50.0; // 50+ FPS is considered good
  }

  /// Get performance recommendations
  static List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final fps = getCurrentFPS();

    if (fps < 30) {
      recommendations.add('Consider reducing animation complexity');
      recommendations.add('Enable widget caching');
      recommendations.add('Reduce particle count');
    } else if (fps < 50) {
      recommendations.add('Consider throttling scroll events');
      recommendations.add('Optimize custom painters');
    }

    return recommendations;
  }

  /// Clear performance data
  static void clear() {
    _frameTimes.clear();
    _memoryUsage.clear();
    _frameCount = 0;
    _totalFrameTime = 0.0;
    _lastFrameTime = null;
  }
}

/// Adaptive quality controller that adjusts effects based on performance
class AdaptiveQualityController {
  static bool _highQualityMode = true;
  static int _performanceChecks = 0;
  static const int checksBeforeAdjustment = 10;

  static bool get isHighQualityMode => _highQualityMode;

  /// Check performance and adjust quality accordingly
  static void checkAndAdjustQuality() {
    _performanceChecks++;

    if (_performanceChecks >= checksBeforeAdjustment) {
      final isPerformanceGood = ScrollPerformanceMonitor.isPerformanceGood();

      if (!isPerformanceGood && _highQualityMode) {
        _highQualityMode = false;
        debugPrint('🔧 Adaptive Quality: Switching to performance mode');
      } else if (isPerformanceGood && !_highQualityMode) {
        _highQualityMode = true;
        debugPrint('🔧 Adaptive Quality: Switching to high quality mode');
      }

      _performanceChecks = 0;
    }
  }

  /// Get recommended particle count based on performance
  static int getRecommendedParticleCount(int defaultCount) {
    if (!_highQualityMode) {
      return (defaultCount * 0.5).round();
    }
    return defaultCount;
  }

  /// Get recommended animation duration based on performance
  static Duration getRecommendedAnimationDuration(Duration defaultDuration) {
    if (!_highQualityMode) {
      return Duration(
          milliseconds: (defaultDuration.inMilliseconds * 0.7).round());
    }
    return defaultDuration;
  }

  /// Check if complex effects should be enabled
  static bool shouldEnableComplexEffects() {
    return _highQualityMode;
  }
}

/// Custom visibility detector for performance optimization
class VisibilityDetector extends StatefulWidget {
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  double _lastVisibleFraction = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkVisibility();
        });
        return false;
      },
      child: widget.child,
    );
  }

  void _checkVisibility() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    // Calculate visible fraction
    final visibleArea = _calculateVisibleArea(position, size, screenSize);
    final totalArea = size.width * size.height;
    final visibleFraction = totalArea > 0 ? visibleArea / totalArea : 0.0;

    if ((visibleFraction - _lastVisibleFraction).abs() > 0.01) {
      _lastVisibleFraction = visibleFraction;
      widget.onVisibilityChanged(
        VisibilityInfo(
          key: widget.key,
          size: size,
          visibleFraction: visibleFraction,
        ),
      );
    }
  }

  double _calculateVisibleArea(Offset position, Size size, Size screenSize) {
    final left = math.max(0.0, -position.dx);
    final top = math.max(0.0, -position.dy);
    final right = math.min(size.width, screenSize.width - position.dx);
    final bottom = math.min(size.height, screenSize.height - position.dy);

    if (right <= left || bottom <= top) return 0.0;

    return (right - left) * (bottom - top);
  }
}

/// Visibility information class
class VisibilityInfo {
  final Key key;
  final Size size;
  final double visibleFraction;

  const VisibilityInfo({
    required this.key,
    required this.size,
    required this.visibleFraction,
  });
}


/// Scroll phase enum (if not already defined)
enum ScrollPhase {
  static,
  transitioning,
  interactive,
}
