import 'package:flutter/material.dart';
import 'dashboard_card_data.dart';
import 'dashboard_card_compact.dart';

extension OpacityFix on Color {
  Color withOpacityFix(double opacity) =>
      withAlpha((opacity * 255).round().clamp(0, 255));
}

class CustomerCarousel extends StatelessWidget {
  final List<DashboardCardData> cards;

  const CustomerCarousel({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(
          child: Text('Keine Karten verfügbar'),
        ),
      );
    }

    final overlayColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withAlpha((0.3 * 255).round())
        : Colors.white.withAlpha((0.8 * 255).round());

    return SizedBox(
      height: 110,
      child: Stack(
        children: [
          ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final card = cards[index];
              return SizedBox(
                width: 100,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: DashboardCardCompact(
                    data: card,
                    background: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    overlayColor.withAlpha(0),
                    overlayColor.withAlpha(150),
                    overlayColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}