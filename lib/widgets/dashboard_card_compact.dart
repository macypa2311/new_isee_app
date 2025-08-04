import 'package:flutter/material.dart';
import 'dashboard_card_data.dart';

class DashboardCardCompact extends StatelessWidget {
  final DashboardCardData data;
  final Color background;

  const DashboardCardCompact({
    super.key,
    required this.data,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1);
    final countStyle = Theme.of(context).textTheme.bodySmall?.copyWith(height: 1);

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
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
            Icon(
              data.icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
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