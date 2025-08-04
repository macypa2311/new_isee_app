import 'package:flutter/material.dart';

class SettingsImpressum extends StatelessWidget {
  const SettingsImpressum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impressum & Datenschutz')),
      body: const Center(child: Text('Platzhalter Impressum und Datenschutz')),
    );
  }
}