// import 'package:alarm_app/features/auth/controller/auth_controller.dart';
// import 'package:alarm_app/features/group/controller/create_group_controller.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../../../core/supabase/groups_crud.dart';
// import '../../../core/supabase/notification_crud.dart';
// import '../../../core/supabase/user_crud.dart';
// import '../../../models/group_model.dart';
// import '../../../servies/send_notification_services.dart';
// import '../../../utils/utils.dart';
//
// class DoorController extends GetxController {
//   final groupController=Get.put(CreateGroupController());
//   final authController=Get.find<AuthController>();
//   final message=TextEditingController();
//   final items = ['Indoor', 'Outdoor'].obs;
//   var selectedType = 'Indoor'.obs;
// RxString imageUrl=''.obs;
// RxString localImagePath=''.obs;
//   var selectedGroup = Rxn<GroupModel>();
//   final groups = <GroupModel>[].obs;
//   void setSelected(String value) {
//     selectedType.value = value;
//     selectedGroup.value = null;
//     loadGroups();
//   }
//   Future<void> loadGroups() async {
//     final fetchedGroups = await GroupCrud.fetchGroupsByType(selectedType.value,authController.userModel.value.id );
//     groups.assignAll(fetchedGroups);
//     print('Loaded groups: $groups');
//   }
//   Future<void> onPress() async {
//     List<String> fcmList = [];
//     try {
//       print(selectedGroup.value?.id);
//
//       // Fetch FCM tokens for group members
//       for (var user in selectedGroup.value!.members) {
//         print('Fetching data for user ID: $user');
//         Map<String, dynamic>? userData = await UserCrud.getUser(user);
//         if (userData != null) {
//           print('User data for $user: $userData');
//           if (userData['fcm'] != null) {
//             fcmList.add(userData['fcm']);
//             print('FCM token for $user: ${userData['fcm']}');
//           } else {
//             print('No FCM token found for $user');
//           }
//         } else {
//           print('No data found for user ID: $user');
//         }
//       }
//
//       // Send notification to all FCM tokens
//       await SendNotificationService.sendNotificationUsingApi(
//         fcmList: fcmList,
//         title: authController.userModel.value.name,
//         body: message.text,
//         data: {'imageUrl': imageUrl.value},
//       );
//
//       // Create notifications for each user in the group
//       for (var user in selectedGroup.value!.members) {
//         await NotificationCrud.createNotification(
//           notificationFrom: authController.userModel.value.id,
//           notificationFor: user,  // Create a notification for each member
//           notificationType: 'emergency',
//           data: {
//             'message': message.text,
//             'imageUrl': imageUrl.value,
//           },
//         );
//       }
//
//       // Show success message after all notifications are sent
//       Utils.showSuccessSnackBar(
//         title: 'Success',
//         description: 'Notifications sent successfully!',
//       );
//
//       // Clear local image path and message after success
//       localImagePath.value = '';
//       message.clear();
//
//     } catch (e) {
//       // Handle any errors and show a failure message if necessary
//       print('Error: $e');
//       Utils.showErrorSnackBar(
//         title: 'Failed to send notification',
//         description: e.toString(),
//       );
//     }
//   }
//
//
//   @override
//   void onInit() {
//   loadGroups();
//     // TODO: implement onInit
//     super.onInit();
//   }
// }














import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/group/controller/create_group_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../core/supabase/groups_crud.dart';
import '../../../core/supabase/notification_crud.dart';
import '../../../core/supabase/user_crud.dart';
import '../../../models/group_model.dart';
import '../../../servies/send_notification_services.dart';
import '../../../utils/utils.dart';

class DoorController extends GetxController {
  final groupController = Get.put(CreateGroupController());
  final authController = Get.find<AuthController>();
  final message = TextEditingController();
  final items = ['Indoor', 'Outdoor'].obs;
  var selectedType = 'Indoor'.obs;
  RxString imageUrl = ''.obs;
  RxString localImagePath = ''.obs;
  var selectedGroup = Rxn<GroupModel>();
  final groups = <GroupModel>[].obs;
  var isLoading = false.obs;
  RxString currentAddress = ''.obs; // To hold the user's current address

  void setSelected(String value) {
    selectedType.value = value;
    selectedGroup.value = null;
    loadGroups();
  }

  Future<void> loadGroups() async {
    final fetchedGroups = await GroupCrud.fetchGroupsByType(selectedType.value, authController.userModel.value.id);
    groups.assignAll(fetchedGroups);
    print('Loaded groups: $groups');
  }

  // Method to get the current location and convert it to an address
  Future<void> getCurrentAddress() async {
    try {
      // Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.showErrorSnackBar(title: 'Location Permission Denied', description: 'Please enable location permissions in settings.');
        return;
      }

      // Set location settings
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      print("Position: ${position.latitude}, ${position.longitude}");

      // Convert the coordinates to a human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];

        // Construct the complete address
        currentAddress.value = "${place.name ?? 'Unknown'}, ${place.thoroughfare ?? 'Unknown'}, "
            "${place.subLocality ?? 'Unknown'}, ${place.locality ?? 'Unknown'}, "
            "${place.administrativeArea ?? 'Unknown'}, ${place.country ?? 'Unknown'}";

        print("Current Address: ${currentAddress.value}");
      }
    } catch (e) {
      print("Error retrieving location: $e");
      Utils.showErrorSnackBar(title: 'Location Error', description: e.toString());
    }
  }


  Future<void> onPress() async {

    if (selectedGroup.value == null) {
      Utils.showErrorSnackBar(
        title: 'Select Group',
        description: 'Please select a group before sending a notification.',
      );
      return; // Exit early if no group is selected
    }

    // Check if the message is empty
    if (message.text.isEmpty) {
      Utils.showErrorSnackBar(
        title: 'Empty Message',
        description: 'Message cannot be empty.',
      );
      return; // Exit early if message is empty
    }
    List<String> fcmList = [];
    isLoading.value = true; // Set loading to true
    try {
      await getCurrentAddress();
      print(selectedGroup.value?.id);

            for (var user in selectedGroup.value!.members) {
        print('Fetching data for user ID: $user');
        Map<String, dynamic>? userData = await UserCrud.getUser(user);
        if (userData != null) {
          print('User data for $user: $userData');
          if (userData['fcm'] != null) {
            fcmList.add(userData['fcm']);
            print('FCM token for $user: ${userData['fcm']}');
          } else {
            print('No FCM token found for $user');
          }
        } else {
          print('No data found for user ID: $user');
        }
      }

      // Send notification to all FCM tokens
      await SendNotificationService.sendNotificationUsingApi(
        fcmList: fcmList,
        title: authController.userModel.value.name,
        body: message.text,
        data: {'imageUrl': imageUrl.value},
      );

      // Create notifications for each user in the group
      for (var user in selectedGroup.value!.members) {
        await NotificationCrud.createNotification(
          notificationFrom: authController.userModel.value.id,
          notificationFor: user,  // Create a notification for each member
          notificationType: 'emergency',
          data: {
            'message': message.text,
            'imageUrl': imageUrl.value,
          },
        );
      }


      Utils.showSuccessSnackBar(
        title: 'Success',
        description: 'Notifications sent successfully!',
      );
    } catch (e) {
      print('Error: $e');
      Utils.showErrorSnackBar(
        title: 'Failed to send notification',
        description: e.toString(),
      );
    } finally {
      isLoading.value = false; // Set loading to false
    }
  }
@override
  void onClose() {
message.dispose();
imageUrl.value="";
localImagePath.value="";
  super.onClose();
  }

  @override
  void onInit() {
    loadGroups();
    super.onInit();
  }
}
