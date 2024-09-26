import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

class AddContactController extends GetxController {
  var contacts = <Contact>[].obs;
  var selectedContacts = <Contact>[].obs;

  Future<void> fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true);
      contacts.value = fetchedContacts;
    } else {
      Get.snackbar(
        'Permission Denied',
        'Please grant contact access permission to select contacts.',
      );
    }
  }

  void addContact(Contact contact) {
    if (!selectedContacts.contains(contact)) {
      selectedContacts.add(contact);
    } else {
      Get.snackbar('Duplicate', 'This contact is already added.');
    }
  }

  void showContactPicker(BuildContext context) {
    fetchContacts();

    showModalBottomSheet(
      backgroundColor: AColors.primary,
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          if (contacts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              Contact contact = contacts[index];
              return ListTile(
                title: Text(contact.displayName ?? 'No Name',style: TextStyle(color: AColors.white,fontWeight: FontWeight.bold)),
                subtitle: Text(contact.phones.isNotEmpty
                    ? contact.phones.first.number
                    : 'No Phone Number',
                style: TextStyle(color: AColors.white,fontWeight: FontWeight.bold),),
                onTap: () {
                  addContact(contact); // Add the selected contact
                  Navigator.pop(context); // Close the modal
                },
              );
            },
          );
        });
      },
    );
  }
}
