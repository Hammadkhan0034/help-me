import 'package:alarm_app/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGroup{
  static final _groupCollection =
  FirebaseFirestore.instance.collection("groups");
  static Future addGroup(GroupModel groupModel) async {
    await _groupCollection
        .doc(groupModel.id)
        .set(groupModel.toJson());
  }

  static Future removeGroup(String groupId) async {
    await _groupCollection.doc(groupId).delete();
  }
}