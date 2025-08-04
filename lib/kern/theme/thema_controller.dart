import 'package:flutter/material.dart';

enum LayoutMode {
  carousel,
  grid,
}

class ThemaController extends ChangeNotifier {
  // Dark Mode
  bool _isDark = false;
  bool get isDark => _isDark;

  void setDarkMode(bool value) {
    if (_isDark != value) {
      _isDark = value;
      notifyListeners();
    }
  }

  // Accent color
  String _accentChoice = 'blue';
  String get accentChoice => _accentChoice;

  void setAccent(String choice) {
    if (_accentChoice != choice) {
      _accentChoice = choice;
      notifyListeners();
    }
  }

  // Layout mode
  LayoutMode _layoutMode = LayoutMode.carousel;
  LayoutMode get layoutMode => _layoutMode;

  void setLayoutMode(LayoutMode mode) {
    if (_layoutMode != mode) {
      _layoutMode = mode;
      notifyListeners();
    }
  }

  // Grid count (2 oder 3)
  int _gridCount = 2;
  int get gridCount => _gridCount;

  void setGridCount(int count) {
    if (count != _gridCount && (count == 2 || count == 3)) {
      _gridCount = count;
      notifyListeners();
    }
  }

  // Accent color (real color value)
  Color get accentColor {
    switch (_accentChoice) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
      default:
        return Colors.blue;
    }
  }

  // ThemeMode
  ThemeMode get modus => _isDark ? ThemeMode.dark : ThemeMode.light;
}