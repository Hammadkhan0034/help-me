import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactListScreen extends StatelessWidget {
  final ContactController contactController = Get.put(ContactController());
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
