import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  List<DoctorsProfileModel> allDoctors = [];

  DoctorBloc() : super(DoctorInitialState()) {
    on<FetchDoctorsEvent>(_onFetchDoctors);
    on<SearchDoctorsEvent>(_onSearchDoctors);
  }

  void _onFetchDoctors(
    FetchDoctorsEvent event,
    Emitter<DoctorState> emit,
  ) async {
    emit(DoctorLoadingState()); // Show loading state

    try {
      final doctorStream = fetchDoctors();
      await emit.forEach(
        doctorStream,
        onData: (List<DoctorsProfileModel> doctors) {
          allDoctors = doctors; // keep full list in memory
          print('Successfully loaded ${doctors.length} doctors');
          return DoctorLoadedState(doctors);
        },
        onError: (error, stackTrace) {
          print('Error fetching doctors: $error');
          return DoctorErrorState(error.toString());
        },
      );
    } catch (e) {
      print('Exception fetching doctors: $e');
      emit(DoctorErrorState(e.toString()));
    }
  }

  void _onSearchDoctors(SearchDoctorsEvent event, Emitter<DoctorState> emit) {
    // Debug logging
    print('Search query: "${event.query}"');
    print('AllDoctors count: ${allDoctors.length}');

    if (event.query.isEmpty) {
      emit(DoctorLoadedState(allDoctors)); // reset full list
      return;
    }

    // If allDoctors is empty, we need to fetch doctors first
    if (allDoctors.isEmpty) {
      print('AllDoctors is empty, fetching doctors first...');
      emit(DoctorLoadingState());
      // Trigger fetch doctors and then search
      add(FetchDoctorsEvent());
      return;
    }

    final query = event.query.toLowerCase();
    final filtered =
        allDoctors.where((doc) {
          final nameMatch = doc.fullName.toLowerCase().contains(query);
          final deptMatch = doc.department.toLowerCase().contains(query);
          final specMatch = doc.specialization.toLowerCase().contains(query);

          print(
            'Doctor: ${doc.fullName}, Department: ${doc.department}, Specialization: ${doc.specialization}',
          );
          print(
            'Name match: $nameMatch, Dept match: $deptMatch, Spec match: $specMatch',
          );

          return nameMatch || deptMatch || specMatch;
        }).toList();

    print('Filtered results count: ${filtered.length}');
    emit(DoctorLoadedState(filtered));
  }
}
