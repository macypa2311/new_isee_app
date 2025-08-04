// lib/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;

  const AppScaffold({
    Key? key,
    required this.child,
    this.title,
    this.actions,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: title != null
            ? Text(
                title!,
                style: TextStyle(color: textColor),
              )
            : null,
        automaticallyImplyLeading: showBackButton,
        iconTheme: IconThemeData(color: textColor),
        actions: actions,
      ),
      body: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: child,
      ),
    );
  }
}