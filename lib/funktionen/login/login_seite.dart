import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kern/auth/auth_controller.dart';
import '../../kern/theme/thema_controller.dart';

class LoginSeite extends StatefulWidget {
  const LoginSeite({super.key});

  @override
  State<LoginSeite> createState() => _LoginSeiteState();
}

class _LoginSeiteState extends State<LoginSeite> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  String? _error;

  bool get isDark => context.watch<ThemaController>().isDark;

  void _attemptLogin() async {
    try {
      print('Versuche Login mit: ${_user.text} / ${_pass.text}');
      await context.read<AuthController>().login(_user.text.trim(), _pass.text.trim());
    } catch (_) {
      setState(() {
        _error = "Login fehlgeschlagen";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login fehlgeschlagen")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keine AppBar, Fullscreen Login
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hintergrundbild (sicherstellen: asset vorhanden oder entfernen)
          Image.asset('assets/images/login_background.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.55)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "iSee Diagnose",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                          Shadow(blurRadius: 5, color: Colors.black87, offset: Offset(0, 2))
                        ]),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _user,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Benutzername',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.person, color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.white.withOpacity(0.1),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _pass,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Passwort',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.white.withOpacity(0.1),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _attemptLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.tealAccent.shade400,
                            foregroundColor: Colors.black87,
                            elevation: 8,
                            shadowColor: Colors.tealAccent.shade700,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 20),
                        Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Hell/Dunkel wechseln',
                            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
                            onPressed: () {
                              final tc = context.read<ThemaController>();
                           final thema = context.read<ThemaController>();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}