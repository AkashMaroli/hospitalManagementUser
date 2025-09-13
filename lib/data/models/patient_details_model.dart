import 'package:hospitalmanagementuser/data/models/patient_history_model.dart';

class PatientDetailModel {
  final String patientId; 
  final String patientFullName;
  final String age;
  final String mobNumber;
  final String gender;
  final String department;
  final List<String>? documentUrl;
  final List<PatientHistoryModel>? patientHistory;

  PatientDetailModel({
        required this.patientId,

    required this.patientFullName,
    required this.age,
    required this.mobNumber,
    required this.gender,
    required this.department,
    this.documentUrl,
    this.patientHistory,
  });

  factory PatientDetailModel.fromJson(Map<String, dynamic> json) {
    return PatientDetailModel(
            patientId: json['patientId'], // NEW

      patientFullName: json['patientFullName'],
      age: json['age'],
      mobNumber: json['mobNumber'],
      gender: json['gender'],
      department: json['department'],
      documentUrl: (json['documentUrl'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      patientHistory: (json['patientHistory'] as List<dynamic>?)
          ?.map((e) => PatientHistoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
            'patientId': patientId, // NEW

      'patientFullName': patientFullName,
      'age': age,
      'mobNumber': mobNumber,
      'gender': gender,
      'department': department,
      'documentUrl': documentUrl,
      'patientHistory': patientHistory?.map((e) => e.toJson()).toList(),
    };
  }
}
