import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class WireframeCurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<NavBarItem> items;
  final double height;
  final Color backgroundColor;
  final Color navBarColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const WireframeCurvedNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.height = 50.0,
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.navBarColor = Colors.white,
    this.selectedItemColor = const Color(0xFF007BFF),
    this.unselectedItemColor = const Color(0xFF6C757D),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: backgroundColor,
      color: navBarColor,
      buttonBackgroundColor: selectedItemColor,
      height: height,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      items: items.map((item) => _buildNavItem(item)).toList(),
      onTap: onTap,
    );
  }

  Widget _buildNavItem(NavBarItem item) {
    final isSelected = items.indexOf(item) == selectedIndex;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          item.icon,
          size: item.iconSize,
          color: isSelected ? Colors.white : unselectedItemColor,
        ),

        // Badge support
        if (item.badgeCount != null && item.badgeCount! > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: item.badgeColor ?? const Color(0xFFDC3545),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Center(
                child: Text(
                  item.badgeCount! > 9 ? '9+' : '${item.badgeCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Navigation bar item model
class NavBarItem {
  final IconData icon;
  final String label;
  final double iconSize;
  final int? badgeCount;
  final Color? badgeColor;
  final VoidCallback? onTap;

  const NavBarItem({
    required this.icon,
    required this.label,
    this.iconSize = 24.0,
    this.badgeCount,
    this.badgeColor,
    this.onTap,
  });
}

// Predefined navigation items for common use cases
class WireframeNavItems {
  static List<NavBarItem> get portfolio => [
        const NavBarItem(
          icon: Icons.home,
          label: 'Home',
        ),
        const NavBarItem(
          icon: Icons.work_outline,
          label: 'Projects',
        ),
        const NavBarItem(
          icon: Icons.add,
          label: 'Add',
        ),
        const NavBarItem(
          icon: Icons.person_outline,
          label: 'Profile',
        ),
        const NavBarItem(
          icon: Icons.bar_chart,
          label: 'Analytics',
        ),
      ];

  static List<NavBarItem> get social => [
        const NavBarItem(
          icon: Icons.home,
          label: 'Home',
        ),
        const NavBarItem(
          icon: Icons.search,
          label: 'Search',
        ),
        const NavBarItem(
          icon: Icons.add_circle_outline,
          label: 'Create',
        ),
        const NavBarItem(
          icon: Icons.favorite_outline,
          label: 'Likes',
        ),
        const NavBarItem(
          icon: Icons.person_outline,
          label: 'Profile',
        ),
      ];

  static List<NavBarItem> get ecommerce => [
        const NavBarItem(
          icon: Icons.home,
          label: 'Home',
        ),
        const NavBarItem(
          icon: Icons.category_outlined,
          label: 'Categories',
        ),
        const NavBarItem(
          icon: Icons.shopping_cart_outlined,
          label: 'Cart',
          badgeCount: 3, // Example badge
        ),
        const NavBarItem(
          icon: Icons.favorite_outline,
          label: 'Wishlist',
        ),
        const NavBarItem(
          icon: Icons.account_circle_outlined,
          label: 'Account',
        ),
      ];

  // Custom builder for dynamic items
  static List<NavBarItem> custom({
    required List<IconData> icons,
    required List<String> labels,
    List<int?>? badgeCounts,
    List<Color?>? badgeColors,
    double iconSize = 24.0,
  }) {
    assert(icons.length == labels.length,
        'Icons and labels must have same length');

    return List.generate(icons.length, (index) {
      return NavBarItem(
        icon: icons[index],
        label: labels[index],
        iconSize: iconSize,
        badgeCount: badgeCounts?[index],
        badgeColor: badgeColors?[index],
      );
    });
  }
}

// Theme variants for different design systems
class WireframeNavThemes {
  static const minimal = WireframeNavTheme(
    backgroundColor: Color(0xFFF8F9FA),
    navBarColor: Colors.white,
    selectedItemColor: Color(0xFF007BFF),
    unselectedItemColor: Color(0xFF6C757D),
    height: 50.0,
  );

  static const dark = WireframeNavTheme(
    backgroundColor: Color(0xFF121212),
    navBarColor: Color(0xFF1E1E1E),
    selectedItemColor: Color(0xFF007BFF),
    unselectedItemColor: Color(0xFF9E9E9E),
    height: 50.0,
  );

  static const colorful = WireframeNavTheme(
    backgroundColor: Color(0xFFF0F0F0),
    navBarColor: Colors.white,
    selectedItemColor: Color(0xFF6C5CE7),
    unselectedItemColor: Color(0xFF74B9FF),
    height: 55.0,
  );

  static const enterprise = WireframeNavTheme(
    backgroundColor: Color(0xFFFAFAFA),
    navBarColor: Color.fromARGB(255, 107, 106, 106),
    selectedItemColor: Color(0xFF2D3748),
    unselectedItemColor: Color(0xFFA0AEC0),
    height: 48.0,
  );
}

class WireframeNavTheme {
  final Color backgroundColor;
  final Color navBarColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final double height;

  const WireframeNavTheme({
    required this.backgroundColor,
    required this.navBarColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.height,
  });
}

// Enhanced curved nav bar with theme support
class ThemedWireframeCurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<NavBarItem> items;
  final WireframeNavTheme theme;
  final Duration animationDuration;
  final Curve animationCurve;

  const ThemedWireframeCurvedNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.theme = WireframeNavThemes.minimal,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WireframeCurvedNavBar(
      selectedIndex: selectedIndex,
      onTap: onTap,
      items: items,
      height: theme.height,
      backgroundColor: theme.backgroundColor,
      navBarColor: theme.navBarColor,
      selectedItemColor: theme.selectedItemColor,
      unselectedItemColor: theme.unselectedItemColor,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
    );
  }
}
