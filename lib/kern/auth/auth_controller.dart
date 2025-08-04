import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum Rolle { superadmin, admin, installateur, endkunde, planer, unbekannt }

class AuthController extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _loggedIn = false;
  Rolle _rolle = Rolle.unbekannt;

  int _unreadMessagesCount = 0;
  int get unreadMessagesCount => _unreadMessagesCount;

  void setUnreadMessagesCount(int count) {
    if (_unreadMessagesCount != count) {
      _unreadMessagesCount = count;
      notifyListeners();
    }
  }

  bool get isLoggedIn => _loggedIn;
  Rolle get rolle => _rolle;

  // Keys für Storage
  static const _keyLoggedIn = 'loggedIn';
  static const _keyRolle = 'rolle';
  static const _keyUnreadMessages = 'unreadMessages';

  Future<void> login(String username, String password) async {
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

      // Beispiel: Ungelesene Nachrichten initialisieren (für Demo)
      _unreadMessagesCount = 2;
      await _storage.write(key: _keyUnreadMessages, value: '2');

      // Speichern in Secure Storage
      await _storage.write(key: _keyLoggedIn, value: 'true');
      await _storage.write(key: _keyRolle, value: _rolle.toString());

      notifyListeners();
    } else {
      throw Exception('Ungültige Anmeldedaten');
    }
  }

  Future<void> logout() async {
    _loggedIn = false;
    _rolle = Rolle.unbekannt;
    _unreadMessagesCount = 0;

    // Löschen aus Secure Storage
    await _storage.delete(key: _keyLoggedIn);
    await _storage.delete(key: _keyRolle);
    await _storage.delete(key: _keyUnreadMessages);

    notifyListeners();
  }

  // Automatischer Login beim App-Start
  Future<void> tryAutoLogin() async {
    final loggedInValue = await _storage.read(key: _keyLoggedIn);
    final rolleString = await _storage.read(key: _keyRolle);
    final unreadString = await _storage.read(key: _keyUnreadMessages);

    if (loggedInValue == 'true' && rolleString != null) {
      _loggedIn = true;
      _rolle = Rolle.values.firstWhere(
        (r) => r.toString() == rolleString,
        orElse: () => Rolle.unbekannt,
      );
      _unreadMessagesCount = int.tryParse(unreadString ?? '0') ?? 0;

      notifyListeners();
    }
  }

  // Neue Methode zum Markieren aller Nachrichten als gelesen
  Future<void> markMessagesAsRead() async {
    if (_unreadMessagesCount != 0) {
      _unreadMessagesCount = 0;
      await _storage.write(key: _keyUnreadMessages, value: '0');
      notifyListeners();
    }
  }
}