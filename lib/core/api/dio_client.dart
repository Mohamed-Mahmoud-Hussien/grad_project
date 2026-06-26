import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  );
}
