import 'package:flutter/material.dart';

class GeraeteFragment extends StatefulWidget {
  const GeraeteFragment({super.key});

  @override
  State<GeraeteFragment> createState() => _GeraeteFragmentState();
}

class _GeraeteFragmentState extends State<GeraeteFragment> {
  final List<Map<String, dynamic>> geraete = [
    {
      'name': 'Wechselrichter – Fronius Symo',
      'status': 'online',
      'seriennummer': 'FR-SYM-20348',
      'standort': 'Dachboden',
      'premium': true,
    },
    {
      'name': 'Batteriespeicher – BYD HVS',
      'status': 'offline',
      'seriennummer': 'BYD-HVS-12321',
      'standort': 'Technikraum',
      'premium': false,
    },
    {
      'name': 'Smart Meter – Kostal',
      'status': 'online',
      'seriennummer': 'KST-SM-8392',
      'standort': 'Zählerschrank',
      'premium': false,
    },
  ];

  String suchbegriff = '';

  @override
  Widget build(BuildContext context) {
    final gefilterteGeraete = geraete.where((g) {
      final lower = suchbegriff.toLowerCase();
      return g['name'].toLowerCase().contains(lower) ||
          g['seriennummer'].toLowerCase().contains(lower);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geräteverwaltung'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Gerät scannen',
            onPressed: () {
              // TODO: Scan-Funktion einfügen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR-Scan noch nicht verfügbar')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Geräte suchen...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (wert) => setState(() => suchbegriff = wert),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: gefilterteGeraete.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final g = gefilterteGeraete[index];
                final statusFarbe = g['status'] == 'online'
                    ? Colors.green
                    : Colors.redAccent;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    title: Text(g['name']),
                    subtitle: Text('Seriennummer: ${g['seriennummer']}\n'
                        'Standort: ${g['standort']}'),
                    leading: CircleAvatar(
                      backgroundColor: statusFarbe,
                      radius: 10,
                    ),
                    trailing: g['premium']
                        ? const Icon(Icons.star, color: Colors.amber)
                        : null,
                    onTap: () {
                      _zeigeDetails(context, g);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _zeigeDetails(BuildContext context, Map<String, dynamic> geraet) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(geraet['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${geraet['status']}'),
            Text('Seriennummer: ${geraet['seriennummer']}'),
            Text('Standort: ${geraet['standort']}'),
            const SizedBox(height: 12),
            if (geraet['premium']) ...[
              const Divider(),
              const Text('⚡ Premium-Funktionen:'),
              const SizedBox(height: 6),
              TextButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Firmware-Update'),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Update gestartet...')),
                  );
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.support_agent),
                label: const Text('Fernwartung anfordern'),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Support wird kontaktiert...')),
                  );
                },
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}