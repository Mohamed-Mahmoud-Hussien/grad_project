class AppointmentBooking {
  String? department;

  String? doctorName;
  String? specialty;

  DateTime? date;
  String? time;

  String? notes;

  String appointmentType;

  String? status;

  AppointmentBooking({
    this.department,
    this.doctorName,
    this.specialty,
    this.date,
    this.time,
    this.notes,
    this.appointmentType = "Consultation",
    this.status = "Requested",
  });
}
