import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/presentation/auth/sign_in_screen.dart';
import 'package:hospitalmanagementuser/presentation/widgets/bottom_nav_bar.dart';


class AuthStateListener extends StatefulWidget {
  const AuthStateListener({super.key});

  @override
  State<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends State<AuthStateListener> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInScreen(); 
          } else {
            return BottomNavBar(); 
          }
        }
        return CircularProgressIndicator(); 
      },
    );
  }
}