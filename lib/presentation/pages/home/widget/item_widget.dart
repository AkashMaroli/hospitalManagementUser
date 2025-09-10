import 'package:flutter/material.dart';

GestureDetector itemsWidget(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 253, 255),
              borderRadius: BorderRadius.circular(50),
            ),
            width: 75,
            height: 75,
            child: Icon(icon, size: 30),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
