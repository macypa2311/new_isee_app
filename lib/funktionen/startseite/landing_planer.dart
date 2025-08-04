import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/settings_sheet.dart';
import '../../widgets/dashboard_components.dart';

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

    final planerCards = [
      DashboardCardData(
        id: 'mail',
        title: 'Mail',
        icon: Icons.mail,
        count: 0,
        onTap: () {
          // TODO: Navigation zum Mail-Fragment ergänzen
        },
      ),
      DashboardCardData(
        id: 'planung_pv',
        title: 'Planung PV',
        icon: Icons.electrical_services,
        count: 0,
        onTap: () {
          // TODO: Navigation zur PV-Planung ergänzen
        },
      ),
      DashboardCardData(
        id: 'planung_wp',
        title: 'Planung Wärmepumpe',
        icon: Icons.ac_unit,
        count: 0,
        onTap: () {
          // TODO: Navigation zur Wärmepumpen-Planung ergänzen
        },
      ),
      DashboardCardData(
        id: 'kamera',
        title: 'Kamera',
        icon: Icons.camera_alt,
        count: 0,
        onTap: () {
          // TODO: Navigation zur Kamera ergänzen
        },
      ),
      DashboardCardData(
        id: 'angebote',
        title: 'Angebote',
        icon: Icons.receipt_long,
        count: 0,
        onTap: () {
          // TODO: Navigation zu Angeboten ergänzen
        },
      ),
      DashboardCardData(
        id: 'todo',
        title: 'To-Do',
        icon: Icons.checklist,
        count: 0,
        onTap: () {
          // TODO: Navigation zu To-Do ergänzen
        },
      ),
      DashboardCardData(
        id: 'kunden',
        title: 'Kunden',
        icon: Icons.people,
        count: 0,
        onTap: () {
          // TODO: Navigation zu Kunden ergänzen
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Dashboard',
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
          Widget cardWidget;
          switch (thema.layoutMode) {
            case LayoutMode.carousel:
              cardWidget = CustomerCarousel(
                cards: planerCards,
                background: backgroundColor,
                borderColor: borderColor,
              );
              break;
            case LayoutMode.grid:
            default:
              cardWidget = GridView.count(
                crossAxisCount: thema.gridCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: planerCards
                    .map((card) => DashboardCardCompact(
                          data: card,
                          background: backgroundColor,
                          borderColor: borderColor,
                        ))
                    .toList(),
              );
          }
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Willkommen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Expanded(child: cardWidget),
              ],
            ),
          );
        },
      ),
    );
  }
}