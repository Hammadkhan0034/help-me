import 'dart:developer';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController extends GetxController {
  final supabase = Supabase.instance.client;
  final isTracking = false.obs;

  final position = Rx<Position?>(null);
  Position? lastPosition;
  final fetchedLocation = Rx<Position?>(null);
  final selectedDate = Rx<DateTime?>(null); // Selected date as observable

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
  @override
  void onInit() {
    super.onInit();
    startLocationTracking();
  }

  Future<void> startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (serviceEnabled && permission == LocationPermission.whileInUse) {
      isTracking.value = true;

      Geolocator.getPositionStream().listen((Position newPosition) {
        position.value = newPosition;
        _logLocation(newPosition);
      });
    } else {
      Get.snackbar('Permission Denied', 'Please enable location permissions.');
    }
  }

  Future<void> _logLocation(Position newPosition) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase.from('location_logs').insert({
        'user_id': userId,
        'latitude': newPosition.latitude,
        'longitude': newPosition.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }
  Stream<Position?> fetchLocationByDate(String userId, DateTime date) async* {
    final formattedDate = date.toIso8601String().split('T').first;

    try {
      while (true) {  // Continuous stream
        final response = await supabase
            .from('location_logs')
            .select('latitude, longitude')
            .eq('user_id', userId)
            .gte('timestamp', '$formattedDate 00:00:00')
            .lte('timestamp', '$formattedDate 23:59:59')
            .order('timestamp', ascending: true)
            .limit(1)
            ;

        // if (response.error != null) {
        //   Get.snackbar('Error', 'Failed to fetch location: ${response.error!.message}');
        //   yield null; // Yield null in case of an error
        // } else
          if (response.isNotEmpty) {
          final data = response[0];
          yield Position(
            latitude: data['latitude'],
            longitude: data['longitude'],
            accuracy: data['accuracy'] ?? 0,
            altitude: data['altitude'] ?? 0,
            altitudeAccuracy: data['altitudeAccuracy'] ?? 0,
            heading: data['heading'] ?? 0,
            headingAccuracy: data['headingAccuracy'] ?? 0,
            speed: 0,
            speedAccuracy: 0,
            timestamp: DateTime.now(),
          );
        } else {
          yield null; // Yield null if no data is found for specified date
        }

        await Future.delayed(Duration(seconds: 5)); // Delay to poll every 5 seconds
      }
    } catch (e,st) {
      log("Error",error: e,stackTrace: st);
      Get.snackbar('Error', 'An error occurred while fetching location: $e');
      yield null; // Yield null if an exception occurs
    }
  }

  bool _isDistanceExceeded(Position lastPosition, Position newPosition) {

    final distanceInMeters = Geolocator.distanceBetween(
      lastPosition.latitude,
      lastPosition.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    // Check if the distance exceeds 50 meters
    return distanceInMeters >= 50;
  }

  @override
  void onClose() {
    isTracking.value = false;
    super.onClose();
  }
}
