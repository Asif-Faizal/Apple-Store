import 'package:flutter/material.dart';
import '../storage/shared.preferences.helper.dart';

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
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}

class AppTheme {
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color secondaryColor = Color(0xFF5856D6);
  static const Color backgroundColor = Color(0xFFF2F2F7);
  static const Color darkBackgroundColor = Color(0xFF000000);
  static const Color textColor = Color(0xFF000000);
  static const Color darkTextColor = Color(0xFFFFFFFF);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textColor,
      onSurface: textColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackgroundColor,
      surface: const Color(0xFF1C1C1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkTextColor,
      onSurface: darkTextColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkTextColor,
      ),
    ),
  );
}
