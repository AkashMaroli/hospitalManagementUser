import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorBloc() : super(DoctorInitialState()) {
    on<FetchDoctorsEvent>(_onFetchDoctors);
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
          print('Success');
          return DoctorLoadedState(doctors);
        },
        onError: (error, stackTrace) {
          return DoctorErrorState(error.toString());
        },
      );
    } catch (e) {
      emit(DoctorErrorState(e.toString()));
    }
  }
}
