import 'package:flutter/material.dart';

class VerbrauchFragment extends StatelessWidget {
  const VerbrauchFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _VerbrauchCard(
        title: 'Heute',
        icon: Icons.bolt,
        amount: '6.2 kWh',
        difference: '+12 %',
        color: Colors.orange,
      ),
      _VerbrauchCard(
        title: 'Diese Woche',
        icon: Icons.calendar_view_week,
        amount: '34.7 kWh',
        difference: '-8 %',
        color: Colors.blue,
      ),
      _VerbrauchCard(
        title: 'Diesen Monat',
        icon: Icons.calendar_month,
        amount: '145.3 kWh',
        difference: '+3 %',
        color: Colors.green,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Verbrauch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dein Energieverbrauch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => cards[index],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Letzte Aktualisierung: vor 3 Minuten'),
          ],
        ),
      ),
    );
  }
}

class _VerbrauchCard extends StatelessWidget {
  final String title;
  final String amount;
  final String difference;
  final IconData icon;
  final Color color;

  const _VerbrauchCard({
    required this.title,
    required this.amount,
    required this.difference,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(amount, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Text(
            difference,
            style: TextStyle(
              color: difference.startsWith('+') ? Colors.red : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}