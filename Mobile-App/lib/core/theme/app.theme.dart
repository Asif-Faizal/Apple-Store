import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  static const Color primaryColor = Colors.deepPurpleAccent;
  static Color lightSecondaryColor = Colors.deepPurple.shade600;
  static Color darkSecondaryColor = const Color.fromARGB(255, 249, 246, 255);
  static const Color backgroundColor = Color(0xFFF2F2F7);
  static const Color darkBackgroundColor = Color(0xFF000000);
  static const Color textColor = Color(0xFF000000);
  static const Color darkTextColor = Color(0xFFFFFFFF);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: lightSecondaryColor,
      background: backgroundColor,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textColor,
      onSurface: textColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightSecondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        backgroundColor: lightSecondaryColor,
        foregroundColor: darkTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade50,
      elevation: 5,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: lightSecondaryColor,width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: lightSecondaryColor,width: 2),
      ),enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: lightSecondaryColor,width: 0.5),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.playfairDisplay(
        fontSize: 16,
        color: textColor,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 24,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: GoogleFonts.playfairDisplay(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: darkTextColor,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: darkSecondaryColor,
      background: darkBackgroundColor,
      surface: const Color(0xFF1C1C1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: darkTextColor,
      onSurface: darkTextColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkSecondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        elevation: 5,
        backgroundColor: darkSecondaryColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 40, 40, 40),
      elevation: 5,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: darkSecondaryColor,width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: darkSecondaryColor,width: 2),
      ),enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: darkSecondaryColor,width: 0.5),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkTextColor,
      ),
      bodyLarge: GoogleFonts.playfairDisplay(
        fontSize: 16,
        color: darkTextColor,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 24,
        color: darkTextColor,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: GoogleFonts.playfairDisplay(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
  );
}
