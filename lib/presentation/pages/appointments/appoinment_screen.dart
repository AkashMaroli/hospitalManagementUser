import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppoinmentScreen extends StatelessWidget {
  const AppoinmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Appointments"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AppointmentList(isUpcoming: true),
            AppointmentList(isUpcoming: false),
          ],
        ),
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  final bool isUpcoming;
  const AppointmentList({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> appointments = List.generate(7, (index) {
      return {
        "doctor": "Dr. Alis Johnson",
        "department": "General",
        "date": DateTime.now().add(Duration(days: index)),
        "isUpcoming": index % 2 == 0, // Mock: Even-indexed are upcoming, odd are completed
      };
    });

    // Filter upcoming/completed appointments
    List<Map<String, dynamic>> filteredAppointments =
        appointments.where((appt) => appt["isUpcoming"] == isUpcoming).toList();

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        var appointment = filteredAppointments[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 31, 199, 191),
                  Color.fromARGB(255, 53, 158, 158),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    height: 100,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/images/OIP (1).jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(appointment["doctor"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment["department"]), // Department Name
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUpcoming ? const Color.fromARGB(235, 7, 7, 7) : Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          " ${DateFormat('MMM dd, yyyy | hh:mm a').format(appointment["date"])}",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ), // Appointment Date & Time
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Message', style: TextStyle(fontSize: 19)),
                    Text('Calling', style: TextStyle(fontSize: 19)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
