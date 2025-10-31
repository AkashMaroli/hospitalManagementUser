import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospitalmanagementuser/data/models/appointment_model.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';
import 'package:hospitalmanagementuser/data/models/patient_history_model.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';

//!--------UserData---Fetching-------
Future<UserPatientModel> userDataFetching() async {
    log('working usedata fetching');

  final currentUser = FirebaseAuth.instance.currentUser;
  print(currentUser?.photoURL);
  final doc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get();

  if (!doc.exists) {
    throw Exception("User not found in Firestore ");
  }
  log("user data exist ?:${doc.exists}");
  // log("${doc.exists}");
  return UserPatientModel.fromJson(doc);
}

//!-----Fetch---PatientData--From--UserData---
Future<List<PatientDetailModel>> fetchPatientsFromUser() async {
  final user = await userDataFetching();

  if (user.patientDetailsList == null || user.patientDetailsList!.isEmpty) {
    return [];
  }

  List<PatientDetailModel> patients = [];

  for (var patientId in user.patientDetailsList!) {
    final patientDoc =
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .get();

    if (patientDoc.exists) {
      patients.add(
        PatientDetailModel.fromJson(patientDoc.data()!, patientDoc.id),
      );
    }
  }
  print(patients);
  return patients;
}

//!--------Add--New--UserData--Into--User--Collection------
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

//!--------Create-=And--Add--New--PatientData
Future<String> addPatient(String uid, PatientDetailModel patient) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

  // cretea new collection patients return the doc
  final patientDoc = FirebaseFirestore.instance.collection('patients').doc();

  final patintDetails = PatientDetailModel(
    patientId: patientDoc.id,
    patientFullName: patient.patientFullName,
    age: patient.age,
    mobNumber: patient.mobNumber,
    gender: patient.gender,
    department: patient.department,
  );
  await patientDoc.set(patintDetails.toJson());
  // Add patient to the list
  await userDoc.update({
    'patientDetailsList': FieldValue.arrayUnion([patientDoc.id]),
  });

  // Create a patients sub-collection doc for history
  // await userDoc.collection('patientDetailsList').doc(patient.patientId).set({
  //   'basicInfo': patient.toJson(),
  // });
  return patientDoc.id;
}
//!--------Add--New--PatientHistory------

Future<void> addPatientHistory({
  required String uid,
  required String patientId,
  required PatientHistoryModel history,
}) async {
  // here few mistakes will come because here second collection patients is not exist in firebase it a list in firebase

  final historyRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('patients')
      .doc(patientId)
      .collection('history');

  await historyRef.add(history.toJson());
}

//!--------Users--Upcoming--Appointments----------
Future<List<AppointmentModel>> userUpcomingAppointments() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  print(currentUser?.photoURL);
  final mathchingdocs =
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('user_id', isEqualTo: currentUser?.uid)
          .where('appointment_status', isEqualTo: false)
          .get();
  log("func appoint not comp${mathchingdocs.docs.length}");
  return mathchingdocs.docs
      .map((doc) => AppointmentModel.fromJson(doc.data()))
      .toList();

  // return UserPatientModel.fromJson(docs);
}

//!--------Users--Completed--Appointments------
Future userCompletedAppointments() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  print(currentUser?.photoURL);
  final mathchingdocs =
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('user_id', isEqualTo: currentUser?.uid)
          .where('appointment_status', isEqualTo: true)
          .get();
  log(mathchingdocs.docs.length.toString());
  return mathchingdocs.docs
      .map((doc) => AppointmentModel.fromJson(doc.data()))
      .toList();

  // return UserPatientModel.fromJson(docs);
}
