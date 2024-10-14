// import 'package:alarm_app/constants/colors.dart';
// import 'package:alarm_app/widgets/elevated_button.dart';
// import 'package:alarm_app/widgets/gradient_container.dart';
// import 'package:alarm_app/widgets/rounded_container.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: () {
//               Get.back();
//             },
//             child: const Icon(Icons.arrow_back_ios_new)),
//         title: const Text(
//           "Notifications",
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//       ),
//       body: GradientContainer(
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: ListView(
//             children: [
//               ARoundedContainer(
//                 padding: 15,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: Get.width * 0.7,
//                           child: const Text(
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             "From :  Nadzmi ",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AColors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           width: Get.width * 0.7,
//                           child: const Text(
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             "Address: No 17 lorong Az-zaharah",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AColors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           width: Get.width * 0.7,
//                           child: const Text(
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             "Message: Help someone in my house!!",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AColors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Icon(Icons.home, color: AColors.white),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 25),
//               ARoundedContainer(
//                 padding: 15,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Text(
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           "Request Contacts: ",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: AColors.white),
//                         ),
//                         SizedBox(
//                           width: Get.width * 0.2,
//                           child: const Text(
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             "Ahmad Akram",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AColors.white),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           "+0123456789",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: AColors.white),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: AElevatedButton(
//                               bgColor: CupertinoColors.activeGreen,
//                               title: "Accept",
//                               padding: 0,
//                               onPress: () {}),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: AElevatedButton(
//                               bgColor: CupertinoColors.destructiveRed,
//                               title: "Accept",
//                               padding: 0,
//                               onPress: () {}),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 25),
//               ARoundedContainer(
//                 padding: 15,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: Get.width * 0.7,
//                           child: const Text(
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             "From :  Same ",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AColors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           width: Get.width * 0.7,
//                           child: const Text(
//                             maxLines: 3,
//                             "Message: No 17 lorong Az-zaharah No 17 lorong Az-zaharah",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AColors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Center(
//                           child: SizedBox(
//                             width: Get.width * 0.7,
//                             height: 200,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: const Image(
//                                 fit: BoxFit.fill,
//                                 image: NetworkImage(
//                                     "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Icon(Icons.pin_drop_outlined, color: AColors.white),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/rounded_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    print("THIS IS ID FROM NOTI SCREEN");
    print(notificationController.authController.userModel.value.id);
    notificationController.fetchNotifications(notificationController.authController.userModel.value.id);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: GradientContainer(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Obx(() {
            if (notificationController.notifications.isEmpty) {
              return const Center(
                child: Text(
                  "No notifications",
                  style: TextStyle(fontSize: 28,color: AColors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: notificationController.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationController.notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ARoundedContainer(
                    padding: 15,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "From: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AColors.white),
                            ),
                            SizedBox(
                              width: Get.width * 0.35,
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                notification.data?['name'] ?? 'Unknown',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AColors.white),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              width: Get.width * 0.3,
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                notification.data?['phone'] ?? 'Unknown',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AColors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                       notification.data?['message'] !=null? Row(
                          children: [
                            const Text(
                              "Message: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AColors.white),
                            ),
                            SizedBox(
                              width: Get.width * 0.5,
                              child: Text(
                                notification.data?['message']?? 'No message',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AColors.white),
                              ),
                            ),
                          ],
                        ):const SizedBox.shrink(),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: AElevatedButton(
                                  bgColor: CupertinoColors.activeGreen,
                                  title: "Accept",
                                  padding: 0,
                                  onPress: () {
                                    notificationController.acceptInvitation(notification.notificationFrom, notification.notificationFor);
                                    notificationController.deleteNotification(notification.id);

                                  }),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: AElevatedButton(
                                  bgColor: CupertinoColors.destructiveRed,
                                  title: "Reject",
                                  padding: 0,
                                  onPress: () {
                                    notificationController.rejectInvitation(notification.notificationFrom, notification.notificationFor);
                                    notificationController.deleteNotification(notification.id);

                                  }),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
