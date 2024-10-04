import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/features/contact/screens/add_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

class ContactListScreen extends StatelessWidget {
  final AddContactController contactController = Get.put(AddContactController());
   ContactListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: Obx(
          //         () => ListView.builder(
          //       itemCount: contactController.selectedContacts.length,
          //       itemBuilder: (context, index) {
          //         Contact contact = contactController.selectedContacts[index];
          //         return ContactCardWidget(
          //           name: contact.displayName ?? 'No Name',
          //           phoneNumber: contact.phones.isNotEmpty
          //               ? contact.phones.first.number
          //               : 'No Phone Number',
          //           suffixIcon: const Icon(Icons.add, color: Colors.white),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          ElevatedButton(
            onPressed: () {
              // Handle Save button press
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
