import 'package:flutter/material.dart';

extension TextileExtensions on TextTheme {
  TextStyle get kachelTitel => titleMedium!.copyWith(letterSpacing: 0.5);
  TextStyle get wichtigeInfo => bodyMedium!.copyWith(fontWeight: FontWeight.w600);
  TextStyle get ueberschrift => headlineSmall!;
}