import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationController extends GetxController {
  final supabase = Supabase.instance.client;
  final isTracking = false.obs;
  final position = Rx<Position?>(null);
  Position? lastPosition; // Store the last known position

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
      if (lastPosition == null || _isDistanceExceeded(lastPosition!, newPosition)) {
        // Update or insert the location only if the distance is exceeded
        lastPosition = newPosition; // Update last known position

        // Fetch the existing record
        var response = await supabase
            .from('location_logs')
            .select()
            .eq('user_id', userId)
            .maybeSingle(); // Use maybeSingle instead of single

        print(response);
        if (response != null) {
          // Record exists, update it
          await supabase.from('location_logs').update({
            'latitude': newPosition.latitude,
            'longitude': newPosition.longitude,
            'timestamp': DateTime.now().toIso8601String(),
          }).eq('user_id', userId);
        } else {
          // No record exists, insert a new one
          await supabase.from('location_logs').insert({
            'user_id': userId,
            'latitude': newPosition.latitude,
            'longitude': newPosition.longitude,
            'timestamp': DateTime.now().toIso8601String(),
          });
        }

      }
    }
  }

  bool _isDistanceExceeded(Position lastPosition, Position newPosition) {
    // Calculate the distance between the last known position and the new position
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
