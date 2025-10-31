class DoctorModel {
  final String name;
  final String department;
  final String gender;
  final String photoUrl;

  DoctorModel({
    required this.name,
    required this.department,
    required this.gender,
    required this.photoUrl,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      gender: json['gender'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'department': department,
      'gender': gender,
      'photoUrl': photoUrl,
    };
  }
}
