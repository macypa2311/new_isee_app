import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/theme/thema_controller.dart';
import '../../kern/theme/app_colors.dart';
import '../../widgets/dashboard_components.dart';
import '../../widgets/hinweis_kachel.dart';

import '../../fragments/verbrauch_fragment.dart';
import '../../fragments/ki_kamera_fragment.dart';
import '../../fragments/diagnose_endkunde_fragment.dart';
import '../../fragments/pv_rechner_fragment.dart';
import '../../fragments/pdf_viewer_fragment.dart';
import '../../fragments/einstellungen_fragment.dart';
import '../../fragments/mail_fragment.dart';
import '../../fragments/wetter_fragment.dart';
import '../settings/settings_menu.dart';

class LandingPageEndkunde extends StatelessWidget {
  const LandingPageEndkunde({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final brightness = Theme.of(context).brightness;

    final backgroundColor = AppColors.background(context);
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade300;
    final textColor = AppColors.textPrimary(context);

    // ⚠️ Hier kannst du das später dynamisch machen – aktuell statisch gesetzt
    final bool hatUngeleseneNachrichten = true;

    final cards = [
      DashboardCardData(
        id: 'verbrauch',
        title: 'Verbrauchsanalyse',
        icon: Icons.bolt,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerbrauchFragment()),
        ),
      ),
      DashboardCardData(
        id: 'kamera',
        title: 'Kamera KI',
        icon: Icons.camera_alt,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KameraKiFragment()),
        ),
      ),
      DashboardCardData(
        id: 'diagnose',
        title: 'Fehlerdiagnose',
        icon: Icons.warning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DiagnoseEndkundeFragment()),
        ),
      ),
      DashboardCardData(
        id: 'pv',
        title: 'PV-Rechner',
        icon: Icons.calculate,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PvRechnerFragment()),
        ),
      ),
      DashboardCardData(
        id: 'pdf',
        title: 'PDF-Hilfe',
        icon: Icons.picture_as_pdf,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PdfViewerFragment(
              title: 'PDF-Hilfe',
              pdfUrl: 'https://example.com/endkunde_hilfe.pdf',
            ),
          ),
        ),
      ),
      DashboardCardData(
        id: 'mail',
        title: 'Mail',
        icon: Icons.mail,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MailFragment()),
        ),
      ),
      DashboardCardData(
        id: 'wetter',
        title: 'Wetter',
        icon: Icons.cloud,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WetterFragment()),
        ),
      ),
      DashboardCardData(
        id: 'einstellungen',
        title: 'Einstellungen',
        icon: Icons.settings,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EinstellungenFragment()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Dashboard', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsMenu()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Willkommensnachricht & Hinweisfeld
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                child: Text(
                  'Willkommen zurück!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                ),
              ),
            ),
            HinweisKachel(
              text: hatUngeleseneNachrichten ? 'Offene Nachrichten' : 'Weitere Anleitung',
              icon: hatUngeleseneNachrichten ? Icons.mark_email_unread : Icons.info_outline,
              onTap: () {
                if (hatUngeleseneNachrichten) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MailFragment()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PdfViewerFragment(
                      title: 'Weitere Anleitung',
                      pdfUrl: 'https://example.com/endkunde_anleitung.pdf',
                    )),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}