// lib/fragments/pv_rechner_fragment.dart

import 'package:flutter/material.dart';
import '../services/pv_defaults_service.dart';

class PvRechnerFragment extends StatefulWidget {
  const PvRechnerFragment({Key? key}) : super(key: key);

  @override
  _PvRechnerFragmentState createState() => _PvRechnerFragmentState();
}

class _PvRechnerFragmentState extends State<PvRechnerFragment> {
  final _formKey = GlobalKey<FormState>();
  final _verbrauchController = TextEditingController();
  final _leistungController = TextEditingController();
  final _speicherController = TextEditingController();

  late Future<Map<String, PvDefaultParameter>> _defaultsFuture;
  Map<String, PvDefaultParameter>? _defaults;
  final Map<String, TextEditingController> _defaultControllers = {};

  double _ertrag = 0;
  double _amortisation = 0;
  double _jahresUeberschuss = 0;
  double _taeglicherBedarf = 0;

  @override
  void initState() {
    super.initState();
    _defaultsFuture = loadPvDefaults();
  }

  @override
  void dispose() {
    _verbrauchController.dispose();
    _leistungController.dispose();
    _speicherController.dispose();
    _defaultControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  void _berechnePv() {
    final verbrauch = double.tryParse(_verbrauchController.text) ?? 0;
    final leistung = double.tryParse(_leistungController.text) ?? 0;
    final eingabeSpeicher = double.tryParse(_speicherController.text) ?? 0;

    final dp = _defaults!;
    final spezifischerErtrag = dp['specific_yield']!.value;
    final stromPreis = dp['electricity_price']!.value;
    final einspeiseVerguetung = dp['feed_in_tariff']!.value;
    final pvKosten = dp['pv_cost_per_kWp']!.value;
    final speicherKosten = dp['storage_cost_per_kWh']!.value;

    setState(() {
      // 1) Jahresertrag
      _ertrag = leistung * spezifischerErtrag;

      // 2) Jahresüberschuss (optimale Jahres-Speicherkapazität)
      _jahresUeberschuss = (_ertrag - verbrauch).clamp(0, _ertrag);

      // 3) Täglicher Speicherbedarf
      _taeglicherBedarf = _jahresUeberschuss / 365.0;

      // 4) Ersparnisse berechnen
      final maxEigen = verbrauch;
      final einspeisung = _jahresUeberschuss;
      final ersparnisEigen = maxEigen * stromPreis;
      final verguetung = einspeisung * einspeiseVerguetung;
      final gesamtErsparnis = ersparnisEigen + verguetung;

      // 5) Investitionskosten & Amortisation
      final invest = leistung * pvKosten + eingabeSpeicher * speicherKosten;
      _amortisation =
          gesamtErsparnis > 0 ? invest / gesamtErsparnis : double.infinity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PV-Rechner'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: FutureBuilder<Map<String, PvDefaultParameter>>(
        future: _defaultsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Fehler beim Laden der Parameter',
                style: TextStyle(color: Colors.red.shade700),
              ),
            );
          }

          _defaults = snapshot.data!;
          if (_defaultControllers.isEmpty) {
            _defaults!.forEach((key, param) {
              _defaultControllers[key] =
                  TextEditingController(text: param.value.toString());
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    'Schnellberechnung zu Ertrag, Amortisation und Speicherbedarf.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Editierbare Assumptions-Box
                  ..._defaults!.entries.map((e) {
                    final key = e.key;
                    final param = e.value;
                    final ctrl = _defaultControllers[key]!;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              param.label,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: ctrl,
                              textAlign: TextAlign.right,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                suffixText: param.unit,
                                border: const OutlineInputBorder(),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                              ),
                              onFieldSubmitted: (val) {
                                final newVal = double.tryParse(val) ?? param.value;
                                setState(() {
                                  param.value = newVal;
                                  ctrl.text = newVal.toStringAsFixed(2);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const Divider(height: 32),

                  // User-Inputs
                  TextFormField(
                    controller: _verbrauchController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stromverbrauch (kWh)',
                      hintText: 'z. B. 6000',
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Bitte Verbrauch eingeben' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _leistungController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Installierte PV-Leistung (kWp)',
                      hintText: 'z. B. 10',
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Bitte Leistung eingeben' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _speicherController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ihr Batteriespeicher (kWh)',
                      hintText: 'z. B. 10',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Berechnen-Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _berechnePv();
                      }
                    },
                    child: const Text('Berechnen'),
                  ),

                  const SizedBox(height: 32),

                  // Ergebnis-Widgets
                  Text('Jährlicher Ertrag: ${_ertrag.toStringAsFixed(1)} kWh'),
                  const SizedBox(height: 8),
                  Text(
                    'Amortisationsdauer: ${_amortisation.isFinite ? _amortisation.toStringAsFixed(1) : '∞'} Jahre',
                  ),
                  const SizedBox(height: 8),
                  Text('Ihr eingegebener Speicher: ${double.tryParse(_speicherController.text)?.toStringAsFixed(1) ?? '–'} kWh'),
                  const SizedBox(height: 4),
                  Text('Optimale Jahres-Speicherkapazität: ${_jahresUeberschuss.toStringAsFixed(1)} kWh'),
                  const SizedBox(height: 4),
                  Text('Täglicher Speicherbedarf: ${_taeglicherBedarf.toStringAsFixed(1)} kWh/Tag'),

                  const SizedBox(height: 24),

                  // Info-Panel
                  ExpansionTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Wie rechnen wir?'),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '• Jahresproduktion = Leistung × spezifischer Ertrag\n'
                          '  (z. B. 10 kWp × 900 kWh/kWp = 9 000 kWh)\n'
                          '• Max. Eigenverbrauch = Ihr Jahresverbrauch\n'
                          '• Einspeisung = Jahresproduktion − Eigenverbrauch\n'
                          '• Ersparnis Eigenverbrauch = Eigenverbrauch × Strompreis\n'
                          '• Vergütung Einspeisung = Einspeisung × Einspeisevergütung\n'
                          '• Amortisation = Investitionskosten ÷ (Ersparnis + Vergütung)\n\n'
                          'Optimale Jahres-Speicherkapazität ist die Gesamtenergie, '
                          'die Sie speichern müssten, um 100 % Autarkie zu erreichen.\n'
                          'Täglicher Speicherbedarf = Jahresüberschuss / 365.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}