import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../../kern/thema/thema_controller.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Darstellung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _buildRow(
            label: 'Modus:',
            children: [
              ChoiceChip(
                label: const Text('Hell', style: TextStyle(fontSize: 13)),
                selected: !thema.isDark,
                onSelected: (_) => thema.setDarkMode(false),
              ),
              ChoiceChip(
                label: const Text('Dunkel', style: TextStyle(fontSize: 13)),
                selected: thema.isDark,
                onSelected: (_) => thema.setDarkMode(true),
              ),
            ],
          ),

          _buildRow(
            label: 'Farbe:',
            children: [
              ChoiceChip(
                label: const Text('Blau', style: TextStyle(fontSize: 13)),
                selected: thema.accentChoice == 'blue',
                onSelected: (_) => thema.setAccent('blue'),
              ),
              ChoiceChip(
                label: const Text('Grün', style: TextStyle(fontSize: 13)),
                selected: thema.accentChoice == 'green',
                onSelected: (_) => thema.setAccent('green'),
              ),
              ChoiceChip(
                label: const Text('Rot', style: TextStyle(fontSize: 13)),
                selected: thema.accentChoice == 'red',
                onSelected: (_) => thema.setAccent('red'),
              ),
            ],
          ),

          _buildRow(
            label: 'Ansicht:',
            children: [
              ChoiceChip(
                label: const Text('Karussell', style: TextStyle(fontSize: 13)),
                selected: thema.layoutMode == LayoutMode.carousel,
                onSelected: (_) => thema.setLayoutMode(LayoutMode.carousel),
              ),
              ChoiceChip(
                label: const Text('Kacheln', style: TextStyle(fontSize: 13)),
                selected: thema.layoutMode == LayoutMode.grid,
                onSelected: (_) => thema.setLayoutMode(LayoutMode.grid),
              ),
            ],
          ),

          _buildRow(
            label: 'Kachelgröße:',
            children: [
              ChoiceChip(
                label: const Text('2 pro Reihe', style: TextStyle(fontSize: 13)),
                selected: thema.gridCount == 2,
                onSelected: (_) => thema.setGridCount(2),
              ),
              ChoiceChip(
                label: const Text('3 pro Reihe', style: TextStyle(fontSize: 13)),
                selected: thema.gridCount == 3,
                onSelected: (_) => thema.setGridCount(3),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                context.read<AuthController>().logout();
                Navigator.of(context).pop();
              },
              child: const Text('Abmelden'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required String label, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          ...children,
        ],
      ),
    );
  }
}