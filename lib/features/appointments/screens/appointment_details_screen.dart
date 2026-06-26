import 'package:flutter/material.dart';
import '../models/appointment_booking.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final AppointmentBooking appointment;

  AppointmentDetailsScreen({super.key, required this.appointment});

  int getCurrentStep() {
    switch (appointment.status ?? "Requested") {
      case "Requested":
        return 1;
      case "Approved":
        return 2;
      case "Scheduled":
        return 3;
      case "Waiting":
        return 4;
      case "With Doctor":
        return 5;
      case "Completed":
        return 6;
      default:
        return 1;
    }
  }

  final List<String> steps = [
    "Requested",
    "Approved",
    "Scheduled",
    "Waiting",
    "With Doctor",
    "Completed",
  ];

  Widget buildProgressTimeline() {
    final currentStep = getCurrentStep();

    return Column(
      children: List.generate(steps.length, (index) {
        final stepNumber = index + 1;
        final completed = stepNumber <= currentStep;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: completed
                      ? const Color(0xFF3563E9)
                      : Colors.grey.shade300,
                  child: completed
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : Text(
                          "$stepNumber",
                          style: const TextStyle(fontSize: 10),
                        ),
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 35,
                    color: completed
                        ? const Color(0xFF3563E9)
                        : Colors.grey.shade300,
                  ),
              ],
            ),

            const SizedBox(width: 12),

            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                steps[index],
                style: TextStyle(
                  fontWeight: completed ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),

          const Spacer(),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget doctorHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B6EF6), Color(0xFF2F46D8)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctorName ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  appointment.specialty ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: title == "STATUS"
                  ? const Color(0xFF3563E9)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget canceledCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F3),
          borderRadius: BorderRadius.circular(20),
        ),

        child: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFFF2D55),
              child: Icon(Icons.close, color: Colors.white),
            ),

            SizedBox(width: 12),

            Text(
              "Appointment Canceled",
              style: TextStyle(
                color: Color(0xFFFF2D55),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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
        title: const Text("Appointment Details"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          doctorHeader(),

          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              infoCard("TYPE", appointment.appointmentType),

              infoCard("STATUS", appointment.status ?? "Requested"),

              infoCard(
                "DATE",
                appointment.date == null
                    ? "-"
                    : "${appointment.date!.day}/${appointment.date!.month}/${appointment.date!.year}",
              ),

              infoCard("QUEUE", "#4"),

              infoCard("START TIME", appointment.time ?? "-"),

              infoCard("END TIME", "--:--"),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Progress",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                appointment.status == "Canceled"
                    ? canceledCard()
                    : buildProgressTimeline(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),
                Text(
                  appointment.status == "Canceled"
                      ? "Canceled by patient."
                      : (appointment.notes?.isEmpty ?? true
                            ? "No notes"
                            : appointment.notes!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ),
        ],
      ),
    );
  }
}
