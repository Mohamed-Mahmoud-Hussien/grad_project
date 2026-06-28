import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../models/appointment_booking.dart';

class AppointmentService {
  
  // ✅ جلب مواعيد الـ patient
  // GET /api/patients/me/appointments
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
      final message = e.response?.data["message"] ?? "Failed to load appointments";
      throw Exception(message);
    }
  }

  // ✅ جلب موعد واحد بالـ ID
  // GET /api/patients/me/appointments/:id
  Future<AppointmentBooking> getMyAppointmentById(String id) async {
    try {
      final response = await DioClient.dio.get('/patients/me/appointments/$id');
      return AppointmentBooking.fromJson(response.data["data"]);
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to load appointment";
      throw Exception(message);
    }
  }

  // ✅ حجز موعد جديد
  // POST /api/patients/me/appointments
  // الـ Backend بيستنى: preferredDate و preferredTime (مش date و time)
  // بعد الحجز status بيكون "pending_approval" → الـ receptionist يوافق
  Future<AppointmentBooking> requestBooking({
    required String doctorId,
    required String preferredDate,  // format: "2024-12-25"
    required String preferredTime,  // format: "10:00 AM"
    required String appointmentType, // "consultation" أو "follow-up" أو "in-person" أو "online"
    String notes = '',
  }) async {
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
      final message = e.response?.data["message"] ?? "Failed to book appointment";
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