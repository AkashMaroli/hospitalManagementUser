import 'package:bloc/bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/onboarding_screen_bloc/onboarding_screen_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/onboarding_screen_bloc/onboarding_screen_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int totalPages;

  OnboardingBloc({required this.totalPages})
      : super(OnboardingState.initial()) {
    on<PageChangedEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });

    on<NextPageEvent>((event, emit) {
      if (state.currentPage < totalPages - 1) {
        emit(state.copyWith(currentPage: state.currentPage + 1));
      } else {
        emit(state.copyWith(isFinished: true));
      }
    });

    on<SkipToLastPageEvent>((event, emit) {
      emit(state.copyWith(currentPage: totalPages - 1));
    });

    on<FinishOnboardingEvent>((event, emit) {
      emit(state.copyWith(isFinished: true));
    });
  }
}
