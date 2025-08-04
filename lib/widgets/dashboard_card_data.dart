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
  }) : assert(count >= 0, 'count darf nicht negativ sein');
}