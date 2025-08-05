// lib/fragments/wirtschaftlichkeitsrechner_fragment.dart

import 'package:flutter/material.dart';

class WirtschaftlichkeitsrechnerFragment extends StatefulWidget {
  const WirtschaftlichkeitsrechnerFragment({Key? key}) : super(key: key);

  @override
  _WirtschaftlichkeitsrechnerFragmentState createState() =>
      _WirtschaftlichkeitsrechnerFragmentState();
}

class _WirtschaftlichkeitsrechnerFragmentState
    extends State<WirtschaftlichkeitsrechnerFragment> {
  final _formKey = GlobalKey<FormState>();

  // Annahmen-Controller
  final _pvKostenCtrl = TextEditingController(text: '1100');        // €/kWp
  final _speicherKostenCtrl = TextEditingController(text: '600');   // €/kWh
  final _montageCtrl = TextEditingController(text: '1500');         // pauschal €
  final _kapitalanteilCtrl = TextEditingController(text: '30');     // %
  final _zinsCtrl = TextEditingController(text: '2.5');             // % p.a.
  final _laufzeitCtrl = TextEditingController(text: '10');         // Jahre
  final _ertragCtrl = TextEditingController(text: '900');          // kWh/kWp
  final _degradationCtrl = TextEditingController(text: '0.5');     // % p.a.
  final _evQuoteCtrl = TextEditingController(text: '30');          // % ohne Speicher
  final _inflationCtrl = TextEditingController(text: '2');         // % p.a.
  final _einspeiseVergCtrl = TextEditingController(text: '0.08');  // €/kWh
  final _wartungCtrl = TextEditingController(text: '10');          // €/kWp·a
  final _battIntervallCtrl = TextEditingController(text: '10');    // Jahre
  final _battWechselCtrl = TextEditingController(text: '400');     // €/kWh

  // Ergebnisse
  double _npv = 0;
  double _irr = 0;
  double _payback = 0;
  double _discountedPayback = 0;
  double _lcoe = 0;

  @override
  void dispose() {
    for (final c in [
      _pvKostenCtrl,
      _speicherKostenCtrl,
      _montageCtrl,
      _kapitalanteilCtrl,
      _zinsCtrl,
      _laufzeitCtrl,
      _ertragCtrl,
      _degradationCtrl,
      _evQuoteCtrl,
      _inflationCtrl,
      _einspeiseVergCtrl,
      _wartungCtrl,
      _battIntervallCtrl,
      _battWechselCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _berechneWirtschaftlichkeit() {
    // Hier würdest du alle Werte in deine NPV/IRR-Formeln geben.
    // Fürs Demo rechnen wir mit Dummy-Formeln:
    final pvKosten = double.tryParse(_pvKostenCtrl.text) ?? 0;
    final speicherKosten = double.tryParse(_speicherKostenCtrl.text) ?? 0;
    final montage = double.tryParse(_montageCtrl.text) ?? 0;
    final kapAnteil = (double.tryParse(_kapitalanteilCtrl.text) ?? 0) / 100;
    final zinssatz = (double.tryParse(_zinsCtrl.text) ?? 0) / 100;
    final laufzeit = double.tryParse(_laufzeitCtrl.text) ?? 0;
    final ertrag = double.tryParse(_ertragCtrl.text) ?? 0;
    final deg = (double.tryParse(_degradationCtrl.text) ?? 0) / 100;
    final evQuote = (double.tryParse(_evQuoteCtrl.text) ?? 0) / 100;
    final infl = (double.tryParse(_inflationCtrl.text) ?? 0) / 100;
    final einspeise = double.tryParse(_einspeiseVergCtrl.text) ?? 0;
    final wartung = double.tryParse(_wartungCtrl.text) ?? 0;
    final battInt = double.tryParse(_battIntervallCtrl.text) ?? 0;
    final battWechsel = double.tryParse(_battWechselCtrl.text) ?? 0;

    // Dummy-Rechnungen
    setState(() {
      _npv = (pvKosten + speicherKosten * 10 + montage) * (1 - kapAnteil) * 0.2;
      _irr = zinssatz + 0.03;
      _payback = 1 / (evQuote * ertrag * einspeise) * 1000;
      _discountedPayback = _payback * (1 + zinssatz / 10);
      _lcoe = (pvKosten + speicherKosten * 10 + montage) /
          (ertrag * 10 * laufzeit);
    });
  }

  Widget _buildInputField(String label, TextEditingController ctrl,
      {String suffix = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Pflichtfeld' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wirtschaftlichkeitsrechner'),
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
              const Text('1. Annahmen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              _buildInputField('PV-Kosten (€/kWp)', _pvKostenCtrl, suffix: '€/kWp'),
              _buildInputField('Speicherkosten (€/kWh)', _speicherKostenCtrl, suffix: '€/kWh'),
              _buildInputField('Montagepauschale (€)', _montageCtrl, suffix: '€'),
              _buildInputField('Eigenkapitalanteil (%)', _kapitalanteilCtrl, suffix: '%'),
              _buildInputField('Fremdkapitalzins (%)', _zinsCtrl, suffix: '%'),
              _buildInputField('Laufzeit (Jahre)', _laufzeitCtrl, suffix: 'J'),
              _buildInputField('Jahresertrag (kWh/kWp)', _ertragCtrl, suffix: 'kWh/kWp'),
              _buildInputField('Degradation (% p.a.)', _degradationCtrl, suffix: '%'),
              _buildInputField('EV-Quote ohne Speicher (%)', _evQuoteCtrl, suffix: '%'),
              _buildInputField('Inflationsannahme (% p.a.)', _inflationCtrl, suffix: '%'),
              _buildInputField('Einspeisevergütung (€/kWh)', _einspeiseVergCtrl, suffix: '€/kWh'),
              _buildInputField('Wartung (€/kWp·a)', _wartungCtrl, suffix: '€/kWp·a'),
              _buildInputField('Batterie-Wechselintervall (Jahre)', _battIntervallCtrl, suffix: 'J'),
              _buildInputField('Batterie-Wechselkosten (€/kWh)', _battWechselCtrl, suffix: '€/kWh'),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _berechneWirtschaftlichkeit();
                  }
                },
                child: const Text('Berechnen'),
              ),

              const SizedBox(height: 24),
              const Text('2. Kennzahlen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text('Kapitalwert (NPV)'),
                  trailing: Text('${_npv.toStringAsFixed(0)} €'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text('Interner Zinsfuß (IRR)'),
                  trailing: Text('${_irr.toStringAsFixed(2)} %'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Payback'),
                  trailing: Text('${_payback.toStringAsFixed(1)} Jahre'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.timeline),
                  title: const Text('Discounted Payback'),
                  trailing: Text('${_discountedPayback.toStringAsFixed(1)} Jahre'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.electrical_services),
                  title: const Text('LCOE'),
                  trailing: Text('${_lcoe.toStringAsFixed(3)} €/kWh'),
                ),
              ),

              const SizedBox(height: 24),
              ExpansionTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Details zur Berechnung'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '• NPV: Gegenwartswert aller Ein- und Auszahlungen\n'
                      '• IRR: interne Rendite des Projekts\n'
                      '• Payback: statische Amortisationsdauer\n'
                      '• Discounted Payback: Amortisation mit Zinssatz\n'
                      '• LCOE: Lebenszykluskosten pro kWh\n\n'
                      'Formeln und Annahmen basieren auf Ihren Eingaben oben.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(child: Text('Cashflow-Chart (coming soon)')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}