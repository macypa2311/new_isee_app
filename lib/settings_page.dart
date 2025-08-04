import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

extension AppThemeModeHelper on AppThemeMode {
  String get storageKey {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

AppThemeMode appThemeModeFromStored(String stored) {
  switch (stored) {
    case 'light':
      return AppThemeMode.light;
    case 'dark':
      return AppThemeMode.dark;
    default:
      return AppThemeMode.system;
  }
}

class SettingsPage extends StatefulWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.currentMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppThemeMode _selected;

  @override
  void initState() {
    super.initState();
    _selected = appThemeModeFromStored(_modeToString(widget.currentMode));
  }

  String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Future<void> _saveAndApply(AppThemeMode newMode) async {
    setState(() => _selected = newMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', newMode.storageKey);
    widget.onThemeChanged(newMode.toThemeMode());
  }

  Widget _radioTile(AppThemeMode mode, String title, String subtitle) {
    return RadioListTile<AppThemeMode>(
      value: mode,
      groupValue: _selected,
      title: Text(title),
      subtitle: Text(subtitle),
      onChanged: (v) {
        if (v != null) _saveAndApply(v);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Thema auswählen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _radioTile(AppThemeMode.system, 'System', 'Folgt dem Systemmodus'),
          _radioTile(AppThemeMode.light, 'Hell', 'Immer helles Thema'),
          _radioTile(AppThemeMode.dark, 'Dunkel', 'Immer dunkles Thema'),
        ],
      ),
    );
  }
}