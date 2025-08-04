import 'package:flutter/material.dart';

class LandingInstallateur extends StatelessWidget {
  const LandingInstallateur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Installateur Landing')),
      body: const Center(child: Text('Willkommen, Installateur')),
    );
  }
}