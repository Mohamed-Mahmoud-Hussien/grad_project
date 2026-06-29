class PatientVitals {
  final int heartRate;
  final String bloodPressure;
  final double temperature;
  final int bloodSugar;
  final double weight;

  PatientVitals({
    required this.heartRate,
    required this.bloodPressure,
    required this.temperature,
    required this.bloodSugar,
    this.weight = 0,
  });

  factory PatientVitals.fromJson(Map<String, dynamic> json) {
    // ✅ bloodPressure هو array - نجيب آخر reading
    final bpList = json["bloodPressure"] as List<dynamic>? ?? [];
    final latestBP = bpList.isNotEmpty ? bpList.last : null;

    final heartRate = (latestBP?["heartRate"] ?? 0).toInt();
    final bp = latestBP?["bp"] ?? "--/--";

    return PatientVitals(
      heartRate: heartRate,
      bloodPressure: bp,
      temperature: (json["temperature"] ?? 0).toDouble(),
      bloodSugar: (json["bloodSugar"] ?? 0).toInt(),
      weight: (json["bodyWeight"] ?? 0).toDouble(), // ✅ bodyWeight مش weight
    );
  }
}