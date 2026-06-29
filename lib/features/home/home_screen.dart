import 'package:flutter/material.dart';
import 'package:grad_project/core/widgets/latest_vitals_section.dart';
import 'package:grad_project/features/appointments/models/appointment_booking.dart';
import 'package:grad_project/features/appointments/screens/appointment_service.dart';
import 'package:grad_project/features/appointments/models/patient_vitals.dart';
import 'package:grad_project/features/doctors/search_doctors_screen.dart';
import 'package:grad_project/features/doctors/specialty_doctors_screen.dart';
import 'package:grad_project/features/home/current_medications_section.dart';
import 'package:grad_project/features/home/services/patient_service.dart';
import 'package:grad_project/features/navigation/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onGoToMedical;
  const HomeScreen({super.key, this.onGoToMedical});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Widget _specialtyCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
  ) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade300
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String fullName = "User";
  PatientVitals? vitals;
  AppointmentBooking? upcomingAppointment;
  bool isLoadingAppointment = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadVitals();
    loadUpcomingAppointment();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      fullName = prefs.getString("fullName") ?? "User";
    });
  }

  Future<void> loadVitals() async {
    final data = await PatientService().getVitals();
    if (!mounted) return;
    setState(() => vitals = data);
  }

  // ✅ جلب أقرب موعد scheduled أو waiting من الـ API
  Future<void> loadUpcomingAppointment() async {
    try {
      final appointments = await AppointmentService().getMyAppointments();
      if (!mounted) return;

      // نجيب أول موعد scheduled أو waiting أو withDoctor
      final upcoming = appointments
          .where(
            (a) =>
                a.status == "scheduled" ||
                a.status == "waiting" ||
                a.status == "withDoctor",
          )
          .toList();

      // نرتبهم بالتاريخ وناخد الأقرب
      if (upcoming.isNotEmpty) {
        upcoming.sort((a, b) {
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return a.date!.compareTo(b.date!);
        });
      }

      setState(() {
        upcomingAppointment = upcoming.isEmpty ? null : upcoming.first;
        isLoadingAppointment = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingAppointment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const AppDrawer(currentPage: "Home"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header Image ──
              Stack(
                children: [
                  SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/home_image.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.35),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(
                                builder: (context) => GestureDetector(
                                  onTap: () =>
                                      Scaffold.of(context).openDrawer(),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).cardColor,
                                    child: const Icon(
                                      Icons.menu,
                                      color: Color(0xFF0E73B8),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SearchDoctorsScreen(),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.search,
                                    color: Color(0xFF0E73B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            "Good Morning 👋",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Manage your health with Tamkeen",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Medical Specialties ──
                    Text(
                      "Medical Specialties",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SpecialtyDoctorsScreen(
                                  specialty: "Cardiology",
                                ),
                              ),
                            ),
                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.monitor_heart,
                              "Cardiology",
                              Colors.red,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SpecialtyDoctorsScreen(
                                  specialty: "Neurology",
                                ),
                              ),
                            ),
                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.psychology,
                              "Neurology",
                              Colors.deepPurple,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SpecialtyDoctorsScreen(
                                  specialty: "Dental",
                                ),
                              ),
                            ),
                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.medical_services,
                              "Dental",
                              Colors.lightBlue,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SpecialtyDoctorsScreen(
                                  specialty: "Orthopedic",
                                ),
                              ),
                            ),
                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.accessibility_new,
                              "Orthopedic",
                              Colors.orange,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SpecialtyDoctorsScreen(
                                  specialty: "Eye",
                                ),
                              ),
                            ),
                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.visibility,
                              "Eye",
                              Colors.green,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SpecialtyDoctorsScreen(
                                  specialty: "Pediatrics",
                                ),
                              ),
                            ),
                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.child_friendly,
                              "Pediatrics",
                              Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ── Upcoming Appointment ──
                    Text(
                      "Upcoming Appointment",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // ✅ بيجيب من الـ API
                    isLoadingAppointment
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : upcomingAppointment == null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "No Upcoming Appointment",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B6EF6), Color(0xFF0E73B8)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white24,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            upcomingAppointment!.doctorName ??
                                                "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            upcomingAppointment!.specialty ??
                                                "",
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ✅ Status badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        upcomingAppointment!.status ==
                                                "scheduled"
                                            ? "Confirmed"
                                            : upcomingAppointment!.status ==
                                                  "waiting"
                                            ? "In Queue"
                                            : "With Doctor",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Divider(color: Colors.white24),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      upcomingAppointment!.date == null
                                          ? ""
                                          : "${upcomingAppointment!.date!.day}/${upcomingAppointment!.date!.month}/${upcomingAppointment!.date!.year}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      upcomingAppointment!.time ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              CurrentMedicationsSection(onSeeAll: widget.onGoToMedical),

              const SizedBox(height: 25),
              vitals == null
                  ? const SizedBox.shrink()
                  : LatestVitalsSection(vitals: vitals!),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
