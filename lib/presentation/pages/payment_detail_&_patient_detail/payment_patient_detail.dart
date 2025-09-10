import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/patient_info_card_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/payment_detail_&_patient_detail/widget/button_widget.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PaymentPatientDetail extends StatelessWidget {
  DoctorsProfileModel doctorsProfileModel;
  final DateTime date;
  final String time;
  PaymentPatientDetail({
    required this.doctorsProfileModel,
    super.key,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM, yyyy').format(date);
    int sum=doctorsProfileModel.expectedConsultationFee+50;
    return Scaffold(
      backgroundColor: backgroudColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 5,
            children: [
              SizedBox(height: 80),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 100,
                  height: 100,
                  color: const Color.fromARGB(255, 230, 239, 255),
                  child: Image.network(
                    doctorsProfileModel.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(doctorsProfileModel.fullName),
              Text(doctorsProfileModel.department),
              Text(doctorsProfileModel.qualification),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [Text(" Appointment")],
              // ),
              PatientInfoCard(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Schedule")],
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [],
                    color: backgroudColor,
                  ),
                  child: Column(
                    children: [
                      ListTile(title: Text('Time & Date')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.query_builder),
                          Text(time),
                          SizedBox(width: 30),
                          Icon(Icons.calendar_month_outlined),
                          Text(formattedDate),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Payment")],
              ),
              Card(
                child: Container(
                  padding: EdgeInsetsDirectional.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [],
                    color: backgroudColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Bill Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [Text('Consultation Fee')]),
                          Column(
                            children: [
                              Text(
                                '${doctorsProfileModel.expectedConsultationFee}',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [Text('Booking Fee')]),
                          Column(children: [Text('50')]),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Total Bill Amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$sum',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [],
                    color: backgroudColor,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Pay with',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        child: Image.asset(
                          'assets/icons/png-transparent-razorpay-logo-tech-companies-thumbnail-removebg-preview.png',
                          height: 50,
                          width: 50,
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildPayButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
