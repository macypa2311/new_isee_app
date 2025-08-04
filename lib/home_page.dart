import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_controller.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landingpage'),
        actions: [
          IconButton(
            icon: Icon(
              controller.mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => controller.toggleQuick(),
            tooltip: 'Schnell umschalten',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsPage(
                    currentMode: controller.mode,
                    onThemeChanged: (mode) {
                      controller.setMode(mode);
                    },
                  ),
                ),
              );
            },
            tooltip: 'Einstellungen',
          ),
        ],
      ),
      body: const Center(
        child: Text('Hallo, Welt!'),
      ),
    );
  }
}