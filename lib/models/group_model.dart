class GroupModel {
  final String? id;
  final String name;
  final List<String> members;
  final String type;
  final int? totalMembers;
  final DateTime? createdAt;
  final String? createdBy;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.type,
    this.totalMembers,
    required this.createdAt,
    required this.createdBy,
  });

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    return GroupModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      // Handle the contacts field, checking if it's a list or a string
      members: json['members'] is List
          ? List<String>.from(json['members'])
          : (json['members'] != null && json['members'].isNotEmpty)
          ? json['members'].split(',') // assuming it's a comma-separated string
          : [],
      type: json["type"] ?? "",
      totalMembers: json["total_members"] != null
          ? int.tryParse(json["total_members"].toString()) ?? 0
          : 0,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
          : DateTime.now(),
      createdBy: json["created_by"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "contacts": members,
      "type": type,
      "totalMembers": totalMembers,
      "createdAt": createdAt?.toIso8601String(),
      "createdBy": createdBy,
    };
  }

  @override
  String toString() {
    return 'GroupModel{id: $id, name: $name, contacts: $members, type: $type, totalMembers: $totalMembers, createdAt: $createdAt, createdBy: $createdBy}';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupModel && other.id == id;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    members,
    type,
    totalMembers,
    createdAt,
    createdBy,
  ];
}
