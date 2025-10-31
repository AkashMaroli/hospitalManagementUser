import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/patient_details_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/widget/document_upload_widget.dart';
import 'package:hospitalmanagementuser/presentation/widgets/button_widget.dart';
import 'package:hospitalmanagementuser/presentation/widgets/drop_down_textfield.dart';
import 'package:hospitalmanagementuser/presentation/widgets/login_widgets.dart';
import 'package:image_picker/image_picker.dart';

class PatientInfoCard extends StatefulWidget {
  List<PatientDetailModel> patientlistobj;
  bool isFirstPatient;
  final Function(PatientDetailModel)? onPatientSelected;
    final VoidCallback? onPatientAdded; // 👈 NEW callback


  PatientInfoCard({
    super.key,
    required this.isFirstPatient,
    required this.patientlistobj,
    this.onPatientSelected,
        this.onPatientAdded, // 👈 add here too

  });

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

PatientDetailModel? selectedGlobalPatient;

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
        if (!mounted) return;
        setState(() => _uploadedImageUrl = response.data["secure_url"]);
        print("Image uploaded: $_uploadedImageUrl");
      }
    } catch (e) {
      print("Image upload error: $e");
      throw ("Image upload failed: $e", isError: true);
    }
  }

  @override
  void initState() {
    super.initState();
    // if (widget.patientlistobj.isNotEmpty) {
    //   selectedGlobalPatient = widget.patientlistobj.first;
    // }
  }

  @override
  Widget build(BuildContext context) {
    log(selectedGlobalPatient?.patientFullName.toString() ?? '');
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFF008B8B),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF008B8B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('here working');
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
                    icon: Icon(Icons.add, color: Color(0xFF008B8B), size: 24),
                    tooltip: 'Add Patient',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            widget.isFirstPatient
                ? _buildEmptyState()
                : _buildPatientDetails(
                  selectedGlobalPatient ?? widget.patientlistobj.first,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add_alt_1_rounded,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No Patient Added',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add patient details to proceed',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetails(PatientDetailModel patientDetails) {
    print("coming patient is ${patientDetails.patientFullName}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF008B8B).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF008B8B).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF008B8B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 32, color: Color(0xFF008B8B)),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Patient',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<PatientDetailModel>(
                        value: selectedGlobalPatient,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF008B8B),
                        ),
                        hint: Text(
                          'Select Patient',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        items:
                            widget.patientlistobj.map((patient) {
                              return DropdownMenuItem<PatientDetailModel>(
                                value: patient,
                                child: Text(
                                  patient.patientFullName ?? 'Unknown',
                                ),
                              );
                            }).toList(),
                        onChanged: (newPatient) {
                          if (newPatient == null) return;
                          setState(() {
                            selectedGlobalPatient = newPatient;
                          });
                          widget.onPatientSelected?.call(newPatient);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Colors.blue.shade700,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You can add new patient by clicking the + button',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
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
    double borderRadius = 24,
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder:
                  (_, controller) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: [
                        // Handle Bar
                        Container(
                          margin: EdgeInsets.only(top: 12, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF008B8B).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.person_add_alt_rounded,
                                  color: Color(0xFF008B8B),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Add New Patient',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, thickness: 1),
                        // Form Content
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel('Patient Name *'),
                                SizedBox(height: 8),
                                normalTextField(
                                  'Enter patient name',
                                  Icons.person_outline,
                                  nameController,
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter patient name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),

                                _buildSectionLabel('Patient Age *'),
                                SizedBox(height: 8),
                                numberTextField('Enter age', ageController, (
                                  value,
                                ) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter age';
                                  }
                                  return null;
                                }),
                                SizedBox(height: 20),

                                _buildSectionLabel('Phone Number *'),
                                SizedBox(height: 8),
                                numberTextField(
                                  'Enter phone number',
                                  phoneNumberController,
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                    if (value.length != 10) {
                                      return 'Please enter valid 10 digit number';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),

                                _buildSectionLabel('Consulting Department *'),
                                SizedBox(height: 8),
                                PopupSelectField(
                                  label: 'Select Department',
                                  value: selectedDepartment,
                                  icon: Icons.local_hospital_outlined,
                                  options: [
                                    'Dental',
                                    'Cardiology',
                                    'ENT',
                                    'Gynecology',
                                    'General',
                                  ],
                                  onSelected:
                                      (val) => setState(() {
                                        selectedDepartment = val;
                                        department = selectedDepartment;
                                      }),
                                  validator:
                                      (val) =>
                                          val == null || val.isEmpty
                                              ? 'Select department'
                                              : null,
                                ),
                                SizedBox(height: 20),

                                _buildSectionLabel('Gender *'),
                                SizedBox(height: 8),
                                PopupSelectField(
                                  label: 'Select Gender',
                                  value: selectedGender,
                                  icon: Icons.wc_outlined,
                                  options: ['Male', 'Female', 'Other'],
                                  onSelected:
                                      (val) => setState(() {
                                        selectedGender = val;
                                        gender = selectedGender;
                                      }),
                                  validator:
                                      (val) =>
                                          val == null || val.isEmpty
                                              ? 'Select gender'
                                              : null,
                                ),
                                SizedBox(height: 20),

                                _buildSectionLabel(
                                  'Medical Document (Optional)',
                                ),
                                SizedBox(height: 8),
                                DocumentUploadWidget(
                                  onTap: _pickImage,
                                  documentName:
                                      _selectedImage != null
                                          ? "Document Uploaded"
                                          : null,
                                  isUploaded: _selectedImage != null,
                                ),
                                SizedBox(height: 32),

                                // Save Button
                                Container(
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFF008B8B,
                                        ).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(
                                        'buttonwidget before save function',
                                      );
                                      saveButtonClick();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF008B8B),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Save Patient Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  saveButtonClick() async {
    print('button function started');

    // Validate required fields
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        department == null ||
        gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Please fill all required fields'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF008B8B)),
                  SizedBox(height: 16),
                  Text(
                    'Saving patient details...',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
    );

    try {
      await _uploadImageToCloudinary();
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final updatePatientObj = PatientDetailModel(
        patientFullName: nameController.text,
        age: ageController.text,
        mobNumber: phoneNumberController.text,
        gender: gender ?? '',
        department: department ?? '',
      );

      await addPatient(uid, updatePatientObj);
      await fetchPatientsFromUser();

      // Close loading dialog
      Navigator.pop(context);
      // Close bottom sheet
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Patient added successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
           widget.onPatientAdded?.call(); // tell parent to refresh

      // Clear fields
      nameController.clear();
      ageController.clear();
      phoneNumberController.clear();
      setState(() {
        department = null;
        gender = null;
        _selectedImage = null;
        _uploadedImageUrl = null;
      });
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context) ;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Failed to save patient: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ) ;
    }
  }
}
