import 'dart:async';
import 'dart:developer';

import 'package:alarm_app/core/supabase/FriendsService.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/models/friends_profile_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/controller/auth_controller.dart';

class LocationManageController extends GetxController {
  List<FriendsProfileModel> friendsList = [];
  final isTracking = false.obs;
  StreamSubscription<Position>? currentLocationStream;

  getFriends(String id) async {
    // String id = ;
    // id = "5abbbfd5-dacf-47c4-ba14-8ce863989740";

    friendsList = await FriendsService().fetchFriends(id);
    print(friendsList);
  }

  Future changeFriendLocationPermission(
      int index, bool? status, FriendsProfileModel friendModel) async {
    if (status == null) return;
    final userModel = Get.find<AuthController>().userModel.value;
    friendsList[index] = friendsList[index].copyWith(canSeeLocation: status);
    update();
    if (!(await FriendsService().updateCanFriendSeeLocation(
        status, friendModel.friendId, friendModel.id))) {
      friendsList[index] = friendsList[index].copyWith(canSeeLocation: !status);
      Utils.showErrorSnackBar(
          title: "Location Permission Error",
          description:
              "Couldn't ${status ? "enable" : "disable"} the location");
      update();
    }
  }

  changeLocationPermission(bool? status) async {
    if (status == null) return;
    final userModel = Get.find<AuthController>().userModel.value;
    isTracking.value = status;

    if (!(await UserCrud.updateUserLocationStatus(userModel.id, status))) {
      isTracking.value = !status;
      Utils.showErrorSnackBar(
          title: "Location Permission Error",
          description:
              "Couldn't ${status ? "enable" : "disable"} the location");
      return;
    }

    if (status) {
      startLocationTracking();
    } else {
      currentLocationStream?.cancel();
      currentLocationStream = null;
    }
  }

  Future<void> startLocationTracking() async {
    if (currentLocationStream != null) return;
    if (!isTracking.value) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (serviceEnabled && permission == LocationPermission.whileInUse) {
      currentLocationStream = Geolocator.getPositionStream(
              locationSettings: LocationSettings(distanceFilter: 50))
          .listen((Position newPosition) {
        // position.value = newPosition;
        print("sssssssssssssssssssszzzzzzzzzzzzzzzzzzzzzzz");
        _logLocation(newPosition);
      });
    } else {
      Get.snackbar('Permission Denied', 'Please enable location permissions.');
    }
  }

  _logLocation(Position newPosition) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await Supabase.instance.client.from('location_logs').insert({
        'user_id': userId,
        'latitude': newPosition.latitude,
        'longitude': newPosition.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await UserCrud.updateUserLocationLatLng(
          userId, newPosition.latitude, newPosition.longitude);
    }
  }

  Stream<Position?> fetchLocationByDate(String userId, DateTime date) async* {
    final formattedDate = date.toIso8601String().split('T').first;

    try {
      while (true) {
        // Continuous stream
        final response = await Supabase.instance.client
            .from('location_logs')
            .select('latitude, longitude')
            .eq('user_id', userId)
            .gte('timestamp', '$formattedDate 00:00:00')
            .lte('timestamp', '$formattedDate 23:59:59')
            .order('timestamp', ascending: true)
            .limit(1);

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

        await Future.delayed(
            Duration(seconds: 5)); // Delay to poll every 5 seconds
      }
    } catch (e, st) {
      log("Error", error: e, stackTrace: st);
      Get.snackbar('Error', 'An error occurred while fetching location: $e');
      yield null; // Yield null if an exception occurs
    }
  }

  initData() {
    final userModel = Get.find<AuthController>().userModel.value;
    isTracking.value = userModel.isLocationEnabled;
    startLocationTracking();
    getFriends(userModel.id);
  }

  openLocation(FriendsProfileModel friendProfileModel) async {
    print("sssssssssssssssssssssssssssssssssssssss");
    if (await FriendsService().canSeeFriendLocationById(
        friendProfileModel.friendId, friendProfileModel.userId)) {
      final friendUserModel =
          await UserCrud.getUserById(friendProfileModel.friendId);

      final latitude = friendUserModel?.latitude ?? friendProfileModel.latitude;
      final longitude =
          friendUserModel?.longitude ?? friendProfileModel.longitude;

      if (latitude != null && longitude != null) {
        Utils.openMap(latitude, longitude);
      }
    }
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    currentLocationStream?.cancel();
    currentLocationStream = null;
    super.onClose();
  }
}
