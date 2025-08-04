import 'package:flutter/material.dart';

class BackupFragment extends StatelessWidget {
  const BackupFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Backup & Wiederherstellung', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Datensicherung',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Hier kannst du später deine persönlichen Einstellungen, '
            'Diagnosehistorien, Nutzerverwaltung, Gerätekonfigurationen und mehr sichern.',
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showInfo(context, 'Backup noch nicht verfügbar.',
                  'Die Cloud-Sicherung wird in einer späteren Version ergänzt.');
            },
            icon: const Icon(Icons.backup),
            label: const Text('Backup erstellen'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              _showInfo(context, 'Wiederherstellung noch nicht verfügbar.',
                  'Die Wiederherstellung aus der Cloud wird später integriert.');
            },
            icon: const Icon(Icons.restore),
            label: const Text('Wiederherstellen'),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Geplante Inhalte:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Diagnosehistorie sichern'),
          ),
          const ListTile(
            leading: Icon(Icons.settings_input_component),
            title: Text('Gerätekonfiguration speichern'),
          ),
          const ListTile(
            leading: Icon(Icons.people),
            title: Text('Nutzerverwaltung sichern'),
          ),
          const ListTile(
            leading: Icon(Icons.event),
            title: Text('Termine und Zeitpläne sichern'),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}