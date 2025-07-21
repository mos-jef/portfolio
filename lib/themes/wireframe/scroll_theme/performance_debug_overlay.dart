// File: lib/themes/wireframe/scroll_theme/performance_debug_overlay.dart
import 'package:flutter/material.dart';
import 'scroll_performance_optimizer.dart';

/// Debug overlay showing performance metrics during development
class PerformanceDebugOverlay extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceDebugOverlay({
    Key? key,
    required this.child,
    this.showOverlay = false, // Set to true during development
  }) : super(key: key);

  @override
  State<PerformanceDebugOverlay> createState() =>
      _PerformanceDebugOverlayState();
}

class _PerformanceDebugOverlayState extends State<PerformanceDebugOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showOverlay) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,

        // Performance overlay
        Positioned(
          top: 50,
          right: 20,
          child: _buildPerformanceOverlay(),
        ),
      ],
    );
  }

  Widget _buildPerformanceOverlay() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: _isExpanded ? 300 : 60,
          height: _isExpanded ? 400 : 60,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child:
              _isExpanded ? _buildExpandedOverlay() : _buildCollapsedOverlay(),
        );
      },
    );
  }

  Widget _buildCollapsedOverlay() {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.speed,
              color: _getPerformanceColor(),
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              '${ScrollPerformanceMonitor.getCurrentFPS().toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedOverlay() {
    final fps = ScrollPerformanceMonitor.getCurrentFPS();
    final avgFrameTime = ScrollPerformanceMonitor.getAverageFrameTime();
    final isPerformanceGood = ScrollPerformanceMonitor.isPerformanceGood();
    final recommendations =
        ScrollPerformanceMonitor.getPerformanceRecommendations();

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Monitor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _toggleOverlay,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Performance metrics
          _buildMetricRow(
              'FPS:', '${fps.toStringAsFixed(1)}', _getPerformanceColor()),
          _buildMetricRow('Frame Time:', '${avgFrameTime.toStringAsFixed(1)}ms',
              Colors.white),
          _buildMetricRow(
            'Quality Mode:',
            AdaptiveQualityController.isHighQualityMode
                ? 'High'
                : 'Performance',
            AdaptiveQualityController.isHighQualityMode
                ? Colors.green
                : Colors.orange,
          ),
          _buildMetricRow(
            'Status:',
            isPerformanceGood ? 'Good' : 'Poor',
            isPerformanceGood ? Colors.green : Colors.red,
          ),

          SizedBox(height: 16),

          // Recommendations
          if (recommendations.isNotEmpty) ...[
            Text(
              'Recommendations:',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...recommendations.map((rec) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $rec',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )),
          ],

          Spacer(),

          // Controls
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScrollPerformanceMonitor.clear();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    'Clear Data',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor() {
    final fps = ScrollPerformanceMonitor.getCurrentFPS();
    if (fps >= 50) return Colors.green;
    if (fps >= 30) return Colors.orange;
    return Colors.red;
  }

  void _toggleOverlay() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}

/// Performance configuration widget for settings
class PerformanceSettings extends StatefulWidget {
  const PerformanceSettings({Key? key}) : super(key: key);

  @override
  State<PerformanceSettings> createState() => _PerformanceSettingsState();
}

class _PerformanceSettingsState extends State<PerformanceSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16),

          // Quality mode toggle
          SwitchListTile(
            title: Text('High Quality Mode'),
            subtitle: Text(
              AdaptiveQualityController.isHighQualityMode
                  ? 'Full effects and animations enabled'
                  : 'Reduced effects for better performance',
            ),
            value: AdaptiveQualityController.isHighQualityMode,
            onChanged: (value) {
              setState(() {
                // This would need to be implemented in AdaptiveQualityController
                // AdaptiveQualityController.setHighQualityMode(value);
              });
            },
          ),

          SizedBox(height: 16),

          // Performance info
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Performance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                    'FPS: ${ScrollPerformanceMonitor.getCurrentFPS().toStringAsFixed(1)}'),
                Text(
                    'Frame Time: ${ScrollPerformanceMonitor.getAverageFrameTime().toStringAsFixed(1)}ms'),
                Text(
                    'Status: ${ScrollPerformanceMonitor.isPerformanceGood() ? "Good" : "Poor"}'),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Clear performance data button
          ElevatedButton(
            onPressed: () {
              ScrollPerformanceMonitor.clear();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Performance data cleared')),
              );
            },
            child: Text('Clear Performance Data'),
          ),

          SizedBox(height: 16),

          // Performance tips
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                    SizedBox(width: 8),
                    Text(
                      'Performance Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• The system automatically adjusts quality based on performance\n'
                  '• Particle effects are reduced on slower devices\n'
                  '• Animation complexity scales with frame rate\n'
                  '• Scroll events are throttled to maintain 60fps',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
