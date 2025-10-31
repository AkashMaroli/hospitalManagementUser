import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends OnboardingEvent {}

class SkipToLastPageEvent extends OnboardingEvent {}

class PageChangedEvent extends OnboardingEvent {
  final int page;
  const PageChangedEvent(this.page);

  @override
  List<Object> get props => [page];
}

class FinishOnboardingEvent extends OnboardingEvent {}
