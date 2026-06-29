class AppointmentBooking {
  String? id;
  String? department;
  String? doctorId;
  String? doctorName;
  String? specialty;
  DateTime? date;
  String? time;
  String? notes;
  String appointmentType;
  String? status;

  AppointmentBooking({
    this.id,
    this.department,
    this.doctorId,
    this.doctorName,
    this.specialty,
    this.date,
    this.time,
    this.notes,
    this.appointmentType = "Consultation",
    this.status = "Requested",
  });

  factory AppointmentBooking.fromJson(Map<String, dynamic> json) {
    // ✅ doctorId ممكن يييجي بشكلين من الـ Backend:
    // 1. Object (populated):  { "_id": "xxx", "userId": { "fullName": "..." }, "specialty": "..." }
    // 2. String (not populated): "xxx"

    String? doctorId;
    String? doctorName;
    String? specialty;

    final doctorData = json["doctorId"];

    if (doctorData is Map) {
      // جه كـ Object منـ populate
      doctorId = doctorData["_id"]?.toString();
      doctorName = doctorData["userId"]?["fullName"]?.toString() ?? "";
      specialty = doctorData["specialty"]?.toString() ?? "";
    } else if (doctorData is String) {
      // جه كـ String ID بس
      doctorId = doctorData;
      doctorName = "";
      specialty = "";
    }

    return AppointmentBooking(
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      appointmentType: json["appointmentType"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      notes: json["notes"]?.toString() ?? "",
      time: json["startTime"]?.toString() ?? "",
      date: json["date"] != null
          ? DateTime.tryParse(json["date"].toString())
          : null,
    );
  }
}
