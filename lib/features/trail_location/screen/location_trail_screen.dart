import 'package:alarm_app/core/supabase/groups_crud.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:geolocator/geolocator.dart';

class LocationTrailScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

   LocationTrailScreen({super.key});

  String userId = Supabase.instance.client.auth.currentUser!.id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Column(
        children: [
          Obx(() {
            final position = locationController.position.value;
            return Center(
              child: position == null
                  ? Text('Tracking location...')
                  : Text('Location: ${position.latitude}, ${position.longitude}'),
            );
          }),
          SizedBox(height:20 ,),

          Text(
            'Select Date:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: locationController.selectedDate.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                locationController.updateSelectedDate(pickedDate);
              }
            },
            child: Obx(() {
              // Observing changes in selectedDate
              final dateText = locationController.selectedDate.value != null
                  ? DateFormat.yMMMd().format(locationController.selectedDate.value!)
                  : 'Choose Date';
              return Text(dateText);
            }),
          ),
          SizedBox(height: 20),
          Text(
            'Location Data:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              // Observing changes in the location stream
              final selectedDate = locationController.selectedDate.value;
              if (selectedDate == null) {
                return Text('Please select a date to view location data.');
              }
              return StreamBuilder<Position?>(
                stream: locationController.fetchLocationByDate(userId, selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final position = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latitude: ${position.latitude}'),
                        Text('Longitude: ${position.longitude}'),

                      ],
                    );
                  } else {
                    return Text('No location data available for this date.');
                  }
                },
              );
            }),
          ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
        await GroupCrud.updateGroupMembers("2b7f5520-dd73-4e81-b150-b540fb7b024d", ["1","2","3"]);
          
         
          // if (locationController.isTracking.value) {
          //   Get.snackbar('Tracking', 'Location tracking is already on');
          // } else {
          //   locationController.startLocationTracking();
          // }
        },
        child: Icon(
          locationController.isTracking.value
              ? Icons.location_off
              : Icons.location_on,
        ),
      ),
    );
  }
}
