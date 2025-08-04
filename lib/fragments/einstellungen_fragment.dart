import 'package:flutter/material.dart';

class EinstellungenFragment extends StatelessWidget {
  const EinstellungenFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Benutzereinstellungen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Benachrichtigungen'),
              value: true,
              onChanged: (value) {
                // TODO: Logik einbauen
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Passwort ändern'),
              onTap: () {
                // TODO: Navigieren oder Dialog öffnen
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App-Info'),
              onTap: () {
                // TODO: Dialog oder Info anzeigen
              },
            ),
          ],
        ),
      ),
    );
  }
}