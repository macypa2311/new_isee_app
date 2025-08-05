// lib/fragments/standortanalyse_fragment.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class StandortanalyseFragment extends StatefulWidget {
  const StandortanalyseFragment({Key? key}) : super(key: key);

  @override
  _StandortanalyseFragmentState createState() =>
      _StandortanalyseFragmentState();
}

class _StandortanalyseFragmentState extends State<StandortanalyseFragment> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  LatLng? _location;
  double? _annualIrradiance;        // kWh/m²
  List<double>? _monthlyIrradiance; // 12 Werte
  GoogleMapController? _mapController;
  bool _isLoading = false;
  String? _error;
  bool _shouldZoom = false;        // Merker für Zoom

  Future<void> _analyzeLocation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _location = null;
      _annualIrradiance = null;
      _monthlyIrradiance = null;
      _shouldZoom = false;
    });

    try {
      // 1) Geocoding
      final places = await locationFromAddress(_addressController.text);
      if (places.isEmpty) throw 'Adresse nicht gefunden';
      final loc = places.first;
      _location = LatLng(loc.latitude, loc.longitude);

      // 2) Jahressolarstrahlung (Dummy)
      final base = 1000.0 + (loc.latitude % 5) * 10;
      _annualIrradiance = base;

      // 3) Dummy Monatswerte (sinusförmig um den Jahresmittelwert)
      _monthlyIrradiance = List.generate(12, (i) {
        final angle = (i / 12) * 2 * math.pi;
        return base * (0.75 + 0.25 * (1 + math.sin(angle)));
      });

      // Sobald die Location da ist, Zoom später ausführen:
      _shouldZoom = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Standortanalyse'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle:
            const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputRow(),
                    if (_error != null) _buildErrorText(),
                    _buildMapSection(constraints.maxHeight * 0.4),
                    if (_annualIrradiance != null) _buildResultsSection(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow() => Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse oder Ort',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Bitte Adresse eingeben' : null,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _analyzeLocation,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Analysieren'),
              ),
            ],
          ),
        ),
      );

  Widget _buildErrorText() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );

  Widget _buildMapSection(double height) {
    return Expanded(
      flex: 2,
      child: _location == null
          ? Center(
              child: Text(
                _isLoading
                    ? 'Standort wird ermittelt…'
                    : 'Geben Sie eine Adresse ein und tippen auf „Analysieren“',
                style: const TextStyle(color: Colors.grey),
              ),
            )
          : SizedBox(
              height: height,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _location!, zoom: 12),
                markers: {
                  Marker(markerId: const MarkerId('loc'), position: _location!)
                },
                onMapCreated: (controller) {
                  _mapController = controller;
                  // Falls wir nach Analyse zoomen sollen, jetzt ausführen:
                  if (_shouldZoom && _location != null) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(_location!, 12),
                    );
                    _shouldZoom = false;
                  }
                },
              ),
            ),
    );
  }

  Widget _buildResultsSection() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Jahressolarstrahlung',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Text(
                    '${_annualIrradiance!.toStringAsFixed(0)} kWh/m²',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: BarChart(_buildBarChartData()),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monatliche Verteilung der Globalstrahlung (kWh/m²).',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(),
        topTitles: AxisTitles(),
        rightTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const m = ['J','F','M','A','M','J','J','A','S','O','N','D'];
              return Text(m[value.toInt()]);
            },
          ),
        ),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: _monthlyIrradiance!
          .asMap()
          .entries
          .map((e) => BarChartGroupData(
                x: e.key,
                barRods: [BarChartRodData(toY: e.value, width: 12)],
              ))
          .toList(),
    );
  }
}