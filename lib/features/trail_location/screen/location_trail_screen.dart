import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/location_controller.dart';

class LocationTrailScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

   LocationTrailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Obx(() {
        final position = locationController.position.value;
        return Center(
          child: position == null
              ? Text('Tracking location...')
              : Text('Location: ${position.latitude}, ${position.longitude}'),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (locationController.isTracking.value) {
            Get.snackbar('Tracking', 'Location tracking is already on');
          } else {
            locationController.startLocationTracking();
          }
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
