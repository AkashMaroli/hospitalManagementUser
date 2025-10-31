import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/presentation/widgets/app_dropdown_field.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedPrice;
  String? selectedExperience;
  String? selectedGender;

  double? minPrice;
  double? maxPrice;
  int? minExperience;

  void parsePrice(String? price) {
    if (price != null) {
      final parts = price.split('-');
      minPrice = double.tryParse(parts[0].trim());
      maxPrice = double.tryParse(parts[1].trim());
    } else {
      minPrice = null;
      maxPrice = null;
    }
  }

  void parseExperience(String? exp) {
    if (exp != null && exp.isNotEmpty) {
      final number = int.tryParse(exp.split(' ')[0]);
      minExperience = number;
    } else {
      minExperience = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey,
                ),
                width: 60,
                height: 5,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            subHeading('Price'),
            AppDropdownField(
              label: 'Price',
              value: selectedPrice,
              options: ['100 - 150', '200 - 250', '300 - 350'],
              onChanged: (value) {
                setState(() {
                  selectedPrice = value as String;
                  parsePrice(selectedPrice);
                });
              },
              icon: Icons.currency_rupee,
            ),
            subHeading('Experience'),
            AppDropdownField(
              label: 'Experience',
              value: selectedExperience,
              options: [
                '1 Experience',
                '2 Experience',
                '3 Experience',
                '4 Experience',
                '5 Experience or above',
              ],
              onChanged: (value) {
                setState(() {
                  selectedExperience = value as String;
                  parseExperience(selectedExperience);
                });
              },
              icon: Icons.person,
            ),
            subHeading('Gender'),
            AppDropdownField(
              label: 'Gender',
              value: selectedGender,
              options: ['Male', 'Female'],
              onChanged: (value) {
                setState(() {
                  selectedGender = value as String;
                });
              },
              icon: Icons.person_outline,
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPrice = null;
                      selectedExperience = null;
                      selectedGender = null;
                      minPrice = null;
                      maxPrice = null;
                      minExperience = null;
                    });
                    context.read<DoctorBloc>().add(FetchDoctorsEvent());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(
                      "$minPrice,$maxPrice,$selectedGender,$minExperience thata all",
                    );
                    context.read<DoctorBloc>().add(
                      FilterDoctorsEvent(
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        minExperience: minExperience,
                        gender: selectedGender,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text subHeading(String title) =>
      Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold));
}
