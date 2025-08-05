import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';
import '../kern/theme/app_text_styles.dart';
import '../constants/strings.dart';
import '../widgets/app_scaffold.dart';

class VerbrauchFragment extends StatefulWidget {
  const VerbrauchFragment({super.key});

  @override
  State<VerbrauchFragment> createState() => _VerbrauchFragmentState();
}

class _VerbrauchFragmentState extends State<VerbrauchFragment> {
  double heute = 6.2;
  double woche = 34.7;
  double monat = 145.3;

  double heuteDiff = 12;
  double wocheDiff = -8;
  double monatDiff = 3;

  void _bearbeiten(String titel, double initialWert, ValueChanged<double> onSave) {
    final controller = TextEditingController(text: initialWert.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$titel bearbeiten', style: AppTextStyles.ueberschrift(context)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: 'kWh'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.'));
              if (value != null) {
                onSave(value);
                Navigator.pop(context);
              }
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  Widget _verbrauchBox({
    required IconData icon,
    required String titel,
    required double wert,
    required double differenz,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        border: Border.all(color: AppColors.accent(context).withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent(context), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titel, style: AppTextStyles.standard(context)),
                const SizedBox(height: 4),
                Text('${wert.toStringAsFixed(1)} kWh', style: AppTextStyles.fett(context)),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${differenz > 0 ? '+' : ''}${differenz.toStringAsFixed(0)} %',
                style: AppTextStyles.klein(context).copyWith(
                  color: differenz < 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _diagrammBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Verbrauchsdiagramm', style: AppTextStyles.ueberschrift(context)),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.6,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 160,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Heute');
                        case 1:
                          return const Text('Woche');
                        case 2:
                          return const Text('Monat');
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(toY: heute, color: AppColors.accent(context), width: 16),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(toY: woche, color: AppColors.accent(context), width: 16),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(toY: monat, color: AppColors.accent(context), width: 16),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.verbrauch,
      child: SingleChildScrollView(
        padding: AppSpacing.innenAll(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dein Energieverbrauch', style: AppTextStyles.ueberschrift(context)),
            const SizedBox(height: 24),
            _verbrauchBox(
              icon: Icons.flash_on,
              titel: 'Heute',
              wert: heute,
              differenz: heuteDiff,
              onEdit: () => _bearbeiten('Heute', heute, (wert) => setState(() => heute = wert)),
            ),
            _verbrauchBox(
              icon: Icons.view_week,
              titel: 'Diese Woche',
              wert: woche,
              differenz: wocheDiff,
              onEdit: () => _bearbeiten('Diese Woche', woche, (wert) => setState(() => woche = wert)),
            ),
            _verbrauchBox(
              icon: Icons.calendar_month,
              titel: 'Diesen Monat',
              wert: monat,
              differenz: monatDiff,
              onEdit: () => _bearbeiten('Diesen Monat', monat, (wert) => setState(() => monat = wert)),
            ),
            const SizedBox(height: 24),
            _diagrammBox(),
            const SizedBox(height: 16),
            Text(
              'Letzte Aktualisierung: vor 3 Minuten',
              style: AppTextStyles.klein(context),
            ),
          ],
        ),
      ),
    );
  }
}