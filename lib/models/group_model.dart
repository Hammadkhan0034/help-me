import 'dart:convert';

import 'package:alarm_app/models/contacts_model.dart';

class GroupModel {
  final String? id;
  final String name;
  final List<ContactsModel> contacts;
  final String type;
  final int totalMembers;
  final DateTime? createdAt;
  final String? createdBy;

  GroupModel({required this.id,
    required this.name,
    required this.contacts,
    required this.type,
    required this.totalMembers,
    required this.createdAt,
    required this.createdBy});

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    return GroupModel(
      id: json["id"],
      name: json["name"],
      contacts: List<ContactsModel>.from(json['contacts']),
      type: json["type"],
      totalMembers: int.parse(json["totalMembers"]),
      createdAt: DateTime.parse(json["createdAt"]),
      createdBy: (json["createdBy"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "contacts": contacts,
      "type": type,
      "totalMembers": totalMembers,
      "createdAt": createdAt?.toIso8601String(),
      "createdBy": createdBy,
    };
  }

  @override
  String toString() {
    return 'GroupModel{id: $id, name: $name, contacts: $contacts, type: $type, totalMembers: $totalMembers, createdAt: $createdAt, createdBy: $createdBy}';
  }

  @override
  List<Object?> get props =>
      [id, name, contacts, type, totalMembers, createdAt, createdBy,];
//
}
