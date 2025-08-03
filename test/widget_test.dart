import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nwe_isee_app/main.dart'; // enthält MyAppWrapper
import 'package:nwe_isee_app/theme_controller.dart';

void main() {
  testWidgets('App lädt und zeigt Text', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeController(),
        child: const MyAppWrapper(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hallo, Welt!'), findsOneWidget);
  });
}