import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/theme/thema_controller.dart';

class SettingsDarstellung extends StatelessWidget {
  const SettingsDarstellung({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.transparent,
        elevation: 0,
        title: Text(
          'Darstellung',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 16,
          children: [
            // Modus (Hell/Dunkel)
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

            // Farbe (Accent Color)
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

            // Kachelgröße (2 oder 3 pro Reihe)
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
          ],
        ),
      ),
    );
  }
}