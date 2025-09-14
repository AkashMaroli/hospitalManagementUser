
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  String departmentName;
  DepartmentModel({required this.departmentName});

  Map<String, dynamic> toJson() {
    return {'departmentName': departmentName};
  }

  factory DepartmentModel.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;

    return DepartmentModel(departmentName: json['departmentName']);
  }
}
