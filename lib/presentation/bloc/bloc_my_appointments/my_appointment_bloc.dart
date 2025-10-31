import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_my_appointments/my_appointment_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_my_appointments/my_appointment_state.dart';


class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    on<LoadUpcomingAppointments>((event, emit) async {
      emit(AppointmentLoading());
      try {
        final data = await userUpcomingAppointments();
        emit(AppointmentLoaded(data));
      } catch (e) {
        emit(AppointmentError(e.toString()));
      }
    });

    on<LoadCompletedAppointments>((event, emit) async {
      emit(AppointmentLoading());
      try {
        final data = await userCompletedAppointments();
        emit(AppointmentLoaded(data));
      } catch (e) {
        emit(AppointmentError(e.toString()));
      }
    });
  }
}
