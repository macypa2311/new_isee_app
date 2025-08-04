import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../kern/theme/thema_controller.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';
import '../kern/theme/app_text_styles.dart';
import '../widgets/custom_app_bar.dart';

class DiagnosePVFragment extends StatefulWidget {
  const DiagnosePVFragment({super.key});

  @override
  State<DiagnosePVFragment> createState() => _DiagnosePVFragmentState();
}

class _DiagnosePVFragmentState extends State<DiagnosePVFragment> {
  String selectedGeraetetyp = 'Wechselrichter';
  String selectedHersteller = '';
  String selectedModell = '';
  final TextEditingController fehlercodeController = TextEditingController();

  String fehlerBeschreibung = '';
  String loesungsvorschlag = '';
  String pdfLink = '';
  bool fehlerGefunden = false;

  final List<String> komponentenListe = [
    'Wechselrichter',
    'Batterie',
    'Smart Meter',
  ];

  final Map<String, String> jsonPfadProHersteller = {
    'Sungrow': 'assets/errors/pv/sungrow/sungrow_shxxrt_errors.json',
    'Fronius': 'assets/errors/pv/fronius_errors_extended.json',
    'Growatt': 'assets/errors/pv/growatt_errors.json',
    // hier weitere Hersteller mit Pfaden ergänzen
  };

  // Vordefinierte Modell-Liste mit allen SH-Modellen, die auf dieselbe JSON zeigen
  final List<String> alleModelle = [
    'SH5RT',
    'SH6RT',
    'SH8RT',
    'SH10RT',
    'SH5RT-20',
    'SH6RT-20',
    'SH8RT-20',
    'SH10RT-20',
  ];

  // Alias, alle verweisen auf den Schlüssel "SH5RT" in der JSON
  final Map<String, String> modellAlias = {
    'SH5RT': 'SH5RT',
    'SH6RT': 'SH5RT',
    'SH8RT': 'SH5RT',
    'SH10RT': 'SH5RT',
    'SH5RT-20': 'SH5RT',
    'SH6RT-20': 'SH5RT',
    'SH8RT-20': 'SH5RT',
    'SH10RT-20': 'SH5RT',
  };

  List<String> modelle = [];
  Map<String, dynamic> fehlerDaten = {};

  @override
  void initState() {
    super.initState();
    _updateHerstellerListe();
  }

  void _updateHerstellerListe() {
    setState(() {
      selectedHersteller = '';
      selectedModell = '';
      modelle = [];
      fehlerBeschreibung = '';
      loesungsvorschlag = '';
      pdfLink = '';
      fehlerGefunden = false;
    });
  }

  Future<void> _ladeModelleUndDaten(String hersteller) async {
    final pfad = jsonPfadProHersteller[hersteller];
    if (pfad == null) {
      setState(() {
        modelle = [];
        fehlerDaten = {};
        selectedModell = '';
      });
      return;
    }
    try {
      final jsonString = await rootBundle.loadString(pfad);
      final Map<String, dynamic> daten = json.decode(jsonString);

      setState(() {
        fehlerDaten = daten;
        modelle = alleModelle; // Nutze die vordefinierte Liste aller Modelle
        selectedModell = '';
        fehlerBeschreibung = '';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
      });
    } catch (e) {
      setState(() {
        modelle = [];
        fehlerDaten = {};
        selectedModell = '';
        fehlerBeschreibung = 'Fehler beim Laden der Fehlerdaten.';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
      });
    }
  }

  void _fehlerAnalysieren() {
    final codeInput = fehlercodeController.text.trim();
    if (codeInput.isEmpty || selectedModell.isEmpty || selectedHersteller.isEmpty) {
      setState(() {
        fehlerBeschreibung = 'Bitte alle Felder ausfüllen.';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
      });
      return;
    }

    // Alias benutzen: das Modell auf den Schlüssel in der JSON abbilden
    final aliasModell = modellAlias[selectedModell] ?? selectedModell;
    final fehlerListe = fehlerDaten[aliasModell];

    if (fehlerListe == null) {
      setState(() {
        fehlerBeschreibung = 'Keine Fehlerdaten für das Modell vorhanden.';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
      });
      return;
    }

    // Suche Fehlercode in Keys (kann auch mehrere Codes als String beinhalten, z.B. "028, 029")
    String? gefundenerKey;
    fehlerListe.forEach((key, value) {
      final codes = key.split(',').map((c) => c.trim());
      if (codes.contains(codeInput)) {
        gefundenerKey = key;
      }
    });

    if (gefundenerKey != null) {
      final fehlerInfo = fehlerListe[gefundenerKey!];
      setState(() {
        fehlerBeschreibung = fehlerInfo['description'] ?? 'Keine Beschreibung vorhanden.';
        loesungsvorschlag = fehlerInfo['solution'] ?? 'Keine Lösung vorhanden.';
        pdfLink = fehlerInfo['pdf'] ?? '';
        fehlerGefunden = true;
      });
      _zeigeFehlerDialog(codeInput);
    } else {
      setState(() {
        fehlerBeschreibung = 'Fehlercode nicht gefunden.';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
      });
      _zeigeFehlerDialog(codeInput);
    }
  }

  void _zeigeFehlerDialog(String code) {
    showDialog(
      context: context,
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return AlertDialog(
          title: Text('Analyse Fehlercode $code'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Beschreibung:', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(fehlerBeschreibung, style: textTheme.bodyMedium),
                const SizedBox(height: 16),
                Text('Lösung:', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(loesungsvorschlag, style: textTheme.bodyMedium),
                if (pdfLink.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(pdfLink);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF-Anleitung öffnen'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Schließen')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Diagnose',
        thema: thema,
      ),
      backgroundColor: thema.isDark
          ? AppFarben.background(context)
          : AppFarben.background(context),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedGeraetetyp,
                items: komponentenListe
                    .map((g) => DropdownMenuItem(value: g, child: Text(g, style: textTheme.bodyMedium)))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Komponente wählen',
                  filled: true,
                  fillColor: thema.isDark ? AppFarben.background(context) : AppFarben.background(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedGeraetetyp = value;
                      _updateHerstellerListe();
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: selectedHersteller.isEmpty ? null : selectedHersteller,
                items: jsonPfadProHersteller.keys
                    .map((h) => DropdownMenuItem(value: h, child: Text(h, style: textTheme.bodyMedium)))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Hersteller wählen',
                  filled: true,
                  fillColor: thema.isDark ? AppFarben.background(context) : AppFarben.background(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedHersteller = value;
                    });
                    _ladeModelleUndDaten(value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: selectedModell.isEmpty ? null : selectedModell,
                items: modelle
                    .map((m) => DropdownMenuItem(value: m, child: Text(m, style: textTheme.bodyMedium)))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Modell wählen',
                  filled: true,
                  fillColor: thema.isDark ? AppFarben.background(context) : AppFarben.background(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedModell = value;
                      fehlerBeschreibung = '';
                      loesungsvorschlag = '';
                      pdfLink = '';
                      fehlerGefunden = false;
                      fehlercodeController.clear();
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: fehlercodeController,
                decoration: InputDecoration(
                  labelText: 'Fehlercode eingeben',
                  filled: true,
                  fillColor: thema.isDark ? AppFarben.background(context) : AppFarben.background(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: _fehlerAnalysieren,
                child: Text('Fehlercode analysieren', style: textTheme.bodyMedium),
              ),
              const SizedBox(height: AppSpacing.l),
              if (fehlerGefunden) ...[
                Text('Beschreibung', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(fehlerBeschreibung, style: textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.md),
                Text('Lösung', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(loesungsvorschlag, style: textTheme.bodyMedium),
                if (pdfLink.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  TextButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(pdfLink);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF-Anleitung öffnen'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}