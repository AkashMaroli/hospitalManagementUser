import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDoctorsEvent extends DoctorEvent {}

class SearchDoctorsEvent extends DoctorEvent {
  final String query;
  SearchDoctorsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterDoctorsEvent extends DoctorEvent {
  final double? minPrice;
  final double? maxPrice;
  final int? minExperience;
  final String? gender;

  FilterDoctorsEvent({
    this.minPrice,
    this.maxPrice,
    this.minExperience,
    this.gender,
  });

  @override
  List<Object?> get props => [minPrice, maxPrice, minExperience, gender];
}
