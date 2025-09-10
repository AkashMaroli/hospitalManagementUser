import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  String buttonTitle;
  VoidCallback buttonOnpress;
  ButtonWidget({super.key, required this.buttonTitle,required this.buttonOnpress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BottomNavBar(),
          //   ),
          // );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          // fixedSize: Size(double.infinity, 20),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
