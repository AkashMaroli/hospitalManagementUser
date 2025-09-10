
import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to fetch all doctors
class FetchDoctorsEvent extends DoctorEvent {}
