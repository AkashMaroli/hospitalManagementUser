part of 'home_filter_top_doctors_bloc.dart';

class HomeFilterTopDoctorsState extends Equatable {
   HomeFilterTopDoctorsState();

  @override
  List<Object?> get props => [];
}

// intial state
final class HomeFilterTopDoctorsInitial extends HomeFilterTopDoctorsState {}

// loading state
class HomeFilterTopDoctorsLoadingState extends HomeFilterTopDoctorsState {}

// sucess state
class HomeFilterTopDoctorsLoadedState extends HomeFilterTopDoctorsState {
  List<DoctorsProfileModel> doctor;
  HomeFilterTopDoctorsLoadedState(this.doctor);

  
  @override
  List<Object?> get props => [doctor];

}

// error state
class HomeFilterTopDoctorsErrorState extends HomeFilterTopDoctorsState {
  String message;
  HomeFilterTopDoctorsErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
}
