import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/appointment_model.dart';
import 'package:hospitalmanagementuser/data/models/review_model_orgi.dart';
import 'package:hospitalmanagementuser/data/services/chat_services.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/pages/chat/chating/chating_screen.dart';
import 'package:intl/intl.dart';

Widget appointmentCard(
  AppointmentModel doctor,
  BuildContext context,
  bool completed, [
  TextEditingController? controller,
  double? size,
]) {
  // final total = doctor.reviewAndRatings.fold<int>(
  //   0,
  //   (sum, review) => sum + review.rating,
  // );
  // final avg =
  //     doctor.reviewAndRatings.isEmpty
  //         ? 2.0
  //         : total / doctor.reviewAndRatings.length;
  // final revCount = doctor.reviewAndRatings.length < 1?2:doctor.reviewAndRatings.length;
  String formattedDate = DateFormat(
    'dd MMM yyyy',
  ).format(DateTime.parse(doctor.date));

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(39, 8, 201, 231),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    doctor.doctorModel.photoUrl.isEmpty
                        ? Image.asset('assets/images/OIP ddd(1).jpeg')
                        : Image.network(
                          doctor.doctorModel.photoUrl,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                doctor.doctorModel.name.isNotEmpty
                    ? Text(
                      'Dr. ${doctor.doctorModel.name}',
                      style: TextStyle(
                        fontSize: 20,
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
                  '${doctor.doctorModel.department}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Gender: ${doctor.doctorModel.gender}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ), // Availability Info
                SizedBox(height: 5),

                Text(
                  "Patient: ${doctor.patientDetailModel.patientFullName}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  doctor.appointmentSlot,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
          ],
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            ChatServices obj = ChatServices();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => ChatScreen(
                      chatId: '${doctor.doctorId}_${doctor.userId}',
                      receiverId: '${doctor.doctorId}',
                      receiverName: '${doctor.doctorModel.name}',
                    ),
              ),
            );
            // obj.createOrOpenChat(
            //   doctorId: doctor.doctorId,
            //   patientId: doctor.patientId,
            //   doctorName: doctor.doctorModel.name,
            //   context: context,
            // );
          },
          style: ElevatedButton.styleFrom(backgroundColor: themeColor),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message_rounded, color: Colors.white, size: 22),
              Text('Send message', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
        SizedBox(height: 4),
        completed == true
            ? ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    double selectedRating =
                        0; // variable to store the selected rating

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Write your review'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ⭐ Interactive Star Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.star,
                                      size: 30,
                                      color:
                                          index < selectedRating
                                              ? Colors.amber
                                              : Colors.grey.shade400,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedRating = index + 1;
                                      });
                                    },
                                  );
                                }),
                              ),
                              const SizedBox(height: 10),

                              // 📝 Text Field for feedback
                              TextField(
                                controller: controller,
                                minLines: 3,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  hintText: 'Write your feedback...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),

                          // 🔘 Action buttons
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: handle submit action
                                print('Rating: $selectedRating');
                                print('Review: ${controller?.text}');
                                final review = ReviewRatingModel(
                                  reviewerId: doctor.userId,
                                  reviewerName:
                                      doctor.patientDetailModel.patientFullName,
                                  review: controller?.text ?? '',
                                  rating: selectedRating,
                                  timestamp: DateTime.now(),
                                );
                                addReview(
                                  doctorId: doctor.doctorId,
                                  review: review,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                              ),
                              child: const Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reviews, color: Colors.white, size: 22),
                  Text('Send Feedback', style: TextStyle(fontSize: 17)),
                ],
              ),
            )
            : SizedBox(),
      ],
    ),
  );
}
