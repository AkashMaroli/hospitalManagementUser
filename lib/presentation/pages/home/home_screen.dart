import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_home_onduty_doc/home_filter_onduty_bloc_bloc.dart';
import 'package:hospitalmanagementuser/presentation/pages/appointments/appoinment_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/all_doctors_screen.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_filter_top_doctors/home_filter_top_doctors_bloc.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/doctor_detail.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/widget/doctors_list_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/widget/item_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/insurrence/insurence_main_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/medicine/medicine_main_screen.dart';

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
          create:
              (context) =>
                  HomeFilterTopDoctorsBloc()..add(FilterTopDoctorsEvent()),
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
    double sizeScreen = MediaQuery.of(context).size.width *0.92;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('How are you feeling today?', style: TextStyle(fontSize: 16)),
          ],
        ),
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        // ],
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
                height: 200,
                // width: 200,
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DoctorDetailScreen(profilObj: doctor),
                                ),
                              );
                            },
                            child: Card(color: Theme.of(context).cardColor,elevation: 2,
                              child: SizedBox(
                                width: sizeScreen,
                                child: doctorsList(
                                  doctor,
                                  context,
                                  true,
                                  
                                ),
                              )
                            )
                          );
                        }
                      );
                    }
                    return SizedBox(); // For initial state or fallback
                  }
                )
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
                      MaterialPageRoute(builder: (_) => MedicineMainScreen()),
                    );
                  }),
                  itemsWidget('Insurence', Icons. shield_rounded, () {
                    // largeBottomSheet(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InsuranceMainScreen()),
                    );
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DoctorDetailScreen(
                                      profilObj: state.doctor[index],
                                    ),
                              ),
                            );
                          },
                          child: Card(color: Theme.of(context).cardColor,elevation: 2,
                            child: doctorsList(
                              state.doctor[index],
                              context,
                              true,
                            ),
                          ),
                        );
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
