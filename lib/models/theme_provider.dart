import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default to light mode
  bool _isNesTheme = false; // Default to modern theme

  bool get isDarkMode => _isDarkMode;
  bool get isNesTheme => _isNesTheme;

  ThemeProvider() {
    _loadFromPrefs();
  }

  // Initialize theme preferences
  Future<void> _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isNesTheme = prefs.getBool('isNesTheme') ?? false;
    notifyListeners();
  }

  // Save theme preferences
  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('isNesTheme', _isNesTheme);
  }

  // Toggle between dark and light mode
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _saveToPrefs();
    notifyListeners();
  }

  // Toggle to NES theme (or off)
  void toggleNesTheme([bool? value]) {
    if (value != null) {
      _isNesTheme = value;
    } else {
      _isNesTheme = !_isNesTheme;
    }
    _saveToPrefs();
    notifyListeners();
  }

  // Get the appropriate theme data
  ThemeData getThemeData() {
    if (_isNesTheme) {
      return _isDarkMode ? nesThemeDark() : nesThemeLight();
    } else {
      return _isDarkMode ? modernThemeDark() : modernThemeLight();
    }
  }

  // Modern dark theme
  ThemeData modernThemeDark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.purple,
      scaffoldBackgroundColor:
          Colors.transparent, // Use transparent for background images
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
      ),
    );
  }

  // Modern light theme
  ThemeData modernThemeLight() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor:
          Colors.transparent, // Use transparent for background images
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
    );
  }

  // NES dark theme
  ThemeData nesThemeDark() {
    return ThemeData.dark().copyWith(
      primaryColor: const Color(0xFF9370DB),
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: const Color(0xFF9370DB),
        secondary: const Color(0xFFB19CD9),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'NES', fontSize: 16),
        bodyMedium: TextStyle(fontFamily: 'NES', fontSize: 14),
        displayLarge: TextStyle(
            fontFamily: 'NES', fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            fontFamily: 'NES', fontSize: 22, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(
            fontFamily: 'NES', fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // NES light theme
  ThemeData nesThemeLight() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xFF4169E1),
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.light().copyWith(
        primary: const Color(0xFF4169E1),
        secondary: const Color(0xFF6495ED),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'NES', fontSize: 16),
        bodyMedium: TextStyle(fontFamily: 'NES', fontSize: 14),
        displayLarge: TextStyle(
            fontFamily: 'NES', fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            fontFamily: 'NES', fontSize: 22, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(
            fontFamily: 'NES', fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
