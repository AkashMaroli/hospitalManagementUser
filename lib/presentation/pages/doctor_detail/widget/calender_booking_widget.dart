import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/pages/payment_detail_&_patient_detail/payment_patient_detail.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MaterialDoctorAppointmentPage extends StatefulWidget {
  DoctorsProfileModel profilObj;
  MaterialDoctorAppointmentPage({super.key, required this.profilObj});

  @override
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 16),
          _buildTimeSlots(),
          const SizedBox(height: 24),
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Colors.transparent,
              headerForegroundColor: Colors.black87,
              dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF008B8B);
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey[200];
                  }
                  return null;
                },
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey[400];
                  }
                  return Colors.black87;
                },
              ),
              todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
              todayForegroundColor:
                  WidgetStateProperty.all(const Color(0xFF008B8B)),
              todayBorder: BorderSide.none,
              dayStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              yearStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          child: CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 7)),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
              _loadAvailableSlots();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
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
              children: const [
                Icon(
                  Icons.access_time_rounded,
                  color: Color(0xFF008B8B),
                  size: 22,
                ),
                SizedBox(width: 8),
                Text(
                  'Select Time Slot',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d, y').format(_selectedDate),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            _availableSlots.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            color: Colors.grey.shade400,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No slots available for this day",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 2,
                    runSpacing: 8,
                    children: _availableSlots.map((slot) {
                      final isBooked = _bookedSlots.contains(slot);
                      final isSelected = _selectedTimeSlot == slot;

                      return InkWell(
                        onTap: isBooked
                            ? null
                            : () {
                                setState(() {
                                  _selectedTimeSlot =
                                      isSelected ? null : slot;
                                });
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isBooked
                                ? Colors.grey.shade200
                                : isSelected
                                    ? const Color(0xFF008B8B)
                                    : backgroudColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isBooked
                                  ? Colors.grey.shade300
                                  : isSelected
                                      ? const Color(0xFF008B8B)
                                      : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            slot,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isBooked
                                  ? Colors.grey.shade500
                                  : isSelected
                                      ? Colors.white
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    final isEnabled = _selectedTimeSlot != null;

    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF008B8B).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPatientDetail(
                      date: _selectedDate,
                      time: _selectedTimeSlot!,
                      doctorsProfileModel: profModel,
                    ),
                  ),
                ).then((_) {
                  // 👇 Auto refresh after returning from booking screen
                  _loadAvailableSlots();
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF008B8B),
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isEnabled ? Colors.white : Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Future<void> _loadAvailableSlots([DateTime? selected]) async {
    final prof = widget.profilObj;

    String _formatTimeOfDay(TimeOfDay time) =>
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    // Get selected day name (e.g., Mon, Tue...)
    final String selectedDayName = DateFormat('EEE').format(_selectedDate);
    if (!prof.availableDays.contains(selectedDayName)) {
      setState(() {
        _bookedSlots = [];
        _availableSlots = [];
        _selectedTimeSlot = null;
      });
      return;
    }

    // Slot duration
    int durationMinutes = prof.timeDurationNeeded.inMinutes;
    if (durationMinutes <= 0) {
      setState(() {
        _bookedSlots = [];
        _availableSlots = [];
        _selectedTimeSlot = null;
      });
      return;
    }

    // Generate all time slots between start and end time
    final allSlots = generateSlots(
      _formatTimeOfDay(prof.availableTimeStart),
      _formatTimeOfDay(prof.availableTimeEnd),
      durationMinutes,
    );

    try {
      // 🔹 Get booked slots from DB
      final booked = await fetchBookedSlots(prof.id, selected ?? _selectedDate);
      print("Booked slots: $booked");

      setState(() {
        _bookedSlots = booked;
        _availableSlots = allSlots; // 👈 show all, booked will be greyed out

        // If previously selected slot is now booked, deselect it
        if (_selectedTimeSlot != null && booked.contains(_selectedTimeSlot)) {
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
