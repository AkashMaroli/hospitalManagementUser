import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/calender_booking_widget.dart';

// ignore: must_be_immutable
class DoctorDetailScreen extends StatefulWidget {
  DoctorsProfileModel profilObj;
  DoctorDetailScreen({super.key, required this.profilObj});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    log(widget.profilObj.fullName);
    final total = widget.profilObj.reviewAndRatings.fold<int>(
  0,
  (sum, review) => sum + review.rating,
);
final avg = widget.profilObj.reviewAndRatings.isEmpty
    ? 0.0
    : total / widget.profilObj.reviewAndRatings.length;
    return Scaffold(
      backgroundColor: backgroudColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 100,
                  height: 100,
                  color: const Color.fromARGB(255, 230, 239, 255),
                  child: Image.network(widget.profilObj.photoUrl),
                ),
              ),
              SizedBox(height: 10),
              Text(widget.profilObj.fullName, style: TextStyle(color: Colors.black)),
              Text(widget.profilObj.department),
              Text(widget.profilObj.qualification),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Card(
                  color: backgroudColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.work),
                          title: Text('Total Experience'),
                          subtitle: Text(
                            '${widget.profilObj.yearsOfExperience}+ years',
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.school),
                          title: Text('Ratings'),
                          subtitle:
                              widget.profilObj.reviewAndRatings.isNotEmpty
                                  ? Text(
                                    '$avg(${widget.profilObj.reviewAndRatings.length})',
                                  )
                                  : Text('2.5(10)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Card(
                  color: backgroudColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.work),
                          title: Text('₹${widget.profilObj.expectedConsultationFee}'),
                          subtitle: Text('Consultation Fee'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text('Available Time'),
              MaterialDoctorAppointmentPage(profilObj: widget.profilObj),

              //    ButtonWidget(buttonTitle: 'Book Appointment', buttonOnpress: (){})
            ],
          ),
        ),
      ),
    );
  }
}
