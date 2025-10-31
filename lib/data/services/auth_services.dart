import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';
import 'package:hospitalmanagementuser/data/services/sharedpreference_change_services.dart';
import 'package:hospitalmanagementuser/main_state_check.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

//! 🔐 Sign in with email & password
Future<User?> signIn(
  String email,
  String password,
  BuildContext context,
) async {
  try {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    updateSharedPreferenceData(true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthStateListener()),
      (route) => false,
    );
    return result.user;
  } catch (e) {
    print("Email sign-in failed: $e");
    return null;
  }
}

//! 🧾 Register a new user
Future<User?> register(
  String email,
  String password,
  BuildContext context,
) async {
  try {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userDetail = UserPatientModel(
      fullName: result.user?.displayName ?? result.user?.uid,
      emailId: result.user?.email ?? 'unknown@gmail.com',
      profilePhotoUrl: result.user?.photoURL ?? '',
      patientDetailsList: [],
    );
    createOrUpdateUser(result.user?.uid, userDetail);
    updateSharedPreferenceData(true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthStateListener()),
      (route) => false,
    );

    return result.user;
  } catch (e) {
    print("Error registering: $e");
    return null;
  }
}

//! 🔄 Reset user password via email
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMessage)));
  }
}

/// 🔓 Google Sign-In
Future<User?> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);
    final user = await FirebaseAuth.instance.currentUser;
    final userDetail = UserPatientModel(
      fullName: userCredential.user?.displayName ?? userCredential.user?.uid,
      emailId: userCredential.user?.email ?? 'unknown@gmail.com',
      profilePhotoUrl: userCredential.user?.photoURL,
      patientDetailsList: [],
    );
    createOrUpdateUser(user?.uid, userDetail);
    updateSharedPreferenceData(true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthStateListener()),
      (route) => false,
    );
    return userCredential.user;
  } catch (e) {
    print("Google sign-in failed: $e");
    return null;
  }
}

/// 🚪 Sign out from Firebase & Google
Future<void> signOut(BuildContext context) async {
  try {
    // Try to disconnect from Google Sign-In, but don't fail if it doesn't work
    try {
      await _googleSignIn.disconnect();
      print("✅ Google Sign-In disconnected successfully");
    } catch (googleError) {
      print(
        "⚠️ Google Sign-In disconnect failed (continuing anyway): $googleError",
      );
    }

    try {
      await _googleSignIn.signOut();
      print("✅ Google Sign-In signed out successfully");
    } catch (googleError) {
      print(
        "⚠️ Google Sign-In sign out failed (continuing anyway): $googleError",
      );
    }

    // Always try to sign out from Firebase
    await auth.signOut();
    print("✅ Firebase Auth signed out successfully");

    // Always update SharedPreferences to false
    await updateSharedPreferenceData(false);
    print("✅ SharedPreferences updated to false");

    print("User signed out successfully!");
    log('Logout completed successfully');
  } catch (e) {
    print("❌ Critical error during sign out: $e");
    // Even if there's an error, try to update SharedPreferences
    try {
      await updateSharedPreferenceData(false);
      print("✅ SharedPreferences updated to false despite error");
    } catch (prefsError) {
      print("❌ Failed to update SharedPreferences: $prefsError");
    }
  }
}
