import 'dart:ui';

import 'package:flutter/material.dart';

Widget normalTextField(
  String hint,
  IconData icon,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: 'Enter  $hint',
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

Widget passwordTextField(
  String label,
  bool need,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      obscureText: need,
      validator: validator,
      decoration: InputDecoration(
        hintText: '$label your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: Icon(need ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}


Widget numberTextField(
  String label,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      keyboardType:TextInputType.number,
      validator: validator,
      decoration: InputDecoration(
        hintText: 'complete this field',
        prefixIcon: const Icon(Icons.lock_outline),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
