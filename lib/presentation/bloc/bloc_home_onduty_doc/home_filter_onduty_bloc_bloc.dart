// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';

part 'home_filter_onduty_bloc_event.dart';
part 'home_filter_onduty_bloc_state.dart';

class HomeFilterOndutyBloc
    extends Bloc<HomeFilterOndutyEvent, HomeFilterOndutyState> {
  HomeFilterOndutyBloc() : super(HomeFilterOndutyInitial()) {
    on<HomeFilterOndutyEvent>(_onFilterOndutyDoctors);
  }

  void _onFilterOndutyDoctors(
    HomeFilterOndutyEvent event,
    Emitter<HomeFilterOndutyState> emit,
  ) async {
    emit(HomeFilterOndutyLoadingState()); // Show loading state

    try {
      final doctorStream = filterOnDutyDoctors();
      await emit.forEach( 
        doctorStream,
        onData: (List<DoctorsProfileModel> doctors) {
          print('Success');
          return HomeFilterOndutyLoadedState(doctors);
        },
        onError: (error, stackTrace) {
          return HomeFilterOndutyErrorState(error.toString());
        },
      );
    } catch (e) {
      emit(HomeFilterOndutyErrorState(e.toString()));
    }
  }



}

