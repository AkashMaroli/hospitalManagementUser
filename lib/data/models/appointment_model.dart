import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/appointment_heper_model.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';

class AppointmentModel {
  final String userId;
  final String doctorId;
  final String patientId;
  final String reason;
  final bool consultationType; // true = video, false = direct
  final String appointmentSlot; // e.g., "09:00 - 09:30"
  final bool appointmentStatus;
  final String date; // yyyy-MM-dd
  final PatientDetailModel patientDetailModel;
  final DoctorModel doctorModel;

  AppointmentModel({
    required this.userId,
    required this.doctorId,
    required this.patientId,
    required this.reason,
    required this.consultationType,
    required this.appointmentStatus,
    required this.appointmentSlot,
    required this.date,
    required this.patientDetailModel,
    required this.doctorModel,
  });

  factory AppointmentModel.fromJson( Map<String, dynamic>json) {
    // final json = snapshot.data() as Map<String, dynamic>;

    DateTime parsedDate;
    final rawDate = json['date'];

    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }
    return AppointmentModel(
      reason: json['reason'],
      userId: json['user_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      consultationType:
          (json['consultation_type'] is bool)
              ? json['consultation_type']
              : (json['consultation_type'].toString() == 'true'),
      appointmentStatus:
          (json['appointment_status'] is bool)
              ? json['appointment_status']
              : (json['appointment_status'].toString() == 'true'),
      appointmentSlot: json['appointment_slot']?.toString() ?? '',
      date: parsedDate.toString(),
       patientDetailModel:
          json['patient_detail_model'] != null
              ? PatientDetailModel.fromJson(json['patient_detail_model']) // ✅ fix here
              : json['patient_detail_model'],
      doctorModel:
          json['doctor_model'] != null
              ? DoctorModel.fromJson(json['doctor_model']) // ✅ fix here
              : json['doctor_model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason':reason,
      'user_id': userId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'consultation_type': consultationType,
      'appointment_status': appointmentStatus,
      'appointment_slot': appointmentSlot,
      'date': date,
      'patient_detail_model':patientDetailModel,
      'doctor_model': doctorModel,
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
