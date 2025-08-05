import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class PvDefaultParameter {
  final String label;
  double value;
  final String unit;
  final String description;

  PvDefaultParameter({
    required this.label,
    required this.value,
    required this.unit,
    required this.description,
  });

  factory PvDefaultParameter.fromJson(Map<String, dynamic> json) {
    return PvDefaultParameter(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      description: json['description'] as String,
    );
  }
}

/// Lädt die PV-Defaults aus dem Asset und gibt sie als Map zurück
Future<Map<String, PvDefaultParameter>> loadPvDefaults() async {
  final String jsonStr =
      await rootBundle.loadString('assets/default-parameters.json');
  final Map<String, dynamic> data = json.decode(jsonStr);
  return data.map((key, val) =>
      MapEntry(key, PvDefaultParameter.fromJson(val as Map<String, dynamic>)));
}