import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/friends_model.dart';

class AddContactScreen extends StatelessWidget {
  AddContactScreen({super.key});

  final AddContactController addContactController =
     Get.put(AddContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
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
                              child: Text('No matched contacts found.'));
                        }
                        return ListView.builder(
                          shrinkWrap: true, // Use shrinkWrap to avoid overflow
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable scrolling
                          itemCount:
                              addContactController.matchedContacts.length,
                          itemBuilder: (context, index) {
                            final matchedContacts =
                                addContactController.matchedContacts[index];
                            return ContactCardWidget(
                              name: Text(
                                matchedContacts['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              phoneNumber: matchedContacts['phone']!,
                              suffixIcon: IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  addContactController.addedContacts(matchedContacts);
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
                      child:
                      Obx(() {
                        if (addContactController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: addContactController.requestedFriends.length,
                          itemBuilder: (context, index) {
                            final FriendsModel friend = addContactController.requestedFriends[index];

                            return Obx(() {
                              return ContactCardWidget(
                                name: addContactController.isEditing.value
                                    ? TextField(
                                  controller: TextEditingController(text: friend.editedName),
                                  style: const TextStyle(color: Colors.white),
                                  onSubmitted: (newName) {
                                    addContactController.updateContactName(
                                      index: index,
                                      newName: newName,
                                      friendId: friend.friendId,
                                    );
                                    addContactController.isEditing.value = false;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                )
                                    : Text(
                                  friend.editedName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                phoneNumber: friend.friendPhone.toString(),
                                suffixIcon: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white),
                                      onPressed: () {
                                        addContactController.isEditing.value = true;
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.white),
                                      onPressed: () {
                                        addContactController.removeContact(index, friend.friendId);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      })

                    ),
                  ),
                ],
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
