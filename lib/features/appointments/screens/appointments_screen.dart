
import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/models/appointment_booking.dart';
import 'appointment_details_screen.dart';
import 'book_appointment_screen.dart';
import 'appointment_service.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int selectedTab = 0;
  bool isLoading = true;
  List<AppointmentBooking> appointments = [];
  final List<String> tabs = ["Upcoming", "Requested", "History", "Canceled"];

  @override
  void initState() {
    super.initState();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      // ✅ الاسم الصح هو getMyAppointments مش getAppointments
      final data = await AppointmentService().getMyAppointments();
      if (!mounted) return;
      setState(() {
        appointments = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "pending_approval": return Colors.orange;
      case "scheduled":        return const Color(0xFF3563E9);
      case "completed":        return Colors.green;
      case "canceled":         return Colors.red;
      case "waiting":          return Colors.purple;
      case "withDoctor":       return Colors.teal;
      case "rejected":         return Colors.red;
      default:                 return Colors.grey;
    }
  }

  List<AppointmentBooking> getFilteredAppointments() {
    switch (selectedTab) {
      case 0: return appointments.where((a) =>
          a.status == "scheduled" || a.status == "waiting" || a.status == "withDoctor").toList();
      case 1: return appointments.where((a) => a.status == "pending_approval").toList();
      case 2: return appointments.where((a) => a.status == "completed").toList();
      case 3: return appointments.where((a) => a.status == "canceled" || a.status == "rejected").toList();
      default: return appointments;
    }
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_month, size: 60, color: Color(0xFF3563E9)),
          ),
          const SizedBox(height: 20),
          const Text("No Appointments Yet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Book your first appointment",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildAppointmentCard(AppointmentBooking appointment) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 55, height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3FF), shape: BoxShape.circle),
                child: const Icon(Icons.person, color: Color(0xFF3563E9)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.doctorName ?? "",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("${appointment.specialty ?? ""} • ${appointment.appointmentType}",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(appointment.status ?? "").withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appointment.status ?? "",
                  style: TextStyle(
                    color: getStatusColor(appointment.status ?? ""),
                    fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text(appointment.date == null
                  ? ""
                  : "${appointment.date!.day}/${appointment.date!.month}/${appointment.date!.year}"),
              const SizedBox(width: 15),
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 6),
              Text(appointment.time ?? ""),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text("Queue #4", style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AppointmentDetailsScreen(appointment: appointment),
                  ));
                },
                child: const Text("View Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B6EF6), Color(0xFF2F46D8)]),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Appointments",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Manage your visits",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const BookAppointmentScreen(),
                            ));
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = selectedTab == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = index),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3563E9)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(tabs[index],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black54,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : getFilteredAppointments().isEmpty
                      ? buildEmptyState()
                      : ListView.builder(
                          itemCount: getFilteredAppointments().length,
                          itemBuilder: (context, index) =>
                              buildAppointmentCard(getFilteredAppointments()[index]),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}