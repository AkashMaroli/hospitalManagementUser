import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart'; // contains the function
import 'package:hospitalmanagementuser/presentation/bloc/profile_bloc/profile_screen_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/profile_bloc/profile_screen_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadUserProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final UserPatientModel user =
          await userDataFetching(); // 👈 direct function call
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
