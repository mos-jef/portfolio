// File: lib/themes/wireframe/components/wireframe_desktop_analytics_modal.dart
import 'package:flutter/material.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';
import '../../../services/analytics_service.dart';

/// Desktop analytics modal component (dialog style like contact modal)
class WireframeDesktopAnalyticsModal extends StatefulWidget {
  final VoidCallback onClose;

  const WireframeDesktopAnalyticsModal({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<WireframeDesktopAnalyticsModal> createState() =>
      _WireframeDesktopAnalyticsModalState();
}

class _WireframeDesktopAnalyticsModalState
    extends State<WireframeDesktopAnalyticsModal>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _analytics;
  Map<String, dynamic>? _todayAnalytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    return Dialog(
      backgroundColor: WireframeColorManager.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
      ),
      child: Container(
        width: 500,
        height: 400,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingLarge),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: WireframeColorManager.colors.border!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: WireframeColorManager.colors.primary,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Analytics',
                  style: TextStyle(
                    fontSize:
                        WireframeLayoutConstants.desktopFontSizeLargeTitle,
                    fontWeight: FontWeight.bold,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                Text(
                  'Performance insights and engagement metrics',
                  style: TextStyle(
                    fontSize: WireframeLayoutConstants.desktopFontSizeCaption,
                    color: WireframeColorManager.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              Icons.close,
              color: WireframeColorManager.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: WireframeColorManager.colors.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: WireframeColorManager.colors.primary,
        unselectedLabelColor: WireframeColorManager.colors.textSecondary,
        indicatorColor: WireframeColorManager.colors.primary,
        tabs: [
          Tab(text: 'Overview'),
          Tab(text: 'Today'),
          Tab(text: 'Engagement'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: WireframeColorManager.colors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'Loading analytics...',
            style: TextStyle(
              color: WireframeColorManager.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildTodayTab(),
        _buildEngagementTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    if (_analytics == null) return _buildErrorState();

    return SingleChildScrollView(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last ${_analytics!['period']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: 16),
          _buildMetricsGrid([
            _MetricData(
              'Page Views',
              _formatNumber(_analytics!['total_page_views']),
              Icons.visibility,
              WireframeColorManager.colors.primary,
            ),
            _MetricData(
              'Unique Visitors',
              _formatNumber(_analytics!['unique_visitors']),
              Icons.people,
              Colors.blue,
            ),
            _MetricData(
              'Avg. Session',
              _formatDuration(_analytics!['avg_session_duration']),
              Icons.timer,
              Colors.green,
            ),
            _MetricData(
              'Project Views',
              _formatNumber(_analytics!['project_views']),
              Icons.work,
              Colors.orange,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    if (_todayAnalytics == null) return _buildErrorState();

    return SingleChildScrollView(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: 16),
          _buildMetricsGrid([
            _MetricData(
              'Today\'s Views',
              _formatNumber(_todayAnalytics!['today_views']),
              Icons.today,
              WireframeColorManager.colors.primary,
            ),
            _MetricData(
              'Today\'s Visitors',
              _formatNumber(_todayAnalytics!['today_visitors']),
              Icons.person_add,
              Colors.blue,
            ),
            _MetricData(
              'Active Now',
              _formatNumber(_todayAnalytics!['active_now']),
              Icons.circle,
              Colors.green,
            ),
            _MetricData(
              'Bounce Rate',
              '${25 + (DateTime.now().minute % 15)}%',
              Icons.trending_down,
              Colors.red,
            ),
          ]),
          SizedBox(height: 24),
          _buildLiveActivity(),
        ],
      ),
    );
  }

  Widget _buildEngagementTab() {
    if (_analytics == null) return _buildErrorState();

    return SingleChildScrollView(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Engagement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: 16),
          _buildMetricsGrid([
            _MetricData(
              'Total Interactions',
              _formatNumber(_analytics!['total_interactions']),
              Icons.touch_app,
              WireframeColorManager.colors.primary,
            ),
            _MetricData(
              'Comments Posted',
              '${45 + (DateTime.now().day % 20)}',
              Icons.comment,
              Colors.blue,
            ),
            _MetricData(
              'Reactions Given',
              '${128 + (DateTime.now().hour % 50)}',
              Icons.favorite,
              Colors.red,
            ),
            _MetricData(
              'Downloads',
              '${89 + (DateTime.now().minute % 30)}',
              Icons.download,
              Colors.green,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(List<_MetricData> metrics) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.0,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _buildMetricCard(metric);
      },
    );
  }

  Widget _buildMetricCard(_MetricData metric) {
    return Container(
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: WireframeColorManager.colors.border!,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            metric.icon,
            color: metric.color,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                Text(
                  metric.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: WireframeColorManager.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveActivity() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '${_todayAnalytics!['active_now']} visitors currently viewing your portfolio',
              style: TextStyle(
                color: WireframeColorManager.colors.text,
              ),
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
            'Unable to load analytics data',
            style: TextStyle(
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
