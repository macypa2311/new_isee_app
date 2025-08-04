import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportFragment extends StatelessWidget {
  const SupportFragment({super.key});

  final String supportEmail = 'support@isee-energy.app';
  final String supportPhone = '+49 89 12345678';
  final String supportTimes = 'Mo–Fr, 9:00–17:00 Uhr';

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=Supportanfrage',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _callPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: supportPhone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Support & Kontakt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Du brauchst Hilfe?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined),
                        const SizedBox(width: 8),
                        Text(supportEmail),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined),
                        const SizedBox(width: 8),
                        Text(supportPhone),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Text('Erreichbar: $supportTimes'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('E-Mail schreiben'),
              onPressed: _sendEmail,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text('Anrufen'),
              onPressed: _callPhone,
              style: ElevatedButton.styleFrom(backgroundColor: colorScheme.secondary),
            ),
            const SizedBox(height: 30),
            Text(
              'Hinweis: Ein integriertes Kontaktformular oder Chatmodul folgt in einer späteren Version.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}