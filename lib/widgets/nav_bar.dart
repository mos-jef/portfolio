import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nes_ui/nes_ui.dart';
import '../models/theme_provider.dart';

class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

  final List<String> navItems = ['Home', 'Projects', 'About', 'Contact'];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isNesTheme = themeProvider.isNesTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return isNesTheme
        ? buildNesNavBar(context, isMobile)
        : buildDefaultNavBar(context, isMobile);
  }

  Widget buildNesNavBar(BuildContext context, bool isMobile) {
    return NesContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isMobile
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Portfolio',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: NesIcon(iconData: NesIcons.rightArrowIndicator),
                  itemBuilder: (context) {
                    return navItems.map((item) {
                      return PopupMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    // Handle navigation
                  },
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Portfolio',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: navItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: NesButton(
                        type: NesButtonType.normal,
                        onPressed: () {
                          // Handle navigation
                        },
                        child: Text(item),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }

  Widget buildDefaultNavBar(BuildContext context, bool isMobile) {
    return AppBar(
      title: const Text('Portfolio'),
      actions: isMobile
          ? [
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return navItems.map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  // Handle navigation
                },
              ),
            ]
          : navItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    // Handle navigation
                  },
                  child: Text(item),
                ),
              );
            }).toList(),
    );
  }
}