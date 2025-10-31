import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/models/appointment_model.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_my_appointments/my_appointment_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_my_appointments/my_appointment_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_my_appointments/my_appointment_state.dart';
import 'package:hospitalmanagementuser/presentation/pages/appointments/widget/appointment_cards.dart';


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
            indicatorColor: themeColor,
            labelColor: themeColor,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            dividerColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (_) => AppointmentBloc()..add(LoadUpcomingAppointments()),
              child: const AppointmentTab(),
            ),
            BlocProvider(
              create: (_) => AppointmentBloc()..add(LoadCompletedAppointments()),
              child: const AppointmentTab(),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentTab extends StatelessWidget {
  const AppointmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return Center(child: CircularProgressIndicator(color: themeColor));
        } else if (state is AppointmentLoaded) {
          final appointments = state.appointments;
          if (appointments.isEmpty) {
            return Center(child: Text("No Appointments Found"));
          }
          return AppointmentList(filteredAppointments: appointments);
        } else if (state is AppointmentError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Center(child: Text('No Data'));
      },
    );
  }
}

class AppointmentList extends StatelessWidget {
  final List<AppointmentModel> filteredAppointments;
  final TextEditingController textcontroller = TextEditingController();

  AppointmentList({super.key, required this.filteredAppointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Theme.of(context).canvasColor,
            elevation: 2,
            child: appointmentCard(
              appointment,
              context,
              appointment.appointmentStatus,
              textcontroller,
            ),
          ),
        );
      },
    );
  }
}
