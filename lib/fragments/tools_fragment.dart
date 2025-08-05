// lib/fragments/tools_fragment.dart

import 'package:flutter/material.dart';

// Importe für alle Tools:
import 'wirtschaftlichkeitsrechner_fragment.dart';
import 'ertragssimulation_fragment.dart';
import 'standortanalyse_fragment.dart';
import 'lastprofil_fragment.dart';
import 'speicherplanungs_fragment.dart';
import 'foerdermittelpruefung_fragment.dart';  // ← hier importieren


class ToolsFragment extends StatelessWidget {
  const ToolsFragment({super.key});

  static const List<Map<String, dynamic>> tools = [
    {
      'title': 'Wirtschaftlichkeitsrechner',
      'icon': Icons.calculate,
      'premium': false,
    },
    {
      'title': 'Ertragssimulation',
      'icon': Icons.stacked_line_chart,
      'premium': false,
    },
    {
      'title': 'Standortanalyse',
      'icon': Icons.place,
      'premium': false,
    },
    {
      'title': 'Lastprofil hochladen',
      'icon': Icons.upload_file,
      'premium': false,
    },
    {
      'title': 'Speicherplanung',
      'icon': Icons.battery_charging_full,
      'premium': false,
    },
    {
      'title': 'Fördermittelprüfung',  // ← Tool in der Liste
      'icon': Icons.euro_symbol,
      'premium': false,
    },
    {
      'title': 'Notfall-Checkliste',
      'icon': Icons.warning,
      'premium': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tools')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = tools[index];
          final isPremium = item['premium'] == true;

          return GestureDetector(
            onTap: () {
              if (isPremium) {
                _showPremiumDialog(context);
              } else {
                _openTool(context, item['title'] as String);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPremium ? Colors.amber : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 36,
                    color: isPremium
                        ? Colors.amber
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (isPremium)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.lock, size: 18, color: Colors.grey),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openTool(BuildContext context, String title) {
    late Widget page;
    switch (title) {
      case 'Wirtschaftlichkeitsrechner':
        page = const WirtschaftlichkeitsrechnerFragment();
        break;
      case 'Ertragssimulation':
        page = const ErtragssimulationFragment();
        break;
      case 'Standortanalyse':
        page = const StandortanalyseFragment();
        break;
      case 'Lastprofil hochladen':
        page = const LastprofilFragment();
        break;
      case 'Speicherplanung':
        page = const SpeicherplanungsFragment();
        break;
      case 'Fördermittelprüfung':                         // ← neu
        page = const FoerdermittelpruefungFragment();    // ← hier öffnen
        break;                                           // ← nicht vergessen
      // case 'Notfall-Checkliste':
      //   page = const NotfallChecklisteFragment();
      //   break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tool „$title“ ist nicht verfügbar')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Premium-Tool'),
        content: const Text('Dieses Tool ist nur für Premium-Nutzer verfügbar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}