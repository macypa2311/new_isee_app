import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double l = 24;
  static const double xl = 32;

  static EdgeInsets innenAll(BuildContext context) => const EdgeInsets.all(md);
  static EdgeInsets innenHorizontal(BuildContext context) => const EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets innenVertikal(BuildContext context) => const EdgeInsets.symmetric(vertical: md);

  static const EdgeInsets screenPaddingAll = EdgeInsets.all(md);
  static const EdgeInsets pagePaddingAll = EdgeInsets.all(md); // Ergänzt
}