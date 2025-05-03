import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';

class CircleThemeToggle extends StatelessWidget {
  final double size;
  final Color borderColor;
  final double borderWidth;

  const CircleThemeToggle({
    Key? key,
    this.size = 50.0,
    this.borderColor = Colors.white,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () {
        themeProvider.toggleDarkMode(!isDarkMode);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: borderColor,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
