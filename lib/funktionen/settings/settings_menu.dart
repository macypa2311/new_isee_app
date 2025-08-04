import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';

// Importiere hier deine Darstellung-Seite (bitte anpassen, falls Pfad anders)
import 'settings_darstellung.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = Theme.of(context).textTheme.titleMedium;
    final textStyleSubtitle = Theme.of(context).textTheme.bodyMedium;
    final auth = context.read<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Einstellungen'),
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Benutzerdaten', style: textStyleTitle),
            subtitle:
                Text('Profil, Passwort ändern, E-Mail ändern', style: textStyleSubtitle),
            leading: const Icon(Icons.person),
            onTap: () {
              // TODO: Navigation zu Benutzerdaten-Seite (Platzhalter)
            },
          ),
          const Divider(),
          ListTile(
            title: Text('Darstellung', style: textStyleTitle),
            subtitle:
                Text('Hell/Dunkel-Modus, Farbe, Kachelgröße', style: textStyleSubtitle),
            leading: const Icon(Icons.color_lens),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsDarstellung()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text('Benachrichtigungen', style: textStyleTitle),
            subtitle: Text('Push & E-Mail Einstellungen', style: textStyleSubtitle),
            leading: const Icon(Icons.notifications),
            onTap: () {
              // TODO: Navigation zu Benachrichtigungen (Platzhalter)
            },
          ),
          const Divider(),
          ListTile(
            title: Text('Impressum & Datenschutz', style: textStyleTitle),
            subtitle: Text('Rechtliche Hinweise', style: textStyleSubtitle),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              // TODO: Navigation zu Impressum / Datenschutz (Platzhalter)
            },
          ),
          const Divider(),
          ListTile(
            title: Text('App-Info', style: textStyleTitle),
            subtitle: Text('Version, Lizenz, Support', style: textStyleSubtitle),
            leading: const Icon(Icons.info),
            onTap: () {
              // TODO: Navigation zu App-Info (Platzhalter)
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Abmelden', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              await auth.logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}