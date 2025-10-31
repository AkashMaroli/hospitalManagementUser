import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                '🛡️ Privacy Policy',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Effective Date: 15/10/2025\n\n'
                'MedValley (“we,” “our,” or “us”) is committed to protecting your privacy. '
                'This Privacy Policy explains how we collect, use, and safeguard your personal information '
                'when you use our Hospital Management & Appointment Booking App (the “App”).\n\n'
                'By using the App, you agree to the terms of this Privacy Policy.',
              ),
              SizedBox(height: 20),
              Text(
                '1. Information We Collect',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We may collect the following information when you use the App:\n'
                '- Personal Information: Name, phone number, email, gender, profile photo.\n'
                '- Appointment Information: Doctor name, date, time slot, booking details.\n'
                '- Device Information: Device type, OS, basic usage data.\n'
                '- Uploaded Files: Prescriptions or health reports you choose to upload.',
              ),
              SizedBox(height: 20),
              Text(
                '2. How We Use Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We use your data to:\n'
                '- Provide appointment booking services.\n'
                '- Maintain your profile and booking history.\n'
                '- Improve performance and experience.\n'
                '- Send reminders and updates.\n'
                '- Comply with legal obligations.',
              ),
              SizedBox(height: 20),
              Text(
                '3. How We Share Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We do not sell your personal data. We may share it with:\n'
                '- Doctors (for appointments).\n'
                '- Admins (for verification).\n'
                '- Trusted service providers (Firebase, Supabase, Cloudinary).\n'
                '- Legal authorities if required by law.',
              ),
              SizedBox(height: 20),
              Text(
                '4. Data Storage and Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your data is securely stored in trusted cloud services. '
                'We use encryption and access controls to protect your information. '
                'Only authorized personnel can access sensitive data.',
              ),
              SizedBox(height: 20),
              Text(
                '5. Your Rights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You have the right to:\n'
                '- View and update your personal information.\n'
                '- Cancel or delete your account.\n'
                '- Request deletion of your data (subject to legal obligations).\n\n'
                'To make a request, contact us at akashmaroli2000@gmai.com.',
              ),
              SizedBox(height: 20),
              Text(
                '6. Third-Party Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We use trusted services like Firebase, Supabase, and Cloudinary for secure data processing. '
                'Their privacy policies apply in addition to ours.',
              ),
              SizedBox(height: 20),
              Text(
                '7. Changes to This Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We may update this Privacy Policy from time to time. '
                'Updates will be posted in the App and the “Effective Date” will be revised accordingly.',
              ),
              SizedBox(height: 20),
              Text(
                '8. Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns, contact us at:\n'
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
