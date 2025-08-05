// lib/fragments/ertragssimulation_fragment.dart

import 'package:flutter/material.dart';

class ErtragssimulationFragment extends StatefulWidget {
  const ErtragssimulationFragment({Key? key}) : super(key: key);

  @override
  _ErtragssimulationFragmentState createState() =>
      _ErtragssimulationFragmentState();
}

class _ErtragssimulationFragmentState
    extends State<ErtragssimulationFragment> {
  final _formKey = GlobalKey<FormState>();
  final _pvLeistungCtrl = TextEditingController(text: '10'); // kWp
  final _neigungCtrl = TextEditingController(text: '30'); // °
  final _ausrichtungCtrl = TextEditingController(text: 'Süd'); // Himmelsrichtung
  final _standortCtrl = TextEditingController(text: 'Berlin'); // Ort

  double? _jahresErtrag;    // in kWh
  double? _monatErtrag;     // Durchschnitt pro Monat

  @override
  void dispose() {
    _pvLeistungCtrl.dispose();
    _neigungCtrl.dispose();
    _ausrichtungCtrl.dispose();
    _standortCtrl.dispose();
    super.dispose();
  }

  void _starteSimulation() {
    final pvLeistung = double.tryParse(_pvLeistungCtrl.text) ?? 0;
    final neigung = double.tryParse(_neigungCtrl.text) ?? 0;
    final ausrichtung = _ausrichtungCtrl.text;
    final standort = _standortCtrl.text;

    // Dummy-Berechnung basierend auf Faustwerten:
    // Jahresertrag ≈ pvLeistung × spezifischer Ertrag (900 kWh/kWp)
    // Anpassung: Neigung und Ausrichtung leicht berücksichtigen
    double basisErtrag = pvLeistung * 900;
    double faktorNeigung = (1 - ((neigung - 30).abs() / 90)).clamp(0.7, 1.0);
    double faktorAusrichtung =
        (ausrichtung.toLowerCase() == 'süd' ? 1.0 : 0.85).clamp(0.7, 1.0);

    final gesimErtrag = basisErtrag * faktorNeigung * faktorAusrichtung;

    setState(() {
      _jahresErtrag = gesimErtrag;
      _monatErtrag = gesimErtrag / 12;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ertragssimulation'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle:
            const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Simuliere den Jahresertrag deiner PV-Anlage.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _pvLeistungCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'PV-Leistung (kWp)',
                  hintText: 'z. B. 10',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Bitte Wert eingeben' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _neigungCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Modulneigung (°)',
                  hintText: 'z. B. 30',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Bitte Wert eingeben' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ausrichtungCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ausrichtung',
                  hintText: 'z. B. Süd, Ost-West',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _standortCtrl,
                decoration: const InputDecoration(
                  labelText: 'Standort (Ort)',
                  hintText: 'z. B. Berlin',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _starteSimulation();
                  }
                },
                child: const Text('Simulation starten'),
              ),

              const SizedBox(height: 32),

              if (_jahresErtrag != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.wb_sunny),
                    title: const Text('Simulierter Jahresertrag'),
                    trailing: Text('${_jahresErtrag!.toStringAsFixed(0)} kWh'),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_view_month),
                    title: const Text('Ø Ertrag pro Monat'),
                    trailing: Text('${_monatErtrag!.toStringAsFixed(0)} kWh'),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Hinweis:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Dies ist eine grobe Schätzung basierend auf Faustwerten. '
                  'Für eine genaue Simulation bitte Standortdaten und Wetterprofil verwenden.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],

              const SizedBox(height: 24),
              Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Center(child: Text('Ertragsverlauf-Chart (demnächst)')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}