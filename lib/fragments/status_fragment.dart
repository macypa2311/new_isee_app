import 'package:flutter/material.dart';

class StatusFragment extends StatelessWidget {
  const StatusFragment({super.key});

  final Map<String, String> statusDaten = const {
    'PV-Leistung': '6.300 W',
    'Batterie': 'Ladezustand 82%',
    'Haushaltsverbrauch': '3.200 W',
    'Netzbezug': '0 W',
    'Netzeinspeisung': '3.100 W',
    'Temperatur WR': '45 °C',
    'Wärmepumpe': 'aktiv (1.800 W)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Systemstatus')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: statusDaten.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final key = statusDaten.keys.elementAt(index);
          final value = statusDaten[key]!;
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(key, style: Theme.of(context).textTheme.bodyLarge),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}