import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;
  ThemeData _currentTheme = lightTheme;

  bool get isDarkTheme => _isDarkTheme;
  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _currentTheme = _isDarkTheme ? darkTheme : lightTheme;
    notifyListeners();
  }

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.amber,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey,
  );
}
