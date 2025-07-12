import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';

import '../wireframe_layout_constants.dart';

/// Mobile status bar component
class WireframeMobileStatusBar extends StatelessWidget {
  final String time;
  final int signalStrength;
  final bool hasWifi;
  final int batteryLevel;
  final bool isCharging;
  final Color? textColor;
  final Color? iconColor;

  const WireframeMobileStatusBar({
    Key? key,
    this.time = '12:30',
    this.signalStrength = 4,
    this.hasWifi = true,
    this.batteryLevel = 100,
    this.isCharging = false,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? WireframeColorManager.colors.text;
    final effectiveIconColor = iconColor ?? WireframeColorManager.colors.text;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingXLarge,
        vertical: WireframeLayoutConstants.spacingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            time,
            style: TextStyle(
              color: WireframeColorManager.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Status icons
          Row(
            children: [
              // Signal strength
              _buildSignalIcon(signalStrength, effectiveIconColor),
              SizedBox(width: WireframeLayoutConstants.spacingTiny),

              // WiFi
              if (hasWifi) ...[
                Icon(
                  Icons.wifi,
                  size: 16,
                  color: effectiveIconColor,
                ),
                SizedBox(width: WireframeLayoutConstants.spacingTiny),
              ],

              // Battery
              _buildBatteryIcon(batteryLevel, isCharging, effectiveIconColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalIcon(int strength, Color color) {
    IconData icon;
    switch (strength) {
      case 1:
        icon =
            Icons.signal_cellular_0_bar; // Fixed: Use 0_bar for lowest signal
        break;
      case 2:
        icon = Icons.signal_cellular_alt_1_bar; // Fixed: correct name
        break;
      case 3:
        icon = Icons.signal_cellular_alt_2_bar; // Fixed: correct name
        break;
      case 4:
      default:
        icon = Icons.signal_cellular_4_bar;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }

  Widget _buildBatteryIcon(int level, bool charging, Color color) {
    IconData icon;

    if (charging) {
      icon = Icons.battery_charging_full;
    } else if (level > 80) {
      icon = Icons.battery_full;
    } else if (level > 60) {
      icon = Icons.battery_6_bar;
    } else if (level > 40) {
      icon = Icons.battery_4_bar;
    } else if (level > 20) {
      icon = Icons.battery_2_bar;
    } else {
      icon = Icons.battery_1_bar;
    }

    return Icon(icon, size: 16, color: color);
  }
}

/// Browser chrome component for desktop
class WireframeBrowserChrome extends StatelessWidget {
  final String title;
  final String url;
  final bool showNavigation;
  final VoidCallback? onBack;
  final VoidCallback? onForward;
  final VoidCallback? onRefresh;
  final VoidCallback? onHome;

  const WireframeBrowserChrome({
    Key? key,
    this.title = 'Jeffjitsu.com',
    this.url = 'Jeffjitsu.com',
    this.showNavigation = true,
    this.onBack,
    this.onForward,
    this.onRefresh,
    this.onHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: WireframeLayoutConstants.spacingLarge,
        vertical: WireframeLayoutConstants.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: WireframeLayoutConstants.browserChromeBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(WireframeLayoutConstants.spacingSmall - 2),
          topRight: Radius.circular(WireframeLayoutConstants.spacingSmall - 2),
        ),
        border: Border(
          bottom: BorderSide(color: WireframeColorManager.colors.border),
        ),
      ),
      child: Row(
        children: [
          // Browser dots (traffic lights)
          _buildTrafficLights(),

          Spacer(),

          // URL bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: WireframeLayoutConstants.spacingMedium,
              vertical: WireframeLayoutConstants.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: WireframeLayoutConstants.wireframeWhite,
              borderRadius:
                  BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
              border: Border.all(color: WireframeColorManager.colors.border),
            ),
            child: Text(
              url,
              style: TextStyle(
                color: WireframeLayoutConstants.wireframeSecondary,
                fontSize: WireframeLayoutConstants.desktopFontSizeBody,
              ),
            ),
          ),

          Spacer(),

          // Browser actions
          if (showNavigation) _buildBrowserActions(),
        ],
      ),
    );
  }

  Widget _buildTrafficLights() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WireframeLayoutConstants.browserChromeRed,
          ),
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WireframeLayoutConstants.browserChromeYellow,
          ),
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WireframeLayoutConstants.browserChromeGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildBrowserActions() {
    return Row(
      children: [
        _buildBrowserButton(Icons.home, onHome),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildBrowserButton(Icons.folder, null),
      ],
    );
  }

  Widget _buildBrowserButton(IconData icon, VoidCallback? onPressed) {
    return ClickableWidget(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(WireframeLayoutConstants.spacingTiny),
        child: Icon(
          icon,
          size: 18,
          color: WireframeLayoutConstants.wireframeSecondary,
        ),
      ),
    );
  }
}

/// Animated status bar for mobile
class WireframeAnimatedStatusBar extends StatefulWidget {
  final Duration animationDuration;
  final bool autoAnimate;
  final Color? textColor;
  final Color? iconColor;

  const WireframeAnimatedStatusBar({
    Key? key,
    this.animationDuration = const Duration(seconds: 30),
    this.autoAnimate = true,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  @override
  State<WireframeAnimatedStatusBar> createState() =>
      _WireframeAnimatedStatusBarState();
}

class _WireframeAnimatedStatusBarState extends State<WireframeAnimatedStatusBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _batteryAnimation;
  late Animation<int> _signalAnimation;
  late Animation<String> _timeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Battery level animation (100% to 20% and back)
    _batteryAnimation = TweenSequence<int>([
      TweenSequenceItem(
        tween: IntTween(begin: 100, end: 20),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: IntTween(begin: 20, end: 100),
        weight: 50,
      ),
    ]).animate(_animationController);

    // Signal strength animation (1 to 4 bars)
    _signalAnimation = TweenSequence<int>([
      TweenSequenceItem(
        tween: IntTween(begin: 4, end: 1),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: IntTween(begin: 1, end: 4),
        weight: 75,
      ),
    ]).animate(_animationController);

    // Time animation (simulated time progression)
    _timeAnimation = TweenSequence<String>([
      TweenSequenceItem(
        tween: ConstantTween<String>('12:30'),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween<String>('12:31'),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween<String>('12:32'),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween<String>('12:33'),
        weight: 25,
      ),
    ]).animate(_animationController);

    if (widget.autoAnimate) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return WireframeMobileStatusBar(
          time: _timeAnimation.value,
          signalStrength: _signalAnimation.value,
          batteryLevel: _batteryAnimation.value,
          isCharging: _batteryAnimation.value < 30,
          textColor: widget.textColor,
          iconColor: widget.iconColor,
        );
      },
    );
  }

  void startAnimation() {
    _animationController.repeat();
  }

  void stopAnimation() {
    _animationController.stop();
  }

  void resetAnimation() {
    _animationController.reset();
  }
}

/// Tab bar for browser chrome
class WireframeBrowserTabBar extends StatelessWidget {
  final List<WireframeBrowserTab> tabs;
  final int selectedIndex;
  final Function(int) onTabChanged;
  final VoidCallback? onNewTab;

  const WireframeBrowserTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.onNewTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: WireframeLayoutConstants.wireframeLightGray,
        border: Border(
          bottom: BorderSide(color: WireframeColorManager.colors.border),
        ),
      ),
      child: Row(
        children: [
          // Tabs
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = index == selectedIndex;

                return _buildTab(tab, isSelected, () => onTabChanged(index));
              },
            ),
          ),

          // New tab button
          if (onNewTab != null) _buildNewTabButton(),
        ],
      ),
    );
  }

  Widget _buildTab(
      WireframeBrowserTab tab, bool isSelected, VoidCallback onTap) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(
          horizontal: WireframeLayoutConstants.spacingMedium,
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? WireframeLayoutConstants.wireframeWhite
              : Colors.transparent,
          border: Border(
            right: BorderSide(color: WireframeColorManager.colors.border),
          ),
        ),
        child: Row(
          children: [
            // Favicon placeholder
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: WireframeLayoutConstants.wireframeAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(width: WireframeLayoutConstants.spacingSmall),

            // Title
            Expanded(
              child: Text(
                tab.title,
                style: TextStyle(
                  fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                  color: WireframeColorManager.colors.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Close button
            if (tab.isCloseable)
              ClickableWidget(
                onTap: tab.onClose,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: WireframeLayoutConstants.wireframeSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewTabButton() {
    return ClickableWidget(
      onTap: onNewTab,
      child: Container(
        width: 32,
        height: 32,
        child: SvgIcon(
          assetPath: SvgIconPaths.addCircleLine,
          size: 16,
          color: WireframeLayoutConstants.wireframeSecondary,
        ),
      ),
    );
  }
}

/// Browser tab data model
class WireframeBrowserTab {
  final String title;
  final String url;
  final bool isCloseable;
  final VoidCallback? onClose;

  const WireframeBrowserTab({
    required this.title,
    required this.url,
    this.isCloseable = true,
    this.onClose,
  });
}

/// Status bar utilities and helpers
class WireframeStatusBarUtils {
  /// Format time from DateTime (12-hour format)
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }

  /// Get current time string
  static String getCurrentTime() {
    return formatTime(DateTime.now());
  }

  /// Get battery icon based on level
  static IconData getBatteryIcon(int level, bool isCharging) {
    if (isCharging) return Icons.battery_charging_full;

    if (level > 80) return Icons.battery_full;
    if (level > 60) return Icons.battery_6_bar;
    if (level > 40) return Icons.battery_4_bar;
    if (level > 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  /// Get signal icon based on strength
  static IconData getSignalIcon(int strength) {
    switch (strength) {
      case 1:
        return Icons
            .signal_cellular_0_bar; // Fixed: Use 0_bar for lowest signal
      case 2:
        return Icons.signal_cellular_alt_1_bar; // Fixed: correct name
      case 3:
        return Icons.signal_cellular_alt_2_bar; // Fixed: correct name
      case 4:
      default:
        return Icons.signal_cellular_4_bar;
    }
  }

  /// Generate random status values for demo
  static Map<String, dynamic> generateRandomStatus() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return {
      'batteryLevel': 20 + (random % 80),
      'signalStrength': 1 + (random % 4),
      'hasWifi': random % 2 == 0,
      'isCharging': random % 3 == 0,
    };
  }

  /// Alternative custom signal strength widget (if you prefer bars instead of icons)
  static Widget buildCustomSignalBars(int strength, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        return Container(
          width: 3,
          height: 8 + (index * 2), // Increasing height for each bar
          margin: EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            color: index < strength ? color : color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  /// Get appropriate status bar height for different devices
  static double getStatusBarHeight(bool isMobile) {
    return isMobile ? 24.0 : 0.0;
  }

  /// Get appropriate chrome height for browser
  static double getBrowserChromeHeight() {
    return 50.0;
  }

  /// Creates a complete status bar for mobile with realistic values
  static Widget createRealisticMobileStatusBar({
    Color? textColor,
    Color? iconColor,
    bool animate = false,
  }) {
    if (animate) {
      return WireframeAnimatedStatusBar(
        textColor: textColor,
        iconColor: iconColor,
        autoAnimate: true,
      );
    } else {
      return WireframeMobileStatusBar(
        time: getCurrentTime(),
        signalStrength: 3,
        hasWifi: true,
        batteryLevel: 85,
        isCharging: false,
        textColor: textColor,
        iconColor: iconColor,
      );
    }
  }

  /// Creates a complete browser chrome with default settings
  static Widget createDefaultBrowserChrome({
    String? title,
    String? url,
    bool showNavigation = true,
    VoidCallback? onHome,
  }) {
    return WireframeBrowserChrome(
      title: title ?? 'Portfolio Website',
      url: url ?? 'jeffjitsu.com',
      showNavigation: showNavigation,
      onHome: onHome,
    );
  }
}
