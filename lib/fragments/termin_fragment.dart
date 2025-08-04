import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TerminFragment extends StatefulWidget {
  const TerminFragment({super.key});

  @override
  State<TerminFragment> createState() => _TerminFragmentState();
}

class _TerminFragmentState extends State<TerminFragment> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime.utc(2025, 8, 7): [
      {
        'title': 'Installation PV-Anlage',
        'time': '08:00 – 12:00',
        'role': 'Installateur',
        'location': 'Musterstraße 12, Berlin'
      }
    ],
    DateTime.utc(2025, 8, 10): [
      {
        'title': 'Planertermin Neubau',
        'time': '14:00 – 15:30',
        'role': 'Planer',
        'location': 'Online-Meeting'
      }
    ],
    DateTime.utc(2025, 8, 15): [
      {
        'title': 'Wartungstermin Kunde Meier',
        'time': '10:00 – 11:00',
        'role': 'Endkunde',
        'location': 'Gartenweg 5, Köln'
      }
    ],
  };

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Termine')),
      body: Column(
        children: [
          TableCalendar(
            locale: 'de_DE',
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text('Keine Termine für diesen Tag'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        tileColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Icon(Icons.event, color: Theme.of(context).colorScheme.primary),
                        title: Text(event['title']!),
                        subtitle: Text('${event['time']} – ${event['role']}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showEventDetails(context, event),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, String> event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(event['title']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [const Icon(Icons.access_time), const SizedBox(width: 8), Text(event['time']!)]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.person), const SizedBox(width: 8), Text(event['role']!)]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.location_on), const SizedBox(width: 8), Flexible(child: Text(event['location']!))]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}