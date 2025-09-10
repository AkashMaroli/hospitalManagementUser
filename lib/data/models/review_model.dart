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
    return ReviewModel(
      reviewerName: json['reviewerName'] ?? '',
      reviewContent: json['reviewContent'] ?? '',
      rating: json['rating'] ?? 0,
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
