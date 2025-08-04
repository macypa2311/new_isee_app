import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../../kern/thema/thema_controller.dart';

class LandingPageInstallateur extends StatelessWidget {
  const LandingPageInstallateur({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final auth = context.read<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Installateur Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const _SharedSettingsSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Abmelden',
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Willkommen, Installateur', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Aktueller Modus: ${thema.isDark ? "Dunkel" : "Hell"}'),
                const Spacer(),
                Text('Accent: ${thema.accentChoice}'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  'Hier kommen deine spezifischen Tools/Widgets hin.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedSettingsSheet extends StatelessWidget {
  const _SharedSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 12,
        children: [
          Text('Darstellung', style: Theme.of(context).textTheme.titleLarge),
          Row(
            children: [
              const Text('Hell/Dunkel:'),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Hell'),
                selected: !thema.isDark,
                onSelected: (_) => thema.setDarkMode(false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Dunkel'),
                selected: thema.isDark,
                onSelected: (_) => thema.setDarkMode(true),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Accent:'),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Blau'),
                selected: thema.accentChoice == 'blue',
                onSelected: (_) => thema.setAccent('blue'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Grün'),
                selected: thema.accentChoice == 'green',
                onSelected: (_) => thema.setAccent('green'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Rot'),
                selected: thema.accentChoice == 'red',
                onSelected: (_) => thema.setAccent('red'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Layout:'),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Kacheln'),
                selected: thema.layoutMode == LayoutMode.grid,
                onSelected: (_) => thema.setLayoutMode(LayoutMode.grid),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Karussell'),
                selected: thema.layoutMode == LayoutMode.carousel,
                onSelected: (_) => thema.setLayoutMode(LayoutMode.carousel),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.read<AuthController>().logout();
              Navigator.of(context).pop();
            },
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
  }
}