import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/dashboard_components.dart';
import '../settings/settings_menu.dart';

import '../../fragments/mail_fragment.dart';
import '../../fragments/diagnose_pv_fragment.dart';
import '../../fragments/diagnose_wp_fragment.dart';
import '../../fragments/ki_kamera_fragment.dart';
import '../../fragments/pdf_viewer_fragment.dart';

class LandingPageInstallateur extends StatelessWidget {
  const LandingPageInstallateur({super.key});

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

    final cards = [
      DashboardCardData(
        id: 'mail',
        title: 'Mail',
        icon: Icons.mail,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MailFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'diagnose_pv',
        title: 'Diagnose PV',
        icon: Icons.electrical_services,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiagnoseWPFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'diagnose_wp',
        title: 'Diagnose WP',
        icon: Icons.ac_unit,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiagnoseWPFragment()),
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
        id: 'pdf',
        title: 'PDF-Verwaltung',
        icon: Icons.picture_as_pdf,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PdfViewerFragment(
                title: 'PDF-Verwaltung',
                pdfUrl: 'https://example.com/installateur.pdf',
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Installateur Dashboard', style: TextStyle(color: textColor)),
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