// Doctor List Item Widget
  import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:intl/intl.dart';

Widget doctorsList(DoctorsProfileModel doctor) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(39, 8, 201, 231),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: doctor.photoUrl.isEmpty? Image.asset('assets/images/OIP ddd(1).jpeg'):Image.network(doctor.photoUrl,fit: BoxFit.cover,)
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. ${doctor.fullName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${doctor.department}',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                "Available: ${DateFormat('MMM dd, yyyy | hh:mm a').format(DateTime.now())}",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ), // Availability Info
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 5),
                  Text(
                    '4.0',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '${doctor.reviewAndRatings.length}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }