// lib/fragments/systemstatus_fragment.dart

import 'package:flutter/material.dart';

class SystemstatusFragment extends StatelessWidget {
  const SystemstatusFragment({Key? key}) : super(key: key);

  // Beispielstatus; später durch echten Status ersetzen
  final Map<String, bool> _status = const {
    'Unabhängigkeitsrechner': true,
    'Wärmepumpenplaner': true,
    'PV-Wirtschaftlichkeits-Analyse': false,
    'PV-Rechner': true,
    'Kamera-KI': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Systemstatus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Übersicht aller Module und ihres aktuellen Status:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _status.entries.map((entry) {
                  return ListTile(
                    leading: Icon(
                      entry.value ? Icons.check_circle : Icons.warning,
                      color: entry.value ? Colors.green : Colors.orange,
                    ),
                    title: Text(entry.key),
                    subtitle: Text(entry.value ? 'Online' : 'Offline'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}