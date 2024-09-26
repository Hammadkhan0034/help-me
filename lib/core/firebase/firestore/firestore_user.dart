import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FireStoreUser {
  static final _userCollection = FirebaseFirestore.instance.collection("users");


  static Future<bool> doesUserAlreadyExists(String number) async {
    final snapshot =
        await _userCollection.where("phone", isEqualTo: number).get();
    return snapshot.size > 0;
  }

  // static Future<UserModel> getUserById(String userId) async {
  //   final snapshot = await _userCollection.doc(userId).get();
  //   return UserModel.fromMap(snapshot.data()!);
  // }

  // static Future<UserModel?> isUserProfileExists(String userId) async {
  //   final snapshot = await _userCollection.doc(userId).get();
  //   return snapshot.data()==null?null:UserModel.fromMap(snapshot.data()!);
  // }

  static Future updateFcmToken(String fcmToken) async {
    try {
      await _userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"fcmToken": fcmToken});
    } catch (e, st) {
      log("update fam token from FireStoreUser", error: e, stackTrace: st);
    }
  }

  // static Future updateRating(double rating, UserModel user) async {
  //   try {
  //     rating += user.rating;
  //     await _userCollection
  //         .doc(user.id)
  //         .update({"rating": rating, 'reviews': (user.reviews + 1)});
  //   } catch (e, st) {
  //     log("update rating from FireStoreUser", error: e, stackTrace: st);
  //   }
  // }

  static Future updateUserVerification(bool isVerified) async {
    try {
      await _userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isVerified": isVerified});
    } catch (e, st) {
      log("update fam token from FireStoreUser", error: e, stackTrace: st);
    }
  }

  // static Future setUser(UserModel user) async {
  //   await _userCollection
  //       .doc(user.id)
  //       .set(user.toMap(), SetOptions(merge: true));
  // }
  //
  // static Future setRating() async {
  //   // await _userCollection
  //   //     .doc(user.id)
  //   //     .set(user.toMap(), SetOptions(merge: true));
  // }
  //
  // static Future updateUserCurrentLocation(MyLocation myLocation) async {
  //   await _userCollection
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .update({"currentLocation": myLocation.toMap()});
  // }
}
