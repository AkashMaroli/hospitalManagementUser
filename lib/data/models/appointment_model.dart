import 'package:flutter/material.dart';

class AppointmentModel {
  final String userId;
  final String doctorId;
  final bool consultationType; // true = video, false = direct
  final String reason;
  final String appointmentSlot; // e.g., "09:00 - 09:30"
  final bool appointmentStatus;
  final String date; // yyyy-MM-dd

  AppointmentModel({
    required this.userId,
    required this.doctorId,
    required this.consultationType,
    required this.reason,
    required this.appointmentStatus,
    required this.appointmentSlot,
    required this.date,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      userId: json['user_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      consultationType:
          (json['consultation_type'] is bool)
              ? json['consultation_type']
              : (json['consultation_type'].toString() == 'true'),
      reason: json['reason'] ?? '',
      appointmentStatus:
          (json['appointment_status'] is bool)
              ? json['appointment_status']
              : (json['appointment_status'].toString() == 'true'),
      appointmentSlot: json['appointment_slot']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'doctor_id': doctorId,
      'consultation_type': consultationType,
      'reason': reason,
      'appointment_status': appointmentStatus,
      'appointment_slot': appointmentSlot,
      'date': date,
    };
  }
}

class DoctorAvailability {
  final List<String> days; // ["Mon", "Wed", "Fri"]
  final String startTime; // "09:00"
  final String endTime; // "13:00"
  final int slotDuration; // in minutes

  DoctorAvailability({
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.slotDuration,
  });
}
