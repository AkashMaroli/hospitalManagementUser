import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospitalmanagementuser/data/models/appointment_model.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/models/review_model.dart';
import 'package:hospitalmanagementuser/data/models/review_model_orgi.dart';
import 'package:intl/intl.dart';

//!--------Fetch--Doctors--Details--------
Stream<List<DoctorsProfileModel>> fetchDoctors() {
  final doctorsCollection = FirebaseFirestore.instance.collection('doctors');

  return doctorsCollection
      .where('admin_approved', isEqualTo: true)
      .snapshots()
      .asyncMap((snapshot) async {
        final doctors = await Future.wait(
          snapshot.docs.map((doc) async {
            final doctor = DoctorsProfileModel.fromFirestore(doc);

            // 🔹 Fetch subcollection for reviews
            final reviewSnapshot =
                await doctorsCollection
                    .doc(doc.id)
                    .collection('reviewCollection')
                    .get();

            final reviews =
                reviewSnapshot.docs.map((reviewDoc) {
                  final data = reviewDoc.data();
                  return ReviewModel(
                    reviewerName: data['reviewerName'] ?? '',
                    reviewContent: data['review'] ?? '',
                    rating:
                        (data['rating'] is double)
                            ? (data['rating'] as double).round()
                            : (data['rating'] ?? 0),
                  );
                }).toList();

            // ✅ Attach reviews to doctor model using copyWith
            return doctor.copyWith(reviewAndRatings: reviews);
          }),
        );

        return doctors;
      });
}

//!----------Filter--Top--Doctors--Depends--Upon--Experience-----------
Stream<List<DoctorsProfileModel>> filterExperienceDoctors() {
  final doctorsCollection = FirebaseFirestore.instance.collection('doctors');

  return doctorsCollection
      .where('admin_approved', isEqualTo: true)
      .where('years_of_experience', isGreaterThan: 2)
      .snapshots()
      .asyncMap((snapshot) async {
        final doctors = await Future.wait(
          snapshot.docs.map((doc) async {
            final doctor = DoctorsProfileModel.fromFirestore(doc);

            // Fetch subcollection for reviews
            final reviewSnapshot =
                await doctorsCollection
                    .doc(doc.id)
                    .collection('reviewCollection')
                    .get();

            final reviews =
                reviewSnapshot.docs.map((reviewDoc) {
                  final data = reviewDoc.data();
                  return ReviewModel(
                    reviewerName: data['reviewerName'] ?? '',
                    reviewContent: data['review'] ?? '',
                    rating:
                        (data['rating'] is double)
                            ? (data['rating'] as double).round()
                            : (data['rating'] ?? 0),
                  );
                }).toList();

            // 👇 Use copyWith instead of reconstructing model
            return doctor.copyWith(reviewAndRatings: reviews);
          }),
        );

        return doctors;
      });
}

//!--------Filter--On--Duty--Doctors----------------
Stream<List<DoctorsProfileModel>> filterOnDutyDoctors() {
  final doctorsCollection = FirebaseFirestore.instance.collection('doctors');

  return doctorsCollection
      .where('admin_approved', isEqualTo: true)
      .where('department', isEqualTo: "General")
      .snapshots()
      .asyncMap((snapshot) async {
        final doctors = await Future.wait(
          snapshot.docs.map((doc) async {
            final doctor = DoctorsProfileModel.fromFirestore(doc);

            // Fetch subcollection for reviews
            final reviewSnapshot =
                await doctorsCollection
                    .doc(doc.id)
                    .collection('reviewCollection')
                    .get();

            final reviews =
                reviewSnapshot.docs.map((reviewDoc) {
                  final data = reviewDoc.data();
                  return ReviewModel(
                    reviewerName: data['reviewerName'] ?? '',
                    reviewContent: data['review'] ?? '',
                    rating:
                        (data['rating'] is double)
                            ? (data['rating'] as double).round()
                            : (data['rating'] ?? 0),
                  );
                }).toList();

            // ✅ Attach reviews to doctor model
            return doctor.copyWith(reviewAndRatings: reviews);
          }),
        );

        return doctors;
      });
}

//! Fetching--Booked--Slot--From--Firebase--Based--On--Appointment--Collection---------
Future<List<String>> fetchBookedSlots(String? doctorId, DateTime date) async {
  if (doctorId == null) return [];

  // Convert selected date to range (00:00:00 to 23:59:59)
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

  final snapshot =
      await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctor_id', isEqualTo: doctorId) // ✅ correct field name
          .where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          ) // ✅ timestamp comparison
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

  return snapshot.docs
      .map((doc) => doc['appointment_slot'] as String) // ✅ correct field name
      .toList();
}

// slot generator helper
List<String> generateSlots(
  String startTime,
  String endTime,
  int durationMinutes,
) {
  final DateFormat fmt = DateFormat("HH:mm");

  DateTime start = fmt.parse(startTime);
  DateTime end = fmt.parse(endTime);

  List<String> slots = [];
  while (start.isBefore(end)) {
    DateTime slotEnd = start.add(Duration(minutes: durationMinutes));
    if (slotEnd.isAfter(end)) break;

    slots.add("${fmt.format(start)} - ${fmt.format(slotEnd)}");
    start = slotEnd;
  }

  return slots;
}

//!----------Removed--Booked--Slots--------
List<String> getAvailableSlots({
  required DoctorAvailability availability,
  required String selectedDay, // e.g. "Mon"
  required List<String> bookedSlots,
}) {
  // Check if doctor works that day
  if (!availability.days.contains(selectedDay)) return [];

  // Generate slots
  final allSlots = generateSlots(
    availability.startTime,
    availability.endTime,
    availability.slotDuration,
  );

  // Remove booked ones
  return allSlots.where((slot) => !bookedSlots.contains(slot)).toList();
}

//!--------Add--Doctor--Review---------
Future<void> addReview({
  required String doctorId,
  required ReviewRatingModel review,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('reviewCollection')
        .add(review.toJson());
    print('✅ Review added successfully');
  } catch (e) {
    print('❌ Error adding review: $e');
    rethrow;
  }
}

//!---------Review--Ratings--Of--Doctors-------
Stream<List<ReviewRatingModel>> streamDoctorReviews(String? doctorId) {
  try {
    if (doctorId == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('reviewCollection')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return ReviewRatingModel(
                  reviewerId: data['reviewerId'],
                  reviewerName: data['reviewerName'],
                  review: data['review'],
                  rating: (data['rating'] as num).toDouble(),
                  timestamp: (data['timestamp'] as Timestamp).toDate(),
                );
              }).toList(),
        );
  } catch (e) {
    print('❌ Error streaming reviews: $e');
    return const Stream.empty();
  }
}
