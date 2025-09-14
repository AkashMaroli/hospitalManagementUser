import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/document_upload_widget.dart';
import 'package:hospitalmanagementuser/presentation/widgets/button_widget.dart';
import 'package:hospitalmanagementuser/presentation/widgets/drop_down_textfield.dart';
import 'package:hospitalmanagementuser/presentation/widgets/login_widgets.dart';
import 'package:image_picker/image_picker.dart';

class PatientInfoCard extends StatefulWidget {
  UserPatientModel obj;
  bool isFirstPatient;
  // PatientDetailModel patientDetailModel;

  PatientInfoCard({super.key, required this.isFirstPatient, required this.obj});
 
  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  String? department;
  String? gender;
  File? _selectedImage;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_selectedImage == null) return;

    try {
      final cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/dahbtbonq/image/upload";

      final formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(_selectedImage!.path),
        "upload_preset": "hospital_management_preset",
        "folder": "doctors",
      });

      final client = dio.Dio();
      final response = await client.post(cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        setState(() => _uploadedImageUrl = response.data["secure_url"]);
        print("Image uploaded: $_uploadedImageUrl");
      }
    } catch (e) {
      print("Image upload error: $e");
      throw ("Image upload failed: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('patientlist length: ${widget.obj.patientDetailsList?.length}');
    return  Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Patient info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showCustomBottomSheet(
                      context: context,
                      nameController: nameController,
                      ageController: ageController,
                      genderController: genderController,
                      phoneNumberController: phoneNumberController,
                      departmentController: departmentController,
                      selectedDepartment: department,
                      selectedGender: gender,
                      selectedImage: _selectedImage,
                      uploadedImageUrl: _uploadedImageUrl,
                    );
                  },
                  icon: Icon(Icons.add),
                ),

                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_sharp)),
              ],
            ),
            const SizedBox(height: 10),

            widget.isFirstPatient
                ? Center(child: Column(children: [Text('Add patient details')]))
                : patientInfoDetails(widget.obj),
          ],
        ),
      ),
    );
  }

  Row patientInfoDetails(UserPatientModel patientDetails) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10), // Space between image and text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patientDetails.patientDetailsList?[0].patientFullName ??
                    'Unknown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                'Note: You can submit patient details, old reports, and test reports in the drop link',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                softWrap: true,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Click to upload prescription',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showCustomBottomSheet({
    required BuildContext context,
    bool isDismissible = true,
    bool enableDrag = true,
    double borderRadius = 20,
    required TextEditingController nameController,
    required TextEditingController ageController,

    required TextEditingController genderController,
    required TextEditingController phoneNumberController,
    required TextEditingController departmentController,
    required String? selectedDepartment,
    required String? selectedGender,
    required File? selectedImage,
    required String? uploadedImageUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Patient Name'),
                  normalTextField(
                    'patient name',
                    Icons.person,
                    nameController,
                    (value) {
                      if (value == null) {
                        return 'type patient name';
                      }
                      return null;
                    },
                  ),
                  Text('Patient Age'),

                  numberTextField('age', ageController, (value) {}),
                  Text('Patient Phone number'),

                  numberTextField(
                    'phone number',
                    phoneNumberController,
                    (value) {},
                  ),

                  Text('Patient Consulting Department'),

                  PopupSelectField(
                    label: 'Select Department',
                    value: selectedDepartment,
                    icon: Icons.local_hospital,
                    options: [
                      'Dental',
                      'Cardiology',
                      'ENT',
                      'Gynecology',
                      'General',
                    ],
                    onSelected:
                        (val) => setState(() => selectedDepartment = val),
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Select department'
                                : null,
                  ),
                  Text('Patient Gender'),

                  PopupSelectField(
                    label: 'Select Gender',
                    value: selectedGender,
                    icon: Icons.local_hospital,
                    options: ['Male', 'Female', 'Other'],
                    onSelected: (val) => setState(() => selectedGender = val),
                    validator:
                        (val) =>
                            val == null || val.isEmpty ? 'Select gender' : null,
                  ),
                  Text('Patient Document(optional)'),

                  DocumentUploadWidget(
                    onTap: _pickImage,
                    documentName:
                        _selectedImage != null ? "Document Uploaded" : null,
                    isUploaded: _selectedImage != null,
                  ),
                  ButtonWidget(
                    buttonTitle: 'Save Details',
                    buttonOnpress: () {
                      saveButtonClick();
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  saveButtonClick() async {
    print('button function started');
    await _uploadImageToCloudinary();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final updatePatientObj = PatientDetailModel(
      patientFullName: nameController.text,
      age: ageController.text,
      mobNumber: phoneNumberController.text,
      gender: gender ?? 'Not specified',
      department: department ?? 'Not specified',
    );

    await addPatient(uid, updatePatientObj);
  }
}
