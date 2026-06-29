import 'package:flutter/material.dart';
import 'package:grad_project/features/home/home_screen.dart';
import 'package:grad_project/features/profile/profile_screen.dart';
import 'package:grad_project/features/appointments/screens/appointments_screen.dart';
import 'package:grad_project/features/reports/reports_screen.dart';
import 'package:grad_project/features/records/medical_records_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int currentIndex;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    // ✅ بنبني الـ screens مرة واحدة بس في initState
    screens = [
      HomeScreen(
        onGoToMedical: () {
          if (mounted) setState(() => currentIndex = 2);
        },
      ),
      const ReportsScreen(),
      const MedicalRecordsScreen(),
      const AppointmentsScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF0E73B8),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined),
            activeIcon: Icon(Icons.medical_information),
            label: "Medical",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: "Appointments",
          ),
        ],
      ),
    );
  }
}
