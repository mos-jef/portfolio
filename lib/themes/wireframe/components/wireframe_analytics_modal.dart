// File: lib/themes/wireframe/components/wireframe_analytics_modal.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';

import '../../../services/analytics_service.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

/// Mobile analytics modal component (bottom sheet style)
class WireframeMobileAnalyticsModal extends StatefulWidget {
  final Animation<Offset> slideAnimation;
  final AnimationController animationController;
  final VoidCallback onClose;

  const WireframeMobileAnalyticsModal({
    Key? key,
    required this.slideAnimation,
    required this.animationController,
    required this.onClose,
  }) : super(key: key);

  @override
  State<WireframeMobileAnalyticsModal> createState() =>
      _WireframeMobileAnalyticsModalState();
}

class _WireframeMobileAnalyticsModalState
    extends State<WireframeMobileAnalyticsModal> {
  Map<String, dynamic>? _analytics;
  Map<String, dynamic>? _todayAnalytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final analytics = await AnalyticsService().getAnalytics();
      final todayAnalytics = await AnalyticsService().getTodayAnalytics();

      if (mounted) {
        setState(() {
          _analytics = analytics;
          _todayAnalytics = todayAnalytics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        widget.animationController.reverse().then((_) {
          widget.onClose();
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeBlack.withOpacity(0.5),
        ),
        child: ClickableWidget(
          onTap: () {}, // Prevent tap from bubbling up
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: widget.slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: widget.slideAnimation.value *
                      WireframeLayoutConstants.mobileModalHeight,
                  child: Container(
                    width: double.infinity,
                    height: math.min(
                      WireframeLayoutConstants
                          .mobileModalHeight, // Same as comment modal
                      WireframeLayoutConstants.iPhoneFrameHeight * 0.85,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    decoration: BoxDecoration(
                      color: WireframeColorManager.colors.surface,
                      borderRadius: BorderRadius.circular(
                          WireframeLayoutConstants.radiusSmall),
                      boxShadow: [
                        BoxShadow(
                          color: WireframeLayoutConstants.wireframeBlack
                              .withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: EdgeInsets.only(
                              top: WireframeLayoutConstants.spacingSmall),
                          width: 32,
                          height: 3,
                          decoration: BoxDecoration(
                            color: WireframeColorManager.colors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                WireframeLayoutConstants.spacingStandard,
                            vertical: WireframeLayoutConstants.spacingMedium,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgIcon(
                                    assetPath: SvgIconPaths.chartBar2Line,
                                    size: 20,
                                    color: WireframeColorManager.colors.primary,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Analytics',
                                    style: TextStyle(
                                      fontSize: WireframeLayoutConstants
                                          .mobileFontSizeLargeTitle,
                                      fontWeight: FontWeight.bold,
                                      color: WireframeColorManager.colors.text,
                                    ),
                                  ),
                                ],
                              ),
                              ClickableWidget(
                                onTap: () {
                                  widget.animationController
                                      .reverse()
                                      .then((_) {
                                    widget.onClose();
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: WireframeColorManager
                                      .colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content
                        Expanded(
                          child: _isLoading
                              ? _buildLoadingState()
                              : _buildContent(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: WireframeColorManager.colors.primary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Loading analytics...',
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBody,
              color: WireframeColorManager.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_analytics == null || _todayAnalytics == null) {
      return _buildErrorState();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingStandard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's metrics
          Text(
            'Today',
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeTitle,
              fontWeight: FontWeight.w600,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingMedium),

          _buildMetricsRow([
            _MetricData(
              'Views',
              _formatNumber(_todayAnalytics!['today_views']),
              Icons.visibility,
              WireframeColorManager.colors.primary,
            ),
            _MetricData(
              'Visitors',
              _formatNumber(_todayAnalytics!['today_visitors']),
              Icons.people,
              Colors.blue,
            ),
          ]),

          SizedBox(height: WireframeLayoutConstants.spacingMedium),

          _buildMetricsRow([
            _MetricData(
              'Active Now',
              _formatNumber(_todayAnalytics!['active_now']),
              Icons.circle,
              Colors.green,
            ),
            _MetricData(
              'Interactions',
              '${_analytics!['total_interactions']}',
              Icons.touch_app,
              Colors.orange,
            ),
          ]),

          SizedBox(height: WireframeLayoutConstants.spacingLarge),

          // 30-day overview
          Text(
            'Last 30 Days',
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeTitle,
              fontWeight: FontWeight.w600,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: WireframeLayoutConstants.spacingMedium),

          _buildMetricsRow([
            _MetricData(
              'Total Views',
              _formatNumber(_analytics!['total_page_views']),
              Icons.trending_up,
              WireframeColorManager.colors.primary,
            ),
            _MetricData(
              'Avg. Session',
              _formatDuration(_analytics!['avg_session_duration']),
              Icons.timer,
              Colors.green,
            ),
          ]),

          SizedBox(height: WireframeLayoutConstants.spacingLarge),

          // Popular pages
          _buildPopularPages(),

          SizedBox(height: WireframeLayoutConstants.spacingStandard),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(List<_MetricData> metrics) {
    return Row(
      children: metrics.map((metric) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: metrics.indexOf(metric) < metrics.length - 1 ? 8 : 0,
            ),
            child: _buildMetricCard(metric),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricCard(_MetricData metric) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: WireframeColorManager.colors.border!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            metric.icon,
            color: metric.color,
            size: 18,
          ),
          SizedBox(height: 6),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeTitle,
              fontWeight: FontWeight.bold,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: 2),
          Text(
            metric.title,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeCaption,
              color: WireframeColorManager.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularPages() {
    final pages = _analytics!['popular_pages'] as Map<String, dynamic>;
    final sortedPages = pages.entries.toList()
      ..sort((a, b) => (b.value as int).compareTo(a.value as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Pages',
          style: TextStyle(
            fontSize: WireframeLayoutConstants.mobileFontSizeTitle,
            fontWeight: FontWeight.w600,
            color: WireframeColorManager.colors.text,
          ),
        ),
        SizedBox(height: WireframeLayoutConstants.spacingMedium),
        ...sortedPages
            .take(3)
            .map((entry) => _buildPageItem(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildPageItem(String page, int views) {
    final total = (_analytics!['popular_pages'] as Map<String, dynamic>)
        .values
        .fold<int>(0, (sum, v) => sum + (v as int));
    final percentage = (views / total * 100).round();

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page,
                  style: TextStyle(
                    fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                    fontWeight: FontWeight.w500,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: WireframeColorManager.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: WireframeColorManager.colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Text(
            '$views',
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBody,
              fontWeight: FontWeight.bold,
              color: WireframeColorManager.colors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 32,
            color: WireframeColorManager.colors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'Unable to load analytics',
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBody,
              color: WireframeColorManager.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(dynamic number) {
    if (number is! int) return number.toString();
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDuration(dynamic seconds) {
    if (seconds is! num) return seconds.toString();
    final duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _MetricData(this.title, this.value, this.icon, this.color);
}
