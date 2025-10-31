
  import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/presentation/pages/appointments/appoinment_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/chat/chating/chating_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/all_doctors_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/widget/item_widget.dart';

void largeBottomSheet(BuildContext context) {
     showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Needs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      itemsWidget(
                        'Appointment',
                        Icons.calendar_today_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AppoinmentScreen(),
                            ),
                          );
                        },
                      ),
                      itemsWidget(
                        'Doctors',
                        Icons.person_sharp,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AllDoctorsScreen(),
                            ),
                          );
                        },
                      ),
                      itemsWidget(
                        'Medicine',
                        Icons.medication_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AppoinmentScreen(),
                            ),
                          );
                        },
                      ),
                      itemsWidget(
                        'Insurrence',
                        Icons.shield_rounded,
                        () {
                          showModalBottomSheet(
                            context: context,
                            builder:
                                (context) => Container(
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.only(
                                          topLeft:
                                              Radius.circular(
                                                10,
                                              ),
                                          topRight:
                                              Radius.circular(
                                                10,
                                              ),
                                        ),
                                  ),
                                ),
                          );
                        },
                      ),
                    ],
                  ),
    
                  Text(
                    'Specialised care',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      itemsWidget(
                        'Pshychology',
                        Icons.calendar_today_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      AppoinmentScreen(),
                            ),
                          );
                        },
                      ),
                      itemsWidget(
                        'ENT',
                        Icons.hearing_rounded,
                        () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => ChatScreen(),
                          //   ),
                          // );
                        },
                      ),
                      itemsWidget('Dental', Icons.stop, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AppoinmentScreen(),
                          ),
                        );
                      }),
                      itemsWidget(
                        'Eye',
                        Icons.remove_red_eye_outlined,
                        () {
                          showModalBottomSheet(
                            context: context,
                            builder:
                                (context) => Container(
                                  height: 400,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.only(
                                          topLeft:
                                              Radius.circular(
                                                10,
                                              ),
                                          topRight:
                                              Radius.circular(
                                                10,
                                              ),
                                        ),
                                  ),
                                  child: Column(children: [],),),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

