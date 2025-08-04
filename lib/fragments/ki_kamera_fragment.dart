import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class KameraKiFragment extends StatefulWidget {
  const KameraKiFragment({Key? key}) : super(key: key);

  @override
  _KameraKiFragmentState createState() => _KameraKiFragmentState();
}

class _KameraKiFragmentState extends State<KameraKiFragment> {
  File? _selectedImage;
  String _analyseErgebnis = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _analyseErgebnis = ''; // Reset previous result
      });
    }
  }

  void _analysiereBild() {
    // TODO: Hier deine KI-Integration einfügen
    setState(() {
      _analyseErgebnis = 'Vorschlag: Optimaler Modul-Ausschnitt in der oberen Dachhälfte';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera-KI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Foto deiner Dachfläche aufnehmen und KI-Vorschlag erhalten.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _selectedImage == null
                ? const Text('Noch kein Foto ausgewählt.')
                : Image.file(_selectedImage!),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Foto aufnehmen'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _selectedImage != null ? _analysiereBild : null,
                  icon: const Icon(Icons.analytics),
                  label: const Text('KI analysieren'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_analyseErgebnis.isNotEmpty)
              Text(
                _analyseErgebnis,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}