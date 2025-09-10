import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/pages/payment_detail_&_patient_detail/payment_patient_detail.dart';
import 'package:intl/intl.dart'; // Added for DateFormat

// ignore: must_be_immutable
class MaterialDoctorAppointmentPage extends StatefulWidget {
  DoctorsProfileModel profilObj;
  MaterialDoctorAppointmentPage({super.key, required this.profilObj});

  @override
  // ignore: library_private_types_in_public_api
  _MaterialDoctorAppointmentPageState createState() =>
      _MaterialDoctorAppointmentPageState();
}

class _MaterialDoctorAppointmentPageState
    extends State<MaterialDoctorAppointmentPage> {
  late DoctorsProfileModel profModel;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> _availableSlots = [];
  List<String> _bookedSlots = [];

 
  @override
  void initState() {
    super.initState();
    profModel = widget.profilObj;
    _loadAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:  16.0,bottom: 16,left: 8,right: 8),
      child: Column(
        children: [          
          _buildCalendar(),
          SizedBox(height: 20),
          _buildTimeSlots(),
          SizedBox(height: 20),
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      color: backgroudColor,
      child: Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF008B8B); // Selected date color
              }
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey[200]; // Disabled dates color
              }
              return null; // Default color
            }),
            dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white; // Selected date text color
              }
              return null; // Default text color
            }),
            todayBorder: const BorderSide(
              color: Colors.transparent,
            ), // Remove today's border
            todayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white; // Today's text color when selected
              }
              return const Color(
                0xFF008B8B,
              ); // Today's text color when not selected
            }),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
              print(_selectedDate);
            });
            _loadAvailableSlots();
          },
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Card(
      color: backgroudColor,
      child: Padding(
        padding: const EdgeInsets.only(top:  16.0,bottom: 16,left: 5,right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Time Slot',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _availableSlots.isEmpty
                ? Center(
                  child: Text(
                    "No slots available for this day",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                : Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children:
                      _availableSlots.map((slot) {
                        final isBooked = _bookedSlots.contains(slot);

                        return ChoiceChip(
                          label: Text(slot),
                          selected: _selectedTimeSlot == slot,
                          selectedColor: Color(0xFF008B8B),
                          backgroundColor:
                              isBooked ? Colors.grey.shade300 : backgroudColor,
                          onSelected:
                              isBooked
                                  ? null
                                  : (selected) {
                                    setState(() {
                                      _selectedTimeSlot =
                                          selected ? slot : null;
                                    });
                                  },
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed:
          _selectedTimeSlot != null
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PaymentPatientDetail(
                          date: _selectedDate,
                          time: _selectedTimeSlot!,
                          doctorsProfileModel: profModel,
                        ),
                  ),
                );
              }
              : null,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Color(0xFF008B8B), // Dark Cyan
      ),
      child: Text('Book Appointment'),
    );
  }

  Future<void> _loadAvailableSlots([DateTime? selected]) async {
    final prof = widget.profilObj;

    String _formatTimeOfDay(TimeOfDay time) =>
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    // Check if selected day is a working day for this doctor
    final String selectedDayName = DateFormat(
      'EEE',
    ).format(_selectedDate); // e.g., Monday
    if (!prof.availableDays.contains(selectedDayName)) {
      setState(() {
        _bookedSlots = [];
        _availableSlots = [];
        _selectedTimeSlot = null;
      });
      // print("❌ Doctor not available on $selectedDayName");
      return;
    }

    // ✅ Convert timeDurationNeeded into minutes safely
    int durationMinutes = 0;
    if (prof.timeDurationNeeded is Duration) {
      durationMinutes = (prof.timeDurationNeeded as Duration).inMinutes;
    } else if (prof.timeDurationNeeded is int) {
      durationMinutes = prof.timeDurationNeeded as int;
    } else if (prof.timeDurationNeeded is String) {
      durationMinutes = int.tryParse(prof.timeDurationNeeded as String) ?? 0;
    } else {
      // print("⚠️ Unknown type for timeDurationNeeded: ${prof.timeDurationNeeded.runtimeType}");
    }

    if (durationMinutes <= 0) {
      setState(() {
        _bookedSlots = [];
        _availableSlots = [];
        _selectedTimeSlot = null;
      });
      // print("❌ Invalid duration: ${prof.timeDurationNeeded}");
      return;
    }

    // // Debug prints
    // print("Doctor availability: ${prof.availableTimeStart} - ${prof.availableTimeEnd}");
    // print("Duration (minutes): $durationMinutes");
    // print("Selected date: $_selectedDate");

    // Generate all possible slots
    final allSlots = generateSlots(
      _formatTimeOfDay(prof.availableTimeStart),
      _formatTimeOfDay(prof.availableTimeEnd),
      durationMinutes,
    );
    // print("Generated slots: $allSlots");

    // Get booked slots from Firestore
    try {
      final booked = await fetchBookedSlots(prof.id, selected ?? _selectedDate);
      print("Booked slots: $booked");

      // Remove booked slots
      final available = allSlots.where((s) => !booked.contains(s)).toList();

      setState(() {
        _bookedSlots = booked;
        _availableSlots = available;
        if (_selectedTimeSlot != null &&
            !available.contains(_selectedTimeSlot)) {
          _selectedTimeSlot = null;
        }
      });
    } catch (e) {
      print("❌ Error fetching booked slots: $e");
      setState(() {
        _bookedSlots = [];
        _availableSlots = [];
        _selectedTimeSlot = null;
      });
    }
  }
}
