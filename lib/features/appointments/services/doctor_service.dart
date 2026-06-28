import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';

class DoctorService {

  // ✅ جلب كل الدكاترة
  // GET /api/doctors
  Future<List<dynamic>> getDoctors({
    String? specialty,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await DioClient.dio.get(
        '/doctors',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (specialty != null) 'specialty': specialty,
          if (search != null) 'search': search,
        },
      );
      return response.data["data"] as List;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to load doctors");
    }
  }

  // ✅ جلب بروفايل دكتور معين
  // GET /api/doctors/:id
  Future<Map<String, dynamic>> getDoctorById(String doctorId) async {
    try {
      final response = await DioClient.dio.get('/doctors/$doctorId');
      return response.data["data"];
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to load doctor");
    }
  }
}
/*import '../../../core/api/dio_client.dart';

class DoctorService {
  Future<List<dynamic>> getDoctors() async {
    final response = await DioClient.dio.get('/doctors');

    return response.data["data"];
  }
}
*/