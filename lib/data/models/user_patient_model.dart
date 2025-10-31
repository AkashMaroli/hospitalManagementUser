import 'package:cloud_firestore/cloud_firestore.dart';

class UserPatientModel {
  final String? fullName;
  final String? emailId;
  final String? profilePhotoUrl;
  final List<String>? patientDetailsList;

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
      emailId: json['emailId'],
      profilePhotoUrl: json['profilePhotoUrl'],
      patientDetailsList:
          (json['patientDetailsList'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': fullName,
      'emailId': emailId, // fixed typo
      'profilePhotoUrl': profilePhotoUrl,
      'patientDetailsList': patientDetailsList,
    };
  }
}
