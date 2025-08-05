// lib/fragments/lastprofil_fragment.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:csv/csv.dart';

class LastprofilFragment extends StatefulWidget {
  const LastprofilFragment({Key? key}) : super(key: key);

  @override
  _LastprofilFragmentState createState() => _LastprofilFragmentState();
}

class _LastprofilFragmentState extends State<LastprofilFragment> {
  List<List<dynamic>>? _rows;
  String? _fileName;
  String? _error;

  Future<void> _pickCsv() async {
    setState(() {
      _error = null;
    });
    try {
      // öffne Dateiauswahl für CSV
      final typeGroup = XTypeGroup(label: 'CSV', extensions: ['csv']);
      final files = await openFiles(acceptedTypeGroups: [typeGroup]);
      if (files.isEmpty) return;

      // lade erstes File
      final XFile xfile = files.first;
      final content = await xfile.readAsString();

      // parse CSV
      final csvRows = const CsvToListConverter().convert(content);

      setState(() {
        _rows = csvRows;
        _fileName = xfile.name;
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Einlesen der Datei: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lastprofil hochladen'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('CSV-Datei auswählen'),
              onPressed: _pickCsv,
            ),
            const SizedBox(height: 12),
            if (_fileName != null) Text('Datei: $_fileName'),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            Expanded(
              child: _rows == null
                  ? const Center(child: Text('Noch kein Lastprofil geladen.'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: _rows!.first
                            .map((h) => DataColumn(label: Text(h.toString())))
                            .toList(),
                        rows: _rows!
                            .skip(1)
                            .map((r) => DataRow(
                                  cells: r
                                      .map((c) =>
                                          DataCell(Text(c.toString())))
                                      .toList(),
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}