import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/presentation/pages/appointments/appoinment_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/chat/chat_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/home/home_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/profile/profile_screen.dart';
import 'package:super_icons/super_icons.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          height: 70,
          child: const TabBar(
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(
                icon: Icon(SuperIcons.is_calendar_search_outline),
                text: "Appointment",
              ),
              Tab(icon: Icon(SuperIcons.is_message_2_outline), text: "Chat"),
              Tab(icon: Icon(SuperIcons.bs_person), text: "Profile"),
            ],
            indicatorColor: Colors.transparent,
            labelColor: Color.fromARGB(255, 0, 201, 194),
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(),
            AppoinmentScreen(),
            ChatScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
