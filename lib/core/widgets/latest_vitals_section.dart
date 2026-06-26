import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/models/patient_vitals.dart';

class LatestVitalsSection extends StatelessWidget {
  final PatientVitals vitals;

  const LatestVitalsSection({super.key, required this.vitals});

  Widget vitalCard({
    required IconData icon,
    required String value,
    required String label,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3563E9), size: 28),

              const Spacer(),

              Text(
                status,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "    Latest Vitals",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.15,
          children: [
            vitalCard(
              icon: Icons.favorite_border,
              value: vitals.heartRate.toString(),
              label: "bpm · Heart Rate",
              status: "+2",
            ),

            vitalCard(
              icon: Icons.monitor_heart_outlined,
              value: vitals.bloodPressure,
              label: "mmHg · Blood Pressure",
              status: "Stable",
            ),

            vitalCard(
              icon: Icons.thermostat_outlined,
              value: vitals.temperature.toString(),
              label: "°C · Temperature",
              status: "Normal",
            ),

            vitalCard(
              icon: Icons.water_drop_outlined,
              value: vitals.bloodSugar.toString(),
              label: "mg/dL · Blood Sugar",
              status: "-3",
            ),
          ],
        ),
      ],
    );
  }
}
