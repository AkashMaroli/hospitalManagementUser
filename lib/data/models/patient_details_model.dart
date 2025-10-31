import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/patient_history_model.dart';

class PatientDetailModel {
  final String? patientId;
  final String patientFullName;
  final String age;
  final String mobNumber;
  final String gender;
  final String department;
  final List<String>? documentUrl;
  final List<PatientHistoryModel>? patientHistory;
  // final DoctorsProfileModel selecteddoctormodel;

  PatientDetailModel({
    this.patientId,
    required this.patientFullName,
    required this.age,
    required this.mobNumber,
    required this.gender,
    required this.department,
    this.documentUrl,
    this.patientHistory,
    // required this.selecteddoctormodel
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientDetailModel &&
          runtimeType == other.runtimeType &&
          patientFullName == other.patientFullName &&
          mobNumber == other.mobNumber;

  @override
  int get hashCode => Object.hash(patientFullName, mobNumber);

  factory PatientDetailModel.fromJson(Map<String, dynamic> json,[String? docId]) {
    // here i made a change i changed the parameter map<string,dynamic> json to current format
    // in the future is there any issue do the nesassery steps
    // final json = doc.data() as Map<String, dynamic>;

    return PatientDetailModel(
      patientId:
          docId, // NEW// patent id(json['patienId']) change to doc.id//!

      patientFullName: json['patientFullName'],
      age: json['age'],
      mobNumber: json['mobNumber'],
      gender: json['gender'],
      department: json['department'],
      documentUrl:
          (json['documentUrl'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      patientHistory:
          (json['patientHistory'] as List<dynamic>?)
              ?.map((e) => PatientHistoryModel.fromJson(e))
              .toList(),
      // selecteddoctormodel: json['selected_doctor_model']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // patien id part removed //!
      'patientFullName': patientFullName,
      'age': age,
      'mobNumber': mobNumber,
      'gender': gender,
      'department': department,
      'documentUrl': documentUrl,
      'patientHistory': patientHistory?.map((e) => e.toJson()).toList(),
      // 'selected_doctor_model': selecteddoctormodel
    };
  }
}
