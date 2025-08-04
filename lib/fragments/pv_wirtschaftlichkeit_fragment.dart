import 'package:flutter/material.dart';

class PvWirtschaftlichkeitsFragment extends StatefulWidget {
  const PvWirtschaftlichkeitsFragment({Key? key}) : super(key: key);

  @override
  _PvWirtschaftlichkeitsFragmentState createState() => _PvWirtschaftlichkeitsFragmentState();
}

class _PvWirtschaftlichkeitsFragmentState extends State<PvWirtschaftlichkeitsFragment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stromverbrauchController = TextEditingController();

  double _investitionskosten = 0;
  double _amortisationsdauer = 0;
  double _einsparpotenzial = 0;

  void _berechneWirtschaftlichkeit() {
    final double strom = double.tryParse(_stromverbrauchController.text) ?? 0;

    // Platzhalter-Logik für Invest, Amortisation, Einsparung
    setState(() {
      _investitionskosten = strom * 0.8;      // z.B. 0,8 € pro kWh Verbrauch
      _amortisationsdauer = _investitionskosten / (strom * 0.2); // jährliche Ersparnis 0,2 €
      _einsparpotenzial = strom * 0.2;        // 0,2 €/kWh
    });
  }

  @override
  void dispose() {
    _stromverbrauchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PV-Wirtschaftlichkeits-Analyse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Ermittle Kosten, Amortisation und ROI für deine PV-Anlage.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Jahresstromverbrauch
              TextFormField(
                controller: _stromverbrauchController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jahresstromverbrauch',
                  suffixText: 'kWh',
                  hintText: 'z. B. 3500',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Stromverbrauch eingeben' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _berechneWirtschaftlichkeit();
                  }
                },
                child: const Text('Berechnen'),
              ),
              const SizedBox(height: 32),

              // Ergebnisanzeige
              Text('Investitionskosten: ${_investitionskosten.toStringAsFixed(2)} €'),
              const SizedBox(height: 8),
              Text('Amortisationsdauer: ${_amortisationsdauer.toStringAsFixed(1)} Jahre'),
              const SizedBox(height: 8),
              Text('Einsparpotenzial: ${_einsparpotenzial.toStringAsFixed(2)} € / Jahr'),
            ],
          ),
        ),
      ),
    );
  }
}