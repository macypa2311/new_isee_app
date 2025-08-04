import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemaController extends ChangeNotifier {
  static const _keyThemeMode = 'theme_mode';
  static const _keyAccent = 'accent_choice';

  bool _isDark = false;
  String _accentChoice = 'blue';

  bool get isDark => _isDark;
  String get accentChoice => _accentChoice;
  ThemeMode get modus => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemaController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_keyThemeMode) ?? false;
    _accentChoice = prefs.getString(_keyAccent) ?? 'blue';
    notifyListeners();
  }

  Future<void> toggleDark(bool value) async {
    _isDark = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyThemeMode, _isDark);
    notifyListeners();
  }

  Future<void> setAccent(String choice) async {
    _accentChoice = choice;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccent, _accentChoice);
    notifyListeners();
  }
}