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
import 'package:alarm_app/features/notification/widget/notification_widget.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/notification_controller_widget.dart';
import 'package:alarm_app/widgets/rounded_container.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/connection_listener.dart';
import '../../../utils/utils.dart';
import '../controller/notification_controller.dart';
import '../widget/full_screen_view_image.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, res) {
        ConnectionStatusListener.isOnHomePage = true;
      },
      child: Scaffold(
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
          actions: [

            NotificationControllerWidget(),
            SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Notification',
                      desc:
                          'You can tap on the notification to open the location in the external map on your mobile and you can turn off notification by switching the toggle button.It will only mute push notification.',
                      btnCancelOnPress: () {},
                      btnCancel: null,
                      transitionAnimationDuration: Duration(microseconds: 0),
                      btnOkOnPress: () {},
                    ).show();
                  },
                  child: Icon(Icons.help_outline)),
            ),

          ],
          centerTitle: true,
        ),
        body: GradientContainer(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: GetBuilder<NotificationController>(builder: (logic) {
              return notificationController.isLoading ?
              const Center(
                child: Text(
                  "Loading Notifications",
                  style: TextStyle(fontSize: 28, color: AColors.white),
                ),
              ) :
                notificationController.notifications.isEmpty
                  ? const Center(
                      child: Text(
                        "No notifications",
                        style: TextStyle(fontSize: 28, color: AColors.white),
                      ),
                    )
                  : CustomMaterialIndicator(
                onRefresh: notificationController.refreshNotifications,
                    child: ListView.builder(
                      controller: notificationController.scrollController,
                        itemCount: notificationController.notifications.length,
                        itemBuilder: (context, index) {
                          final notification =
                              notificationController.notifications[index];
                    
                          // Check if the notification is of type 'emergency'
                          bool isEmergency =
                              notification.notificationType == 'emergency';
                    
                          return Dismissible(
                              key: Key(notification.id),
                              // Unique key for each notification
                              direction: DismissDirection.endToStart,
                              // Allow swipe to the right
                              onDismissed: (direction) {
                                // Remove the notification from the list
                                notificationController
                                    .deleteNotification(notification.id);
                                if (notification.notificationType ==
                                    "invitation") {
                                  notificationController.rejectInvitation(
                                      notification.notificationFrom,
                                      notification.notificationFor);
                                }
                    
                                // Show a snackbar or a message if desired
                                Utils.showSuccessSnackBar(
                                  title: 'Deleted',
                                  description: 'Notification has been deleted.',
                                );
                              },
                              background: Container(
                                color: CupertinoColors
                                    .destructiveRed, // Background color when swiped
                                alignment: Alignment.centerLeft,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child:
                              // isEmergency
                              //     ? Padding(
                              //         padding: const EdgeInsets.only(bottom: 8.0),
                              //         child: ARoundedContainer(
                              //           padding: 15,
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               NotificationWidget(
                              //                   title:
                              //                       "From: ${notification.data?['name'] ?? 'Unknown'}"),
                              //               const SizedBox(height: 8),
                              //               if (notification.data?['address'] !=
                              //                   null)
                              //                 GestureDetector(
                              //                     onTap: () {
                              //                       if (notification
                              //                               .notificationType ==
                              //                           "Outdoor") {
                              //                         Utils.openMap(
                              //                             notification.address![
                              //                                 'latitude']!,
                              //                             notification.address![
                              //                                 'longitude']!);
                              //                       }
                              //                     },
                              //                     child: NotificationWidget(
                              //                         title:
                              //                             "Address: ${notification.data?['address'] ?? 'Address not provided'}")),
                              //               const SizedBox(height: 15),
                              //               if (notification.data?['message'] !=
                              //                   null)
                              //                 NotificationWidget(
                              //                     title:
                              //                         "Message: ${notification.data?['message'] ?? 'No message'}"),
                              //               const SizedBox(height: 15),
                              //               if (isEmergency &&
                              //                   notification.data?['imageUrl'] !=
                              //                       null &&
                              //                   notification
                              //                       .data?['imageUrl'].isNotEmpty)
                              //                 Center(
                              //                   child: Container(
                              //                     width: Get.width * 0.7,
                              //                     height: 200,
                              //                     decoration: BoxDecoration(
                              //                       borderRadius:
                              //                           BorderRadius.circular(12),
                              //                     ),
                              //                     child: ClipRRect(
                              //                       borderRadius:
                              //                           BorderRadius.circular(12),
                              //                       child: GestureDetector(
                              //                         onTap: () {
                              //                           Get.to(() =>
                              //                               FullScreenImageView(
                              //                                   imageUrl: notification
                              //                                           .data?[
                              //                                       'imageUrl']));
                              //                         },
                              //                         child: Image.network(
                              //                           notification.data?[
                              //                                   'imageUrl'] ??
                              //                               '',
                              //                           fit: BoxFit.cover,
                              //                           errorBuilder: (context,
                              //                               error, stackTrace) {
                              //                             return Container(
                              //                               decoration:
                              //                                   BoxDecoration(
                              //                                 color: Colors.grey,
                              //                                 // Background color for the placeholder
                              //                                 borderRadius:
                              //                                     BorderRadius
                              //                                         .circular(
                              //                                             12),
                              //                               ),
                              //                               child: const Center(
                              //                                 child: Text(
                              //                                   'Image not available',
                              //                                   style: TextStyle(
                              //                                       color: Colors
                              //                                           .white),
                              //                                 ),
                              //                               ),
                              //                             );
                              //                           },
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 )
                              //               else
                              //                 const SizedBox.shrink(),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     :
                              GestureDetector(
                                onTap: () {

                                  if (notification
                                      .notificationType ==
                                      "Outdoor") {
                                    Utils.openMap(
                                        notification.address![
                                        'latitude']!,
                                        notification.address![
                                        'longitude']!);
                                  }
                                },
                                child: Padding(
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      notification.data?['name'] ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AColors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.3,
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      notification.data?['phone'] ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AColors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                            if(notification.notificationType != 'invitation')   Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Address: ${notification.data?["address"]}",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: AColors.white),
                                                ),
                                            ),

                                              const SizedBox(height: 5),
                                              notification.data?['message'] != null
                                                  ? Row(
                                                      children: [
                                                        const Text(
                                                          "Message: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: AColors.white),
                                                        ),
                                                        SizedBox(
                                                          width: Get.width * 0.5,
                                                          child: Text(
                                                            notification.data?[
                                                                    'message'] ??
                                                                'No message',
                                                            maxLines: 2,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                color:
                                                                    AColors.white),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              const SizedBox(height: 15),
                                       if(notification.notificationType == 'invitation') Row(
                                                children: [
                                                  Expanded(
                                                    child: AElevatedButton(
                                                        bgColor: CupertinoColors
                                                            .activeGreen,
                                                        title: "Accept",
                                                        padding: 0,
                                                        onPress: () async {
                                                          await notificationController
                                                              .acceptInvitation(
                                                                  notification
                                                                      .notificationFrom,
                                                                  notification
                                                                      .notificationFor);
                                                          notificationController
                                                              .deleteNotification(
                                                                  notification.id);
                                                        }),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: AElevatedButton(
                                                        bgColor: CupertinoColors
                                                            .destructiveRed,
                                                        title: "Reject",
                                                        padding: 0,
                                                        onPress: () async {
                                                          await notificationController
                                                              .rejectInvitation(
                                                                  notification
                                                                      .notificationFrom,
                                                                  notification
                                                                      .notificationFor);
                                                          notificationController
                                                              .deleteNotification(
                                                                  notification.id);
                                                        }),
                                                  ),
                                                ],
                                              ),
                                       if(notification.data?['imageUrl']!=null && (notification.data!['imageUrl'] as String).isNotEmpty)       Center(
                                                child: SizedBox(
                                                  width: Get.width * 0.7,
                                                  height: 200,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: CachedNetworkImage(imageUrl: notification.data!["imageUrl"],
                                                    placeholder: (context,a){
                                                      return Icon(Icons.image, size: 100,color: Colors.white,);
                                                    },
                                                    errorWidget: (context, a,b){
                                                      return Icon(Icons.error,color: Colors.white,size: 100,);
                                                    },
                                                    )
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                              ));
                        },
                      ),
                  );
            }),
          ),
        ),
      ),
    );
  }
}
