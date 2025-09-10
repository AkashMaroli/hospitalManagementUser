class PatientHistoryModel {
  final String doctorId;
  final String doctorName;
  final List<String> notes;
  final List<String> prescription;
  final List<String>? dignosisReports;

  PatientHistoryModel({
    required this.doctorId,
    required this.doctorName,
    required this.notes,
    required this.prescription,
    this.dignosisReports,
  });

  factory PatientHistoryModel.fromJson(Map<String, dynamic> json) {
    return PatientHistoryModel(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      notes: List<String>.from(json['notes'] ?? []),
      prescription: List<String>.from(json['prescription'] ?? []),
      dignosisReports: (json['dignosisReports'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'notes': notes,
      'prescription': prescription,
      'dignosisReports': dignosisReports,
    };
  }
}
