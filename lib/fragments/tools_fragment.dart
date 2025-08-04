import 'package:flutter/material.dart';

class ToolsFragment extends StatelessWidget {
  const ToolsFragment({super.key});

  final List<Map<String, dynamic>> tools = const [
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
      'title': 'Fördermittelprüfung',
      'icon': Icons.euro_symbol,
      'premium': true,
    },
    {
      'title': 'Notfall-Checkliste',
      'icon': Icons.warning,
      'premium': true,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tool "${item['title']}" geöffnet')),
                );
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
                  Icon(item['icon'], size: 36, color: isPremium ? Colors.amber : Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    item['title'],
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