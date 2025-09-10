import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
part 'home_filter_top_doctors_event.dart';
part 'home_filter_top_doctors_state.dart';

class HomeFilterTopDoctorsBloc extends Bloc<HomeFilterTopDoctorsEvent, HomeFilterTopDoctorsState> {
  HomeFilterTopDoctorsBloc() : super(HomeFilterTopDoctorsInitial()) {
    on<HomeFilterTopDoctorsEvent>( _onFilterTopDoctors);
  }

  void _onFilterTopDoctors(
    HomeFilterTopDoctorsEvent event,
    Emitter<HomeFilterTopDoctorsState> emit,
  ) async {
    emit(HomeFilterTopDoctorsLoadingState()); // Show loading state

    try {
      final doctorStream = filterExperienceDoctors();
      await emit.forEach( 
        doctorStream,
        onData: (List<DoctorsProfileModel> doctors) {
          print('Success');
          return HomeFilterTopDoctorsLoadedState(doctors);
        },
        onError: (error, stackTrace) {
          return HomeFilterTopDoctorsErrorState(error.toString());
        },
      );
    } catch (e) {
      emit(HomeFilterTopDoctorsErrorState(e.toString()));
    }
  }

}
