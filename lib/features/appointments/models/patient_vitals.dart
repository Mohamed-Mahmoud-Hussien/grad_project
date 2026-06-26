class PatientVitals {
  final int heartRate;
  final String bloodPressure;
  final double temperature;
  final int bloodSugar;

  PatientVitals({
    required this.heartRate,
    required this.bloodPressure,
    required this.temperature,
    required this.bloodSugar,
  });

  factory PatientVitals.fromJson(Map<String, dynamic> json) {
    final bloodPressureList =
        json["bloodPressure"] as List<dynamic>? ?? [];

    final latestBP = bloodPressureList.isNotEmpty
        ? bloodPressureList.last
        : null;

    return PatientVitals(
      heartRate: latestBP?["heartRate"] ?? 0,
      bloodPressure: latestBP?["bp"] ?? "--/--",
      temperature: (json["temperature"] ?? 0).toDouble(),
      bloodSugar: json["bloodSugar"] ?? 0,
    );
  }
}