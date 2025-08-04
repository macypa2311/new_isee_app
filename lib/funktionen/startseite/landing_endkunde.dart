import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/settings_sheet.dart';
import '../../widgets/dashboard_components.dart';

class LandingPageEndkunde extends StatelessWidget {
  const LandingPageEndkunde({super.key});

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

    final endkundeCards = [
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
        id: 'diagnose_pv',
        title: 'Diagnose PV',
        icon: Icons.electrical_services,
        count: 0,
        onTap: () {
          // TODO: Navigation zur PV-Diagnose ergänzen
        },
      ),
      DashboardCardData(
        id: 'status',
        title: 'Status',
        icon: Icons.info,
        count: 0,
        onTap: () {
          // TODO: Navigation zum Status ergänzen
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
        id: 'tipps',
        title: 'Tipps',
        icon: Icons.lightbulb,
        count: 0,
        onTap: () {
          // TODO: Navigation zu Tipps ergänzen
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
                cards: endkundeCards,
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
                children: endkundeCards
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