import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/strings.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';
import '../kern/theme/app_text_styles.dart';
import '../widgets/app_scaffold.dart';

class DiagnoseEndkundeFragment extends StatefulWidget {
  const DiagnoseEndkundeFragment({super.key});

  @override
  State<DiagnoseEndkundeFragment> createState() => _DiagnoseEndkundeFragmentState();
}

class _DiagnoseEndkundeFragmentState extends State<DiagnoseEndkundeFragment> {
  final TextEditingController _codeController = TextEditingController();
  String? _hersteller;
  String? _beschreibung;
  String? _empfehlung;

  final List<String> _herstellerListe = [
    'Fronius',
    'Sungrow',
    'Kostal',
    'Deye',
  ];

  Future<void> _analyseFehler() async {
    FocusScope.of(context).unfocus(); // ✅ Tastatur schließen

    if (_hersteller == null || _codeController.text.isEmpty) {
      setState(() {
        _beschreibung = 'Bitte Hersteller und Fehlercode angeben.';
        _empfehlung = null;
      });
      return;
    }

    final jsonPfad = 'assets/fehlercodes/${_hersteller!.toLowerCase()}.json';

    try {
      final jsonString = await rootBundle.loadString(jsonPfad);
      final daten = json.decode(jsonString);
      final code = _codeController.text.trim();

      final eintrag = daten[code];
      if (eintrag != null) {
        setState(() {
          _beschreibung = eintrag['beschreibung'] ?? 'Keine Beschreibung vorhanden.';
          _empfehlung = eintrag['empfehlung'] ?? 'Keine Empfehlung vorhanden.';
        });
      } else {
        setState(() {
          _beschreibung = 'Fehlercode nicht gefunden.';
          _empfehlung = null;
        });
      }
    } catch (e) {
      setState(() {
        _beschreibung = 'Fehler beim Laden der Daten.';
        _empfehlung = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.diagnose,
      child: SingleChildScrollView(
        padding: AppSpacing.innenAll(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fehleranalyse für Endkunden', style: AppTextStyles.ueberschrift(context)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Hersteller wählen'),
              value: _hersteller,
              items: _herstellerListe
                  .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (value) => setState(() => _hersteller = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Fehlercode eingeben'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _analyseFehler,
                icon: const Icon(Icons.search),
                label: const Text('Fehler analysieren'),
              ),
            ),
            const SizedBox(height: 24),
            if (_beschreibung != null) ...[
              Text('Beschreibung', style: AppTextStyles.fett(context)),
              const SizedBox(height: 4),
              Text(_beschreibung!, style: AppTextStyles.standard(context)),
              const SizedBox(height: 16),
              if (_empfehlung != null) ...[
                Text('Empfehlung', style: AppTextStyles.fett(context)),
                const SizedBox(height: 4),
                Text(_empfehlung!, style: AppTextStyles.standard(context)),
              ],
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}