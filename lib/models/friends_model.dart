class FriendsModel {
  final String id;
  final DateTime createdAt;
  final String friendId;
  final String editedName;
  final String userId;
   String? friendPhone;
  final DateTime? acceptedAt;
  final DateTime? updatedAt;
  final int requestStatus;




  FriendsModel({
    required this.id,
    required this.createdAt,
    required this.friendId,
    required this.editedName,
    required this.userId,
    this.acceptedAt,
    this.updatedAt,
    this.friendPhone,
    required this.requestStatus,
  });

  // Method to create a FriendsModel instance from a map
  factory FriendsModel.fromMap(Map<String, dynamic> map) {
    return FriendsModel(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      friendId: map['friend_id'],
      editedName: map['edited_name'],
      userId: map['user_id'],
      acceptedAt: map['accepted_at'] != null ? DateTime.parse(map['accepted_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      requestStatus: map['request_status'],
      friendPhone: map['phone']
    );
  }

  // Method to convert a FriendsModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'friend_id': friendId,
      'edited_name': editedName,
      'user_id': userId,
      'accepted_at': acceptedAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'request_status': requestStatus,
    };
  }

  @override
  String toString() {
    return 'FriendsModel{id: $id, createdAt: $createdAt, friendId: $friendId,friendPhone: $friendPhone ,editedName: $editedName, userId: $userId, acceptedAt: $acceptedAt, updatedAt: $updatedAt, requestStatus: $requestStatus}';
  }
}
