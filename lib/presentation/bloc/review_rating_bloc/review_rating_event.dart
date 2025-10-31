import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class StreamDoctorReviews extends ReviewEvent {
  final String doctorId;
  const StreamDoctorReviews(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}
