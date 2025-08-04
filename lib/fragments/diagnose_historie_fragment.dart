import 'package:flutter/material.dart';

class DiagnoseHistorieFragment extends StatelessWidget {
  const DiagnoseHistorieFragment({super.key});

  final List<Map<String, String>> diagnoseListe = const [
    {
      'datum': '04.08.2025',
      'geraet': 'Fronius Symo 10.0',
      'fehler': 'State 567: Übertemperatur',
    },
    {
      'datum': '03.08.2025',
      'geraet': 'Sungrow SH5K',
      'fehler': 'Fehler 108: Isolation prüfen',
    },
    {
      'datum': '01.08.2025',
      'geraet': 'Kostal Plenticore',
      'fehler': 'Keine Kommunikation mit Batterie',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnose-Historie')),
      body: diagnoseListe.isEmpty
          ? const Center(child: Text('Noch keine Diagnosen gespeichert.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: diagnoseListe.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final eintrag = diagnoseListe[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    title: Text(eintrag['geraet'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eintrag['fehler'] ?? '', style: const TextStyle(height: 1.2)),
                        const SizedBox(height: 4),
                        Text('Datum: ${eintrag['datum']}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Später: Details oder PDF-Vorschau
                    },
                  ),
                );
              },
            ),
    );
  }
}