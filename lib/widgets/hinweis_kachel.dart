import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../kern/theme/app_colors.dart';
import '../kern/theme/thema_controller.dart';

class HinweisKachel extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const HinweisKachel({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thema = context.watch<ThemaController>();
    final brightness = Theme.of(context).brightness;

    final backgroundColor = brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : AppColors.card(context);
    final borderColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.shade300;
    final iconColor = thema.accentColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}