import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_home_onduty_doc/home_filter_onduty_bloc_bloc.dart';
import 'package:hospitalmanagementuser/presentation/pages/appointments/appoinment_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/all_doctors_screen.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_filter_top_doctors/home_filter_top_doctors_bloc.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/widget/doctors_list_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/widget/item_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/widget/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  DoctorBloc()..add(
                    FetchDoctorsEvent(),
                  ), // Bloc created + event triggered
        ),
        BlocProvider(
          create: (context) => HomeFilterOndutyBloc()..add(FilterOndutyEvent()),
        ),
        BlocProvider(
          create: (context) => HomeFilterTopDoctorsBloc()..add(FilterTopDoctorsEvent()),
        ),
      ],
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('How are you feeling today?', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal ListView of doctors
              SizedBox(
                height: 180,
                child: BlocBuilder<HomeFilterOndutyBloc, HomeFilterOndutyState>(
                  builder: (context, state) {
                    if (state is HomeFilterOndutyLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is HomeFilterOndutyErrorState) {
                      return Center(child: Text("Error: ${state.message}"));
                    } else if (state is HomeFilterOndutyLoadedState) {
                      if (state.doctors.isEmpty) {
                        return Center(child: Text("No doctors available."));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = state.doctors[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.85,
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
                                  SizedBox(height: 15),
                                  ListTile(
                                    leading: Container(
                                      height: 100,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          doctor.photoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  Icon(Icons.person),
                                        ),
                                      ),
                                    ),
                                    title: Text(doctor.fullName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(doctor.department),
                                        SizedBox(height: 6),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            "Available: ${DateFormat('MMM dd, yyyy | hh:mm a').format(DateTime.now())}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Message',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Text(
                                        'Calling',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox(); // For initial state or fallback
                  },
                ),
              ),

              // Health Needs Section
              SizedBox(height: 20),
              Text(
                'Health Needs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  itemsWidget(
                    'Appointments',
                    Icons.calendar_today_outlined,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AppoinmentScreen()),
                      );
                    },
                  ),
                  itemsWidget('Doctors', Icons.person_sharp, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AllDoctorsScreen()),
                    );
                  }),
                  itemsWidget('Medicine', Icons.medication_outlined, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AppoinmentScreen()),
                    );
                  }),
                  itemsWidget('More', Icons.dashboard_customize_rounded, () {
                    largeBottomSheet(context);
                  }),
                ],
              ),

              // Top Doctors Section
              SizedBox(height: 20),
              Text(
                'Top Doctors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              BlocBuilder<HomeFilterTopDoctorsBloc, HomeFilterTopDoctorsState>(
                builder: (context, state) {
                  if (state is HomeFilterTopDoctorsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is HomeFilterTopDoctorsErrorState) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is HomeFilterTopDoctorsLoadedState) {
                    if (state.doctor.isEmpty) {
                      return Center(child: Text("No doctors available."));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.doctor.length,
                      itemBuilder: (context, index) {
                        return Card(child: doctorsList(state.doctor[index]));
                      },
                    );
                  }
                  return SizedBox(); // For initial state or fallback
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
