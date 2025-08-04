import 'package:flutter/material.dart';

class LandingEndkunde extends StatelessWidget {
  const LandingEndkunde({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Endkunde Landing')),
      body: const Center(child: Text('Willkommen, Endkunde')),
    );
  }
}