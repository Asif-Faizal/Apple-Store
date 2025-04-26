import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static PreferencesManager? _instance;
  static SharedPreferences? _preferences;

  // Keys
  static const String keyTheme = 'isDarkMode';

  // Default values
  static const bool defaultTheme = false;
  PreferencesManager._();

  static Future<PreferencesManager> getInstance() async {
    if (_instance == null) {
      _instance = PreferencesManager._();
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Theme preferences
  bool get isDarkMode => _preferences?.getBool(keyTheme) ?? defaultTheme;

  Future<void> setDarkMode(bool value) async {
    await _preferences?.setBool(keyTheme, value);
  }
}