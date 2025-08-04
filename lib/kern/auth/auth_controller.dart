import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Rolle { superadmin, admin, installateur, endkunde, planer, unknown }

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  Rolle _rolle = Rolle.unknown;

  bool get isLoggedIn => _isLoggedIn;
  Rolle get rolle => _rolle;

  static const _storageKeyLoggedIn = 'is_logged_in';
  static const _storageKeyRole = 'role';

  AuthController() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_storageKeyLoggedIn) ?? false;
    final storedRole = prefs.getString(_storageKeyRole) ?? '';
    _rolle = _stringToRolle(storedRole);
    notifyListeners();
  }

  Rolle _stringToRolle(String s) {
    switch (s) {
      case 'superadmin':
        return Rolle.superadmin;
      case 'admin':
        return Rolle.admin;
      case 'installateur':
        return Rolle.installateur;
      case 'endkunde':
        return Rolle.endkunde;
      case 'planer':
        return Rolle.planer;
      default:
        return Rolle.unknown;
    }
  }

  Future<void> login(String username, String password) async {
    Rolle? role;

    if (username == "superadmin" && password == "sA_2025!PVDx#") {
      role = Rolle.superadmin;
    } else if (username == "admin" && password == "admin123") {
      role = Rolle.admin;
    } else if (username == "installateur" && password == "install2025") {
      role = Rolle.installateur;
    } else if (username == "endkunde" && password == "kunde2025") {
      role = Rolle.endkunde;
    } else if (username == "planer" && password == "plan2025") {
      role = Rolle.planer;
    }

    print('Loginversuch: $username / $password -> Rolle: $role');

    if (role != null && role != Rolle.unknown) {
      _isLoggedIn = true;
      _rolle = role;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_storageKeyLoggedIn, true);
      await prefs.setString(_storageKeyRole, role.name);
      notifyListeners();
    } else {
      throw Exception('Ungültige Anmeldedaten');
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _rolle = Rolle.unknown;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKeyLoggedIn);
    await prefs.remove(_storageKeyRole);
    notifyListeners();
  }
}