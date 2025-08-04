import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'kern/theme/thema_controller.dart';
import 'kern/theme/design_system.dart';
import 'kern/auth/auth_controller.dart';
import 'funktionen/login/login_seite.dart';
import 'funktionen/startseite/landing_admin.dart';
import 'funktionen/startseite/landing_installateur.dart';
import 'funktionen/startseite/landing_endkunde.dart';
import 'funktionen/startseite/landing_planer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemaController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const AppStart(),
    ),
  );
}

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final auth = context.watch<AuthController>();

    Widget home;
    if (!auth.isLoggedIn) {
      home = const LoginSeite();
    } else {
      switch (auth.rolle) {
        case Rolle.admin:
        case Rolle.superadmin:
          home = const LandingAdmin();
          break;
        case Rolle.installateur:
          home = const LandingPageInstallateur();
          break;
        case Rolle.endkunde:
          home = const LandingPageEndkunde();
          break;
        case Rolle.planer:
          home = const LandingPagePlaner();
          break;
        default:
          home = const LoginSeite();
      }
    }

    return MaterialApp(
      title: 'ISEE App',
      themeMode: thema.modus,
      theme: DesignSystem.hellesTheme(thema.accentColor),
      darkTheme: DesignSystem.dunklesTheme(thema.accentColor),
      home: home,
    );
  }
}