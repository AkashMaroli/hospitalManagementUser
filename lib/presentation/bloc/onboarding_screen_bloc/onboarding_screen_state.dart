import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isFinished;

  const OnboardingState({
    required this.currentPage,
    required this.isFinished,
  });

  factory OnboardingState.initial() => const OnboardingState(
        currentPage: 0,
        isFinished: false,
      );

  OnboardingState copyWith({
    int? currentPage,
    bool? isFinished,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object> get props => [currentPage, isFinished];
}
