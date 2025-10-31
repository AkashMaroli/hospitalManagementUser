// import 'package:flutter/material.dart';
// import 'package:hospitalmanagementuser/core/constants.dart';
// import 'package:lottie/lottie.dart';

// class PaymentConfirmScreen extends StatelessWidget {
//   const PaymentConfirmScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroudColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             //  mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Lottie Animation
//               SizedBox(
//                 height: 200, // Set height for animation
//                 child: Lottie.asset(
//                   'assets/animation/Animation - 1743483178975.json',
//                 ),
//               ),
//               SizedBox(height: 20), // Space between animation and text
//               Text(
//                 "Thanks, Your booking has been confirmed.",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.only(left: 50, right: 50),
//                 child: Text(
//                   "Please check your email for receipt and booking details.",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 17,
//                     color: Colors.grey,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Card(
//                 child: Container(
//                   color: backgroudColor,
//                   width: double.infinity,
//                   height: 220,
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(5),
//                           child: Image.asset('assets/images/OIP ddd(1).jpeg'),
//                         ),
//                         title: Text('Dr.Kevon Lane'),
//                         subtitle: Text('Gynecologist'),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.type_specimen_outlined),
//                         title: Text('Offline'),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.calendar_month),
//                         title: Text('Wednesday,Feb 17,2024'),
//                         subtitle: Text('06:40 PM'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
