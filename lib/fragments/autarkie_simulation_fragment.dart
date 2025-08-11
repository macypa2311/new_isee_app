import 'dart:async';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AutarkieSimulationFragment extends StatefulWidget {
  const AutarkieSimulationFragment({super.key});

  @override
  State<AutarkieSimulationFragment> createState() =>
      _AutarkieSimulationFragmentState();
}

class _AutarkieSimulationFragmentState extends State<AutarkieSimulationFragment> {
  final _kwpCtrl = TextEditingController(text: '10');
  final _speicherCtrl = TextEditingController(text: '10');
  bool _isLoading = true;

  List<double> _lastprofil = []; // Verbrauch (relativ)
  List<double> _verbrauch = [];  // Verbrauch (absolut kWh)
  List<double> _erzeugung = [];  // PV-Ertrag (kWh)

  double _gesamtVerbrauch = 0;
  double _direktverbrauch = 0;
  double _einspeisung = 0;
  double _batterieLadung = 0;
  double _batterieEntladung = 0;
  double _netzbezug = 0;

  double _autarkie = 0;
  double _eva = 0; // Eigenverbrauchsanteil

  @override
  void initState() {
    super.initState();
    _ladeLastprofil();
  }

  Future<void> _ladeLastprofil() async {
    final raw = await rootBundle.loadString('assets/lastprofile/H0.csv');
    final data = const CsvToListConverter(fieldDelimiter: ';').convert(raw);
    final werte = <double>[];

    for (final row in data.skip(1)) {
      if (row.length >= 2 && row[1] is num) {
        werte.add(row[1].toDouble());
      }
    }

    setState(() {
      _lastprofil = werte;
      _isLoading = false;
    });
  }

  void _simuliere() {
    final kwp = double.tryParse(_kwpCtrl.text) ?? 0;
    final speicherKapazitaet = double.tryParse(_speicherCtrl.text) ?? 0;
    const ertragProKwp = 950; // kWh/kWp
    final jahresErtrag = kwp * ertragProKwp;

    final gesamtVerbrauch = 6500.0;
    final faktor = gesamtVerbrauch / _lastprofil.reduce((a, b) => a + b);
    _verbrauch = _lastprofil.map((v) => v * faktor).toList();

    _erzeugung = List.generate(
      8760,
      (i) => jahresErtrag / 8760,
    );

    double speicher = 0;
    double direkt = 0;
    double einspeisung = 0;
    double batterieLadung = 0;
    double batterieEntladung = 0;
    double netzbezug = 0;

    for (int i = 0; i < 8760; i++) {
      final erzeugt = _erzeugung[i];
      final verbraucht = _verbrauch[i];

      if (erzeugt >= verbraucht) {
        direkt += verbraucht;
        final ueberschuss = erzeugt - verbraucht;

        final ladung = (speicher + ueberschuss).clamp(0, speicherKapazitaet) - speicher;
        speicher += ladung;
        batterieLadung += ladung;

        final rest = ueberschuss - ladung;
        einspeisung += rest;
      } else {
        direkt += erzeugt;

        final fehlend = verbraucht - erzeugt;

        final entladung = fehlend.clamp(0, speicher);
        speicher -= entladung;
        batterieEntladung += entladung;

        final netz = fehlend - entladung;
        netzbezug += netz;
      }
    }

    final autarkie = 100 * (direkt + batterieEntladung) / gesamtVerbrauch;
    final eva = 100 * (direkt + batterieEntladung) / jahresErtrag;

    setState(() {
      _gesamtVerbrauch = gesamtVerbrauch;
      _direktverbrauch = direkt;
      _einspeisung = einspeisung;
      _batterieLadung = batterieLadung;
      _batterieEntladung = batterieEntladung;
      _netzbezug = netzbezug;
      _autarkie = autarkie;
      _eva = eva;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autarkie-Simulation (HTW-Logik)')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _kwpCtrl,
                    decoration: const InputDecoration(labelText: 'PV-Leistung [kWp]'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _speicherCtrl,
                    decoration: const InputDecoration(labelText: 'Speicher [kWh]'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _simuliere,
                    child: const Text('Simulation starten'),
                  ),
                  const SizedBox(height: 24),
                  if (_autarkie > 0) ...[
                    Text('Autarkiegrad: ${_autarkie.toStringAsFixed(1)} %'),
                    Text('Eigenverbrauchsanteil: ${_eva.toStringAsFixed(1)} %'),
                    Text('Netzbezug: ${_netzbezug.toStringAsFixed(0)} kWh'),
                    Text('Direktverbrauch: ${_direktverbrauch.toStringAsFixed(0)} kWh'),
                    Text('Batterieentladung: ${_batterieEntladung.toStringAsFixed(0)} kWh'),
                    Text('Einspeisung: ${_einspeisung.toStringAsFixed(0)} kWh'),
                  ]
                ],
              ),
            ),
    );
  }
}