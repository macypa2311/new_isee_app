import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatistikFragment extends StatelessWidget {
  const StatistikFragment({super.key});

  final List<double> beispielWerte = const [
    5.3, 4.7, 6.1, 7.0, 6.8, 3.9, 4.4  // Beispiel für Ertrag in kWh
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 8,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const wochentage = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
                    return Text(wochentage[value.toInt() % 7]);
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(beispielWerte.length, (index) {
              return BarChartGroupData(x: index, barRods: [
                BarChartRodData(
                  toY: beispielWerte[index],
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                )
              ]);
            }),
          ),
        ),
      ),
    );
  }
}