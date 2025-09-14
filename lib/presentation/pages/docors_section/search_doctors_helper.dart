import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/doctor_detail.dart';

class DoctorSearchDelegate extends SearchDelegate {
  final DoctorBloc doctorBloc;

  DoctorSearchDelegate(this.doctorBloc);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Only trigger search if query is not empty
    if (query.isNotEmpty) {
      doctorBloc.add(SearchDoctorsEvent(query));
    }

    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is DoctorErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text("Error: ${state.message}"),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => doctorBloc.add(FetchDoctorsEvent()),
                  child: Text("Retry"),
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
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No doctors found for '$query'"),
                  SizedBox(height: 8),
                  Text("Try searching by name, department, or specialization"),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: state.doctors.length,
            itemBuilder: (context, index) {
              final doc = state.doctors[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        doc.photoUrl.isNotEmpty
                            ? NetworkImage(doc.photoUrl)
                            : AssetImage('assets/images/default_doctor.png')
                                as ImageProvider,
                  ),
                  title: Text(doc.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.department),
                      if (doc.specialization.isNotEmpty)
                        Text(
                          doc.specialization,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorDetailScreen(profilObj: doc),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Only trigger search if query is not empty
    if (query.isNotEmpty) {
      doctorBloc.add(SearchDoctorsEvent(query));
    }

    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoadedState && query.isNotEmpty) {
          if (state.doctors.isEmpty) {
            return Container();
          }

          return ListView(
            children:
                state.doctors
                    .map(
                      (doc) => Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                doc.photoUrl.isNotEmpty
                                    ? NetworkImage(doc.photoUrl)
                                    : AssetImage(
                                          'assets/images/default_doctor.png',
                                        )
                                        as ImageProvider,
                          ),
                          title: Text(doc.fullName),
                          subtitle: Text(doc.department),
                          onTap: () {
                            query = doc.fullName;
                            showResults(context);
                          },
                        ),
                      ),
                    )
                    .toList(),
          );
        }
        return Container();
      },
    );
  }
}
