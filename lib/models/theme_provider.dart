import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { main, nes, wireframe }

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default to light mode
  bool _isNesTheme = false; // Default to modern theme
  AppThemeMode _currentThemeMode = AppThemeMode.wireframe; // Default to wireframe theme

  bool get isDarkMode => _isDarkMode;
  bool get isNesTheme => _isNesTheme;
  AppThemeMode get currentThemeMode => _currentThemeMode;
  bool get isWireframeTheme => _currentThemeMode == AppThemeMode.wireframe;

  ThemeProvider() {
    _loadFromPrefs();
  }

  // Initialize theme preferences
  Future<void> _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isNesTheme = prefs.getBool('isNesTheme') ?? false;

    // Load theme mode
    String themeMode = prefs.getString('themeMode') ?? 'wireframe';
    switch (themeMode) {
      case 'nes':
        _currentThemeMode = AppThemeMode.nes;
        _isNesTheme = true;
        break;
      case 'wireframe':
        _currentThemeMode = AppThemeMode.wireframe;
        _isNesTheme = false;
        break;
      default:
        _currentThemeMode = AppThemeMode.wireframe;
        _isNesTheme = false;
    }

    notifyListeners();
  }

  // Save theme preferences
  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('isNesTheme', _isNesTheme);
    await prefs.setString(
        'themeMode', _currentThemeMode.toString().split('.').last);
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
      _currentThemeMode = value ? AppThemeMode.nes : AppThemeMode.main;
    } else {
      _isNesTheme = !_isNesTheme;
      _currentThemeMode = _isNesTheme ? AppThemeMode.nes : AppThemeMode.main;
    }
    _saveToPrefs();
    notifyListeners();
  }

  // Set wireframe theme
  void setWireframeTheme() {
    _currentThemeMode = AppThemeMode.wireframe;
    _isNesTheme = false;
    _saveToPrefs();
    notifyListeners();
  }

  // Set theme mode
  void setThemeMode(AppThemeMode mode) {
    _currentThemeMode = mode;
    _isNesTheme = (mode == AppThemeMode.nes);
    _saveToPrefs();
    notifyListeners();
  }

  // Get the appropriate theme data
  ThemeData getThemeData() {
    switch (_currentThemeMode) {
      case AppThemeMode.nes:
        return _isDarkMode ? nesThemeDark() : nesThemeLight();
      case AppThemeMode.wireframe:
        return wireframeTheme();
      case AppThemeMode.main:
      default:
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

  // Wireframe theme
  ThemeData wireframeTheme() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xFF007BFF),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: const ColorScheme.light().copyWith(
        primary: const Color(0xFF007BFF),
        secondary: const Color(0xFF6C757D),
        surface: Colors.white,
        background: const Color(0xFFF8F9FA),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
            fontFamily: 'Montserrat', fontSize: 16, color: Color(0xFF495057)),
        bodyMedium: TextStyle(
            fontFamily: 'Montserrat', fontSize: 14, color: Color(0xFF495057)),
        displayLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF495057)),
        displayMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF495057)),
        displaySmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF495057)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F9FA),
        foregroundColor: Color(0xFF495057),
        elevation: 0,
      ),
    );
  }
}
