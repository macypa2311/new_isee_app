import 'package:flutter/material.dart';

enum Rolle { superadmin, admin, installateur, endkunde, planer, unbekannt }

class AuthController extends ChangeNotifier {
  bool _loggedIn = false;
  Rolle _rolle = Rolle.unbekannt;

  bool get isLoggedIn => _loggedIn;
  Rolle get rolle => _rolle;

  /// Harteingecodete Login-Daten
  Future<void> login(String username, String password) async {
    // Simulierter Delay (optional)
    await Future.delayed(const Duration(milliseconds: 200));

    if (username == 'superadmin' && password == 'sA_2025!PVDx#') {
      _rolle = Rolle.superadmin;
    } else if (username == 'admin' && password == 'admin123') {
      _rolle = Rolle.admin;
    } else if (username == 'installateur' && password == 'install2025') {
      _rolle = Rolle.installateur;
    } else if (username == 'endkunde' && password == 'kunde2025') {
      _rolle = Rolle.endkunde;
    } else if (username == 'planer' && password == 'plan2025') {
      _rolle = Rolle.planer;
    } else {
      _rolle = Rolle.unbekannt;
    }

    if (_rolle != Rolle.unbekannt) {
      _loggedIn = true;
      notifyListeners();
    } else {
      throw Exception('Ungültige Anmeldedaten');
    }
  }

  Future<void> logout() async {
    _loggedIn = false;
    _rolle = Rolle.unbekannt;
    notifyListeners();
  }
}