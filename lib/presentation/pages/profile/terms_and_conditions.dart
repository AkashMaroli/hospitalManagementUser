import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📜 Terms & Conditions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Effective Date: 15/10/2025\n\n'
                'Welcome to MedValley. By using our Appointment Booking App (the “App”), '
                'you agree to comply with and be bound by the following Terms & Conditions. '
                'Please read them carefully before using the App.',
              ),
              SizedBox(height: 20),
              Text(
                '1. Use of the App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• You must be at least 18 years old or have parental consent to use this App.\n'
                '• You agree to provide accurate and truthful information while registering and booking appointments.\n'
                '• You may not use the App for any illegal or unauthorized purpose.',
              ),
              SizedBox(height: 20),
              Text(
                '2. Appointment Booking',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• All bookings are subject to doctor availability.\n'
                '• Users are responsible for attending the appointment at the scheduled time.\n'
                '• No cancellations or no changes can be made ',                             
              ),
              SizedBox(height: 20),
              Text(
                '3. User Responsibilities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• You are responsible for maintaining the confidentiality of your account.\n'
                '• Do not share your login credentials with anyone.\n'
                '• Misuse of the App may lead to account suspension or termination.',
              ),
              SizedBox(height: 20),
              Text(
                '4. Data & Privacy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• By using this App, you agree to our Privacy Policy.\n'
                '• We collect and use your information only to provide services and improve the user experience.\n'
                '• We do not sell your personal information.',
              ),
              SizedBox(height: 20),
              Text(
                '5. Limitation of Liability',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• MedValley is not responsible for delays, cancellations, or any issues caused by third parties.\n'
                '• Medical advice or treatment is provided solely by the doctor, not the App.\n'
                '• We are not liable for any loss or damage arising from the use of this App.',
              ),
              SizedBox(height: 20),
              Text(
                '6. Changes to Terms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We may update or change these Terms & Conditions at any time. '
                'Changes will be effective once updated in the App. Please review periodically.',
              ),
              SizedBox(height: 20),
              Text(
                '7. Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions about these Terms & Conditions, contact us at:\n'
                '📧 akashmaroli2000@gmail.com\n'
                '🏢 Akash Maroli',
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  '© 2025 MedValley. All Rights Reserved.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
