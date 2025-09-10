part of 'home_filter_onduty_bloc_bloc.dart';

 class HomeFilterOndutyState extends Equatable {
  const HomeFilterOndutyState();

  @override
  List<Object?> get props => [];
}


// Initial State
final class HomeFilterOndutyInitial extends HomeFilterOndutyState {}


// Loading State
class HomeFilterOndutyLoadingState extends HomeFilterOndutyState {}

// Success State
class HomeFilterOndutyLoadedState extends HomeFilterOndutyState {
  final List<DoctorsProfileModel> doctors;
 HomeFilterOndutyLoadedState(this.doctors);

  
  @override
  List<Object?> get props => [doctors];
  
}

// Error State
class HomeFilterOndutyErrorState extends HomeFilterOndutyState {
  final String message;
  HomeFilterOndutyErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
