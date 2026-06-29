import '../../core/api/dio_client.dart';

class MedicalService {
  // ✅ /patient/me/medications
  static Future<List<Map<String, dynamic>>> fetchMedications() async {
    try {
      final response = await DioClient.dio.get('/patients/me/medications');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
    } catch (e) {
      print('[MedicalService] medications error: $e');
    }
    return [];
  }

  // ✅ /patient/me/medical-info  (conditions, allergies)
  static Future<Map<String, dynamic>?> fetchMedicalInfo() async {
    try {
      final response = await DioClient.dio.get('/patients/me/medical-info');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data'] ?? {});
      }
    } catch (e) {
      print('[MedicalService] medical-info error: $e');
    }
    return null;
  }

  // ✅ /patient/me/vitals
  static Future<Map<String, dynamic>?> fetchVitals() async {
    try {
      final response = await DioClient.dio.get('/patients/me/vitals');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data'] ?? {});
      }
    } catch (e) {
      print('[MedicalService] vitals error: $e');
    }
    return null;
  }
}