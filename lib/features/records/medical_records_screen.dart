import 'package:flutter/material.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  int selectedTab = 0;

  final tabs = ["Conditions", "Allergies", "Vitals", "Medications"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF3563E9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Medical Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Your complete health profile",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: List.generate(
                  tabs.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: selectedTab == index
                              ? const Color(0xFF3563E9)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selectedTab == index
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: selectedTab == 0
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      _conditionCard(
                        title: "Type 1 Diabetes",
                        subtitle:
                            "Since childhood, managed with insulin therapy.",
                      ),

                      const SizedBox(height: 14),

                      _conditionCard(
                        title: "Mild Asthma",
                        subtitle: "Seasonal, controlled with inhaler.",
                      ),
                    ],
                  )
                : selectedTab == 1
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "KNOWN ALLERGIES",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _allergyChip("Penicillin"),
                                _allergyChip("Dust"),
                                _allergyChip("Seafood"),
                                _allergyChip("Pollen"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : selectedTab == 2
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.1,
                        children: const [
                          VitalCard(
                            icon: Icons.favorite_border,
                            value: "72",
                            unit: "bpm",
                            title: "Heart Rate",
                          ),
                          VitalCard(
                            icon: Icons.show_chart,
                            value: "118/76",
                            unit: "mmHg",
                            title: "Blood Pressure",
                          ),
                          VitalCard(
                            icon: Icons.device_thermostat_outlined,
                            value: "36.6",
                            unit: "°C",
                            title: "Temperature",
                          ),
                          VitalCard(
                            icon: Icons.water_drop_outlined,
                            value: "95",
                            unit: "mg/dL",
                            title: "Blood Sugar",
                          ),
                          VitalCard(
                            icon: Icons.balance_outlined,
                            value: "58",
                            unit: "kg",
                            title: "Weight",
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "View History",
                          style: TextStyle(
                            color: Color(0xFF3563E9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : selectedTab == 3
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    children: [
                      const Text(
                        "ACTIVE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 12),

                      medicationCard(
                        name: "Insulin Glargine",
                        details: "Injection · 10 units",
                        frequency: "Once daily",
                        fromDate: "2024-01-10",
                        toDate: "Ongoing",
                        active: true,
                      ),

                      const SizedBox(height: 14),

                      medicationCard(
                        name: "Metformin",
                        details: "Tablet · 500 mg",
                        frequency: "Twice daily",
                        fromDate: "2024-03-01",
                        toDate: "Ongoing",
                        active: true,
                      ),

                      const SizedBox(height: 14),

                      medicationCard(
                        name: "Salbutamol",
                        details: "Inhaler · 2 puffs",
                        frequency: "As needed",
                        fromDate: "2023-09-15",
                        toDate: "Ongoing",
                        active: true,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "COMPLETED",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 12),

                      medicationCard(
                        name: "Amoxicillin",
                        details: "Capsule · 500 mg",
                        frequency: "3x daily",
                        fromDate: "2024-05-01",
                        toDate: "2024-05-08",
                        active: false,
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _conditionCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _conditionCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

Widget _allergyChip(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFCE4E8),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFFD90429),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class VitalCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String title;

  const VitalCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF3563E9), size: 24),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          Text(
            unit,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Widget medicationCard({
  required String name,
  required String details,
  required String frequency,
  required String fromDate,
  required String toDate,
  required bool active,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: active
                  ? const Color(0xFFE6F0FF)
                  : const Color(0xFFF0F2F5),
              child: Icon(
                Icons.medication_outlined,
                color: active ? const Color(0xFF3563E9) : Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(details, style: const TextStyle(color: Colors.black54)),

                  const SizedBox(height: 4),

                  Text(
                    frequency,
                    style: const TextStyle(
                      color: Color(0xFF3563E9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFE7F8ED)
                    : const Color(0xFFEDEFF2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                active ? "Active" : "Completed",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.green : Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        const Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "From $fromDate",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),

            Text(
              "To $toDate",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}
