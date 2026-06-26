import 'package:grad_project/core/api/dio_client.dart';
import 'package:grad_project/features/appointments/models/patient_vitals.dart';

class PatientService {
  Future<PatientVitals> getVitals() async {
    try {
      final response = await DioClient.dio.get(
        "/patients/me/vitals",
      );

      return PatientVitals.fromJson(
        response.data["data"],
      );
    } catch (e) {
      print("VITALS ERROR: $e");

      return PatientVitals(
        heartRate: 0,
        bloodPressure: "--/--",
        temperature: 0,
        bloodSugar: 0,
      );
    }
  }
}