import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:grad_project/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> callHospital() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+201001234567');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF0E73B8),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        children: [
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            onChanged: (value) {
              MyApp.of(context)?.toggleTheme(value);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("English"),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Contact Us"),
            subtitle: const Text("+20 100 123 4567"),
            onTap: () {
              callHospital();
            },
          ),
        ],
      ),
    );
  }
}
