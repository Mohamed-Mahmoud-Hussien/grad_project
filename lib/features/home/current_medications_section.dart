import 'package:flutter/material.dart';
import 'medication_card.dart';

class CurrentMedicationsSection extends StatelessWidget {
  const CurrentMedicationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Current Medications",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  color: Color(0xFF3563E9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              MedicationCard(
                name: "Insulin Glargine",
                dosage: "10 units · Injection",
                frequency: "Once daily",
              ),

              MedicationCard(
                name: "Metformin",
                dosage: "500 mg · Tablet",
                frequency: "Twice daily",
              ),
            ],
          ),
        ),
      ],
    );
  }
}