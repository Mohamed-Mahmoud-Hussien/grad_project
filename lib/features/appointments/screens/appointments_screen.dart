import 'dart:async';
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
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    loadAppointments();

    // ✅ Auto Refresh كل 30 ثانية عشان يتحدث الـ status تلقائياً
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadAppointments(silent: true);
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  // silent: true → مش بيشغل الـ loading indicator (للـ background refresh)
  Future<void> loadAppointments({bool silent = false}) async {
    if (!silent) {
      if (mounted) setState(() => isLoading = true);
    }
    try {
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
      case "pending_approval":
        return Colors.orange;
      case "scheduled":
        return const Color(0xFF3563E9);
      case "completed":
        return Colors.green;
      case "canceled":
        return Colors.red;
      case "waiting":
        return Colors.purple;
      case "withDoctor":
        return Colors.teal;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ✅ تحويل الـ status لنص واضح للمستخدم
  String getStatusLabel(String status) {
    switch (status) {
      case "pending_approval":
        return "Requested";
      case "scheduled":
        return "Scheduled";
      case "completed":
        return "Completed";
      case "canceled":
        return "Canceled";
      case "waiting":
        return "Waiting";
      case "withDoctor":
        return "With Doctor";
      case "rejected":
        return "Rejected";
      default:
        return status;
    }
  }

  List<AppointmentBooking> getFilteredAppointments() {
    switch (selectedTab) {
      case 0:
        return appointments
            .where(
              (a) =>
                  a.status == "scheduled" ||
                  a.status == "waiting" ||
                  a.status == "withDoctor",
            )
            .toList();
      case 1:
        return appointments
            .where((a) => a.status == "pending_approval")
            .toList();
      case 2:
        return appointments.where((a) => a.status == "completed").toList();
      case 3:
        return appointments
            .where((a) => a.status == "canceled" || a.status == "rejected")
            .toList();
      default:
        return appointments;
    }
  }

  // ✅ رسالة الـ empty state تتغير حسب الـ tab
  Widget buildEmptyState() {
    final messages = [
      (
        "No Upcoming Appointments",
        "Your approved appointments will appear here",
      ),
      ("No Pending Requests", "Book an appointment using the + button"),
      ("No History Yet", "Completed appointments will appear here"),
      (
        "No Canceled Appointments",
        "Canceled or rejected appointments will appear here",
      ),
    ];
    final msg = messages[selectedTab];

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
            child: const Icon(
              Icons.calendar_month,
              size: 60,
              color: Color(0xFF3563E9),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            msg.$1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(msg.$2, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget buildAppointmentCard(AppointmentBooking appointment) {
    final status = appointment.status ?? "";
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        // ✅ border خفيف لو الموعد مع الدكتور دلوقتي
        border: status == "withDoctor"
            ? Border.all(color: Colors.teal, width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF3563E9)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${appointment.specialty ?? ""} • ${appointment.appointmentType}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // ✅ Status badge بالنص المفهوم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(status).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStatusLabel(status),
                  style: TextStyle(
                    color: getStatusColor(status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                appointment.date == null
                    ? ""
                    : "${appointment.date!.day}/${appointment.date!.month}/${appointment.date!.year}",
              ),
              const SizedBox(width: 15),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(appointment.time ?? ""),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 6),
          Row(
            children: [
              // ✅ أيقونة تعبر عن الحالة
              _buildStatusHint(status),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AppointmentDetailsScreen(appointment: appointment),
                    ),
                  );
                  // ✅ لما يرجع من الـ details، يعمل refresh
                  loadAppointments(silent: true);
                },
                child: const Text("View Details"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHint(String status) {
    switch (status) {
      case "pending_approval":
        return const Row(
          children: [
            Icon(Icons.hourglass_top, size: 16, color: Colors.orange),
            SizedBox(width: 4),
            Text(
              "Awaiting approval",
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        );
      case "scheduled":
        return const Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Color(0xFF3563E9),
            ),
            SizedBox(width: 4),
            Text(
              "Confirmed",
              style: TextStyle(color: Color(0xFF3563E9), fontSize: 12),
            ),
          ],
        );
      case "waiting":
        return const Row(
          children: [
            Icon(Icons.people_outline, size: 16, color: Colors.purple),
            SizedBox(width: 4),
            Text(
              "In queue",
              style: TextStyle(color: Colors.purple, fontSize: 12),
            ),
          ],
        );
      case "withDoctor":
        return const Row(
          children: [
            Icon(Icons.medical_services, size: 16, color: Colors.teal),
            SizedBox(width: 4),
            Text(
              "With doctor now",
              style: TextStyle(color: Colors.teal, fontSize: 12),
            ),
          ],
        );
      case "completed":
        return const Row(
          children: [
            Icon(Icons.done_all, size: 16, color: Colors.green),
            SizedBox(width: 4),
            Text(
              "Completed",
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        );
      case "canceled":
      case "rejected":
        return const Row(
          children: [
            Icon(Icons.cancel_outlined, size: 16, color: Colors.red),
            SizedBox(width: 4),
            Text("Canceled", style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B6EF6), Color(0xFF2F46D8)],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Appointments",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Manage your visits",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BookAppointmentScreen(),
                              ),
                            );
                            // ✅ بعد الحجز، حول للـ Requested tab وعمل refresh
                            setState(() => selectedTab = 1);
                            loadAppointments(silent: true);
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // ── Tabs ──
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = selectedTab == index;
                        // ✅ عدد المواعيد في كل tab
                        final count = index == 0
                            ? appointments
                                  .where(
                                    (a) =>
                                        a.status == "scheduled" ||
                                        a.status == "waiting" ||
                                        a.status == "withDoctor",
                                  )
                                  .length
                            : index == 1
                            ? appointments
                                  .where((a) => a.status == "pending_approval")
                                  .length
                            : 0;

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
                                child: count > 0 && (index == 0 || index == 1)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            tabs[index],
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF3563E9),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              "$count",
                                              style: TextStyle(
                                                color: isSelected
                                                    ? const Color(0xFF3563E9)
                                                    : Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        tabs[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
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

            // ── List ──
            Expanded(
              // ✅ Pull to Refresh
              child: RefreshIndicator(
                onRefresh: () => loadAppointments(),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : getFilteredAppointments().isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(height: 400, child: buildEmptyState()),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 24),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: getFilteredAppointments().length,
                        itemBuilder: (context, index) => buildAppointmentCard(
                          getFilteredAppointments()[index],
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
