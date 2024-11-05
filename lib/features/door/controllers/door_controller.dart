










import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/group/controller/create_group_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  RxDouble latitude=0.0.obs;
  RxDouble longitude=0.0.obs;
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

  Future<void> getCurrentAddress() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        Utils.showErrorSnackBar(
          title: 'Location Permission Denied',
          description: 'Please enable location permissions in settings.',
        );
        return;
      }

      // Define location accuracy and obtain current position
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
        latitude.value=position.latitude;
        longitude.value=position.longitude;
      // Reverse geocoding to get address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];

        // Construct a detailed address format
        String address = "${place.name ?? ''}, ${place.street ?? ''}, "
            "${place.subLocality ?? ''}, ${place.locality ?? ''}, "
            "${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}, "
            "${place.country ?? ''}";
        print("Current Address: $address");
        await Supabase.instance.client
            .from('notifications')
            .update({'address': {"longitude":position.longitude, "latitude":position.latitude}})
            .eq('notification_from', authController.userModel.value.id);
      }
    } catch (e) {
      print("Error retrieving location: $e");
      Utils.showErrorSnackBar(title: 'Location Error', description: e.toString());
    }}



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
      await SendNotificationService.sendNotificationUsingApi(
        fcmList: fcmList,
        title: authController.userModel.value.name,
        body: message.text,
        data: {'imageUrl': imageUrl.value, 'address':currentAddress.value},

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
            'address':currentAddress.value
          }, address: {
            'longitude':longitude.value,
            'latitude':latitude.value
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
