import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/screens/book_appointment_screen.dart';
//import 'package:grad_project/features/appointments/models/appointment_booking.dart';
import 'package:grad_project/features/doctors/doctor_details_screen.dart';
import 'package:grad_project/features/appointments/services/doctor_service.dart';

class SpecialtyDoctorsScreen extends StatefulWidget {
  final String specialty;
  const SpecialtyDoctorsScreen({super.key, required this.specialty});

  @override
  State<SpecialtyDoctorsScreen> createState() => _SpecialtyDoctorsScreenState();
}

class _SpecialtyDoctorsScreenState extends State<SpecialtyDoctorsScreen> {
  List<dynamic> doctors = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      final data = await DoctorService().getDoctors(specialty: widget.specialty);
      if (!mounted) return;
      setState(() {
        doctors = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.specialty),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : doctors.isEmpty
                  ? const Center(
                      child: Text("No doctors available for this specialty",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];
                        final name = doctor["userId"]?["fullName"] ?? "Unknown";
                        final specialty = doctor["specialty"] ?? widget.specialty;
                        final doctorId = doctor["_id"]?.toString() ?? "";
                        final photo = doctor["userId"]?["profilePhoto"] ?? "";

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorDetailsScreen(
                                doctorData: doctor,
                              ),
                            ),
                          ),
                          child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: const Color(0xFFE8F1FB),
                                    backgroundImage: photo.isNotEmpty
                                        ? NetworkImage(photo)
                                        : null,
                                    child: photo.isEmpty
                                        ? const Icon(Icons.person,
                                            size: 30, color: Color(0xFF0E73B8))
                                        : null,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17)),
                                        const SizedBox(height: 5),
                                        Text(specialty,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withValues(alpha: 0.7))),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // ✅ يروح لصفحة الحجز مباشرةً مع الدكتور محدد
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookAppointmentScreen(
                                            preSelectedDoctorId: doctorId,
                                            preSelectedDoctorName: name,
                                            preSelectedSpecialty: specialty,
                                            preSelectedDepartment: widget.specialty,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0E73B8)),
                                    child: const Text("Book",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}