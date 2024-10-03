import 'package:alarm_app/models/group_model.dart';
import 'package:alarm_app/models/user_model.dart';

class ContactsModel {

  final UserModel userId;

  final GroupModel groupId;

  const ContactsModel({
    required this.userId,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'groupId': groupId,
    };
  }

  factory ContactsModel.fromMap(Map<String, dynamic> map) {
    return ContactsModel(
      userId: map['userId'] as UserModel,
      groupId: map['groupId'] as GroupModel,
    );
  }

  @override
  String toString() {
    return 'ContactsModel{userId: $userId, groupId: $groupId}';
  }

  @override
  List<Object> get props => [userId, groupId];
}
