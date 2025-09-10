import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/presentation/widgets/logout_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),

      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(220, 70, 173, 167), // Light Sea Green
                        Color.fromARGB(220, 21, 26, 25),
                        Color(0xFF008B8B), // Dark Cyan
                      ],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset('assets/images/old-man-20.png'),
                ),
                title: Text("Davi Abhraham"),
                // subtitle: Text("Gynocology"),
                trailing: SizedBox(
                  width: 50,
                  child: Row(children: [Icon(Icons.edit), Text('Edit')]),
                ),
              ),
            ),
            SizedBox(height: 60),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
            ),
            ListTile(
              leading: Icon(Icons.history_edu_rounded),
              title: Text('Transaction history'),
            ),
            ListTile(leading: Icon(Icons.quiz_outlined), title: Text('FAQ')),
            ListTile(leading: Icon(Icons.info), title: Text('About App')),
            //Spacer(),
           LogoutWidget(),
          ],
        ),
      ),
    );
  }
}
