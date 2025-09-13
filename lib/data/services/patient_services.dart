// import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';
// import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';

// UserPatientModel patientDetail;
// global auth data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';
import 'package:hospitalmanagementuser/data/models/patient_history_model.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';

var userDetaill;
Future<UserPatientModel> userDataFetching() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  print(currentUser?.photoURL);
  final doc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get();

  if (!doc.exists) {
    throw Exception("User not found in Firestore");
  }

  return UserPatientModel.fromJson(doc);
}

Future<void> createOrUpdateUser(String? userId, UserPatientModel user) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(
          user.toJson(),
          SetOptions(merge: true), // merge true keeps old fields
        );
    print("✅ User saved successfully");
  } catch (e) {
    print("❌ Error saving user: $e");
  }
}

Future<void> addPatient(String uid, PatientDetailModel patient) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

  // Add patient to the list
  await userDoc.update({
    'patientDetailsList': FieldValue.arrayUnion([patient.toJson()]),
  });

  // Create a patients sub-collection doc for history
  await userDoc.collection('patients').doc(patient.patientId).set({
    'basicInfo': patient.toJson(),
  });
}

Future<void> addPatientHistory({
  required String uid,
  required String patientId,
  required PatientHistoryModel history,
}) async {
  final historyRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('patients')
      .doc(patientId)
      .collection('history');

  await historyRef.add(history.toJson());
}
