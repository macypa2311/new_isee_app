import 'package:flutter/material.dart';

class InfoFragment extends StatelessWidget {
  const InfoFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info & Anleitung')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          InfoSection(
            title: '🔧 Admin-Bereich',
            content: '''
• Benutzerrollen verwalten (Planer, Installateure, Endkunden)
• Diagnosefunktionen und Fehlercodes bereitstellen
• PDF-Dokumente und Anleitungen hochladen
• Statistiken und Gerätestände einsehen
• Backups sichern und wiederherstellen
• Einstellungen für Theme, Layout, Rechte uvm.
''',
          ),
          InfoSection(
            title: '📐 Planer-Bereich',
            content: '''
• Projekte erstellen und Geräte zuweisen
• Wirtschaftlichkeitsrechner (optional)
• Zugriff auf technische PDF-Daten
• Terminkoordination mit Installateuren
• Kontaktverwaltung für Hersteller und Partner
''',
          ),
          InfoSection(
            title: '🔧 Installateur-Bereich',
            content: '''
• Diagnosetool für Wechselrichter, Batterie, Smart Meter
• Zugriff auf Kamera-Funktion für Dokumentation
• Kontakt- und Herstellersupport integriert
• Geräteverwaltung und Inbetriebnahmehilfe
• Arbeitszeiten und Termine verwalten
''',
          ),
          InfoSection(
            title: '👤 Endkunden-Bereich',
            content: '''
• Fehlerdiagnose einfach erklärt
• Direktzugriff auf Anleitungen & Support
• Verbrauchsübersicht (optional)
• Kontaktaufnahme mit Installateur oder Hersteller
• Terminabsprachen und Nachrichtenfunktion
''',
          ),
          SizedBox(height: 32),
          Text(
            'Diese App wurde entwickelt, um alle Beteiligten rund um die Installation und Wartung von PV-Anlagen, Wärmepumpen und Smart Energy optimal zu vernetzen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const InfoSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}