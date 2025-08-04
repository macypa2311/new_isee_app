import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nwe_isee_app/settings_page.dart';

void main() {
  testWidgets('SettingsPage: Wechsel zu Dunkel löst Callback aus und speichert', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    ThemeMode appliedMode = ThemeMode.system;

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(
          currentMode: ThemeMode.system,
          onThemeChanged: (mode) {
            appliedMode = mode;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dunkel'), findsOneWidget);

    // Tippe auf "Dunkel"
    await tester.tap(find.text('Dunkel'));
    await tester.pumpAndSettle();

    // Callback sollte ausgelöst worden sein
    expect(appliedMode, equals(ThemeMode.dark));

    // Persistenz prüfen
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('themeMode'), equals('dark'));
  });

  testWidgets('SettingsPage mit vorausgewähltem dark Mode: Callback wird nicht unnötig ausgeführt', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'themeMode': 'dark'});

    // Wie main.dart: aus den prefs initialen Mode bestimmen
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('themeMode') ?? 'system';
    ThemeMode initialMode;
    if (stored == 'light') {
      initialMode = ThemeMode.light;
    } else if (stored == 'dark') {
      initialMode = ThemeMode.dark;
    } else {
      initialMode = ThemeMode.system;
    }

    bool callbackFired = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(
          currentMode: initialMode,
          onThemeChanged: (_) {
            callbackFired = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // "Dunkel" ist sichtbar
    expect(find.text('Dunkel'), findsOneWidget);
    // Callback wurde ohne Interaktion nicht ausgeführt
    expect(callbackFired, isFalse);
  });
}