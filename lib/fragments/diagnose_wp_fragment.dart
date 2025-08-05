import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../kern/theme/thema_controller.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';
import '../widgets/custom_app_bar.dart';

class DiagnoseWPFragment extends StatefulWidget {
  const DiagnoseWPFragment({super.key});

  @override
  State<DiagnoseWPFragment> createState() => _DiagnoseWPFragmentState();
}

class _DiagnoseWPFragmentState extends State<DiagnoseWPFragment> {
  String selectedHersteller = '';
  String selectedModell = '';
  final TextEditingController fehlercodeController = TextEditingController();

  String fehlerBeschreibung = '';
  String loesungsvorschlag = '';
  String pdfLink = '';
  bool fehlerGefunden = false;

  final List<String> herstellerListe = [
    'Bosch',
    'Buderus',
    'Daikin',
    'Danfoss',
    'LG',
    'Samsung',
    'Stiebel Eltron',
    'Viessmann',
    'Wolf',
    'Vaillant',
  ];

  final Map<String, String> jsonPfadProHersteller = {
    'Bosch': 'assets/errors/wp/bosch_errors.json',
    'Buderus': 'assets/errors/wp/buderus_errors.json',
    'Daikin': 'assets/errors/wp/daikin_errors.json',
    'Danfoss': 'assets/errors/wp/danfoss_errors.json',
    'LG': 'assets/errors/wp/lg_errors.json',
    'Samsung': 'assets/errors/wp/samsung_errors.json',
    'Stiebel Eltron': 'assets/errors/wp/stiebel_eltron_errors.json',
    'Viessmann': 'assets/errors/wp/viessmann_errors.json',
    'Wolf': 'assets/errors/wp/wolf_errors.json',
    'Vaillant': 'assets/errors/wp/vaillant_errors.json',
  };

  List<String> modelle = [];
  Map<String, dynamic> fehlerDaten = {};

  @override
  void initState() {
    super.initState();
    _resetAuswahl();
  }

  void _resetAuswahl() {
    setState(() {
      selectedHersteller = '';
      selectedModell = '';
      modelle = [];
      fehlerBeschreibung = '';
      loesungsvorschlag = '';
      pdfLink = '';
      fehlerGefunden = false;
      fehlercodeController.clear();
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
        modelle = daten.keys.toList();
        selectedModell = '';
        fehlerBeschreibung = '';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
        fehlercodeController.clear();
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

    final fehlerListe = fehlerDaten[selectedModell];
    if (fehlerListe == null) {
      setState(() {
        fehlerBeschreibung = 'Keine Fehlerdaten für das Modell vorhanden.';
        loesungsvorschlag = '';
        pdfLink = '';
        fehlerGefunden = false;
      });
      return;
    }

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
        title: 'Diagnose WP',
        thema: thema,
      ),
      backgroundColor: thema.isDark
          ? AppColors.background(context)
          : AppColors.background(context),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedHersteller.isEmpty ? null : selectedHersteller,
                items: herstellerListe
                    .map((h) => DropdownMenuItem(value: h, child: Text(h, style: textTheme.bodyMedium)))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Hersteller wählen',
                  filled: true,
                  fillColor: thema.isDark ? AppColors.background(context) : AppColors.background(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedHersteller = value;
                      selectedModell = '';
                      modelle = [];
                      fehlerBeschreibung = '';
                      loesungsvorschlag = '';
                      pdfLink = '';
                      fehlerGefunden = false;
                      fehlercodeController.clear();
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
                  fillColor: thema.isDark ? AppColors.background(context) : AppColors.background(context),
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
                  fillColor: thema.isDark ? AppColors.background(context) : AppColors.background(context),
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}