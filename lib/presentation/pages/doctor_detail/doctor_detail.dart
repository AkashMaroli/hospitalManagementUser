import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/calender_booking_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/profile/review_and_ratings.dart';

// ignore: must_be_immutable
class DoctorDetailScreen extends StatelessWidget {
  DoctorsProfileModel profilObj;
  DoctorDetailScreen({super.key, required this.profilObj});

  @override
  Widget build(BuildContext context) {
    log(profilObj.fullName);
    final total = profilObj.reviewAndRatings.fold<int>(
      0,
      (sum, review) => sum + review.rating,
    );
    final avg =
        profilObj.reviewAndRatings.isEmpty
            ? 0.0
            : total / profilObj.reviewAndRatings.length;

    return Scaffold(
      backgroundColor: backgroudColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Doctor Profile Image
              Hero(
                tag: 'doctor_${profilObj.id}',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 230, 239, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(profilObj.photoUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Doctor Name
              Text(
                profilObj.fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 6),

              // Department
              Text(
                profilObj.department,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF008B8B),
                ),
              ),
              SizedBox(height: 4),

              // Qualification
              Text(
                profilObj.qualification,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 24),

              // Experience & Ratings Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoTile(
                            icon: Icons.work_outline_rounded,
                            title: 'Experience',
                            subtitle: '${profilObj.yearsOfExperience}+ years',
                            iconColor: Color(0xFF008B8B),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              log(profilObj.id.toString());
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReviewAndRating(
                                        doctorId: profilObj.id ?? '',
                                      ),
                                ),
                              );
                            },
                            child: _buildInfoTile(
                              icon: Icons.star_rounded,
                              title: 'Ratings',
                              subtitle:
                                  profilObj.reviewAndRatings.isNotEmpty
                                      ? '${avg.toStringAsFixed(1)} (${profilObj.reviewAndRatings.length})'
                                      : 'Not Yet',
                              iconColor: Colors.amber.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Consultation Fee Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF008B8B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF008B8B),
                        size: 28,
                      ),
                    ),
                    title: Text(
                      'Consultation Fee',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    subtitle: Text(
                      '₹${profilObj.expectedConsultationFee}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Available Time Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Calendar and Time Slots
              MaterialDoctorAppointmentPage(profilObj: profilObj),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
