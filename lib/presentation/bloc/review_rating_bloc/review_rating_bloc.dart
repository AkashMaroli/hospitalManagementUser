import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/models/review_model_orgi.dart';
import 'package:hospitalmanagementuser/data/services/doctors_service.dart';
import 'package:hospitalmanagementuser/presentation/bloc/review_rating_bloc/review_rating_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/review_rating_bloc/review_rating_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  // final ReviewService reviewService; // contains streamDoctorReviews()
  StreamSubscription<List<ReviewRatingModel>>? _reviewSubscription;

  ReviewBloc() : super(ReviewInitial()) {
    on<StreamDoctorReviews>(_onStreamDoctorReviews);
  }

  Future<void> _onStreamDoctorReviews(
    StreamDoctorReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());

    await _reviewSubscription?.cancel(); // cancel old subscription if any
    try {
      await emit.forEach<List<ReviewRatingModel>>(
        streamDoctorReviews(event.doctorId),
        onData: (reviews) => ReviewLoaded(reviews),
        onError:
            (error, stackTrace) => ReviewError('Error loading reviews: $error'),
      );
    } catch (e) {
      emit(ReviewError('Error loading reviews: $e'));
    }
  }

  @override
  Future<void> close() {
    _reviewSubscription?.cancel();
    return super.close();
  }
}
