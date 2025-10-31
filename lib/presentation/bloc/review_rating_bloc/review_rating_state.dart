import 'package:equatable/equatable.dart';
import 'package:hospitalmanagementuser/data/models/review_model_orgi.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewRatingModel> reviews;
  const ReviewLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
