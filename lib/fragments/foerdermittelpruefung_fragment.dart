// lib/fragments/foerdermittelpruefung_fragment.dart

import 'package:flutter/material.dart';

class FoerdermittelpruefungFragment extends StatefulWidget {
  const FoerdermittelpruefungFragment({Key? key}) : super(key: key);

  @override
  _FoerdermittelpruefungFragmentState createState() =>
      _FoerdermittelpruefungFragmentState();
}

class _FoerdermittelpruefungFragmentState
    extends State<FoerdermittelpruefungFragment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _leistungCtrl = TextEditingController();

  bool _isLoading = false;
  String? _error;
  List<String> _results = [];

  Future<void> _checkFoerdermittel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _results = [];
    });

    // Hier könntest du später deinen API-Call einbauen.
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _results = [
        'KfW – 270: 1 000 EUR/kWp (max. 30 kWp)',
        'BAFA – Solarthermie: 300 EUR/m² Kollektorfläche',
        'Landesförderung XY: pauschal 500 EUR',
      ];
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _leistungCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Fördermittelprüfung'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Formular
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _addressCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Adresse / PLZ',
                        hintText: 'z. B. 10115 Berlin',
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Bitte Adresse eingeben' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _leistungCtrl,
                      decoration: const InputDecoration(
                        labelText: 'PV-Leistung (kWp)',
                        hintText: 'z. B. 10',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Bitte kWp eingeben' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _checkFoerdermittel,
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Prüfen'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Fehlermeldung
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),

              // Ergebnisse
              if (_results.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (ctx, i) => ListTile(
                    leading: const Icon(Icons.monetization_on),
                    title: Text(_results[i]),
                  ),
                )
              else if (!_isLoading && _error == null)
                const Center(child: Text('Noch keine Prüfergebnisse')),
            ],
          ),
        ),
      ),
    );
  }
}