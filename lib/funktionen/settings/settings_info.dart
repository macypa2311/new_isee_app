import 'package:flutter/material.dart';

class SettingsInfo extends StatelessWidget {
  const SettingsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: const Center(child: Text('Platzhalter App-Info')),
    );
  }
}