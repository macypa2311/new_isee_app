import 'package:flutter/material.dart';

class PvErtragFragment extends StatefulWidget {
  const PvErtragFragment({super.key});

  @override
  State<PvErtragFragment> createState() => _PvErtragFragmentState();
}

class _PvErtragFragmentState extends State<PvErtragFragment> {
  final _kwpCtrl = TextEditingController();
  final _speicherCtrl = TextEditingController();

  @override
  void dispose() {
    _kwpCtrl.dispose();
    _speicherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Material sorgt dafür, dass TextField, ElevatedButton etc. funktionieren
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'PV-Ertrag berechnen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _kwpCtrl,
              decoration: const InputDecoration(
                labelText: 'Anlagen-Leistung (kWp)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _speicherCtrl,
              decoration: const InputDecoration(
                labelText: 'Speichergröße (kWh)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final kwp = double.tryParse(_kwpCtrl.text) ?? 0;
                final speicher = double.tryParse(_speicherCtrl.text) ?? 0;
                // TODO: hier deine Logik einbauen
                final ertrag = kwp * 900; // z.B. 900 kWh pro kWp
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Erwarteter Jahresertrag: ${ertrag.toStringAsFixed(0)} kWh\n'
                      'Speicher: ${speicher.toStringAsFixed(0)} kWh',
                    ),
                  ),
                );
              },
              child: const Text('Berechnen'),
            ),
          ],
        ),
      ),
    );
  }
}