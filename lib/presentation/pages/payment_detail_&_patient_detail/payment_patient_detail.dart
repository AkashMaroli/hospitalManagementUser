import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/appointment_heper_model.dart';
import 'package:hospitalmanagementuser/data/models/appointment_model.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/patient_info_card_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/payment_detail_&_patient_detail/widget/button_widget.dart';
import 'package:hospitalmanagementuser/presentation/widgets/bottom_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: must_be_immutable
class PaymentPatientDetail extends StatefulWidget {
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
  State<PaymentPatientDetail> createState() => _PaymentPatientDetailState();
}

class _PaymentPatientDetailState extends State<PaymentPatientDetail> {
  List<PatientDetailModel> patients = [];
  late Future<UserPatientModel> userDetailsCarrier;
  PatientDetailModel? selectedPatient;
  TextEditingController reasonController = TextEditingController();
  late Razorpay _razorpay;
  String patientname = '';
  var amountTotal;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    userDetailsCarrier = userDataFetching();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM, yyyy').format(widget.date);
    int sumamount = widget.doctorsProfileModel.expectedConsultationFee + 50;
    amountTotal = sumamount;

    return Scaffold(
      backgroundColor: backgroudColor,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Info Card
                Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 230, 239, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.network(
                              widget.doctorsProfileModel.photoUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctorsProfileModel.fullName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.doctorsProfileModel.department,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF008B8B),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                widget.doctorsProfileModel.qualification,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Patient Info Section
                FutureBuilder<List<PatientDetailModel>>(
                  future: fetchPatientsFromUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFF008B8B),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Card(
                        elevation: 2,
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No user data found"),
                        ),
                      );
                    } else {
                      final patientslist = snapshot.data!;
                      patients = snapshot.data!;
                      return PatientInfoCard(
                        patientlistobj: patientslist,
                        isFirstPatient: (patientslist.isEmpty) ? true : false,
                        onPatientSelected: (patient) {
                          setState(() {
                            selectedPatient = patient;
                            // selectedGlobalPatient = patient;
                          });
                        },
                        onPatientAdded: refreshPatientList,
                      ) ;
                    }
                  },
                ),
                SizedBox(height: 20),

                // Schedule Section
                Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF008B8B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.access_time_rounded,
                                color: Color(0xFF008B8B),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  widget.time,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 40),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF008B8B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xFF008B8B),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Payment Section
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildBillRow(
                          'Consultation Fee',
                          '₹${widget.doctorsProfileModel.expectedConsultationFee}',
                          false,
                        ),
                        SizedBox(height: 12),
                        _buildBillRow('Booking Fee', '₹50', false),
                        SizedBox(height: 16),
                        Divider(thickness: 1),
                        SizedBox(height: 12),
                        _buildBillRow('Total Amount', '₹$sumamount', true),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Payment Method Card
                Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.payment_rounded,
                          color: Color(0xFF008B8B),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Pay with',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/png-transparent-razorpay-logo-tech-companies-thumbnail-removebg-preview.png',
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Pay Button
                buildPayButton(context, openCheckout),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.black54,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Color(0xFF008B8B) : Colors.black87,
          ),
        ),
      ],
    );
  }

  void openCheckout() async {
    var options = {
      'key': myRazorpayapikey,
      'amount': amountTotal * 100,
      'name': 'Med Valley',
      'description': 'Payment for services',
      'prefill': {'contact': '9876543210', 'email': 'example@domain.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String purpose = "Appointment Booking";
    DateTime now = DateTime.now();

    final docDetails =
        DoctorModel(
          name: widget.doctorsProfileModel.fullName,
          department: widget.doctorsProfileModel.department,
          gender: widget.doctorsProfileModel.gender,
          photoUrl: widget.doctorsProfileModel.photoUrl,
        ).toJson();

    final patientDetails =
        PatientDetailModel(
          patientFullName: selectedPatient?.patientFullName ?? '',
          age: selectedPatient?.age ?? '',
          mobNumber: selectedPatient?.mobNumber ?? '',
          gender: selectedPatient?.gender ?? '',
          department: selectedPatient?.department ?? '',
        ).toJson();

    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'paymentId': response.paymentId,
        'amount': amountTotal / 100,
        'purpose': purpose,
        'timestamp': now,
      });

      await FirebaseFirestore.instance.collection('appointments').add({
        'user_id': FirebaseAuth.instance.currentUser?.uid,
        'doctor_id': widget.doctorsProfileModel.id,
        'patient_id': selectedPatient?.patientId,
        'reason': reasonController.text,
        'consultation_type': false,
        'appointment_status': false,
        'appointment_slot': widget.time,
        'date': widget.date,
        'patient_detail_model': patientDetails,
        'doctor_model': docDetails,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text("Payment Successful!"),
            ],
          ),
          backgroundColor: themeColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (route) => false,
      );
    } catch (e) {
      print("Error saving payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text("Payment saved failed"),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text("Payment failed: ${response.message}")),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  } 

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
  }
    void refreshPatientList() {
    setState(() {
       fetchPatientsFromUser();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}
