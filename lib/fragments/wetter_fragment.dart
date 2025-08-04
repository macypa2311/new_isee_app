import 'package:flutter/material.dart';

class WetterFragment extends StatelessWidget {
  const WetterFragment({super.key});

  // Beispielhafte Wetterdaten (später via API ersetzbar)
  final Map<String, dynamic> wetterDaten = const {
    'standort': 'München, DE',
    'temperatur': '24°C',
    'zustand': 'Sonnig',
    'luftfeuchtigkeit': '48%',
    'wind': '12 km/h',
    'symbol': Icons.wb_sunny,
    'aktualisiert': '04.08.2025 – 14:45 Uhr'
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Wetter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(wetterDaten['symbol'], size: 48, color: colorScheme.primary),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wetterDaten['temperatur'],
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              wetterDaten['zustand'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoTile('Luftfeuchtigkeit', wetterDaten['luftfeuchtigkeit']),
                        _infoTile('Wind', wetterDaten['wind']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Standort: ${wetterDaten['standort']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Aktualisiert: ${wetterDaten['aktualisiert']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Wetterdaten aktualisieren per API
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Aktualisieren'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}