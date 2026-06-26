import 'package:flutter/material.dart';
import 'choose_doctor_screen.dart';
import '../models/appointment_booking.dart';


class ChooseDepartmentScreen extends StatelessWidget {
  const ChooseDepartmentScreen({super.key});

  Widget departmentCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
  final booking = AppointmentBooking(
    department: title,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChooseDoctorScreen(
        booking: booking,
      ),
    ),
  );
},
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 28),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Department",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Step 1 of 4",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            departmentCard(
              context: context,
              icon: Icons.favorite_border,
              color: Colors.redAccent,
              title: "Cardiology",
              subtitle: "Heart & vascular care",
            ),

            departmentCard(
              context: context,
              icon: Icons.psychology_outlined,
              color: Colors.deepPurpleAccent,
              title: "Neurology",
              subtitle: "Brain & nervous system",
            ),

            departmentCard(
              context: context,
              icon: Icons.auto_awesome,
              color: Colors.orange,
              title: "Dermatology",
              subtitle: "Skin, hair & nails",
            ),

            departmentCard(
              context: context,
              icon: Icons.accessibility_new,
              color: Colors.teal,
              title: "Orthopedics",
              subtitle: "Bones, joints & muscles",
            ),

            departmentCard(
              context: context,
              icon: Icons.child_care,
              color: Colors.lightBlue,
              title: "Pediatrics",
              subtitle: "Children's healthcare",
            ),

            departmentCard(
              context: context,
              icon: Icons.sentiment_satisfied_alt,
              color: Colors.indigoAccent,
              title: "Dentistry",
              subtitle: "Oral & dental care",
            ),
          ],
        ),
      ),
    );
  }
}
