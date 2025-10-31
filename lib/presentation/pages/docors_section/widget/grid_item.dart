import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/models/doctors_model.dart';
import 'package:hospitalmanagementuser/presentation/pages/doctor_detail/doctor_detail.dart';

Widget doctorGridItem(DoctorsProfileModel obj, BuildContext context) {
 final total = obj.reviewAndRatings.fold<int>(
    0,
    (sum, review) => sum + review.rating,
  );
  
  final avg =
      obj.reviewAndRatings.isEmpty
          ? 0.0
          : total / obj.reviewAndRatings.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(profilObj: obj),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).canvasColor,
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3),

              // Specialty
              Text(
                obj.department,
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),

              // Availability Info
              Text(
                "Available: ${obj.availableTimeStart.format(context)} to ${obj.availableTimeEnd.format(context)}",
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 3),
                  Text(
                    avg==0?'Not Yet':avg.toString(), // Assuming a default rating
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 3),
                  obj.reviewAndRatings.isEmpty?Text(''):
                  Text(
                    '(${obj.reviewAndRatings.length})', // Assuming a default review count
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }