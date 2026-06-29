import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/dio_client.dart';

class ProfileService {
  // ✅ الـ endpoint الصح هو /patient/me
  static Future<Map<String, dynamic>?> fetchAndCacheProfile() async {
    try {
      final response = await DioClient.dio.get('/patients/me');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final userId = data['userId'] ?? {};
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('fullName', userId['fullName'] ?? '');
        await prefs.setString('email', userId['email'] ?? '');
        await prefs.setString('phone', userId['phone'] ?? '');
        await prefs.setString('address', userId['address'] ?? '');
        await prefs.setString('gender', userId['gender'] ?? '');

        final dob = data['dateOfBirth'] ?? userId['dateOfBirth'] ?? '';
        await prefs.setString('dob', dob.toString());

        return {
          'fullName': userId['fullName'],
          'email': userId['email'],
          'phone': userId['phone'],
          'address': userId['address'],
          'gender': userId['gender'],
          'dateOfBirth': dob,
        };
      }
    } catch (e) {
      print('[ProfileService] Error: $e');
    }
    return null;
  }
}