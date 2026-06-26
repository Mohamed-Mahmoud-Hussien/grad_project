import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/dio_client.dart';

class AuthService {
  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await DioClient.dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );

      final data = response.data["data"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("accessToken", data["accessToken"]);

      await prefs.setString("fullName", data["user"]["fullName"]);

      await prefs.setString("email", data["user"]["email"]);

      await prefs.setBool("isLoggedIn", true);

      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await DioClient.dio.post(
        '/auth/register',
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "phone": phone,
          "gender": "male",
          "dateOfBirth": "2000-01-01",
          "address": "Egypt",
        },
      );

      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
