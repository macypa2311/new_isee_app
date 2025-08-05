// lib/fragments/notfall_checkliste_fragment.dart

import 'package:flutter/material.dart';

class NotfallChecklisteFragment extends StatefulWidget {
  const NotfallChecklisteFragment({Key? key}) : super(key: key);

  @override
  _NotfallChecklisteFragmentState createState() =>
      _NotfallChecklisteFragmentState();
}

class _NotfallChecklisteFragmentState
    extends State<NotfallChecklisteFragment> {
  // Beispiel-Items für die Checkliste
  final List<_CheckItem> _items = [
    _CheckItem('Ersatzstromversorgung prüfen'),
    _CheckItem('Notabschaltung erläutern'),
    _CheckItem('Kontaktnummern bereithalten'),
    _CheckItem('Erste-Hilfe-Kasten kontrollieren'),
    _CheckItem('Werkzeug-Set komplettieren'),
    _CheckItem('Handbücher griffbereit legen'),
    _CheckItem('Sicherungen markiert anbringen'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notfall-Checkliste'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle:
            const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final item = _items[i];
            return CheckboxListTile(
              value: item.done,
              title: Text(item.label),
              onChanged: (val) {
                setState(() {
                  item.done = val ?? false;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

// Hilfsklasse für ein Listenelement
class _CheckItem {
  final String label;
  bool done;
  _CheckItem(this.label) : done = false;
}