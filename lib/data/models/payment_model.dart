// import 'package:cloud_firestore/cloud_firestore.dart';

// class DoctorProfileModel {
//   final String? id; // Firestore document ID (optional)
//   final String name;
//   final String department;
//   final String qualification;
//   final String availableTimeStart;
//   final String availableTimeEnd;
//   final String phoneNumber;
//   final String? photoUrl;
//   bool verified;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String documentUrl;
//   // string variable for duty type off or on duty//*dutyStatus-field name;

//   DoctorProfileModel({
//     this.id, // Optional Firestore document ID
//     required this.name,
//     required this.department,
//     required this.qualification,
//     required this.availableTimeStart,
//     required this.availableTimeEnd,
//     required this.phoneNumber,
//     this.photoUrl,
//     this.verified = false,
//     this.createdAt,
//     this.updatedAt,
//     required this.documentUrl,
//   });

//   //! Send Data to Firestore
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'department': department,
//       'qualification': qualification,
//       'available_time_start': availableTimeStart,
//       'available_time_end': availableTimeEnd,
//       'phone_number': phoneNumber,
//       'photo_url': photoUrl,
//       'verified': verified,
//       'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
//       'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
//       'documentUrl':
//           documentUrl, // ✅ Fixed: Added missing field
//     };
//   }

//   //! Receive Data from Firestore
//   factory DoctorProfileModel.fromJson(Map<String, dynamic> json, {String? id}) {
//     return DoctorProfileModel(
//       id: id, // Firestore document ID
//       name: json['name'] ?? '',
//       department: json['department'] ?? '',
//       qualification: json['qualification'] ?? '',
//       availableTimeStart: json['available_time_start'] ?? '',
//       availableTimeEnd: json['available_time_end'] ?? '',
//       phoneNumber: json['phone_number'] ?? '',
//       photoUrl: json['photo_url'],
//       verified: (json['verified'] as bool?) ?? false,
//       createdAt: (json['created_at'] as Timestamp?)?.toDate(),
//       updatedAt: (json['updated_at'] as Timestamp?)?.toDate(),
//       documentUrl:
//           json['documentUrl'] ??
//           '', // ✅ Fixed: Ensure documentUrl is correctly received
//     );
//   }

//   //! Copy Method for Updating Data
//   DoctorProfileModel copyWith({
//     String? id,
//     String? name,
//     String? department,
//     String? qualification,
//     String? availableTimeStart,
//     String? availableTimeEnd,
//     String? phoneNumber,
//     String? photoUrl,
//     bool? verified,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     String? documentUrl,
//   }) {
//     return DoctorProfileModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       department: department ?? this.department,
//       qualification: qualification ?? this.qualification,
//       availableTimeStart: availableTimeStart ?? this.availableTimeStart,
//       availableTimeEnd: availableTimeEnd ?? this.availableTimeEnd,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       photoUrl: photoUrl ?? this.photoUrl,
//       verified: verified ?? this.verified,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       documentUrl: documentUrl ?? this.documentUrl,
//     );
//   }

//   @override
//   String toString() {
//     return 'DoctorProfileModel{id: $id, name: $name, department: $department, qualification: $qualification, '
//         'availableTimeStart: $availableTimeStart, availableTimeEnd: $availableTimeEnd, '
//         'phoneNumber: $phoneNumber, photoUrl: $photoUrl, verified: $verified, '
//         'createdAt: $createdAt, updatedAt: $updatedAt, documentUrl: $documentUrl}';
//   }
// }
