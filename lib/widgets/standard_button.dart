import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const StandardButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final thema = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: thema.colorScheme.primary,
        foregroundColor: thema.colorScheme.onPrimary,
        textStyle: thema.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      child: Text(label),
    );
  }
}