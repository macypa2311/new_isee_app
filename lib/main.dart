import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString('themeMode') ?? 'system';
  ThemeMode initialMode;
  if (stored == 'light') {
    initialMode = ThemeMode.light;
  } else if (stored == 'dark') {
    initialMode = ThemeMode.dark;
  } else {
    initialMode = ThemeMode.system;
  }
  runApp(MyApp(initialMode: initialMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialMode;
  const MyApp({super.key, this.initialMode = ThemeMode.system});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialMode;
  }

  Future<void> _setMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    String val;
    if (mode == ThemeMode.light) {
      val = 'light';
    } else if (mode == ThemeMode.dark) {
      val = 'dark';
    } else {
      val = 'system';
    }
    await prefs.setString('themeMode', val);
  }

  void _toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _setMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      _setMode(ThemeMode.light);
    } else {
      _setMode(ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Themen Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Themenwechsel'),
          actions: [
            IconButton(
              icon: Icon(
                _themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: _toggleTheme,
              tooltip: 'Thema umschalten',
            ),
          ],
        ),
        body: const Center(
          child: Text('Hallo, Welt!'),
        ),
      ),
    );
  }
}