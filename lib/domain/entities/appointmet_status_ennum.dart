enum AppointmentStatus {
  pending,
  approved,
  rejected,
  completed,
  cancelled,
}

String appointmentStatusToString(AppointmentStatus status) => status.name;

AppointmentStatus appointmentStatusFromString(String value) =>
    AppointmentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppointmentStatus.pending,
    );
