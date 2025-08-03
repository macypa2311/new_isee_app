import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nwe_isee_app/main.dart';

void main() {
  testWidgets('App lädt und zeigt Text', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialMode: ThemeMode.system));

    expect(find.text('Hallo, Welt!'), findsOneWidget);
  });
}