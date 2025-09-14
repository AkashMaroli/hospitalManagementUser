 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalmanagementuser/data/models/department_model.dart';
import 'package:hospitalmanagementuser/presentation/controllers/global_controller.dart';


void departmentsFetching() {
    print('fetching deapartment details');
    FirebaseFirestore.instance.collection('departments').snapshots().listen((
      snapshot,
    ) {
      departmentList=
          snapshot.docs
              .map((doc) => DepartmentModel.fromFirestore(doc).departmentName)
              .toList();
    });
  }