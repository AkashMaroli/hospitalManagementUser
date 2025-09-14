import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/user_patient_model.dart';
import 'package:hospitalmanagementuser/data/services/patient_services.dart';
import 'package:hospitalmanagementuser/presentation/widgets/logout_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<UserPatientModel>(
        future: userDataFetching(), // your async function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("⚠️ No user data found"));
          }
          // userDetailsCarrier = snapshot.data!;
          final userDetail = snapshot.data!;
          return Center(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(220, 70, 173, 167),
                          Color.fromARGB(220, 21, 26, 25),
                          Color(0xFF008B8B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                        userDetail.profilePhotoUrl!.isEmpty
                            ? Image.asset('assets/images/old-man-20.png')
                            : Image.network(userDetail.profilePhotoUrl ?? ''),
                  ),
                  title: Text(userDetail.fullName ?? "No Name"),
                  trailing: const SizedBox(
                    width: 50,
                    child: Row(children: [Icon(Icons.edit), Text('Edit')]),
                  ),
                ),
                const SizedBox(height: 60),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                const ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notification'),
                ),
                const ListTile(
                  leading: Icon(Icons.history_edu_rounded),
                  title: Text('Transaction history'),
                ),
                const ListTile(
                  leading: Icon(Icons.quiz_outlined),
                  title: Text('FAQ'),
                ),
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About App'),
                ),
                LogoutWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
