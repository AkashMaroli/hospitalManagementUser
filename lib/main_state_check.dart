import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospitalmanagementuser/presentation/auth/sign_in_screen.dart';
import 'package:hospitalmanagementuser/presentation/widgets/bottom_nav_bar.dart';

class AuthStateListener extends StatefulWidget {
  const AuthStateListener({super.key});

  @override
  State<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends State<AuthStateListener> {
  late Future<bool?> _loginCheckFuture;

  @override
  void initState() {
    super.initState();
    _loginCheckFuture = checkLoginStatus();
  }

  Future<bool?> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Return null if key doesn't exist (first time user)
    if (!prefs.containsKey('isLoggedIn')) {
      return null;
    }
    final status = prefs.getBool('isLoggedIn');
    print("🔍 App restart - Login status: $status");
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: _loginCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final value = snapshot.data;

        if (value == null) {
          // First time user
          print("📱 Navigating to OnboardingScreen");
          return const OnboardingScreen();
        } else if (value == false) {
          // Logged out user
          print("🚪 Navigating to SignInScreen");
          return const SignInScreen();
        } else {
          // Logged in user
          print("🏠 Navigating to BottomNavBar");
          return const BottomNavBar();
        }
      },
    );
  }
}
