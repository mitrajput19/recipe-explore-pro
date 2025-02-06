import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeBoxName = 'settings';
  static const String _themeKey = 'isDarkMode';

  bool _isDarkMode = false;
  ThemeData _currentTheme = lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;
  ThemeData get currentTheme => _currentTheme;

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Add other light theme customizations
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Add other dark theme customizations
  );

  Future<void> _loadTheme() async {
    final settingsBox = Hive.box(_themeBoxName);
    _isDarkMode = settingsBox.get(_themeKey, defaultValue: false);
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final settingsBox = Hive.box(_themeBoxName);
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    await settingsBox.put(_themeKey, _isDarkMode);
    notifyListeners();
  }

  void setTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _currentTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }
}
