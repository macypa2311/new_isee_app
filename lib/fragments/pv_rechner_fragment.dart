// lib/fragments/pv_rechner_fragment.dart

import 'package:flutter/material.dart';

class PvRechnerFragment extends StatefulWidget {
  const PvRechnerFragment({Key? key}) : super(key: key);

  @override
  _PvRechnerFragmentState createState() => _PvRechnerFragmentState();
}

class _PvRechnerFragmentState extends State<PvRechnerFragment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verbrauchController = TextEditingController();
  final TextEditingController _leistungController = TextEditingController();
  final TextEditingController _speicherController = TextEditingController();
  final TextEditingController _preisController = TextEditingController();

  double _ertrag = 0;
  double _amortisation = 0;
  double _speicherbedarf = 0;

  void _berechnePv() {
    final double verbrauch = double.tryParse(_verbrauchController.text) ?? 0;
    final double leistung = double.tryParse(_leistungController.text) ?? 0;
    final double speicher = double.tryParse(_speicherController.text) ?? 0;
    final double preis = double.tryParse(_preisController.text) ?? 0;

    // Platzhalter-Logik
    setState(() {
      _ertrag = leistung * 1000 * 0.9; // z.B. 0,9 kWh Ertrag pro kW Leistung
      _amortisation = (leistung * 1000 * 1.2) / (verbrauch * preis); // Beispielrechnung
      _speicherbedarf = speicher; // direkt übernommen
    });
  }

  @override
  void dispose() {
    _verbrauchController.dispose();
    _leistungController.dispose();
    _speicherController.dispose();
    _preisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PV-Rechner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Schnellberechnung zu Ertrag, Amortisation und Speicherbedarf.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _verbrauchController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stromverbrauch (kWh)',
                  hintText: 'z. B. 3500',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Verbrauch eingeben' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _leistungController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Installierte PV-Leistung (kW)',
                  hintText: 'z. B. 5',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Leistung eingeben' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _speicherController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Batteriespeicher (kWh)',
                  hintText: 'z. B. 10',
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _preisController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Strompreis (€/kWh)',
                  hintText: 'z. B. 0.30',
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _berechnePv();
                  }
                },
                child: const Text('Berechnen'),
              ),
              const SizedBox(height: 32),

              Text('Jährlicher Ertrag: ${_ertrag.toStringAsFixed(1)} kWh'),
              const SizedBox(height: 8),
              Text('Amortisationsdauer: ${_amortisation.toStringAsFixed(1)} Jahre'),
              const SizedBox(height: 8),
              Text('Benötigter Speicher: ${_speicherbedarf.toStringAsFixed(1)} kWh'),
            ],
          ),
        ),
      ),
    );
  }
}