import 'package:grad_project/core/api/dio_client.dart';
import 'package:grad_project/features/appointments/models/reports_model.dart';


class ReportsService {
  Future<List<ReportModel>> getReports() async {
    try {
      final response = await DioClient.dio.get(
        "/patients/me/health-reports",
      );

      final List data = response.data["data"];

      return data
          .map(
            (e) => ReportModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}