import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/core/supabase/group_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class AddContactController extends GetxController {
  var groupContacts = <String>[].obs; // Only phone numbers
  var phoneContacts = <Map<String, String>>[].obs; // Maps phone number to contact name
  var matchedContacts = <Map<String, String>>[].obs; // Stores matched contacts
  var isLoading = false.obs;

  Future<void> fetchGroupContacts() async {
    isLoading(true);
    try {
      groupContacts.value = await GroupContacts.fetchGroupContacts();
      print('Group Contacts: $groupContacts');
      findMatchedContacts();
    } catch (error) {
      print('Error fetching group contacts: $error');
    } finally {
      isLoading(false);
    }
  }

  void findMatchedContacts() {
    matchedContacts.value = phoneContacts.where((contact) {
      String? phoneNumber = contact['phone'];

      // Check if the phone number has at least 10 digits
      if (phoneNumber!.length >= 10) {
        String phoneNumberWithoutCode = phoneNumber.substring(phoneNumber.length - 10); // Keep only the last 10 digits
        return groupContacts.contains(phoneNumberWithoutCode);
      }

      // If phone number is less than 10 digits, it cannot match
      return false;
    }).toList();

    print('Matched Contacts: $matchedContacts');
  }

  Future<void> fetchPhoneContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

      // Extract phone numbers and names from contacts
      phoneContacts.value = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map((contact) => {
        'phone': contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), ''), // Keep the raw phone number
        'name': contact.displayName ?? 'No Name',
      })
          .toList();

      print('Total contacts fetched: ${phoneContacts.length}');
      print('Phone Contacts: $phoneContacts');
      findMatchedContacts(); // Call this after fetching contacts to update matches
    } else {
      // Handle permission denied case
      Get.snackbar('Permission Denied', 'Please grant contact access permission to load contacts.');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupContacts();
    fetchPhoneContacts();
  }
}
