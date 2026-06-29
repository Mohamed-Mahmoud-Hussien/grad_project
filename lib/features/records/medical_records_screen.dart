import 'package:flutter/material.dart';
import 'medical_service.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  int selectedTab = 0;
  final tabs = ["Conditions", "Allergies", "Vitals", "Medications"];

  bool _isLoading = true;

  // بيانات من الـ API
  List<String> conditions = [];
  List<String> allergies = [];
  Map<String, dynamic> vitals = {};
  List<Map<String, dynamic>> activeMeds = [];
  List<Map<String, dynamic>> completedMeds = [];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        MedicalService.fetchMedications(),
        MedicalService.fetchMedicalInfo(),
        MedicalService.fetchVitals(),
      ]);

      final meds = results[0] as List<Map<String, dynamic>>;
      final info = results[1] as Map<String, dynamic>?;
      final vitalsData = results[2] as Map<String, dynamic>?;

      setState(() {
        // Medications
        activeMeds = meds
            .where((m) => m['status'] == 'active' || m['active'] == true)
            .toList();
        completedMeds = meds
            .where((m) => m['status'] != 'active' && m['active'] != true)
            .toList();

        // Medical info
        if (info != null) {
          final rawConditions = info['conditions'] as List<dynamic>? ?? [];
          conditions = rawConditions.map((c) {
            if (c is Map) return c['name']?.toString() ?? '';
            return c.toString();
          }).where((s) => s.isNotEmpty).toList();
          allergies = List<String>.from(info['allergies'] ?? []);
        }

        // Vitals
        if (vitalsData != null) vitals = vitalsData;
      });
    } catch (e) {
      print('[MedicalRecordsScreen] error: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Column(
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 50, left: 20, right: 20, bottom: 30),
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
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Your complete health profile",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // ── Tabs ──
          Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: List.generate(
                  tabs.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = index),
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

          // ── Content ──
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF3563E9)))
                : RefreshIndicator(
                    color: const Color(0xFF3563E9),
                    onRefresh: _loadAll,
                    child: _buildTabContent(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return _buildConditions();
      case 1:
        return _buildAllergies();
      case 2:
        return _buildVitals();
      case 3:
        return _buildMedications();
      default:
        return const SizedBox();
    }
  }

  // ── Conditions ──
  Widget _buildConditions() {
    if (conditions.isEmpty) {
      return _emptyState("No conditions recorded");
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: conditions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => _ConditionCard(title: conditions[i], subtitle: ''),
    );
  }

  // ── Allergies ──
  Widget _buildAllergies() {
    if (allergies.isEmpty) {
      return _emptyState("No allergies recorded");
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("KNOWN ALLERGIES",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allergies.map((a) => _allergyChip(a)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Vitals ──
  Widget _buildVitals() {
    final bpList = vitals["bloodPressure"] as List<dynamic>? ?? [];
    final latestBP = bpList.isNotEmpty ? bpList.last as Map<String, dynamic>? : null;
    final bpString = latestBP?["bp"]?.toString() ?? '--/--';
    final heartRateVal = latestBP?["heartRate"]?.toString() ?? '--';

    String v(String key) {
      if (key == 'weight') return vitals['bodyWeight']?.toString() ?? '--';
      return vitals[key]?.toString() ?? '--';
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.1,
          children: [
            VitalCard(
                icon: Icons.favorite_border,
                value: heartRateVal,
                unit: "bpm",
                title: "Heart Rate"),
            VitalCard(
                icon: Icons.show_chart,
                value: bpString,
                unit: "mmHg",
                title: "Blood Pressure"),
            VitalCard(
                icon: Icons.device_thermostat_outlined,
                value: v('temperature'),
                unit: "°C",
                title: "Temperature"),
            VitalCard(
                icon: Icons.water_drop_outlined,
                value: v('bloodSugar'),
                unit: "mg/dL",
                title: "Blood Sugar"),
            VitalCard(
                icon: Icons.balance_outlined,
                value: v('weight'),
                unit: "kg",
                title: "Weight"),
          ],
        ),
      ],
    );
  }

  // ── Medications ──
  Widget _buildMedications() {
    if (activeMeds.isEmpty && completedMeds.isEmpty) {
      return _emptyState("No medications recorded");
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        if (activeMeds.isNotEmpty) ...[
          const Text("ACTIVE",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
          const SizedBox(height: 12),
          ...activeMeds.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: medicationCard(
                  name: m['name'] ?? '',
                  details:
                      '${m['form'] ?? m['type'] ?? ''} · ${m['dose'] ?? m['dosage'] ?? ''}',
                  frequency: m['frequency'] ?? '',
                  fromDate: _formatDate(m['startDate'] ?? m['from']),
                  toDate: m['endDate'] != null
                      ? _formatDate(m['endDate'])
                      : 'Ongoing',
                  active: true,
                ),
              )),
        ],
        if (completedMeds.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text("COMPLETED",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
          const SizedBox(height: 12),
          ...completedMeds.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: medicationCard(
                  name: m['name'] ?? '',
                  details:
                      '${m['form'] ?? m['type'] ?? ''} · ${m['dose'] ?? m['dosage'] ?? ''}',
                  frequency: m['frequency'] ?? '',
                  fromDate: _formatDate(m['startDate'] ?? m['from']),
                  toDate: _formatDate(m['endDate'] ?? m['to']),
                  active: false,
                ),
              )),
        ],
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '--';
    try {
      final d = DateTime.parse(date.toString());
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return date.toString();
    }
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text(msg,
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

// ── Widgets ──

class _ConditionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ConditionCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(subtitle,
                style:
                    TextStyle(color: Colors.grey.shade700, fontSize: 14)),
          ],
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
    child: Text(text,
        style: const TextStyle(
            color: Color(0xFFD90429), fontWeight: FontWeight.w600)),
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
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF3563E9), size: 24),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold)),
          Text(unit,
              style:
                  const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16)),
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
        color: Colors.white, borderRadius: BorderRadius.circular(24)),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: active
                  ? const Color(0xFFE6F0FF)
                  : const Color(0xFFF0F2F5),
              child: Icon(Icons.medication_outlined,
                  color: active
                      ? const Color(0xFF3563E9)
                      : Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(details,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(frequency,
                      style: const TextStyle(
                          color: Color(0xFF3563E9),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    color: active ? Colors.green : Colors.blueGrey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("From $fromDate",
                style:
                    const TextStyle(color: Colors.black54, fontSize: 12)),
            Text("To $toDate",
                style:
                    const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}