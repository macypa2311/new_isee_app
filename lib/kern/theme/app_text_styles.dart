import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle kachelTitel(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          );

  static TextStyle wichtigeInfo(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
          );

  static TextStyle ueberschrift(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!;

  static TextStyle standard(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;

  static TextStyle fett(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          );

  static TextStyle wichtig(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
          );

  static TextStyle klein(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;

  static TextStyle titelGross(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!;

  static TextStyle meldungFehler(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
          );

  static TextStyle textNormal(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;

  static TextStyle beschreibung(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          );
}