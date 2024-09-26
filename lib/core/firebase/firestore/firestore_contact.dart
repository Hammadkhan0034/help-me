import 'dart:developer';

import 'package:alarm_app/models/contacts_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FireStoreContact {
  static final _contactCollection = FirebaseFirestore.instance.collection("contacts");

  static Future setContact(ContactsModel contactModel) async {
    await _contactCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'contacts': contactModel.toJson()});
  }

  static Future removeContact(String contactId) async {
    await _contactCollection.doc(contactId).delete();
  }
  static Future<bool> doesContactAlreadyExists(String number) async {
    final snapshot =
    await _contactCollection.where("phone", isEqualTo: number).get();
    return snapshot.size > 0;
  }

  // static Future setCandidateId(CandidateModel candidateModel) async {
  //   await _userCollection
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({'candidateId': candidateModel.id});
  // }

  // static Future setInvitationId(InvitationModel invitationModel) async {
  //   await _userCollection
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({'invitationId': invitationModel.id});
  // }




  // static Stream<List<UserModel>> getActiveDrivers(String vehicleType) {
  //   return _userCollection
  //       .where('working', isEqualTo: true)
  //       .where('vehicle.vehicleType', isEqualTo: vehicleType)
  //       .snapshots()
  //       .map((snapshot) {
  //     List<UserModel> activeDrivers = [];
  //     for (final driver in snapshot.docs) {
  //       String myId = FirebaseAuth.instance.currentUser!.uid;
  //       UserModel userModel = UserModel.fromMap(driver.data());
  //       if (userModel.id == myId) continue;
  //       activeDrivers.add(userModel);
  //     }
  //     return activeDrivers;
  //   });
  // }
}
