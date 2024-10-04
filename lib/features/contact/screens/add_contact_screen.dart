import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

                  Obx(() {
                    if (addContactController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (addContactController.matchedContacts.isEmpty) {
                      return Center(child: Text('No matched contacts found.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true, // Use shrinkWrap to avoid overflow
                      physics: NeverScrollableScrollPhysics(), // Disable scrolling
                      itemCount: addContactController.matchedContacts.length,
                      itemBuilder: (context, index) {
                        final contact = addContactController.matchedContacts[index];
                        return ContactCardWidget(
                          name: contact['name']!, // Accessing name from map
                          phoneNumber: contact['phone']!, // Accessing phone number from map
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              // Handle adding the contact
                            },
                          ),
                        );
                      },
                    );
                  }),

                  // Obx(() {
                  //   if (addContactController.isLoading.value) {
                  //     return Center(child: CircularProgressIndicator());
                  //   }
                  //   if (addContactController.matchedContacts.isEmpty) {
                  //     return Center(child: Text('No matched contacts found.'));
                  //   }
                  //   return ListView.builder(
                  //     itemCount: addContactController.matchedContacts.length,
                  //     itemBuilder: (context, index) {
                  //       final contact = addContactController.matchedContacts[index];
                  //       print(contact);
                  //       return ContactCardWidget(
                  //         name: "contact['name']",
                  //         phoneNumber: addContactController.matchedContacts[index], // Use the phone number from the matched contact
                  //         suffixIcon: IconButton(
                  //           icon: const Icon(Icons.add, color: Colors.white),
                  //           onPressed: () {
                  //             // Handle adding the contact
                  //             // addContactController.showContactPicker(context);
                  //           },
                  //         ),
                  //       );
                  //     },
                  //   );
                  // }),

                  // ContactCardWidget(
                  //   name: "Sam",
                  //   phoneNumber: "+013256645",
                  //   suffixIcon: IconButton(
                  //     icon: const Icon(Icons.add, color: Colors.white),
                  //     onPressed: () {
                  //
                  //       // addContactController.showContactPicker(context);
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    "Added Contacts",
                    style: TextStyle(
                        color: AColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10,),
                  // Expanded(
                  //   child: Obx(() {
                  //     return ListView.builder(
                  //       itemCount: addContactController.selectedContacts.length,
                  //       itemBuilder: (context, index) {
                  //         Contact contact =
                  //             addContactController.selectedContacts[index];
                  //         return ContactCardWidget(
                  //           name: contact.displayName ?? 'No Name',
                  //           phoneNumber: contact.phones.isNotEmpty
                  //               ? contact.phones.first.number
                  //               : 'No Phone Number',
                  //           suffixIcon: IconButton(
                  //             icon: const Text(
                  //               "Pending",
                  //               style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontWeight: FontWeight.bold),
                  //             ),
                  //             onPressed: () {
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   }),
                  // ),

                  // SizedBox(height: 10,),
                  // ContactCardWidget(
                  //   name: "Sam",
                  //   phoneNumber: "+013256645",
                  //   suffixIcon: IconButton(
                  //     icon: const Row(
                  //       children: [
                  //         Icon(Icons.edit, color: Colors.white),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Icon(Icons.delete, color: Colors.white)
                  //       ],
                  //     ),
                  //     onPressed: () {
                  //       // Handle the suffix icon button press
                  //     },
                  //   ),
                  // ),
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
  final String name;
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
                      SizedBox(
                        width: Get.width * 0.45,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
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
