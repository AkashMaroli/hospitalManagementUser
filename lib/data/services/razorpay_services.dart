import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout() async {
    var options = {
      'key': myRazorpayapikey, // Replace with your Razorpay Key
      'amount': 100, // in paise = 500 INR
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
    String userId =
        "USER_ID"; // Replace with real user ID from FirebaseAuth if using auth
    int amountPaid = 50000; // in paise
    String purpose = "Appointment Booking";
    DateTime now = DateTime.now();

    try {
      await FirebaseFirestore.instance.collection('payments').add({
        'userId': userId,
        'paymentId': response.paymentId,
        'amount': amountPaid / 100, // convert paise to INR
        'purpose': purpose,
        'timestamp': now,
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

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: Text("Pay Now")),
    //   body: Center(
    //     child: ElevatedButton(
    //       onPressed: openCheckout,
    //       child: Text("Pay ₹500"),
    //     ),
    //   ),
    // );
    return Placeholder();
  }
}
