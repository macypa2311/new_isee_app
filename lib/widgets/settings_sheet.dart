import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../kern/theme/thema_controller.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final isGrid = thema.layoutMode == LayoutMode.grid;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 16,
        children: [
          const Text('Darstellung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Modus
          Row(
            children: [
              const Text('Modus:'),
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

          // Farbe
          Row(
            children: [
              const Text('Farbe:'),
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

          // Ansicht
          Row(
            children: [
              const Text('Ansicht:'),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Karussell'),
                selected: thema.layoutMode == LayoutMode.carousel,
                onSelected: (_) => thema.setLayoutMode(LayoutMode.carousel),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Kacheln'),
                selected: thema.layoutMode == LayoutMode.grid,
                onSelected: (_) => thema.setLayoutMode(LayoutMode.grid),
              ),
            ],
          ),

          // Kachelgröße – Kompakt und in Wrap statt Row
          if (isGrid)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kachelgröße:'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('2 pro Reihe'),
                      selected: thema.gridCount == 2,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      onSelected: (_) => thema.setGridCount(2),
                    ),
                    ChoiceChip(
                      label: const Text('3 pro Reihe'),
                      selected: thema.gridCount == 3,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      onSelected: (_) => thema.setGridCount(3),
                    ),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 8),
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