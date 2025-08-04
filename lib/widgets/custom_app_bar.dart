// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/thema_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ThemaController thema;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.thema,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: thema.isDark
          ? AppFarben.background(context)
          : AppFarben.background(context),
      elevation: 0,
      iconTheme: IconThemeData(
        color: thema.isDark ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: thema.isDark ? Colors.white : Colors.black,
          fontSize: 20,
        ),
      ),
      actions: actions,
      toolbarHeight: 70,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}