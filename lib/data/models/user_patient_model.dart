
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';

class UserPatientModel {
  final String? fullName;
  final String? emailId;
  final String? profilePhotoUrl;
  final List<PatientDetailModel>? patientDetailsList;

  UserPatientModel({
    this.fullName,
    this.emailId,
    this.profilePhotoUrl,
    this.patientDetailsList,
  });

  factory UserPatientModel.fromJson(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return UserPatientModel(
      fullName: json['userName'],
      emailId: json['emilId'],
      profilePhotoUrl: json['profilePhotoUrl'],
      patientDetailsList: (json['patientDetailsList'] as List<dynamic>?)
          ?.map((e) => PatientDetailModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': fullName,
      'emilId': emailId,
      'profilePhotoUrl': profilePhotoUrl,
      'patientDetailsList':
          patientDetailsList?.map((e) => e.toJson()).toList(),
    };
  }
}
