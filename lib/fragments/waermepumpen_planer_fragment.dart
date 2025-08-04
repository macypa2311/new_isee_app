import 'package:flutter/material.dart';

class WaermepumpenPlanerFragment extends StatefulWidget {
  const WaermepumpenPlanerFragment({Key? key}) : super(key: key);

  @override
  _WaermepumpenPlanerFragmentState createState() => _WaermepumpenPlanerFragmentState();
}

class _WaermepumpenPlanerFragmentState extends State<WaermepumpenPlanerFragment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _baujahrController = TextEditingController();
  final TextEditingController _effizienzController = TextEditingController();
  final TextEditingController _stromverbrauchController = TextEditingController();

  double _empfohleneLeistung = 0;
  double _amortisation = 0;
  double _co2Einsparung = 0;

  // Beispiel: Effizienzabschaetzung aus Baujahr
  void _schaetzeEffizienz() {
    final int baujahr = int.tryParse(_baujahrController.text) ?? DateTime.now().year;
    double eff;
    if (baujahr < 1970) {
      eff = 0.5;
    } else if (baujahr < 2000) {
      eff = 0.7;
    } else {
      eff = 0.9;
    }
    _effizienzController.text = (eff * 100).toStringAsFixed(0);
  }

  void _berechneWaermepumpe() {
    final double effizienz = double.tryParse(_effizienzController.text) ?? 0;
    final double strom = double.tryParse(_stromverbrauchController.text) ?? 0;

    // Platzhalter-Logik
    setState(() {
      _empfohleneLeistung = strom / 1000 * (1 / (effizienz / 100));
      _amortisation = _empfohleneLeistung * 1000 / 500; // z.B. Investkosten / Einsparung
      _co2Einsparung = strom * 0.2; // t CO2 pro Jahr
    });
  }

  @override
  void dispose() {
    _baujahrController.dispose();
    _effizienzController.dispose();
    _stromverbrauchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waermepumpenplaner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Schaetze deine passende WP-Leistung und Wirtschaftlichkeit ab.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Baujahr
              TextFormField(
                controller: _baujahrController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Gebaeudealter (Baujahr)',
                  hintText: 'z. B. 1990',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Bitte Baujahr eingeben' : null,
              ),
              const SizedBox(height: 12),

              // Effizienz
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _effizienzController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Energieeffizienz (%)',
                        hintText: 'z. B. 70',
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Bitte Effizienz angeben' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _schaetzeEffizienz,
                    child: const Text('Schaetzen'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stromverbrauch
              TextFormField(
                controller: _stromverbrauchController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stromverbrauch (kWh)',
                  hintText: 'z. B. 4000',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Stromverbrauch angeben' : null,
              ),
              const SizedBox(height: 24),

              // Berechnen-Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _berechneWaermepumpe();
                  }
                },
                child: const Text('Berechnen'),
              ),
              const SizedBox(height: 32),

              // Ergebnisanzeige
              Text('Empfohlene WP-Leistung: ${_empfohleneLeistung.toStringAsFixed(2)} kW'),
              const SizedBox(height: 8),
              Text('Amortisation: ${_amortisation.toStringAsFixed(1)} Jahre'),
              const SizedBox(height: 8),
              Text('CO2-Einsparung: ${_co2Einsparung.toStringAsFixed(2)} t/Jahr'),
            ],
          ),
        ),
      ),
    );
  }
}