import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:nwe_isee_app/main.dart';
import 'package:nwe_isee_app/kern/theme/thema_controller.dart';
import 'package:nwe_isee_app/kern/auth/auth_controller.dart';

void main() {
  testWidgets('Startseite zeigt Login', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemaController()),
          ChangeNotifierProvider(create: (_) => AuthController()),
        ],
        child: const AppStart(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
  });
}