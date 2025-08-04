import 'package:flutter/material.dart';

class EreignisLogFragment extends StatelessWidget {
  const EreignisLogFragment({super.key});

  final List<Map<String, String>> ereignisse = const [
    {
      'timestamp': '2025-08-04 10:23',
      'event': 'Wechselrichter neu gestartet',
    },
    {
      'timestamp': '2025-08-04 09:41',
      'event': 'Update der Firmware durchgeführt',
    },
    {
      'timestamp': '2025-08-03 18:12',
      'event': 'Verbindungsverlust – neu verbunden',
    },
    {
      'timestamp': '2025-08-03 07:45',
      'event': 'Wärmepumpe aktiviert (Timer)',
    },
    {
      'timestamp': '2025-08-02 22:11',
      'event': 'Störung behoben: Batteriekommunikation',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ereignisprotokoll')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: ereignisse.length,
        separatorBuilder: (_, __) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final eintrag = ereignisse[index];
          return ListTile(
            leading: const Icon(Icons.event_note),
            title: Text(eintrag['event']!),
            subtitle: Text(eintrag['timestamp']!),
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        },
      ),
    );
  }
}