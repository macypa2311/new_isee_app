import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../../kern/thema/thema_controller.dart';

class LandingPageEndkunde extends StatelessWidget {
  const LandingPageEndkunde({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final auth = context.read<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Endkunde Dashboard'),
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
            Text('Willkommen, Endkunde', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Layout: ${thema.layoutMode == LayoutMode.grid ? "Kacheln" : "Karussell"}'),
                const Spacer(),
                Text('Accent: ${thema.accentChoice}'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  'Hier kommt die Endkunden-spezifische Übersicht hin.',
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
              Switch(value: thema.isDark, onChanged: (v) => thema.setDarkMode(v)),
            ],
          ),
          Row(
            children: [
              const Text('Accent:'),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: thema.accentChoice,
                items: const [
                  DropdownMenuItem(value: 'blue', child: Text('Blau')),
                  DropdownMenuItem(value: 'green', child: Text('Grün')),
                  DropdownMenuItem(value: 'red', child: Text('Rot')),
                ],
                onChanged: (s) {
                  if (s != null) thema.setAccent(s);
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text('Layout:'),
              const SizedBox(width: 8),
              DropdownButton<LayoutMode>(
                value: thema.layoutMode,
                items: const [
                  DropdownMenuItem(value: LayoutMode.grid, child: Text('Kacheln')),
                  DropdownMenuItem(value: LayoutMode.carousel, child: Text('Karussell')),
                ],
                onChanged: (l) {
                  if (l != null) thema.setLayoutMode(l);
                },
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