class ReviewRatingModel {
  final String reviewerId;
  final String reviewerName;
  final String review;
  final double rating;
  final DateTime timestamp;

  ReviewRatingModel({
    required this.reviewerId,
    required this.reviewerName,
    required this.review,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'review': review,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}
