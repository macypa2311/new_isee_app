import 'package:flutter/material.dart';

class LandingPlaner extends StatelessWidget {
  const LandingPlaner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planer Landing')),
      body: const Center(child: Text('Willkommen, Planer')),
    );
  }
}