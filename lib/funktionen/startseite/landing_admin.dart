import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/dashboard_components.dart';

import '../startseite/landing_planer.dart' as planer;
import '../startseite/landing_installateur.dart' as installateur;
import '../startseite/landing_endkunde.dart';
import '../settings/settings_menu.dart';

import '../../fragments/mail_fragment.dart';
import '../../fragments/kontakt_fragment.dart';
import '../../fragments/pdf_viewer_fragment.dart';
import '../../fragments/nutzerverwaltung.dart';
import '../../fragments/backup_fragment.dart';
import '../../fragments/tools_fragment.dart';
import '../../fragments/statistik_fragment.dart';
import '../../fragments/einstellungen_fragment.dart';

class LandingAdmin extends StatelessWidget {
  const LandingAdmin({super.key});

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
        id: 'endkunde',
        title: 'Endkunde',
        icon: Icons.home,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LandingPageEndkunde()),
          );
        },
      ),
    ];

    final otherCards = [
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
        id: 'kontakt',
        title: 'Hersteller-Kontakte',
        icon: Icons.factory,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KontaktFragment()),
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
                pdfUrl: 'https://example.com/pdf.pdf',
              ),
            ),
          );
        },
      ),
      DashboardCardData(
        id: 'nutzer',
        title: 'Nutzerverwaltung',
        icon: Icons.manage_accounts,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NutzerverwaltungsFragment(),
            ),
          );
        },
      ),
      DashboardCardData(
        id: 'backup',
        title: 'Backup & Wiederherstellung',
        icon: Icons.backup,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BackupFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'tools',
        title: 'Technische Tools',
        icon: Icons.build,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ToolsFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'statistik',
        title: 'Statistiken',
        icon: Icons.bar_chart,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StatistikFragment()),
          );
        },
      ),
    ];

    final allCards = [...primaryCards, ...otherCards];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
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