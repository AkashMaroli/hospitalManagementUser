import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUpcomingAppointments extends AppointmentEvent {}

class LoadCompletedAppointments extends AppointmentEvent {}
