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
  final List<_CheckItem> _items = [
    _CheckItem('Ersatzstromversorgung prüfen'),
    _CheckItem('Notabschaltung erläutern'),
    _CheckItem('Kontaktnummern bereithalten'),
    _CheckItem('Erste-Hilfe-Kasten kontrollieren'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notfall-Checkliste')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (ctx, i) {
            final item = _items[i];
            return CheckboxListTile(
              value: item.done,
              title: Text(item.label),
              onChanged: (v) {
                setState(() => item.done = v!);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CheckItem {
  final String label;
  bool done;
  _CheckItem(this.label, {this.done = false});
}