import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/bloc_doctors/doctors_section_state.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/search_doctors_helper.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/widget/filter_widget.dart';
import 'package:hospitalmanagementuser/presentation/pages/docors_section/widget/grid_item.dart';

// ignore: must_be_immutable
class AllDoctorsScreen extends StatelessWidget {
  FlipCardController con1 = FlipCardController();
  AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final existingBloc = context.read<DoctorBloc?>();
    final screen = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctors,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Find and consult doctors?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Theme.of(context).canvasColor, //,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return FilterBottomSheet();
                },
              );
            },
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: DoctorSearchDelegate(context.read<DoctorBloc>()),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          // If no data yet, ensure fetch and show loader
          if (state is DoctorInitialState) {
            // ignore: avoid_print
            print('[AllDoctorsScreen] DoctorInitialState -> triggering fetch');
            context.read<DoctorBloc>().add(FetchDoctorsEvent());
            return Center(child: CircularProgressIndicator());
          }
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
    );
    if (existingBloc == null) {
      // ignore: avoid_print
      print('[AllDoctorsScreen] No existing DoctorBloc found, creating one');
      return BlocProvider(
        create: (context) => DoctorBloc()..add(FetchDoctorsEvent()),
        child: screen,
      );
    }
    // Using existing bloc from ancestor (e.g., HomeScreen)
    return screen;
  }

  // Doctor Grid Item Widget
}
