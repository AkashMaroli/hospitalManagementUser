import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/widget/grid_item.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/doctor_detail.dart';

class DoctorSearchDelegate extends SearchDelegate {
  final DoctorBloc doctorBloc;

  DoctorSearchDelegate(this.doctorBloc);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          doctorBloc.add(SearchDoctorsEvent(query));
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Trigger search only when query is not empty
    if (query.isNotEmpty) {
      doctorBloc.add(SearchDoctorsEvent(query));
    }

    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DoctorErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text("Error: ${state.message}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => doctorBloc.add(FetchDoctorsEvent()),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (state is DoctorLoadedState) {
          if (state.doctors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text("No doctors found for '$query'"),
                  const SizedBox(height: 8),
                  const Text(
                    "Try searching by name, department, or specialization",
                  ),
                ],
              ),
            );
          }

          /// ✅ Using GridView consistently here
          return GridView.builder(
            itemCount: state.doctors.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final doctor = state.doctors[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorDetailScreen(profilObj: doctor),
                    ),
                  );
                },
                child: doctorGridItem(doctor, context),
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      doctorBloc.add(SearchDoctorsEvent(query));
    }

    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoadedState && query.isNotEmpty) {
          if (state.doctors.isEmpty) {
            return Container();
          }

          /// ✅ GridView also used in suggestions for consistency
          return GridView.builder(
            itemCount: state.doctors.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final doctor = state.doctors[index];
              return GestureDetector(
                onTap: () {
                  query = doctor.fullName;
                  showResults(context);
                },
                child: doctorGridItem(doctor, context),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}
