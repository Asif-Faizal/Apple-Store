import 'package:flutter/material.dart';
import '../core/storage/shared.preferences.helper.dart';
import '../core/theme/app.theme.dart';

class ThemeProvider with ChangeNotifier {
  late PreferencesManager _preferences;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _preferences = await PreferencesManager.getInstance();
    _isDarkMode = _preferences.isDarkMode;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _preferences.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  ThemeData get themeData {
    return _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
