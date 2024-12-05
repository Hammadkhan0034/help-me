import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/friends_model.dart';

class AddContactScreen extends StatelessWidget {
  AddContactScreen({super.key, required this.addContactController});

  final ContactController addContactController;
  bool isEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Add Contacts",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GradientContainer(
            mTop: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100, width: Get.width),
                    const Text(
                      "App Contacts",
                      style: TextStyle(
                          color: AColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: Get.height * 0.2,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Obx(() {
                          if (addContactController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (addContactController.matchedContacts.isEmpty) {
                            return const Center(
                                child: Text(
                              'No matched contacts found.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ));
                          }
                          return ListView.builder(
                            shrinkWrap:
                                true, // Use shrinkWrap to avoid overflow
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling
                            itemCount:
                                addContactController.matchedContacts.length,
                            itemBuilder: (context, index) {
                              final matchedContacts =
                                  addContactController.matchedContacts[index];
                              return ContactCardWidget(
                                name: Text(
                                  matchedContacts.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                phoneNumber: matchedContacts.phone,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.white),
                                  onPressed: () async {
                                    if (isEnabled) {
                                      isEnabled = false;
                                      await addContactController
                                          .sendFriendRequestToUser(
                                              matchedContacts);
                                      isEnabled = true;
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Added Contacts",
                      style: TextStyle(
                          color: AColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: Get.height * 0.25,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Obx(() {
                          if (addContactController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return addContactController.requestedFriends.isEmpty
                              ? Center(
                                  child: Text(
                                  'No Added contacts found.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: addContactController
                                      .requestedFriends.length,
                                  itemBuilder: (context, index) {
                                    final FriendsModel friend =
                                        addContactController
                                            .requestedFriends[index];

                                    return ContactCardWidget(
                                      name: Text(
                                        friend.editedName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      phoneNumber:
                                          friend.friendPhone.toString(),
                                      suffixIcon: friend.requestStatus == 1
                                          ? Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    String name =
                                                        friend.editedName;
                                                    Get.dialog(
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 200,
                                                            width:
                                                                Get.width * 0.8,
                                                            child: Card(
                                                              color: AColors
                                                                  .primary,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // Text(
                                                                    //   "User Name",
                                                                    //   style: const TextStyle(
                                                                    //     fontSize: 18,
                                                                    //     fontWeight: FontWeight.bold,
                                                                    //     color: Colors.white,
                                                                    //   ),
                                                                    //   overflow: TextOverflow.ellipsis,
                                                                    // ),
                                                                    SizedBox(
                                                                      width: Get
                                                                              .width *
                                                                          0.8,
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            TextEditingController(text: name),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                        onChanged:
                                                                            (val) {
                                                                          name =
                                                                              val;
                                                                        },
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                                                                          label:
                                                                              Text(
                                                                            "Name",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20),

                                                                    SizedBox(
                                                                      height:
                                                                          50,
                                                                      width: Get
                                                                              .width *
                                                                          0.8,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            elevation:
                                                                                3,
                                                                            backgroundColor:
                                                                                Color(0xff9E3030)),
                                                                        onPressed:
                                                                            () {
                                                                          addContactController
                                                                              .updateContactName(
                                                                            index:
                                                                                index,
                                                                            newName:
                                                                                name,
                                                                            friendId:
                                                                                friend.friendId,
                                                                          );
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "SAVE",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    addContactController
                                                        .removeContact(index,
                                                            friend.friendId);
                                                  },
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              "Pending",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    );
                                  },
                                );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const WarningCircleIcon(),
        ],
      ),
    );
  }
}

class ContactCardWidget extends StatelessWidget {
  final Widget name;
  final String phoneNumber;
  final Widget suffixIcon;

  const ContactCardWidget({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.circle, size: 10, color: AColors.white),
                  ), // The dot icon before the name
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: Get.width * 0.45, child: name
                          // Text(
                          //   name,
                          //   style: const TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          ),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              suffixIcon,
            ],
          ),
          const Divider(
            color: Colors.white,
            indent: 1,
            endIndent: 1,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
