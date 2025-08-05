// lib/fragments/mail_fragment.dart
import 'package:flutter/material.dart';
import '../constants/strings.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';
import '../kern/theme/app_text_styles.dart';

class MailFragment extends StatelessWidget {
  const MailFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.background(context);
    final textColor = AppColors.textPrimary(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          AppStrings.mail,
          style: AppTextStyles.ueberschrift(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.mailEinleitung,
              style: AppTextStyles.wichtigeInfo(context),
            ),
            const SizedBox(height: AppSpacing.l),
            TextField(
              decoration: InputDecoration(
                labelText: AppStrings.mailAdresse,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            TextField(
              decoration: InputDecoration(
                labelText: AppStrings.mailPasswort,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: Text(AppStrings.mailAnmelden),
              onPressed: () {
                // TODO: Login-Logik
              },
            ),
          ],
        ),
      ),
    );
  }
}