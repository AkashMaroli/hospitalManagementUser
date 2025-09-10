import 'package:equatable/equatable.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';

abstract class DoctorState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial State
class DoctorInitialState extends DoctorState {}

// Loading State
class DoctorLoadingState extends DoctorState {}

// Success State
class DoctorLoadedState extends DoctorState {
  final List<DoctorsProfileModel> doctors;
  DoctorLoadedState(this.doctors);

  @override
  List<Object?> get props => [doctors];
  
}

// Error State
class DoctorErrorState extends DoctorState {
  final String message;
  DoctorErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
