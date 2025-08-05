// lib/kern/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Seed-Farbe zentral
  static const Color seed = Color(0xFF0066CC);

  // Theme-basierte Helfer
  static Color background(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color textPrimary(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color accent(BuildContext context) => Theme.of(context).colorScheme.primary;
  static Color error(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color card(BuildContext context) => Theme.of(context).colorScheme.surface;
}