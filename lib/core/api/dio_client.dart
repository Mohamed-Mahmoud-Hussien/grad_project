import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Content-Type": "application/json"},
    ),
  )..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("accessToken");
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // ✅ Token انتهى → نجدده تلقائياً
          if (e.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString("refreshToken");
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
                final res = await refreshDio.post(
                  '/auth/refresh-token',
                  data: {"refreshToken": refreshToken},
                );
                final newAccess = res.data["data"]["accessToken"];
                final newRefresh = res.data["data"]["refreshToken"];
                await prefs.setString("accessToken", newAccess);
                await prefs.setString("refreshToken", newRefresh);
                e.requestOptions.headers["Authorization"] = "Bearer $newAccess";
                final retry = await dio.fetch(e.requestOptions);
                return handler.resolve(retry);
              } catch (_) {
                await prefs.clear();
              }
            }
          }
          return handler.next(e);
        },
      ),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => print('[DIO] $log'),
      ),
    ]);
}
/*import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final token = prefs.getString("accessToken");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
}*/