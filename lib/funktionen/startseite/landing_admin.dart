import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../../kern/thema/thema_controller.dart';
import '../../widgets/settings_sheet.dart'; // Stelle sicher, dass dieser Pfad korrekt ist

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
        onTap: () {},
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
                  crossAxisCount: thema.gridCount, // ← Dynamisch
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

class DashboardCardData {
  final String id;
  final String title;
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  const DashboardCardData({
    required this.id,
    required this.title,
    required this.icon,
    this.count = 0,
    required this.onTap,
  });
}

class DashboardCardCompact extends StatelessWidget {
  final DashboardCardData data;
  final Color background;
  final Color borderColor;

  const DashboardCardCompact({
    super.key,
    required this.data,
    required this.background,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1);
    final countStyle = Theme.of(context).textTheme.bodySmall?.copyWith(height: 1);

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              data.count > 0 ? '${data.count} offen' : 'Keine offenen',
              style: countStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerCarousel extends StatelessWidget {
  final List<DashboardCardData> cards;
  final Color background;
  final Color borderColor;

  const CustomerCarousel({
    super.key,
    required this.cards,
    required this.background,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final overlayColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withAlpha((0.3 * 255).round())
        : Colors.white.withAlpha((0.8 * 255).round());

    return SizedBox(
      height: 110,
      child: Stack(
        children: [
          ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final card = cards[index];
              return SizedBox(
                width: 100,
                child: DashboardCardCompact(
                  data: card,
                  background: background,
                  borderColor: borderColor,
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    overlayColor.withAlpha(0),
                    overlayColor.withAlpha((0.6 * 255).round()),
                    overlayColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}