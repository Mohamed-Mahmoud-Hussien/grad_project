import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../models/appointment_booking.dart';

class AppointmentService {
  Future<List<AppointmentBooking>> getMyAppointments({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await DioClient.dio.get(
        '/patients/me/appointments',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data["data"];
      return data.map((e) => AppointmentBooking.fromJson(e)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data["message"] ?? "Failed to load appointments";
      throw Exception(message);
    }
  }

  Future<AppointmentBooking> getMyAppointmentById(String id) async {
    try {
      final response = await DioClient.dio.get('/patients/me/appointments/$id');
      return AppointmentBooking.fromJson(response.data["data"]);
    } on DioException catch (e) {
      final message =
          e.response?.data["message"] ?? "Failed to load appointment";
      throw Exception(message);
    }
  }

  Future<List<dynamic>> getDoctorAppointmentsOnDate({
    required String doctorId,
    required String date,
  }) async {
    try {
      final response = await DioClient.dio.get(
        '/appointments',
        queryParameters: {'date': date},
      );
      final List allAppointments = response.data["data"];
      return allAppointments.where((a) {
        final apptDoctorId = a["doctorId"] is Map
            ? a["doctorId"]["_id"]?.toString()
            : a["doctorId"]?.toString();
        return apptDoctorId == doctorId;
      }).toList();
    } on DioException catch (_) {
      return [];
    }
  }

  Future<String?> checkTimeConflict({
    required String doctorId,
    required String date,
    required String time,
  }) async {
    final existingAppointments = await getDoctorAppointmentsOnDate(
      doctorId: doctorId,
      date: date,
    );
    for (final appt in existingAppointments) {
      final apptTime = appt["startTime"]?.toString() ?? "";
      final apptStatus = appt["status"]?.toString() ?? "";
      if (apptStatus == "canceled" ||
          apptStatus == "rejected" ||
          apptStatus == "completed")
        continue;
      if (apptTime == time) {
        return "This time slot ($time) is already booked. Please choose another time.";
      }
    }
    return null;
  }

  Future<AppointmentBooking> requestBooking({
    required String doctorId,
    required String preferredDate,
    required String preferredTime,
    required String appointmentType,
    String notes = '',
  }) async {
    final conflict = await checkTimeConflict(
      doctorId: doctorId,
      date: preferredDate,
      time: preferredTime,
    );
    if (conflict != null) throw Exception(conflict);

    try {
      final response = await DioClient.dio.post(
        '/patients/me/appointments',
        data: {
          "doctorId": doctorId,
          "appointmentType": appointmentType,
          "preferredDate": preferredDate,
          "preferredTime": preferredTime,
          "notes": notes,
        },
      );
      return AppointmentBooking.fromJson(response.data["data"]);
    } on DioException catch (e) {
      final message =
          e.response?.data["message"] ?? "Failed to book appointment";
      throw Exception(message);
    }
  }

  // ✅ إلغاء موعد
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await DioClient.dio.patch(
        '/patients/me/appointments/$appointmentId/cancel',
      );
    } on DioException catch (e) {
      final message =
          e.response?.data["message"] ?? "Failed to cancel appointment";
      throw Exception(message);
    }
  }
}

/*import '../../../core/api/dio_client.dart';
import '../models/appointment_booking.dart';

class AppointmentService {
  Future<List<AppointmentBooking>> getAppointments() async {
    final response = await DioClient.dio.get('/patients/me/appointments');

    final List data = response.data["data"];

    return data.map((e) => AppointmentBooking.fromJson(e)).toList();
  }

  // التعديل هنا لتطابق الـ Body المعرف في الـ Controller للباك إند
  Future<void> requestAppointment({
    required String doctorId,
    required String date, // تعديل المسمى لـ date
    required String time, // تعديل المسمى لـ time
    required String appointmentType,
    String notes = '',
  }) async {
    await DioClient.dio.post(
      '/patients/me/appointments',
      data: {
        "doctorId": doctorId,
        "appointmentType": appointmentType,
        "date": date, // الاسم الصحيح المتوقع في الـ Backend
        "time": time, // الاسم الصحيح المتوقع في الـ Backend
        "notes": notes,
      },
    );
  }
}*/
/*import '../../../core/api/dio_client.dart';
import '../models/appointment_booking.dart';

class AppointmentService {
  Future<List<AppointmentBooking>> getAppointments() async {
    final response = await DioClient.dio.get(
      '/patients/me/appointments',
    );

    final List data = response.data["data"];

    return data
        .map((e) => AppointmentBooking.fromJson(e))
        .toList();
  }

  Future<void> requestAppointment({
    required String doctorId,
    required String preferredDate,
    required String preferredTime,
    required String appointmentType,
    String notes = '',
  }) async {
    await DioClient.dio.post(
      '/patients/me/appointments',
      data: {
        "doctorId": doctorId,
        "appointmentType": appointmentType,
        "preferredDate": preferredDate,
        "preferredTime": preferredTime,
        "notes": notes,
      },
    );
  }
}*/
