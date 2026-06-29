/*import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/dio_client.dart';

class AuthService {

  // ✅ Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );
      final data = response.data["data"];
      final user = data["user"];
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("accessToken", data["accessToken"]);
      await prefs.setString("refreshToken", data["refreshToken"]);
      await prefs.setString("userId", user["_id"]);
      await prefs.setString("fullName", user["fullName"]);
      await prefs.setString("email", user["email"]);
      await prefs.setString("role", user["role"]);
      await prefs.setBool("isLoggedIn", true);

      return user;
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Login failed";
      throw Exception(message);
    }
  }

  // ✅ Register - بعده الحساب "pending" لحد ما Admin يوافق
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    String gender = "male",
    required String dateOfBirth,
    required String address,
  }) async {
    try {
      await DioClient.dio.post(
        '/auth/register',
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "phone": phone,
          "gender": gender,
          "dateOfBirth": dateOfBirth,
          "address": address,
        },
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Registration failed";
      throw Exception(message);
    }
  }

  // ✅ Logout
  Future<void> logout() async {
    try {
      await DioClient.dio.post('/auth/logout');
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ✅ Get my profile
  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await DioClient.dio.get('/auth/me');
      return response.data["data"];
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to get profile");
    }
  }

  // ✅ Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await DioClient.dio.put(
        '/auth/change-password',
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Password change failed");
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }
}

*/
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/dio_client.dart';

class AuthService {
  // ✅ Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );
      final data = response.data["data"];
      final user = data["user"];
      final prefs = await SharedPreferences.getInstance();

      // حفظ الـ tokens والبيانات الأساسية
      await prefs.setString("accessToken", data["accessToken"]);
      await prefs.setString("refreshToken", data["refreshToken"]);
      await prefs.setString("userId", user["_id"]);
      await prefs.setString("fullName", user["fullName"] ?? '');
      await prefs.setString("email", user["email"] ?? '');
      await prefs.setString("role", user["role"] ?? '');
      await prefs.setBool("isLoggedIn", true);

      // ✅ جيب باقي البيانات (phone, gender, address, dob) من /patient/profile
      await _fetchAndCacheFullProfile(prefs);

      return user;
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Login failed";
      throw Exception(message);
    }
  }

  // ✅ جيب البيانات الكاملة من patient profile وحفظها
  Future<void> _fetchAndCacheFullProfile(SharedPreferences prefs) async {
    try {
      final response = await DioClient.dio.get('/patients/me');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final userId = data['userId'] ?? {};

        await prefs.setString('phone', userId['phone'] ?? '');
        await prefs.setString('gender', userId['gender'] ?? '');
        await prefs.setString('address', userId['address'] ?? '');

        final dob = data['dateOfBirth'] ?? userId['dateOfBirth'] ?? '';
        await prefs.setString('dob', dob.toString());
      }
    } catch (e) {
      // مش هنوقف الـ login لو الـ profile call فشل
      print('[AuthService] Could not fetch full profile: $e');
    }
  }

  // ✅ Register
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    String gender = "male",
    required String dateOfBirth,
    required String address,
  }) async {
    try {
      await DioClient.dio.post(
        '/auth/register',
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "phone": phone,
          "gender": gender,
          "dateOfBirth": dateOfBirth,
          "address": address,
        },
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Registration failed";
      throw Exception(message);
    }
  }

  // ✅ Logout
  Future<void> logout() async {
    try {
      await DioClient.dio.post('/auth/logout');
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ✅ Get my profile
  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await DioClient.dio.get('/auth/me');
      return response.data["data"];
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to get profile");
    }
  }

  // ✅ Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await DioClient.dio.put(
        '/auth/change-password',
        data: {"currentPassword": currentPassword, "newPassword": newPassword},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Password change failed");
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }
}
