import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Icon or Logo
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.calendar_month,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: Text(
                  'Appointment Booking App',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),

              Center(
                child: Text(
                  'Making healthcare access simple, fast & secure.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Description
              Text(
                'Our Appointment Booking App is designed to make healthcare access fast, simple, and convenient. Patients can easily browse verified doctors, view their profiles, check available time slots, and book appointments in just a few taps.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              Text(
                'For doctors, the app provides a secure platform to manage their schedules, approve or decline appointments, and stay connected with patients. Admins can verify doctors and ensure a trusted environment for users.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),

              // Key Features
              Text(
                '✨ Key Features:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              _buildFeatureItem(Icons.schedule, 'Real-time appointment booking'),
              _buildFeatureItem(Icons.person_search, 'Verified doctor profiles'),
              _buildFeatureItem(Icons.lock, 'Secure authentication & data'),
              _buildFeatureItem(Icons.check_circle, 'Instant booking confirmation'),
              _buildFeatureItem(Icons.manage_accounts, 'Role-based access'),
              _buildFeatureItem(Icons.calendar_today, 'Easy slot management'),
              _buildFeatureItem(Icons.cloud_upload, 'Cloud image & document upload'),
              _buildFeatureItem(Icons.chat, 'Chat and communication'),

              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
