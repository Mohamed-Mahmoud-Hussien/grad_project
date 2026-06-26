import 'package:flutter/material.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String doctorName;
  final String specialty;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorName,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(title: const Text("Doctor Details"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFE8F1FB),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF0E73B8),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    doctorName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    specialty,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _infoCard(context, Icons.work_outline, "Experience", "12 Years"),

            const SizedBox(height: 12),

            _infoCard(
              context,
              Icons.location_on_outlined,
              "Clinic",
              "Tamkeen Hospital",
            ),

            const SizedBox(height: 12),

            _infoCard(
              context,
              Icons.meeting_room_outlined,
              "Room Number",
              "203",
            ),

            const SizedBox(height: 25),

            const Text(
              "About Doctor",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Text(
                "Experienced specialist with extensive experience in diagnosing and treating patients. Dedicated to providing high-quality healthcare and personalized treatment plans.",
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Working Hours",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saturday - Thursday",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text("09:00 AM - 05:00 PM"),
                ],
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Booking for $doctorName will be connected later",
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.calendar_month),

                label: const Text(
                  "Book Appointment",
                  style: TextStyle(fontSize: 16),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E73B8),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0E73B8)),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
