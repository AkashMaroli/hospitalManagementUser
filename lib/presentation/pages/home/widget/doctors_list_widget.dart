// Doctor List Item Widget
import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/doctor_detail.dart';

Widget doctorsList(
  DoctorsProfileModel doctor,
  BuildContext context,
  bool isHome, [
  double? size,
]) {
  final total = doctor.reviewAndRatings.fold<int>(
    0,
    (sum, review) => sum + review.rating,
  );
  
  final avg =
      doctor.reviewAndRatings.isEmpty
          ? 0.0
          : total / doctor.reviewAndRatings.length;
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 105,
              width: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(39, 8, 201, 231),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    doctor.photoUrl.isEmpty
                        ? Image.asset(
                          'assets/images/OIP ddd(1).jpeg',
                          fit: BoxFit.cover,
                        )
                        : Image.network(
                          doctor.photoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Image loaded
                            }
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ); // Show icon while loading
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                        ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3),
                doctor.fullName.isNotEmpty
                    ? Text(
                      'Dr. ${doctor.fullName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : Text(
                      'Dr. Uknown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                Text(
                  doctor.department,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Experience: ${doctor.yearsOfExperience}years",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ), // Availability Info
                SizedBox(height: 5),
                Row(
                  children: [
                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 16,
                          color:
                              index < avg.round()
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$avg',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '|',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.reviewAndRatings.length}  Reviews',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: themeColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Text(
                  "₹${doctor.expectedConsultationFee.toString()}/p",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: size ?? MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DoctorDetailScreen(
                                      profilObj: doctor,
                                    ),
                              ),
                            );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              minimumSize: Size(size ?? double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Book Appointment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );
}
