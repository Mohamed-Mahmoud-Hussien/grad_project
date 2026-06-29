import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/models/appointment_booking.dart';
import 'package:grad_project/features/appointments/screens/choose_department_screen.dart';
import 'package:grad_project/features/appointments/screens/select_date_time_screen.dart';

class BookAppointmentScreen extends StatelessWidget {
  // ✅ لو جه من doctor details أو specialty screen، بييجي بيانات الدكتور جاهزة
  final String? preSelectedDoctorId;
  final String? preSelectedDoctorName;
  final String? preSelectedSpecialty;
  final String? preSelectedDepartment;

  const BookAppointmentScreen({
    super.key,
    this.preSelectedDoctorId,
    this.preSelectedDoctorName,
    this.preSelectedSpecialty,
    this.preSelectedDepartment,
  });

  bool get hasPreSelectedDoctor =>
      preSelectedDoctorId != null && preSelectedDoctorId!.isNotEmpty;

  Widget buildStep({required String number, required String title, bool done = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: done ? Colors.green.shade100 : const Color(0xFFE8F3FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, color: Colors.green, size: 18)
                  : Text(number,
                      style: const TextStyle(
                          color: Color(0xFF3563E9), fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: done ? Colors.grey : Colors.black)),
          ),
          Icon(
            done ? Icons.check_circle : Icons.arrow_forward_ios,
            size: 16,
            color: done ? Colors.green : Colors.grey,
          ),
        ],
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
        title: const Text("Book Appointment",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                    colors: [Color(0xFF3B6EF6), Color(0xFF2F46D8)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.medical_services_outlined,
                      color: Colors.white, size: 30),
                  const SizedBox(height: 16),
                  const Text("Find the right care",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // ✅ لو في دكتور محدد، اعرض اسمه
                  if (hasPreSelectedDoctor)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            preSelectedDoctorName ?? "",
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "• ${preSelectedSpecialty ?? ""}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text(
                      "Choose a department, pick a doctor, and select a time slot.",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Steps ──
            // لو في دكتور محدد، الخطوتين الأوليين خلصوا
            buildStep(number: "1", title: "Choose Department",
                done: hasPreSelectedDoctor),
            buildStep(number: "2", title: "Choose Doctor",
                done: hasPreSelectedDoctor),
            buildStep(number: "3", title: "Select Date & Time"),
            buildStep(number: "4", title: "Confirm Booking"),

            const Spacer(),

            // ── Button ──
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (hasPreSelectedDoctor) {
                    // ✅ لو في دكتور محدد → روح لـ SelectDateTime مباشرةً
                    final booking = AppointmentBooking(
                      doctorId:        preSelectedDoctorId,
                      doctorName:      preSelectedDoctorName,
                      specialty:       preSelectedSpecialty,
                      department:      preSelectedDepartment,
                      appointmentType: "consultation",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectDateTimeScreen(booking: booking),
                      ),
                    );
                  } else {
                    // مفيش دكتور محدد → ابدأ من الخطوة الأولى
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChooseDepartmentScreen()),
                    );
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  hasPreSelectedDoctor ? "Select Date & Time" : "Start Booking",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3563E9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}