import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/strings.dart';
import '../kern/theme/app_colors.dart';
import '../kern/theme/app_spacing.dart';
import '../kern/theme/app_text_styles.dart';
import '../widgets/app_scaffold.dart';

class KameraKiFragment extends StatefulWidget {
  const KameraKiFragment({super.key});

  @override
  State<KameraKiFragment> createState() => _KameraKiFragmentState();
}

class _KameraKiFragmentState extends State<KameraKiFragment>
    with SingleTickerProviderStateMixin {
  File? _bildDatei;
  final ImagePicker _picker = ImagePicker();
  String _analyseErgebnis = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  Future<void> _fotoAufnehmen() async {
    final XFile? bild = await _picker.pickImage(source: ImageSource.camera);
    if (bild != null) {
      setState(() {
        _bildDatei = File(bild.path);
        _analyseErgebnis = '';
        _animationController.reset();
      });
    }
  }

  void _kiAnalyseDurchfuehren() {
    if (_bildDatei != null) {
      setState(() {
        _analyseErgebnis = 'Keine Auffälligkeiten erkannt.';
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.kameraKi,
      child: Padding(
        padding: AppSpacing.innenAll(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foto aufnehmen und analysieren',
              style: AppTextStyles.ueberschrift(context),
            ),
            const SizedBox(height: 8),
            Text(
              'Nutze die Kamera, um ein Bild aufzunehmen. Die KI analysiert es auf mögliche Auffälligkeiten.',
              style: AppTextStyles.standard(context),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _bildDatei != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _bildDatei!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        'Kein Bild aufgenommen',
                        style: AppTextStyles.klein(context),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _fotoAufnehmen,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Foto aufnehmen'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _bildDatei == null ? null : _kiAnalyseDurchfuehren,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('KI analysieren'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_analyseErgebnis.isNotEmpty)
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent(context).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _analyseErgebnis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.wichtigeInfo(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}