import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/appointment_model.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:intl/intl.dart';

Stream<List<DoctorsProfileModel>> fetchDoctors() {
  return FirebaseFirestore.instance
      .collection('doctors')
      .where('admin_approved', isEqualTo: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => DoctorsProfileModel.fromFirestore(doc))
                .toList());
                }


// filter top doctors depends upon experience
Stream<List<DoctorsProfileModel>> filterExperienceDoctors() {
  return FirebaseFirestore.instance
      .collection('doctors')
      .where('admin_approved', isEqualTo: true).where('years_of_experience',isGreaterThan: 2)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => DoctorsProfileModel.fromFirestore(doc))
                .toList());
                }


// filter on duty doctors
Stream<List<DoctorsProfileModel>> filterOnDutyDoctors() {
  return FirebaseFirestore.instance
      .collection('doctors')
      .where('admin_approved', isEqualTo: true).where('active_status',isEqualTo: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => DoctorsProfileModel.fromFirestore(doc))
                .toList());
                }
// fetching booked slot from firebase based on appointment collection
Future<List<String>> fetchBookedSlots(String? doctorId, DateTime date) async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(date);

  final snapshot = await FirebaseFirestore.instance
      .collection('appointments')
      .where('doctor_id', isEqualTo: doctorId)
      .where('date', isEqualTo: formattedDate)
      .get();

  return snapshot.docs.map((doc) => doc['slot'] as String).toList();
}

// slot generator helper
List<String> generateSlots(
    String startTime, String endTime, int durationMinutes) {
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
      //! removed booked slots

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

