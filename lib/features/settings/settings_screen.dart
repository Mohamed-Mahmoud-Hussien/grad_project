import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grad_project/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> callHospital() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+201001234567');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Language / اللغة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              leading: Radio<String>(
                value: 'en',
                groupValue: MyApp.of(context)?.currentLocale ?? 'en',
                activeColor: const Color(0xFF0E73B8),
                onChanged: (val) {
                  MyApp.of(context)?.setLocale('en');
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text("العربية"),
              leading: Radio<String>(
                value: 'ar',
                groupValue: MyApp.of(context)?.currentLocale ?? 'en',
                activeColor: const Color(0xFF0E73B8),
                onChanged: (val) {
                  MyApp.of(context)?.setLocale('ar');
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = MyApp.of(context)?.currentLocale ?? 'en';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF0E73B8),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // ✅ Dark Mode
          SwitchListTile(
            value: isDark,
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            activeColor: const Color(0xFF0E73B8),
            onChanged: (value) {
              MyApp.of(context)?.toggleTheme(value);
            },
          ),
          const Divider(),

          // ✅ Language
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text(locale == 'ar' ? "العربية" : "English"),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLanguageDialog,
          ),
          const Divider(),

          // Contact Us
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Contact Us"),
            subtitle: const Text("+20 100 123 4567"),
            onTap: callHospital,
          ),
        ],
      ),
    );
  }
}