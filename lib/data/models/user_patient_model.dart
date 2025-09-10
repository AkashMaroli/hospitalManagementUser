
// import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';

// class UserPatientModel {
//   final String? fullName;
//   final String? emailId;
//   final String? profilePhotoUrl;
//   final List<PatientDetailModel>? patientDetailsList;

//   UserPatientModel({
//     this.fullName,
//     this.emailId,
//     this.profilePhotoUrl,
//     this.patientDetailsList,
//   });

//   factory UserPatientModel.fromJson(Map<String, dynamic> json) {
//     return UserPatientModel(
//       fullName: json['fullName'],
//       emailId: json['emailId'],
//       profilePhotoUrl: json['profilePhotoUrl'],
//       patientDetailsList: (json['patientDetailsList'] as List<dynamic>?)
//           ?.map((e) => PatientDetailModel.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'fullName': fullName,
//       'emailId': emailId,
//       'profilePhotoUrl': profilePhotoUrl,
//       'patientDetailsList':
//           patientDetailsList?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
