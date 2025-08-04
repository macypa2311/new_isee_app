import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';
import '../../widgets/settings_sheet.dart';
import '../../widgets/dashboard_components.dart';  // <-- Hier importieren

import '../startseite/landing_installateur.dart';

class LandingAdmin extends StatelessWidget {
  const LandingAdmin({super.key});

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
        id: 'planer',
        title: 'Planer',
        icon: Icons.engineering,
        count: 3,
        onTap: () {},
      ),
      DashboardCardData(
        id: 'installateur',
        title: 'Installateur',
        icon: Icons.person,
        count: 1,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LandingPageInstallateur()),
          );
        },
      ),
      DashboardCardData(
        id: 'endkunde',
        title: 'Endkunde',
        icon: Icons.home,
        count: 0,
        onTap: () {},
      ),
    ];

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