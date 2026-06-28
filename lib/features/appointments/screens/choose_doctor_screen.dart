import 'package:flutter/material.dart';
import 'select_date_time_screen.dart';
import '../models/appointment_booking.dart';
import '../services/doctor_service.dart';

class ChooseDoctorScreen extends StatefulWidget {
  final AppointmentBooking booking;

  const ChooseDoctorScreen({super.key, required this.booking});

  @override
  State<ChooseDoctorScreen> createState() => _ChooseDoctorScreenState();
}

class _ChooseDoctorScreenState extends State<ChooseDoctorScreen> {
  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      final doctors = await DoctorService().getDoctors();

      print("========== DOCTORS ==========");
      print(doctors);
    } catch (e) {
      print("ERROR = $e");
    }
  }
  /* Future<void> loadDoctors() async {
    try {
      final doctors = await DoctorService().getDoctors();

      print("DOCTORS = $doctors");
    } catch (e) {
      print("ERROR = $e");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final doctors = [];

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
              "Choose Doctor",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Step 2 of 4",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFE6F0FF),
                      child: Image.asset("assets/images/doctor.jpg", width: 32),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor["name"].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            doctor["specialty"].toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),

                              Text(" ${doctor["rating"]}"),

                              const SizedBox(width: 10),

                              const Icon(
                                Icons.work_outline,
                                size: 16,
                                color: Colors.grey,
                              ),

                              Text(" ${doctor["experience"]}y"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: doctor["available"] == true
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        doctor["available"] == true ? "Available" : "Busy",
                        style: TextStyle(
                          color: doctor["available"] == true
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: doctor["available"] == true
                        ? () {
                            // السطر السحري اللي كان ناقص:
                            widget.booking.doctorId = doctor["id"].toString();

                            widget.booking.doctorName = doctor["name"]
                                .toString();
                            widget.booking.specialty = doctor["specialty"]
                                .toString();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SelectDateTimeScreen(
                                  booking: widget.booking,
                                ),
                              ),
                            );
                          }
                        : null,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A63F3),
                      disabledBackgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Select Doctor",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
