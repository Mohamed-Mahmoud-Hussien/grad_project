class AppointmentBooking {
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
    return AppointmentBooking(
      doctorId: json["doctorId"]?["_id"],
      doctorName: json["doctorId"]?["userId"]?["fullName"] ?? "",
      specialty: json["doctorId"]?["specialty"] ?? "",
      appointmentType: json["appointmentType"]?.toString() ?? "",

      status: json["status"]?.toString() ?? "",
      notes: json["notes"] ?? "",
      time: json["startTime"] ?? "",
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
    );
  }
}
