// lib/fragments/diagnose_endkunde_fragment.dart
import 'package:flutter/material.dart';
import '../constants/strings.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_text_styles.dart';
import '../kern/theme/app_spacing.dart';
import '../widgets/app_scaffold.dart';

class DiagnoseEndkundeFragment extends StatelessWidget {
  const DiagnoseEndkundeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.diagnoseEndkunde,
      child: Padding(
        padding: AppSpacing.innenAll(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.diagnoseEndkundeEinleitung,
              style: AppTextStyles.wichtigeInfo(context),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.diagnoseEndkundeHinweis,
              style: AppTextStyles.ueberschrift(context),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.diagnoseEndkundeBeschreibung,
              style: AppTextStyles.standard(context),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Funktion folgt später
                },
                icon: const Icon(Icons.search),
                label: Text(AppStrings.fehlerAnalyseStarten),
              ),
            ),
          ],
        ),
      ),
    );
  }
}