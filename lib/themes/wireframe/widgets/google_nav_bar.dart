import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';

/// Customizable Google Navigation Bar for Wireframe Theme
class WireframeGoogleNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final List<WireframeNavItem> items;
  final WireframeGoogleNavTheme? theme;
  final bool showLabels;
  final bool hapticFeedback;
  final Duration animationDuration;
  final Curve animationCurve;

  const WireframeGoogleNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.items,
    this.theme,
    this.showLabels = true,
    this.hapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? WireframeGoogleNavTheme.defaultTheme();

    return Container(
      height: effectiveTheme.containerHeight,
      decoration: BoxDecoration(
        color: effectiveTheme.backgroundColor,
        borderRadius: BorderRadius.circular(effectiveTheme.borderRadius),
        boxShadow: effectiveTheme.boxShadow,
        border: effectiveTheme.border,
      ),
      child: SafeArea(
        child: Padding(
          padding: effectiveTheme.containerPadding,
          child: GNav(
            // Colors - Add textStyle here for unselected text
            rippleColor: effectiveTheme.rippleColor,
            hoverColor: effectiveTheme.hoverColor,
            color: effectiveTheme.unselectedColor,
            activeColor: effectiveTheme.selectedColor,
            tabBackgroundColor: effectiveTheme.tabBackgroundColor,
            textStyle: TextStyle(
              fontSize: effectiveTheme.textSize,
              fontWeight: effectiveTheme.textWeight,
              color: effectiveTheme
                  .unselectedTextColor, // This controls unselected text color
            ),

            // Sizing
            iconSize: effectiveTheme.iconSize,
            gap: effectiveTheme.gap,
            padding: effectiveTheme.tabPadding,

            // Styling
            tabBorderRadius: effectiveTheme.tabBorderRadius,
            tabActiveBorder: effectiveTheme.tabActiveBorder,
            tabBorder: effectiveTheme.tabBorder,
            tabShadow: effectiveTheme.tabShadow,
            tabBackgroundGradient: effectiveTheme.tabBackgroundGradient,

            // Animation
            duration: animationDuration,
            curve: animationCurve,

            // Behavior
            haptic: hapticFeedback,

            // Content
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: items
                .map((item) => _buildGButton(item, effectiveTheme))
                .toList(),
          ),
        ),
      ),
    );
  }

  GButton _buildGButton(WireframeNavItem item, WireframeGoogleNavTheme theme) {
    return GButton(
      icon: item.icon,
      text: showLabels ? item.label : '',
      iconActiveColor: item.activeColor ?? theme.selectedColor,
      iconColor: item.inactiveColor ?? theme.unselectedColor,
      textColor:
          item.textColor ?? theme.selectedTextColor, // Selected text color
      backgroundColor: item.backgroundColor ?? theme.tabBackgroundColor,
      iconSize: item.iconSize ?? theme.iconSize,
      leading: item.leading,
      gap: item.gap ?? theme.gap,
      padding: item.padding ?? theme.tabPadding,
      // Remove textStyle from here since it's now set at the GNav level
    );
  }
}

/// Navigation item configuration
class WireframeNavItem {
  final IconData icon;
  final String label;
  final String? svgPath;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? textColor;
  final Color? backgroundColor;
  final double? iconSize;
  final Widget? leading;
  final double? gap;
  final EdgeInsets? padding;

  const WireframeNavItem({
    required this.icon,
    required this.label,
    this.svgPath,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.backgroundColor,
    this.iconSize,
    this.leading,
    this.gap,
    this.padding,
  });
}

/// Theme configuration for Google Nav Bar
class WireframeGoogleNavTheme {
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color rippleColor;
  final Color hoverColor;
  final Color tabBackgroundColor;
  final double iconSize;
  final double gap;
  final double borderRadius;
  final double tabBorderRadius;
  final double containerHeight;
  final EdgeInsets containerPadding;
  final EdgeInsets tabPadding;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final Border? tabBorder;
  final Border? tabActiveBorder;
  final List<BoxShadow>? tabShadow;
  final Gradient? tabBackgroundGradient;
  final double textSize; // Added text size property
  final FontWeight textWeight; // Added text weight property
  final Color selectedTextColor; // Added selected text color
  final Color unselectedTextColor; // Added unselected text color

  const WireframeGoogleNavTheme({
    required this.backgroundColor,
    required this.selectedColor,
    required this.unselectedColor,
    required this.rippleColor,
    required this.hoverColor,
    required this.tabBackgroundColor,
    this.iconSize = 24.0,
    this.gap = 4.0,
    this.borderRadius = 0.0,
    this.tabBorderRadius = 15.0,
    this.containerHeight = 120.0,
    this.containerPadding =
        const EdgeInsets.symmetric(horizontal: 9.9, vertical: 8),
    this.tabPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    this.textSize = 10.0, // Added default text size
    this.textWeight = FontWeight.w600, // Added default text weight
    Color? selectedTextColor, // Made nullable with default
    Color? unselectedTextColor, // Made nullable with default
    this.boxShadow,
    this.border,
    this.tabBorder,
    this.tabActiveBorder,
    this.tabShadow,
    this.tabBackgroundGradient,
  })  : selectedTextColor = selectedTextColor ??
            selectedColor, // Default to selectedColor if not provided
        unselectedTextColor = unselectedTextColor ??
            unselectedColor; // Default to unselectedColor if not provided

  /// Default wireframe theme
  static WireframeGoogleNavTheme defaultTheme() {
    return WireframeGoogleNavTheme(
      backgroundColor: const Color.fromARGB(255, 34, 60, 109),
      selectedColor:
          const Color.fromARGB(255, 223, 170, 72), // Icon color when selected
      unselectedColor: const Color.fromARGB(
          255, 243, 240, 240), // Icon color when unselected
      rippleColor: WireframeColorManager.colors.textSecondary!,
      hoverColor: WireframeColorManager.colors.textSecondary!,
      tabBackgroundColor:
          const Color.fromARGB(255, 229, 231, 233).withValues(alpha: 0.1),
      iconSize: 20.0, //
      gap: 4.0, //
      borderRadius: 0.0,
      tabBorderRadius: 30.0,
      containerHeight: 120.0,
      tabPadding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 8), // Increased padding
      textSize: 10.0, // Larger text
      textWeight: FontWeight.w700, // Bolder text
      selectedTextColor: const Color.fromARGB(
          255, 223, 170, 72), // Same as icons, or choose different
      unselectedTextColor: const Color.fromARGB(
          255, 223, 170, 72), // Same as unselected icons, or choose different
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  /// Dark theme
  static WireframeGoogleNavTheme darkTheme() {
    return WireframeGoogleNavTheme(
      backgroundColor: const Color(0xFF2C2C2E),
      selectedColor: WireframeColorManager.colors.onPrimary,
      unselectedColor: WireframeColorManager.colors.textSecondary,
      rippleColor: WireframeColorManager.colors.textSecondary,
      hoverColor: WireframeColorManager.colors.textSecondary,
      tabBackgroundColor: WireframeColorManager.colors.textSecondary,
      iconSize: 24.0,
      gap: 8.0,
      borderRadius: 25.0,
      tabBorderRadius: 15.0,
      containerHeight: 120.0,
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withValues(alpha: 0.3),
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  /// Colorful theme
  static WireframeGoogleNavTheme colorfulTheme() {
    return WireframeGoogleNavTheme(
      backgroundColor: WireframeColorManager.colors.onPrimary,
      selectedColor: Colors.purple,
      unselectedColor: WireframeColorManager.colors.textSecondary!,
      rippleColor: Colors.purple.withValues(alpha: 0.3),
      hoverColor: Colors.purple.withValues(alpha: 0.1),
      tabBackgroundColor: Colors.purple.withValues(alpha: 0.15),
      iconSize: 26.0,
      gap: 10.0,
      borderRadius: 30.0,
      tabBorderRadius: 20.0,
      containerHeight: 75.0,
      boxShadow: [
        BoxShadow(
          blurRadius: 25,
          color: Colors.purple.withValues(alpha: 0.1),
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  /// Minimal theme
  static WireframeGoogleNavTheme minimalTheme() {
    return WireframeGoogleNavTheme(
      backgroundColor: Colors.transparent,
      selectedColor: Colors.black,
      unselectedColor: WireframeColorManager.colors.textSecondary!,
      rippleColor: WireframeColorManager.colors.textSecondary!,
      hoverColor: WireframeColorManager.colors.textSecondary!,
      tabBackgroundColor: WireframeColorManager.colors.textSecondary!,
      iconSize: 22.0,
      gap: 6.0,
      borderRadius: 0.0,
      tabBorderRadius: 10.0,
      containerHeight: 120.0,
      containerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      tabPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Gradient theme
  static WireframeGoogleNavTheme gradientTheme() {
    return WireframeGoogleNavTheme(
      backgroundColor: WireframeColorManager.colors.onPrimary,
      selectedColor: WireframeColorManager.colors.onPrimary,
      unselectedColor: WireframeColorManager.colors.textSecondary!,
      rippleColor: Colors.blue.withValues(alpha: 0.3),
      hoverColor: Colors.blue.withValues(alpha: 0.1),
      tabBackgroundColor: Colors.transparent,
      iconSize: 24.0,
      gap: 8.0,
      borderRadius: 25.0,
      tabBorderRadius: 15.0,
      containerHeight: 120.0,
      tabBackgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue, Colors.purple],
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.blue.withValues(alpha: 0.1),
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  /// Custom theme builder
  static WireframeGoogleNavTheme custom({
    Color? backgroundColor,
    Color? selectedColor,
    Color? unselectedColor,
    Color? rippleColor,
    Color? hoverColor,
    Color? tabBackgroundColor,
    double? iconSize,
    double? gap,
    double? borderRadius,
    double? tabBorderRadius,
    double? containerHeight,
    EdgeInsets? containerPadding,
    EdgeInsets? tabPadding,
    List<BoxShadow>? boxShadow,
    Border? border,
    Gradient? tabBackgroundGradient,
  }) {
    final defaultTheme = WireframeGoogleNavTheme.defaultTheme();

    return WireframeGoogleNavTheme(
      backgroundColor: backgroundColor ?? defaultTheme.backgroundColor,
      selectedColor: selectedColor ?? defaultTheme.selectedColor,
      unselectedColor: unselectedColor ?? defaultTheme.unselectedColor,
      rippleColor: rippleColor ?? defaultTheme.rippleColor,
      hoverColor: hoverColor ?? defaultTheme.hoverColor,
      tabBackgroundColor: tabBackgroundColor ?? defaultTheme.tabBackgroundColor,
      iconSize: iconSize ?? defaultTheme.iconSize,
      gap: gap ?? defaultTheme.gap,
      borderRadius: borderRadius ?? defaultTheme.borderRadius,
      tabBorderRadius: tabBorderRadius ?? defaultTheme.tabBorderRadius,
      containerHeight: containerHeight ?? defaultTheme.containerHeight,
      containerPadding: containerPadding ?? defaultTheme.containerPadding,
      tabPadding: tabPadding ?? defaultTheme.tabPadding,
      boxShadow: boxShadow ?? defaultTheme.boxShadow,
      border: border ?? defaultTheme.border,
      tabBackgroundGradient: tabBackgroundGradient,
    );
  }

  /// Responsive theme that uses WireframeColorManager colors
  static WireframeGoogleNavTheme responsiveTheme() {
    return WireframeGoogleNavTheme(
      backgroundColor: WireframeColorManager.colors.surface,
      selectedColor: WireframeColorManager.colors.primary,
      unselectedColor: WireframeColorManager.colors.textSecondary,
      rippleColor: WireframeColorManager.colors.primary.withValues(alpha: 0.3),
      hoverColor: WireframeColorManager.colors.primary.withValues(alpha: 0.1),
      tabBackgroundColor:
          WireframeColorManager.colors.primary.withValues(alpha: 0.1),
      iconSize: 20.0,
      gap: 4.0,
      borderRadius: 0.0,
      tabBorderRadius: 30.0,
      containerHeight: 120.0,
      tabPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      textSize: 10.0,
      textWeight: FontWeight.w700,
      selectedTextColor: WireframeColorManager.colors.primary,
      unselectedTextColor: WireframeColorManager.colors.textSecondary,
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  /// Border-only theme - selected items have border but no background fill (like green arrow example)
  static WireframeGoogleNavTheme borderOnlyTheme() {
    // ← Now INSIDE the class!
    return WireframeGoogleNavTheme(
      backgroundColor: WireframeColorManager.colors.surface,
      selectedColor: WireframeColorManager
          .colors.primary, // Icon and text color when selected
      unselectedColor: WireframeColorManager
          .colors.textSecondary!, // Icon and text color when unselected
      rippleColor: WireframeColorManager.colors.primary.withValues(alpha: 0.1),
      hoverColor: WireframeColorManager.colors.primary.withValues(alpha: 0.05),
      tabBackgroundColor: Colors.transparent, // KEY: No background fill!
      iconSize: 20.0,
      gap: 4.0,
      borderRadius: 0.0,
      tabBorderRadius: 30.0,
      containerHeight: 120.0,
      tabPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      textSize: 10.0,
      textWeight: FontWeight.w700,
      selectedTextColor: WireframeColorManager.colors.primary,
      unselectedTextColor: WireframeColorManager.colors.textSecondary!,
      // KEY: Add border for selected items only
      tabActiveBorder: Border.all(
        color: WireframeColorManager.colors.primary,
        width: 0.50,
      ),
      tabBorder: Border.all(
        color: Colors.transparent, // No border for unselected items
        width: 0.50,
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, -2),
        ),
      ],
    );
  }
} // ← This closes the WireframeGoogleNavTheme class

/// Predefined navigation item sets
class GoogleWireframeNavItems {
  /// Portfolio navigation items
  static List<WireframeNavItem> portfolio() {
    return [
      WireframeNavItem(
        icon: Icons.home, // Will be replaced by SVG
        label: 'Home',
        svgPath: SvgIconPaths.home3Line,
      ),
      WireframeNavItem(
        icon: Icons.work, // Will be replaced by SVG
        label: 'Projects',
        svgPath: SvgIconPaths.displayLine,
      ),
      WireframeNavItem(
        icon: Icons.add, // Will be replaced by SVG
        label: 'Add',
        svgPath: SvgIconPaths.addCircleLine,
      ),
      WireframeNavItem(
        icon: Icons.person, // Will be replaced by SVG
        label: 'About',
        svgPath: SvgIconPaths.userLine,
      ),
      WireframeNavItem(
        icon: Icons.settings, // Will be replaced by SVG
        label: 'Settings',
        svgPath: SvgIconPaths.settings3Line,
      ),
    ];
  }

  /// Social media style items
  static List<WireframeNavItem> social() {
    return [
      const WireframeNavItem(
        icon: LineIcons.home,
        label: 'Home',
        activeColor: Colors.blue,
      ),
      WireframeNavItem(
        icon: LineIcons.heart,
        label: 'Likes',
        activeColor: WireframeColorManager.colors.error,
      ),
      const WireframeNavItem(
        icon: LineIcons.search,
        label: 'Search',
        activeColor: Colors.green,
      ),
      const WireframeNavItem(
        icon: LineIcons.userFriends,
        label: 'Friends',
        activeColor: Colors.orange,
      ),
    ];
  }

  /// Custom items with individual colors
  static List<WireframeNavItem> customColored() {
    return [
      WireframeNavItem(
        icon: LineIcons.home,
        label: 'Home',
        activeColor: Colors.purple,
        backgroundColor: Colors.purple.withValues(alpha: 0.1),
      ),
      WireframeNavItem(
        icon: LineIcons.briefcase,
        label: 'Work',
        activeColor: Colors.blue,
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      WireframeNavItem(
        icon: LineIcons.heart,
        label: 'Favorites',
        activeColor: WireframeColorManager.colors.error,
        backgroundColor:
            WireframeColorManager.colors.error.withValues(alpha: 0.1),
      ),
      WireframeNavItem(
        icon: LineIcons.cog,
        label: 'Settings',
        activeColor: WireframeColorManager.colors.textSecondary!,
        backgroundColor:
            WireframeColorManager.colors.textSecondary.withValues(alpha: 0.1),
      ),
    ];
  }
}

// Custom navigation bar with SVG icon support
class WireframeSvgNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final List<WireframeNavItem> items;
  final WireframeGoogleNavTheme theme;

  const WireframeSvgNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.items,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: theme.containerHeight,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        boxShadow: theme.boxShadow,
        border: theme.border,
      ),
      child: SafeArea(
        child: Padding(
          padding: theme.containerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;
              return _buildNavItem(item, isSelected, () => onTabChange(index));
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      WireframeNavItem item, bool isSelected, VoidCallback onTap) {
    return ClickableWidget(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: theme.tabPadding,
        decoration: BoxDecoration(
          color: isSelected ? theme.tabBackgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(theme.tabBorderRadius),
          border: isSelected ? theme.tabActiveBorder : theme.tabBorder,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon (SVG or fallback)
            if (item.svgPath != null)
              SvgIcon(
                assetPath: item.svgPath!,
                size: theme.iconSize,
                color: isSelected
                    ? (item.activeColor ?? theme.selectedColor)
                    : (item.inactiveColor ?? theme.unselectedColor),
              )
            else
              Icon(
                item.icon,
                size: theme.iconSize,
                color: isSelected
                    ? (item.activeColor ?? theme.selectedColor)
                    : (item.inactiveColor ?? theme.unselectedColor),
              ),

            // Gap and text
            if (isSelected) ...[
              SizedBox(width: theme.gap),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: theme.textSize,
                  fontWeight: theme.textWeight,
                  color: isSelected
                      ? theme.selectedTextColor
                      : theme.unselectedTextColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
