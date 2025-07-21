// File: lib/themes/wireframe/wireframe_main_theme.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_scrollable_theme.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_desktop_theme.dart';

/// Main entry point for the wireframe theme
/// Provides both scrollable and static versions
class WireframeMainTheme extends StatelessWidget {
  final bool enableScrollableMode;

  const WireframeMainTheme({
    Key? key,
    this.enableScrollableMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🔍 DEBUG: WireframeMainTheme.build() called with enableScrollableMode: $enableScrollableMode');

    if (enableScrollableMode) {
      print('🔍 DEBUG: Returning WireframeScrollableTheme()');
      return WireframeScrollableTheme();
    } else {
      print('🔍 DEBUG: Returning WireframeDesktopTheme()');
      return WireframeDesktopTheme(
        isScrollableMode: false,
      );
    }
  }
}

/// Settings toggle for wireframe mode
class WireframeThemeSettings extends StatefulWidget {
  final bool initialScrollableMode;
  final ValueChanged<bool> onModeChanged;

  const WireframeThemeSettings({
    Key? key,
    required this.initialScrollableMode,
    required this.onModeChanged,
  }) : super(key: key);

  @override
  State<WireframeThemeSettings> createState() => _WireframeThemeSettingsState();
}

class _WireframeThemeSettingsState extends State<WireframeThemeSettings> {
  late bool _scrollableMode;

  @override
  void initState() {
    super.initState();
    _scrollableMode = widget.initialScrollableMode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wireframe Display Mode',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          SwitchListTile(
            title: Text('Scrollable Story Mode'),
            subtitle: Text(
              _scrollableMode
                  ? 'Shows wireframe evolution story with scroll animations'
                  : 'Shows static wireframe interface directly',
            ),
            value: _scrollableMode,
            onChanged: (value) {
              setState(() {
                _scrollableMode = value;
              });
              widget.onModeChanged(value);
            },
          ),
          if (_scrollableMode) ...[
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                '📱 Scroll down to see wireframes come to life!',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
