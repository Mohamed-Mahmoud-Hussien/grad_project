import 'package:flutter/material.dart';
import 'package:grad_project/core/widgets/latest_vitals_section.dart';
import 'package:grad_project/features/appointments/models/patient_vitals.dart';
import 'package:grad_project/features/doctors/search_doctors_screen.dart';
import 'package:grad_project/features/doctors/specialty_doctors_screen.dart';
import 'package:grad_project/features/home/current_medications_section.dart';
import 'package:grad_project/features/home/services/patient_service.dart';
import 'package:grad_project/features/navigation/app_drawer.dart';
import 'package:grad_project/features/appointments/models/appointment_booking.dart';
import 'package:grad_project/features/appointments/models/appointment_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
            backgroundColor: color.withOpacity(0.15),

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

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadVitals();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString("fullName") ?? "User";
    });
  }

  Future<void> loadVitals() async {
    final data = await PatientService().getVitals();

    setState(() {
      vitals = data;
    });
  }

  AppointmentBooking? getUpcomingAppointment() {
    try {
      return AppointmentStorage.appointments.firstWhere(
        (appointment) => appointment.status == "Scheduled",
      );
    } catch (e) {
      return null;
    }
  }

  Widget build(BuildContext context) {
    final appointment = getUpcomingAppointment();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const AppDrawer(currentPage: "Home"),

        body: SingleChildScrollView(
          child: Column(
            children: [
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
                      color: Colors.blue.withOpacity(0.35),
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
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).cardColor,
                                    child: Icon(
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

                                  border: Border.all(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade300
                                        : Colors.transparent,
                                  ),

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
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications_none,
                                    color: Colors.white,
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

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {},

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0E73B8),
                            ),

                            child: const Text("Book Appointment"),
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
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchDoctorsScreen(),
                          ),
                        );
                      },

                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search doctor...",
                            prefixIcon: const Icon(Icons.search),

                            filled: true,
                            fillColor: Theme.of(context).cardColor,

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey.shade300
                                    : Colors.transparent,
                              ),
                            ),

                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFF0E73B8),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Text(
                          "Medical Specialties",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtyDoctorsScreen(
                                        specialty: "Cardiology",
                                      ),
                                ),
                              );
                            },

                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.monitor_heart,
                              "Cardiology",
                              Colors.red,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtyDoctorsScreen(
                                        specialty: "Neurology",
                                      ),
                                ),
                              );
                            },

                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.psychology,
                              "Neurology",
                              Colors.deepPurple,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtyDoctorsScreen(
                                        specialty: "Dental",
                                      ),
                                ),
                              );
                            },

                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.medical_services,
                              "Dental",
                              Colors.lightBlue,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtyDoctorsScreen(
                                        specialty: "Orthopedic",
                                      ),
                                ),
                              );
                            },

                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.accessibility_new,
                              "Orthopedic",
                              Colors.orange,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtyDoctorsScreen(
                                        specialty: "Eye",
                                      ),
                                ),
                              );
                            },

                            child: HomeScreen._specialtyCard(
                              context,
                              Icons.visibility,
                              "Eye",
                              Colors.green,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SpecialtyDoctorsScreen(
                                        specialty: "Pediatrics",
                                      ),
                                ),
                              );
                            },

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

                    Row(
                      children: [
                        Text(
                          "Upcoming Appointment",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    appointment == null
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
                              color: const Color(0xFF0E73B8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.doctorName ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  appointment.specialty ?? "",
                                  style: const TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "${appointment.date?.day}/${appointment.date?.month}/${appointment.date?.year} • ${appointment.time}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const CurrentMedicationsSection(),

              const SizedBox(height: 25),

              vitals == null
                  ? const Center(child: CircularProgressIndicator())
                  : LatestVitalsSection(vitals: vitals!),
            ],
          ),
        ),
      ),
    );
  }
}
