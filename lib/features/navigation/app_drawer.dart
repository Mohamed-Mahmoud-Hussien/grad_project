import 'package:flutter/material.dart';
import 'package:grad_project/features/settings/settings_screen.dart';
import 'package:grad_project/features/auth/screens/login_screen.dart';
import 'package:grad_project/features/records/medical_records_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentPage;

  const AppDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Abdulrahman"),
            accountEmail: Text("PT-2035-001"),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),

            selected: currentPage == "Home",
            selectedTileColor: Colors.blue.shade50,
            selectedColor: const Color(0xFF0E73B8),

            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),

            selected: currentPage == "Settings",
            selectedTileColor: Colors.blue.shade50,
            selectedColor: const Color(0xFF0E73B8),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Medical Records"),

            selected: currentPage == "Records",
            selectedTileColor: Colors.blue.shade50,
            selectedColor: const Color(0xFF0E73B8),

            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedicalRecordsScreen()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
