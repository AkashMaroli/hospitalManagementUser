import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/doctor_detail.dart';

// ignore: must_be_immutable
class AllDoctorsScreen extends StatelessWidget {
  FlipCardController con1 = FlipCardController();
   AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              DoctorBloc()
                ..add(FetchDoctorsEvent()), // Fetch doctors when screen loads
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctors,',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Find and consult doctors?', style: TextStyle(fontSize: 14)),
            ],
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: BlocBuilder<DoctorBloc, DoctorState>(
          builder: (context, state) {
            if (state is DoctorLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorErrorState) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is DoctorLoadedState) {
              if (state.doctors.isEmpty) {
                return Center(child: Text("No doctors available."));
              }
              return GridView.builder(
                itemCount: state.doctors.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  return FlipCard(
                    rotateSide: RotateSide.bottom,
                    controller: con1,
                    frontWidget: doctorGridItem(state.doctors[index], context),
                    backWidget: Container(color: Colors.green),
                  );
                },
              );
            }
            return Center(child: Text("Press to load doctors"));
          },
        ),
      ),
    );
  }

  // Doctor Grid Item Widget
  Widget doctorGridItem(DoctorsProfileModel obj, BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(profilObj: obj),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Doctor Image
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(39, 8, 201, 231),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                      obj.photoUrl.isNotEmpty
                          ? Image.network(obj.photoUrl, fit: BoxFit.cover)
                          : Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ), // Fallback image
                ),
              ),
              SizedBox(height: 10),

              // Doctor Name
              Text(
                obj.fullName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3),

              // Specialty
              Text(
                obj.department,
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),

              // Availability Info
              Text(
                "Available: ${obj.availableTimeStart} to ${obj.availableTimeEnd}",
                style: TextStyle(fontSize: 10, color: Colors.black54),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 3),
                  Text(
                    '4.0', // Assuming a default rating
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 3),
                  Text(
                    '(180)', // Assuming a default review count
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
