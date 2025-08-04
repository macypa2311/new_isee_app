import 'package:flutter/material.dart';

class Nutzer {
  String name;
  String email;
  String rolle;

  Nutzer({required this.name, required this.email, required this.rolle});
}

class NutzerverwaltungsFragment extends StatefulWidget {
  const NutzerverwaltungsFragment({super.key});

  @override
  State<NutzerverwaltungsFragment> createState() => _NutzerverwaltungsFragmentState();
}

class _NutzerverwaltungsFragmentState extends State<NutzerverwaltungsFragment> {
  List<Nutzer> _alleNutzer = [
    Nutzer(name: 'Anna Müller', email: 'anna@example.com', rolle: 'Installateur'),
    Nutzer(name: 'Peter Schulz', email: 'peter@example.com', rolle: 'Endkunde'),
    Nutzer(name: 'Lisa Hoffmann', email: 'lisa@example.com', rolle: 'Planer'),
  ];

  String _suchbegriff = '';
  String _rollenFilter = 'Alle';

  final _rollen = ['Alle', 'Installateur', 'Endkunde', 'Planer', 'Admin'];

  @override
  Widget build(BuildContext context) {
    final gefilterteNutzer = _alleNutzer.where((nutzer) {
      final matchesSuchbegriff = nutzer.name.toLowerCase().contains(_suchbegriff.toLowerCase());
      final matchesRolle = _rollenFilter == 'Alle' || nutzer.rolle == _rollenFilter;
      return matchesSuchbegriff && matchesRolle;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutzerverwaltung'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _neuenNutzerAnlegen,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nutzer suchen...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() => _suchbegriff = value),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _rollenFilter,
                  items: _rollen.map((rolle) => DropdownMenuItem(value: rolle, child: Text(rolle))).toList(),
                  onChanged: (value) => setState(() => _rollenFilter = value!),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: gefilterteNutzer.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final nutzer = gefilterteNutzer[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(nutzer.name),
                  subtitle: Text('${nutzer.email} • ${nutzer.rolle}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'Bearbeiten':
                          _bearbeiteNutzer(nutzer);
                          break;
                        case 'Rolle ändern':
                          _rolleAendern(nutzer);
                          break;
                        case 'Löschen':
                          _nutzerLoeschen(nutzer);
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'Bearbeiten', child: Text('Bearbeiten')),
                      const PopupMenuItem(value: 'Rolle ändern', child: Text('Rolle ändern')),
                      const PopupMenuItem(value: 'Löschen', child: Text('Löschen')),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _neuenNutzerAnlegen() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String rolle = 'Endkunde';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Neuen Nutzer anlegen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'E-Mail')),
            DropdownButton<String>(
              value: rolle,
              isExpanded: true,
              items: _rollen.where((r) => r != 'Alle').map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (value) => setState(() => rolle = value!),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _alleNutzer.add(Nutzer(
                  name: nameController.text,
                  email: emailController.text,
                  rolle: rolle,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _bearbeiteNutzer(Nutzer nutzer) {
    final nameController = TextEditingController(text: nutzer.name);
    final emailController = TextEditingController(text: nutzer.email);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nutzer bearbeiten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'E-Mail')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                nutzer.name = nameController.text;
                nutzer.email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _rolleAendern(Nutzer nutzer) {
    String neueRolle = nutzer.rolle;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rolle ändern'),
        content: DropdownButton<String>(
          value: neueRolle,
          isExpanded: true,
          items: _rollen.where((r) => r != 'Alle').map((rolle) => DropdownMenuItem(value: rolle, child: Text(rolle))).toList(),
          onChanged: (value) => setState(() => neueRolle = value!),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () {
              setState(() => nutzer.rolle = neueRolle);
              Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _nutzerLoeschen(Nutzer nutzer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nutzer löschen'),
        content: Text('Soll ${nutzer.name} wirklich gelöscht werden?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          ElevatedButton(
            onPressed: () {
              setState(() => _alleNutzer.remove(nutzer));
              Navigator.pop(context);
            },
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }
}