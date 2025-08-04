import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/dashboard_components.dart';
import '../settings/settings_menu.dart';

import '../../fragments/diagnose_pv_fragment.dart';
import '../../fragments/pdf_viewer_fragment.dart';
import '../../fragments/verbrauch_fragment.dart';
import '../../fragments/ki_kamera_fragment.dart';
import '../../fragments/tools_fragment.dart';
import '../../fragments/einstellungen_fragment.dart';

class LandingPagePlaner extends StatelessWidget {
  const LandingPagePlaner({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final auth = context.read<AuthController>();
    final brightness = Theme.of(context).brightness;

    final backgroundColor = brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : Colors.white;
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade300;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    final cards = [
      DashboardCardData(
        id: 'diagnose',
        title: 'Fehlerdiagnose',
        icon: Icons.warning,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiagnosePVFragment()),
          );
        },
      ),
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
        title: 'Kamera-KI',
        icon: Icons.camera_alt,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KameraKiFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'tools',
        title: 'Werkzeuge',
        icon: Icons.build,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ToolsFragment()),
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
                title: 'Planer-Hilfe',
                pdfUrl: 'https://example.com/planer.pdf',
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Planer Dashboard', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsMenu()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: thema.gridCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: cards
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