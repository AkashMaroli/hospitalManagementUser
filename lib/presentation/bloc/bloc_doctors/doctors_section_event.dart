
import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to fetch all doctors
class FetchDoctorsEvent extends DoctorEvent {}


// Event to search doctors by name/department
class SearchDoctorsEvent extends DoctorEvent {
  final String query;
  SearchDoctorsEvent(this.query);

  @override
  List<Object?> get props => [query];
}