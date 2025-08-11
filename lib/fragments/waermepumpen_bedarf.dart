// lib/fragments/waermepumpenbedarf_fragment.dart
import 'package:flutter/material.dart';

class WaermepumpenbedarfFragment extends StatefulWidget {
  const WaermepumpenbedarfFragment({super.key});
  @override
  State<WaermepumpenbedarfFragment> createState() => _WaermepumpenbedarfFragmentState();
}

class _WaermepumpenbedarfFragmentState extends State<WaermepumpenbedarfFragment> {
  // TextController für Wohnfläche, Personen, Baujahr etc.
  // Berechnungs-Logik COP, spezif. Bedarf
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Eingabefelder...
          // „Berechnen“-Button
          // Ergebnis-Anzeige „kWh/Jahr WP-Bedarf“
        ],
      ),
    );
  }
}