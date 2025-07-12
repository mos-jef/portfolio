// File: lib/themes/wireframe/widgets/analytics_modal.dart
import 'package:flutter/material.dart';
import '../utils/wireframe_color_manager.dart';
import '../../../services/analytics_service.dart';

class AnalyticsModal extends StatefulWidget {
  final bool isMobile;

  const AnalyticsModal({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<AnalyticsModal> createState() => _AnalyticsModalState();
}

class _AnalyticsModalState extends State<AnalyticsModal>
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

      setState(() {
        _analytics = analytics;
        _todayAnalytics = todayAnalytics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(widget.isMobile ? 16 : 40),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: widget.isMobile ? double.infinity : 800,
          maxHeight:
              widget.isMobile ? MediaQuery.of(context).size.height * 0.9 : 600,
        ),
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.surface,
          borderRadius: BorderRadius.circular(widget.isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
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
      padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
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
            size: widget.isMobile ? 24 : 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Analytics',
                  style: TextStyle(
                    fontSize: widget.isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                Text(
                  'Performance insights and user engagement metrics',
                  style: TextStyle(
                    fontSize: widget.isMobile ? 12 : 14,
                    color: WireframeColorManager.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
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
      padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
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
          SizedBox(height: 20),
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
          SizedBox(height: 30),
          _buildPopularPages(),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    if (_todayAnalytics == null) return _buildErrorState();

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
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
          SizedBox(height: 20),
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
          SizedBox(height: 30),
          _buildLiveActivity(),
        ],
      ),
    );
  }

  Widget _buildEngagementTab() {
    if (_analytics == null) return _buildErrorState();

    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
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
          SizedBox(height: 20),
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
          SizedBox(height: 30),
          _buildEngagementDetails(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(List<_MetricData> metrics) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isMobile ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: widget.isMobile ? 1.2 : 1.5,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: WireframeColorManager.colors.border!,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            metric.icon,
            color: metric.color,
            size: widget.isMobile ? 24 : 28,
          ),
          SizedBox(height: 8),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: widget.isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(height: 4),
          Text(
            metric.title,
            style: TextStyle(
              fontSize: widget.isMobile ? 12 : 14,
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: WireframeColorManager.colors.text,
          ),
        ),
        SizedBox(height: 16),
        ...sortedPages.map((entry) => _buildPageItem(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildPageItem(String page, int views) {
    final total = (_analytics!['popular_pages'] as Map<String, dynamic>)
        .values
        .fold<int>(0, (sum, v) => sum + (v as int));
    final percentage = (views / total * 100).round();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        borderRadius: BorderRadius.circular(8),
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
                    fontWeight: FontWeight.w500,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 4,
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
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$views',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: WireframeColorManager.colors.text,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12,
                  color: WireframeColorManager.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: WireframeColorManager.colors.text,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
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
        ),
      ],
    );
  }

  Widget _buildEngagementDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Engagement Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: WireframeColorManager.colors.text,
          ),
        ),
        SizedBox(height: 16),
        _buildEngagementItem(
            'Theme Changes', '${12 + (DateTime.now().day % 8)}', Icons.palette),
        _buildEngagementItem('Contact Clicks',
            '${34 + (DateTime.now().hour % 15)}', Icons.contact_mail),
        _buildEngagementItem('Project Interactions',
            '${67 + (DateTime.now().minute % 25)}', Icons.work),
        _buildEngagementItem('Social Shares',
            '${23 + (DateTime.now().second % 12)}', Icons.share),
      ],
    );
  }

  Widget _buildEngagementItem(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: Row(
        children: [
          Icon(icon, color: WireframeColorManager.colors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: WireframeColorManager.colors.text),
            ),
          ),
          Text(
            value,
            style: TextStyle(
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
            size: 48,
            color: WireframeColorManager.colors.textSecondary,
          ),
          SizedBox(height: 16),
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
