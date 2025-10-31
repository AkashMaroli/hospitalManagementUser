import 'package:flutter/material.dart';

class PopupSelectField extends StatelessWidget {
  final String label;
  final dynamic value;
  final IconData icon;
  final List<dynamic> options;
  final void Function(dynamic) onSelected;
final FormFieldValidator<dynamic>? validator;

  const PopupSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.options,
    required this.onSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      value: value,
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Colors.grey),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: const Color(0xFFF2F4F8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      validator: validator,
      // underline: const SizedBox(),
      items: options
      .map((option) => DropdownMenuItem(
            value: option,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(option.toString(),
                  style: const TextStyle(fontSize: 16)),
            ),
          ))
      .toList(),
      onChanged: onSelected,
    );

  }
}
