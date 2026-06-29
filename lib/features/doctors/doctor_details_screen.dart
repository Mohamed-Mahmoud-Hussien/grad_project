import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/screens/book_appointment_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDetailsScreen({super.key, required this.doctorData});

  String get doctorName => doctorData["userId"]?["fullName"] ?? "Unknown";
  String get specialty => doctorData["specialty"] ?? "";
  String get about =>
      doctorData["about"] ??
      "Experienced specialist dedicated to providing high-quality healthcare.";
  String get doctorId => doctorData["_id"]?.toString() ?? "";
  String get photo => doctorData["userId"]?["profilePhoto"] ?? "";
  String get department => doctorData["department"]?["name"] ?? specialty;

  // ✅ جيب أيام الشغل من الـ schedule
  String getWorkingHours() {
    final schedule = doctorData["schedule"];
    if (schedule == null) return "Not available";

    // ✅ الـ schedule ممكن يييجي Map أو List - نتعامل مع الحالتين
    List<String> workingDays = [];
    String startTime = "";
    String endTime = "";

    if (schedule is Map) {
      // لو جه كـ Map: { "sunday": { isWorking, startTime, endTime }, ... }
      final dayKeys = [
        "sunday",
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
      ];
      final dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
      for (int i = 0; i < dayKeys.length; i++) {
        final day = schedule[dayKeys[i]];
        if (day != null && day["isWorking"] == true) {
          workingDays.add(dayNames[i]);
          if (startTime.isEmpty) {
            startTime = day["startTime"]?.toString() ?? "";
            endTime = day["endTime"]?.toString() ?? "";
          }
        }
      }
    } else if (schedule is List) {
      // لو جه كـ List: [{ day, startTime, endTime, isWorking }, ...]
      for (final item in schedule) {
        if (item is Map && item["isWorking"] == true) {
          workingDays.add(item["day"]?.toString() ?? "");
          if (startTime.isEmpty) {
            startTime = item["startTime"]?.toString() ?? "";
            endTime = item["endTime"]?.toString() ?? "";
          }
        }
      }
    }

    if (workingDays.isEmpty) return "Not available";
    return "${workingDays.first} - ${workingDays.last}\n$startTime - $endTime";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Doctor Details"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor Header ──
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFFE8F1FB),
                    backgroundImage: photo.isNotEmpty
                        ? NetworkImage(photo)
                        : null,
                    child: photo.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF0E73B8),
                          )
                        : null,
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
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── Info Cards ──
            _infoCard(
              context,
              Icons.work_outline,
              "Experience",
              "${doctorData["experience"] ?? 0} Years",
            ),
            const SizedBox(height: 12),
            _infoCard(
              context,
              Icons.local_hospital_outlined,
              "Department",
              department,
            ),
            const SizedBox(height: 12),
            _infoCard(
              context,
              Icons.star_outline,
              "Performance Score",
              "${doctorData["performanceScore"] ?? 0} / 100",
            ),

            const SizedBox(height: 25),

            // ── About ──
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
              child: Text(
                about,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),

            const SizedBox(height: 25),

            // ── Working Hours ──
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
              child: Text(
                getWorkingHours(),
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),

            const SizedBox(height: 35),

            // ✅ Book Appointment Button → يروح لصفحة الحجز مباشرةً
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentScreen(
                        preSelectedDoctorId: doctorId,
                        preSelectedDoctorName: doctorName,
                        preSelectedSpecialty: specialty,
                        preSelectedDepartment: department,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
