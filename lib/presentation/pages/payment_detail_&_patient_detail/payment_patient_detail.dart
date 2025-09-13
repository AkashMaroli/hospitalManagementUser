import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/auth_services.dart';
import 'package:hospitalmanagementuser/presentation/controllers/global_controller.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/patient_info_card_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/payment_detail_&_patient_detail/widget/button_widget.dart';
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
  late Razorpay _razorpay;
  String patientname='';
  var amountTotal;
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMM, yyyy').format(widget.date);
    int sumamount = widget.doctorsProfileModel.expectedConsultationFee + 50;
    amountTotal=sumamount;
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
                    widget.doctorsProfileModel.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(widget.doctorsProfileModel.fullName),
              Text(widget.doctorsProfileModel.department),
              Text(widget.doctorsProfileModel.qualification),
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
                          Text(widget.time),
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
                                '${widget.doctorsProfileModel.expectedConsultationFee}',
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
                                '$sumamount',
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
              buildPayButton(context, openCheckout),
            ],
          ),
        ),
      ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': myRazorpayapikey, // Replace with your Razorpay Key
      'amount': amountTotal * 100, // in paise = 500 INR
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
    // String userId =
    //     "USER_ID"; // Replace with real user ID from FirebaseAuth if using auth
    String purpose = "Appointment Booking";
    DateTime now = DateTime.now();

    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'paymentId': response.paymentId,
        'amount': amountTotal / 100, // convert paise to INR
        'purpose': purpose,
        'timestamp': now,
      });
      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'doctorId':widget.doctorsProfileModel.id ,
        'patientName': patientname, 
        'date': widget.date,
        'time': widget.time,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment Successful!")));
    } catch (e) {
      print("Error saving payment: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment saved failed")));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    // Show error message
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}
