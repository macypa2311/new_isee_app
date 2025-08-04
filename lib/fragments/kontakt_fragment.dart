import 'package:flutter/material.dart';

class KontaktFragment extends StatelessWidget {
  const KontaktFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final wechselrichter = [
      {
        'name': 'Sungrow',
        'phone': '+1‑833‑SGPOWER (747‑6937)',
        'email': 'techsupport@sungrow‑na.com',
      },
      {
        'name': 'Fronius',
        'phone': '877‑376‑6487',
        'email': 'pv‑sales‑usa@fronius.com',
      },
      {
        'name': 'SolarEdge',
        'phone': '+1 510 498 3200',
        'email': 'info@solaredge.com',
      },
      {
        'name': 'Kostal',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'EcoFlow',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Growatt',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'GoodWe',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Enphase',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Deye',
        'phone': '–',
        'email': '–',
      },
    ];

    final waermepumpen = [
      {
        'name': 'Viessmann',
        'phone': '+49 6452 70‑0',
        'email': 'info@viessmann.com',
      },
      {
        'name': 'Stiebel Eltron',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Bosch',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Weishaupt',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Nibe',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Alpha Innotec',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Panasonic',
        'phone': '–',
        'email': '–',
      },
      {
        'name': 'Wolf',
        'phone': '–',
        'email': '–',
      },
    ];

    Widget buildTile(Map<String, String> e, IconData icon) {
      return Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(e['name']!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (e['phone'] != null && e['phone'] != '–')
                Text('📞 ${e['phone']}'),
              if (e['email'] != null && e['email'] != '–')
                Text('✉️ ${e['email']}'),
            ],
          ),
          isThreeLine: true,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Herstellerkontakte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Wechselrichter-Hersteller',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...wechselrichter.map((e) => buildTile(e, Icons.electrical_services)),

          const SizedBox(height: 24),
          const Text('Wärmepumpen-Hersteller',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...waermepumpen.map((e) => buildTile(e, Icons.ac_unit)),
        ],
      ),
    );
  }
}