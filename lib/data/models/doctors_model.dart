import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/review_model.dart';

class DoctorsProfileModel {
  final String? id;
  final String fullName;
  final String department;
  final String qualification;
  final TimeOfDay availableTimeStart;
  final TimeOfDay availableTimeEnd;
  final String phoneNumber;
  final String photoUrl; // non-nullable
  final bool adminApproved;
  final String emailAddress;
  final String gender;
  final int yearsOfExperience;
  final bool videoConsultation;
  final int expectedConsultationFee; // per head
  final List<ReviewModel> reviewAndRatings;
  final bool activeStatus;
  final List<String> availableDays; // e.g. ['Monday', 'Wednesday']
  final String specialization;
  final String idProof;
  final String medicalLicence;
  final Duration timeDurationNeeded; // for each consultation
  final String rejectNote;
  final DateTime possibleJointDate;
  final bool personBlocked;

  DoctorsProfileModel({
    this.id,
    required this.fullName,
    required this.department,
    required this.qualification,
    required this.availableTimeStart,
    required this.availableTimeEnd,
    required this.phoneNumber,
    required this.photoUrl,
    required this.adminApproved,
    required this.emailAddress,
    required this.gender,
    required this.yearsOfExperience,
    required this.videoConsultation,
    required this.expectedConsultationFee,
    required this.reviewAndRatings,
    required this.activeStatus,
    required this.availableDays,
    required this.specialization,
    required this.idProof,
    required this.medicalLicence,
    required this.timeDurationNeeded,
    required this.rejectNote,
    required this.possibleJointDate,
    required this.personBlocked,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'department': department,
      'qualification': qualification,
      'available_time_start': _formatTimeOfDay(availableTimeStart),
      'available_time_end': _formatTimeOfDay(availableTimeEnd),
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'admin_approved': adminApproved,
      'email_address': emailAddress,
      'gender': gender,
      'years_of_experience': yearsOfExperience,
      'video_consultation': videoConsultation,
      'expected_consultation_fee': expectedConsultationFee,
      'review_and_ratings': reviewAndRatings.map((r) => r.toJson()).toList(),
      'active_status': activeStatus,
      'available_days': availableDays,
      'specialization': specialization,
      'id_proof': idProof,
      'medical_licence': medicalLicence,
      'time_duration_needed': timeDurationNeeded.inMinutes,
      'reject_note': rejectNote,
      'possible_joint_date': possibleJointDate.toIso8601String(),
      'person_blocked': personBlocked,
    };
  }

  factory DoctorsProfileModel.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    return DoctorsProfileModel(
      id: doc.id,
      fullName: json['full_name'] ?? '',
      department: json['department'] ?? '',
      qualification: json['qualification'] ?? '',
      availableTimeStart: _parseTimeOfDay(json['available_time_start']),
      availableTimeEnd: _parseTimeOfDay(json['available_time_end']),
      phoneNumber: json['phone_number'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      adminApproved: json['admin_approved'] ?? false,
      emailAddress: json['email_address'] ?? '',
      gender: json['gender'] ?? '',
      yearsOfExperience: json['years_of_experience'] ?? 0,
      videoConsultation: json['video_consultation'] ?? false,
      expectedConsultationFee: json['expected_consultation_fee'] ?? 0,
      reviewAndRatings: (json['review_and_ratings'] as List<dynamic>? ?? [])
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeStatus: json['active_status'] ?? false,
      availableDays: List<String>.from(json['available_days'] ?? <String>[]),
      specialization: json['specialization'] ?? '',
      idProof: json['id_proof'] ?? '',
      medicalLicence: json['medical_licence'] ?? '',
      timeDurationNeeded:
          Duration(minutes: json['time_duration_needed'] ?? 0),
      rejectNote: json['reject_note'] ?? '',
      possibleJointDate: DateTime.tryParse(json['possible_joint_date'] ?? '') ??
          DateTime.now(),
      personBlocked: json['person_blocked'] ?? false,
    );
  }

  // Utility: TimeOfDay <-> String
  static String _formatTimeOfDay(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  static TimeOfDay _parseTimeOfDay(String? timeStr) {
    if (timeStr == null || !timeStr.contains(":")) return const TimeOfDay(hour: 0, minute: 0);
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  
}
