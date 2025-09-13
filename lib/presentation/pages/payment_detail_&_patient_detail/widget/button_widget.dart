import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/services/razorpay_services.dart';

Widget buildPayButton(BuildContext context, VoidCallback buttonFunction) {
  return ElevatedButton(
    onPressed: () {
      buttonFunction();
      print('working button');
    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50),
      backgroundColor: Color(0xFF008B8B), // Dark Cyan
    ),
    child: Text('Pay'),
  );
}
