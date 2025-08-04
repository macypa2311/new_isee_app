import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/settings_sheet.dart';
import '../../widgets/dashboard_components.dart';

import '../../fragments/diagnose_pv_fragment.dart';

class DiagnoseWPFragment extends StatelessWidget {
  const DiagnoseWPFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnose Wärmepumpe'),
        backgroundColor: thema.isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: const Center(child: Text('Diagnose WP - Platzhalter')),
    );
  }
}

class KameraFragment extends StatelessWidget {
  const KameraFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera'),
        backgroundColor: thema.isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: const Center(child: Text('Kamera - Platzhalter')),
    );
  }
}

class MailFragment extends StatelessWidget {
  const MailFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mail'),
        backgroundColor: thema.isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: const Center(child: Text('Mail - Platzhalter')),
    );
  }
}

class FehlercodesFragment extends StatelessWidget {
  const FehlercodesFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fehlercodes'),
        backgroundColor: thema.isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: const Center(child: Text('Fehlercodes - Platzhalter')),
    );
  }
}

class StatistikenFragment extends StatelessWidget {
  const StatistikenFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiken'),
        backgroundColor: thema.isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: const Center(child: Text('Statistiken - Platzhalter')),
    );
  }
}

class LandingPageInstallateur extends StatelessWidget {
  const LandingPageInstallateur({super.key});

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

    final exampleCards = [
      DashboardCardData(
        id: 'diagnose_pv',
        title: 'Diagnose PV',
        icon: Icons.solar_power,
        count: 0,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiagnosePVFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'diagnose_wp',
        title: 'Diagnose WP',
        icon: Icons.ac_unit,
        count: 0,
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
        count: 0,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KameraFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'mail',
        title: 'Mail',
        icon: Icons.mail,
        count: 0,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MailFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'fehlercodes',
        title: 'Fehlercodes',
        icon: Icons.warning,
        count: 0,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FehlercodesFragment()),
          );
        },
      ),
      DashboardCardData(
        id: 'statistiken',
        title: 'Statistiken',
        icon: Icons.bar_chart,
        count: 0,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StatistikenFragment()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Installateur Dashboard',
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const SettingsSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Abmelden',
            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          switch (thema.layoutMode) {
            case LayoutMode.carousel:
              return CustomerCarousel(
                cards: exampleCards,
                background: backgroundColor,
                borderColor: borderColor,
              );
            case LayoutMode.grid:
            default:
              return Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  crossAxisCount: thema.gridCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: exampleCards
                      .map((card) => DashboardCardCompact(
                            data: card,
                            background: backgroundColor,
                            borderColor: borderColor,
                          ))
                      .toList(),
                ),
              );
          }
        },
      ),
    );
  }
}