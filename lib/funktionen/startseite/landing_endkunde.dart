// lib/funktionen/startseite/landing_endkunde.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/theme/thema_controller.dart';
import '../../widgets/dashboard_components.dart';
import '../startseite/landing_planer.dart' as planer;
import '../startseite/landing_installateur.dart' as installateur;
import '../startseite/landing_admin.dart';

import '../../fragments/einstellungen_fragment.dart';
import '../../fragments/verbrauch_fragment.dart';
import '../../fragments/diagnose_endkunde_fragment.dart';
import '../../fragments/ki_kamera_fragment.dart';
import '../../fragments/pv_rechner_fragment.dart';
import '../../fragments/unabhaengigkeits_fragment.dart';
import '../../fragments/pdf_viewer_fragment.dart';

class LandingPageEndkunde extends StatelessWidget {
  const LandingPageEndkunde({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final brightness = Theme.of(context).brightness;

    final backgroundColor = brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade300;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    final primaryCards = [
      DashboardCardData(
        id: 'planer',
        title: 'Planer',
        icon: Icons.engineering,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const planer.LandingPagePlaner()),
          );
        },
      ),
      DashboardCardData(
        id: 'installateur',
        title: 'Installateur',
        icon: Icons.handyman,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const installateur.LandingPageInstallateur()),
          );
        },
      ),
      DashboardCardData(
        id: 'admin',
        title: 'Admin',
        icon: Icons.admin_panel_settings,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LandingAdmin()),
          );
        },
      ),
    ];

    final otherCards = [
      DashboardCardData(
        id: 'verbrauch',
        title: 'Verbrauchsanalyse',
        icon: Icons.bolt,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VerbrauchFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'kamera',
        title: 'Kamera',
        icon: Icons.camera_alt,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KameraKiFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'diagnose',
        title: 'Fehlerdiagnose',
        icon: Icons.report_problem,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiagnoseEndkundeFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'pvRechner',
        title: 'PV-Rechner',
        icon: Icons.calculate,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PvRechnerFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'unabhaengigkeit',
        title: 'Unabhängigkeit',
        icon: Icons.energy_savings_leaf,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UnabhaengigkeitsFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'pdf',
        title: 'PDF-Hilfe',
        icon: Icons.picture_as_pdf,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PdfViewerFragment(
                title: 'Endkunden-Hilfe',
                pdfUrl: 'https://example.com/endkunde.pdf',
              ),
            ),
          );
        },
      ),
      DashboardCardData(
        id: 'einstellungen',
        title: 'Einstellungen',
        icon: Icons.settings,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EinstellungenFragment()),
          );
        },
      ),
    ];

    final allCards = [...primaryCards, ...otherCards];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Endkundenbereich',
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: thema.gridCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: allCards
              .map((card) => DashboardCardCompact(
                    data: card,
                    background: backgroundColor,
                    borderColor: borderColor,
                  ))
              .toList(),
        ),
      ),
    );
  }
}