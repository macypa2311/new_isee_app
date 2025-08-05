// lib/fragments/speicherplanungs_fragment.dart

import 'package:flutter/material.dart';

class SpeicherplanungsFragment extends StatefulWidget {
  const SpeicherplanungsFragment({Key? key}) : super(key: key);

  @override
  _SpeicherplanungsFragmentState createState() =>
      _SpeicherplanungsFragmentState();
}

class _SpeicherplanungsFragmentState extends State<SpeicherplanungsFragment> {
  final _formKey = GlobalKey<FormState>();
  final _pvLeistungCtrl = TextEditingController();
  final _verbrauchCtrl = TextEditingController();
  final _basisQuoteCtrl = TextEditingController(text: '30'); // in %
  final _zielAutarkieCtrl = TextEditingController(text: '80'); // in %
  double? _empfohleneSpeichergroesse;
  double? _autarkieGrad;

  @override
  void dispose() {
    _pvLeistungCtrl.dispose();
    _verbrauchCtrl.dispose();
    _basisQuoteCtrl.dispose();
    _zielAutarkieCtrl.dispose();
    super.dispose();
  }

  void _berechneSpeicherbedarf() {
    final double pvLeistung = double.tryParse(_pvLeistungCtrl.text) ?? 0;
    final double verbrauch = double.tryParse(_verbrauchCtrl.text) ?? 0;
    final double basisQuote = (double.tryParse(_basisQuoteCtrl.text) ?? 0) / 100;
    final double zielQuote = (double.tryParse(_zielAutarkieCtrl.text) ?? 0) / 100;

    // Jahresproduktion
    final double jahresErtrag = pvLeistung * 900;

    // Jahresüberschuss, den man puffern möchte
    final double zielDiff = (zielQuote - basisQuote).clamp(0.0, 1.0);
    final double speicherbedarf = jahresErtrag * zielDiff;

    // Realistischer Autarkiegewinn (angenommene Speicherwirksamkeit 90%)
    final double zusaetzlicherEigen =
        jahresErtrag * basisQuote + jahresErtrag * zielDiff * 0.9;
    final double autarkie = (zusaetzlicherEigen / jahresErtrag) * 100;

    setState(() {
      _empfohleneSpeichergroesse = speicherbedarf;
      _autarkieGrad = autarkie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speicherplanung'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Planen Sie Ihren Batteriespeicher für eine gewünschte Autarkie.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // PV-Leistung
              TextFormField(
                controller: _pvLeistungCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Installierte PV-Leistung (kWp)',
                  hintText: 'z.B. 10',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte PV-Leistung eingeben' : null,
              ),
              const SizedBox(height: 12),

              // Jahresverbrauch
              TextFormField(
                controller: _verbrauchCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Jahresstromverbrauch (kWh)',
                  hintText: 'z.B. 6000',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Verbrauch eingeben' : null,
              ),
              const SizedBox(height: 12),

              // Basis-Eigenverbrauchsquote
              TextFormField(
                controller: _basisQuoteCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Basis-Eigenverbrauchsquote (%)',
                  hintText: 'z.B. 30',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Quote eingeben' : null,
              ),
              const SizedBox(height: 12),

              // Ziel-Autarkie
              TextFormField(
                controller: _zielAutarkieCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Ziel-Autarkie (%)',
                  hintText: 'z.B. 80',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Bitte Zielquote eingeben' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _berechneSpeicherbedarf();
                  }
                },
                child: const Text('Berechnen'),
              ),

              const SizedBox(height: 32),

              if (_empfohleneSpeichergroesse != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Empfohlene Speicherkapazität'),
                    trailing: Text(
                      '${_empfohleneSpeichergroesse!.toStringAsFixed(1)} kWh',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.autorenew),
                    title: const Text('Erwarteter Autarkiegrad'),
                    trailing:
                        Text('${_autarkieGrad!.toStringAsFixed(1)} %'),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              ExpansionTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Details zur Berechnung'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '• Jahresproduktion = PV-Leistung × 900 kWh/kWp\n'
                      '• Basis-Eigenverbrauch ohne Speicher = Quote × Jahresproduktion\n'
                      '• Ziel-Autarkie = gewünschte Quote\n'
                      '• Zusätzliche Speicherung = (Zielquote – Basisquote) × Jahresproduktion\n'
                      '• Wirksamkeit (90%) berücksichtigt Lade-/Wirkungsgrad\n'
                      '• Empfohlene Kapazität = zusätzliche Speicherung\n'
                      '• Autarkiegrad mit Speicher = (Basis + 0.9×Zusatz)×100 %',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Chart-Platzhalter
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(child: Text('Verlaufsdiagramm (demnächst)')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}