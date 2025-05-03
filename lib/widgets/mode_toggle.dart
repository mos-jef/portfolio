import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default to dark mode
  bool _isNesTheme = false; // Default to modern theme

  bool get isDarkMode => _isDarkMode;
  bool get isNesTheme => _isNesTheme;

  ModeProvider() {
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

  // Toggle between NES and modern theme
  void toggleNesTheme() {
    _isNesTheme = !_isNesTheme;
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
      scaffoldBackgroundColor: Colors.grey[900],
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
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
    );
  }

  // NES dark theme
  ThemeData nesThemeDark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.purple[800],
      scaffoldBackgroundColor: Colors.grey[900],
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // NES light theme
  ThemeData nesThemeLight() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue[800],
      scaffoldBackgroundColor: Colors.grey[200],
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
