import 'package:flutter/material.dart';

class UnabhaengigkeitsFragment extends StatefulWidget {
  const UnabhaengigkeitsFragment({Key? key}) : super(key: key);

  @override
  _UnabhaengigkeitsFragmentState createState() => _UnabhaengigkeitsFragmentState();
}

class _UnabhaengigkeitsFragmentState extends State<UnabhaengigkeitsFragment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stromverbrauchController = TextEditingController();
  final TextEditingController _pvLeistungController = TextEditingController();
  final TextEditingController _speicherController = TextEditingController();
  final TextEditingController _plzController = TextEditingController();

  double _autarkiegrad = 0;
  double _eigenverbrauch = 0;

  void _berechneAutarkie() {
    final double strom = double.tryParse(_stromverbrauchController.text) ?? 0;
    final double pvLeistung = double.tryParse(_pvLeistungController.text) ?? 0;
    final double speicher = double.tryParse(_speicherController.text) ?? 0;
    // TODO: Hier kommt deine Berechnungs-Logik hin.
    setState(() {
      _autarkiegrad = (pvLeistung * 1000 + speicher) / (strom == 0 ? 1 : strom) * 10;
      _eigenverbrauch = _autarkiegrad * 0.8; // Platzhalter-Wert
    });
  }

  @override
  void dispose() {
    _stromverbrauchController.dispose();
    _pvLeistungController.dispose();
    _speicherController.dispose();
    _plzController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unabhängigkeitsrechner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Berechne deinen Autarkiegrad und Eigenverbrauch.',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte gib deinen Jahresstromverbrauch an';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // PV-Leistung
              TextFormField(
                controller: _pvLeistungController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Photovoltaik-Leistung',
                  suffixText: 'kW',
                  hintText: 'z. B. 5',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte gib die PV-Leistung an';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Speicherkapazität
              TextFormField(
                controller: _speicherController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nutzbare Speicherkapazität',
                  suffixText: 'kWh',
                  hintText: 'z. B. 10',
                ),
              ),
              const SizedBox(height: 12),

              // Postleitzahl
              TextFormField(
                controller: _plzController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Postleitzahl',
                  hintText: 'z. B. 10115',
                ),
              ),
              const SizedBox(height: 24),

              // Berechnen-Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _berechneAutarkie();
                  }
                },
                child: const Text('Berechnen'),
              ),
              const SizedBox(height: 32),

              // Visualisierung als einfache Fortschrittsindikatoren
              Text('Autarkiegrad: ${_autarkiegrad.toStringAsFixed(1)} %'),
              LinearProgressIndicator(value: _autarkiegrad / 100),
              const SizedBox(height: 16),
              Text('Eigenverbrauch: ${_eigenverbrauch.toStringAsFixed(1)} %'),
              LinearProgressIndicator(value: _eigenverbrauch / 100),

              const SizedBox(height: 24),
              const Text(
                'Datenbasis: HTW Berlin Unabhängigkeitsrechner',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}