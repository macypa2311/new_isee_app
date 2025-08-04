import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../../kern/thema/thema_controller.dart';

class LandingAdmin extends StatelessWidget {
  const LandingAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final thema = context.watch<ThemaController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // einfache Theme-Umschaltung sichtbar machen
              showModalBottomSheet(
                context: context,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Darstellung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Hell'),
                            selected: !thema.isDark,
                            onSelected: (_) => thema.toggleDark(false),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Dunkel'),
                            selected: thema.isDark,
                            onSelected: (_) => thema.toggleDark(true),
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
                ),
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
      body: const Center(child: Text('Admin Landingpage (Platzhalter)')),
    );
  }
}