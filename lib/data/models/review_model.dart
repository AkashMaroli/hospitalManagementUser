import 'dart:developer';

class ReviewModel {
  final String reviewerName;
  final String reviewContent;
  final int rating;

  ReviewModel({
    required this.reviewerName,
    required this.reviewContent,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    log(json['rating']);
    return ReviewModel(
      reviewerName: json['reviewerName'] ?? '',
      reviewContent: json['review'] ?? '',
      rating:
          (json['rating'] is double)
              ? (json['rating'] as double).round()
              : (json['rating'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewerName': reviewerName,
      'reviewContent': reviewContent,
      'rating': rating,
    };
  }
}
