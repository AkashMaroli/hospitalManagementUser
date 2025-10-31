import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

// !--------Loggin--Status--Add--To--Sharedpreference---------
// Future<void> saveData(String logRoute) async {
//   final prefs = await SharedPreferences.getInstance();
//   // await prefs.setString('username', 'Akash');
//   await prefs.setBool('isLoggedIn', true);
//   // await prefs.setInt('age', 25);
// }

//!--------//!--------Loggin--Status--Update--To--Sharedpreference---------
Future<void> updateSharedPreferenceData(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', value); // old value replaced
  print("💾 SharedPreferences updated to: $value");
  log("SharedPreferences isLoggedIn: ${prefs.get('isLoggedIn')}");
}

//!--------Loggin--Status--Remove--From--Sharedpreference---------
Future<void> removeSharedPreferenceData(String routeKey) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(routeKey);
}
