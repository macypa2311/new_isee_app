import 'package:flutter/material.dart';

class BrennstoffkostenFragment extends StatefulWidget {
  const BrennstoffkostenFragment({super.key});

  @override
  State<BrennstoffkostenFragment> createState() => _BrennstoffkostenFragmentState();
}

class _BrennstoffkostenFragmentState extends State<BrennstoffkostenFragment> {
  // Controller für die Eingaben
  final _verbrauchController = TextEditingController();
  final _preisController = TextEditingController();

  String _ergebnis = '';

  @override
  void dispose() {
    _verbrauchController.dispose();
    _preisController.dispose();
    super.dispose();
  }

  void _berechneKosten() {
    final verbrauch = double.tryParse(_verbrauchController.text.replaceAll(',', '.')) ?? 0;
    final preis = double.tryParse(_preisController.text.replaceAll(',', '.')) ?? 0;

    final kosten = verbrauch * preis;

    setState(() {
      _ergebnis = kosten > 0
          ? 'Ihre jährlichen Brennstoffkosten:\n${kosten.toStringAsFixed(2)} €'
          : 'Bitte Verbrauch und Preis eingeben';
    });
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    String suffix = '',
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brennstoffkosten')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Berechnen Sie Ihre jährlichen Brennstoffkosten',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            _buildNumberField(
              label: 'Verbrauch (kWh/Jahr)',
              controller: _verbrauchController,
            ),
            const SizedBox(height: 12),

            _buildNumberField(
              label: 'Preis (€/kWh)',
              controller: _preisController,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _berechneKosten,
              child: const Text('Kosten berechnen'),
            ),
            const SizedBox(height: 24),

            if (_ergebnis.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _ergebnis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}