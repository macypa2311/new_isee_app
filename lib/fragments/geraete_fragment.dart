import 'package:flutter/material.dart';

class GeraeteFragment extends StatelessWidget {
  const GeraeteFragment({super.key});

  final List<Map<String, String>> geraete = const [
    {
      'name': 'Fronius Symo 10.0-3-M',
      'typ': 'Wechselrichter',
      'status': 'Online',
    },
    {
      'name': 'BYD Battery-Box Premium HVS',
      'typ': 'Batteriespeicher',
      'status': 'Ladezustand: 78%',
    },
    {
      'name': 'Kostal Smart Meter',
      'typ': 'Zähler',
      'status': 'Aktiv',
    },
    {
      'name': 'Wolf Wärmepumpe CHA-Monoblock',
      'typ': 'Wärmepumpe',
      'status': 'Heizt aktuell',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geräte')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: geraete.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = geraete[index];
          return ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: const Icon(Icons.devices_other),
            title: Text(item['name'] ?? ''),
            subtitle: Text('${item['typ']} – ${item['status']}'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              // Optional: Detailansicht oder weitere Aktionen
            },
          );
        },
      ),
    );
  }
}