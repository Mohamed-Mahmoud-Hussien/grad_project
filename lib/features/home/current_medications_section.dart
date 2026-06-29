import 'package:flutter/material.dart';
import 'package:grad_project/features/records/medical_records_screen.dart';
import 'package:grad_project/features/records/medical_service.dart';
import 'medication_card.dart';

class CurrentMedicationsSection extends StatefulWidget {
  final VoidCallback? onSeeAll; // ✅ callback بدل Navigator.push
  const CurrentMedicationsSection({super.key, this.onSeeAll});

  @override
  State<CurrentMedicationsSection> createState() =>
      _CurrentMedicationsSectionState();
}

class _CurrentMedicationsSectionState extends State<CurrentMedicationsSection> {
  List<Map<String, dynamic>> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final meds = await MedicalService.fetchMedications();
    if (mounted) {
      setState(() {
        _medications = meds
            .where((m) => m['status'] == 'active' || m['active'] == true)
            .toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Current Medications",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // ✅ See All بيستدعي الـ callback
              GestureDetector(
                onTap: widget.onSeeAll,
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: Color(0xFF3563E9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Color(0xFF3563E9)),
            ),
          )
        else if (_medications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "No active medications",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final med = _medications[index];
                final name = med['name'] ?? '';
                final dose = med['dose'] ?? med['dosage'] ?? '';
                final form = med['form'] ?? med['type'] ?? '';
                final frequency = med['frequency'] ?? '';
                return MedicationCard(
                  name: name,
                  dosage: '$dose · $form',
                  frequency: frequency,
                );
              },
            ),
          ),
      ],
    );
  }
}
