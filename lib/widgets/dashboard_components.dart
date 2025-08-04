import 'package:flutter/material.dart';

class DashboardCardData {
  final String id;
  final String title;
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  const DashboardCardData({
    required this.id,
    required this.title,
    required this.icon,
    this.count = 0,
    required this.onTap,
  });
}

class DashboardCardCompact extends StatelessWidget {
  final DashboardCardData data;
  final Color background;
  final Color borderColor;

  const DashboardCardCompact({
    super.key,
    required this.data,
    required this.background,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1);
    final countStyle = Theme.of(context).textTheme.bodySmall?.copyWith(height: 1);

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              data.title,
              style: titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              data.count > 0 ? '${data.count} offen' : 'Keine offenen',
              style: countStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerCarousel extends StatelessWidget {
  final List<DashboardCardData> cards;
  final Color background;
  final Color borderColor;

  const CustomerCarousel({
    super.key,
    required this.cards,
    required this.background,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
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
                child: DashboardCardCompact(
                  data: card,
                  background: background,
                  borderColor: borderColor,
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
                    overlayColor.withAlpha((0.6 * 255).round()),
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