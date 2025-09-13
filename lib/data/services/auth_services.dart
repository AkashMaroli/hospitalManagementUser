import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

/// 🔐 Sign in with email & password
Future<User?> signIn(String email, String password) async {
  try {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  } catch (e) {
    print("Email sign-in failed: $e");
    return null;
  }
}

/// 🧾 Register a new user
Future<User?> register(String email, String password) async {
  try {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance.collection('users').add({
      'userName': result.user?.uid,
      'emilId': email 
    });
    return result.user;
  } catch (e) {
    print("Error registering: $e");
    return null;
  }
}

/// 🔄 Reset user password via email
Future<void> resetPassword(BuildContext context, String email) async {
  if (email.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Please enter your email.")));
    return;
  }

  try {
    await auth.sendPasswordResetEmail(email: email);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password reset email sent! Check your inbox."),
      ),
    );
  } catch (e) {
    print("Error: $e");
    String errorMessage = "Something went wrong. Try again later.";

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case "user-not-found":
          errorMessage = "No account found with this email.";
          break;
        case "invalid-email":
          errorMessage = "Invalid email format.";
          break;
      }
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMessage)));
  }
}

/// 🔓 Google Sign-In
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);
    // userAuthData = userCredential.user;
    final user = await FirebaseAuth.instance.currentUser;
    final userDetail = UserPatientModel(
      fullName: userCredential.user?.displayName ?? userCredential.user?.uid,
      emailId: userCredential.user?.email ?? 'unknown@gmail.com',
      profilePhotoUrl: userCredential.user?.photoURL,
      patientDetailsList: [],
    );
    createOrUpdateUser(user?.uid, userDetail);
    

    return userCredential.user;
  } catch (e) {
    print("Google sign-in failed: $e");
    return null;
  }
}

/// 🚪 Sign out from Firebase & Google
Future<void> signOut() async {
  try {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut(); // Disconnect Google session
    await auth.signOut(); // Firebase sign-out
    print("User signed out successfully!");
    log('success');
  } catch (e) {
    print("Error signing out: $e");
  }
}
