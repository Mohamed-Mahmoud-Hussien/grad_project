import 'package:flutter/material.dart';
import '../models/appointment_booking.dart';
import 'appointment_success_screen.dart';
import '../models/appointment_storage.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final AppointmentBooking booking;

  const ConfirmBookingScreen({super.key, required this.booking});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  String selectedType = "Consultation";

  Widget appointmentTypeCard({required String title, required IconData icon}) {
    final bool isSelected = selectedType == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = title;
          widget.booking.appointmentType = title;
        });
      },

      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A63F3) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFD8E4FF)),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),

            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookingInfo(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EDF5))),
      ),

      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),

          const Spacer(),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Confirm Booking",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "Step 5 of 5",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: [
                  bookingInfo("Department", widget.booking.department ?? ""),

                  bookingInfo("Doctor", widget.booking.doctorName ?? ""),

                  bookingInfo(
                    "Date",
                    widget.booking.date == null
                        ? ""
                        : "${widget.booking.date!.day}/${widget.booking.date!.month}/${widget.booking.date!.year}",
                  ),

                  bookingInfo("Time", widget.booking.time ?? ""),

                  bookingInfo("Type", selectedType),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Appointment Type",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 14),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.7,
              children: [
                appointmentTypeCard(
                  title: "Consultation",
                  icon: Icons.medical_services,
                ),

                appointmentTypeCard(title: "Follow Up", icon: Icons.refresh),

                appointmentTypeCard(title: "Telemedicine", icon: Icons.laptop),

                appointmentTypeCard(
                  title: "Surgery",
                  icon: Icons.local_hospital,
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEEFF),
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Row(
                children: [
                  Icon(Icons.info, color: Color(0xFF3A63F3)),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Your booking request will be reviewed and confirmed by the reception team.",
                      style: TextStyle(color: Color(0xFF3A63F3)),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                onPressed: () {
                  widget.booking.status = "Requested";
                  AppointmentStorage.appointments.add(widget.booking);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentSuccessScreen(),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A63F3),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
