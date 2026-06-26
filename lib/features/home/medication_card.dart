import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String frequency;

  const MedicationCard({
    super.key,
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE8F1FF),
            child: Icon(
              Icons.medication_outlined,
              color: Color(0xFF3563E9),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            dosage,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),

          const Spacer(),

          Text(
            frequency,
            style: const TextStyle(
              color: Color(0xFF3563E9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}