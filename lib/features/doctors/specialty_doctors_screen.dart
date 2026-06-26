import 'package:flutter/material.dart';
import 'doctor_details_screen.dart';

class SpecialtyDoctorsScreen extends StatelessWidget {
  final String specialty;

  const SpecialtyDoctorsScreen({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> doctorsBySpecialty = {
      "Cardiology": ["Dr. Ahmed Mohamed", "Dr. Mahmoud Ali", "Dr. Sara Hassan"],

      "Neurology": ["Dr. Mohamed Adel", "Dr. Omar Hassan", "Dr. Youssef Ali"],

      "Dental": ["Dr. Mariam Ahmed", "Dr. Nada Mohamed", "Dr. Salma Ali"],

      "Orthopedic": ["Dr. Khaled Hassan", "Dr. Mostafa Ahmed", "Dr. Tarek Ali"],

      "Eye": ["Dr. Hany Mahmoud", "Dr. Islam Adel", "Dr. Ahmed Samir"],

      "Pediatrics": ["Dr. Mona Hassan", "Dr. Reham Ahmed", "Dr. Noha Ali"],
    };

    final doctors = doctorsBySpecialty[specialty] ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text(specialty),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,

        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorDetailsScreen(
                    doctorName: doctors[index],
                    specialty: specialty,
                  ),
                ),
              );
            },
            child: _doctorCard(context, doctors[index], specialty),
          );
        },
      ),
    );
  }

  Widget _doctorCard(
    BuildContext context,
    String doctorName,
    String specialty,
  ) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFE8F1FB),

              child: Icon(Icons.person, size: 30, color: Color(0xFF0E73B8)),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    specialty,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 5),

                  
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E73B8),
              ),

              child: const Text("Book", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
