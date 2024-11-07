class FriendsProfileModel {
  final String id;
  final String friendId;
  final String userId;
  final String? editedName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final int requestStatus;
  final bool canSeeLocation;
  final String nameInContacts;
  final String? fcm;
  final String? phone;
  final bool isPremium;
  final bool isLocationEnabled;
  final double? latitude;
  final double? longitude;

  const FriendsProfileModel({
    required this.id,
    required this.friendId,
    required this.userId,
    this.editedName,
    required this.createdAt,
    required this.updatedAt,
    this.acceptedAt,
    required this.requestStatus,
    required this.canSeeLocation,
    required this.nameInContacts,
    this.fcm,
    this.phone,
    required this.isPremium,
    required this.isLocationEnabled,
    this.latitude,
    this.longitude,
  });

  // Factory constructor to create a FriendProfile instance from a map
  factory FriendsProfileModel.fromMap(Map<String, dynamic> map) {
    return FriendsProfileModel(
      id: map['id'] as String,
      friendId: map['friend_id'] as String,
      userId: map['user_id'] as String,
      editedName: map['edited_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.parse(map['updated_at'] as String),
      acceptedAt: map['accepted_at'] != null
          ? DateTime.parse(map['accepted_at'] as String)
          : null,
      requestStatus: map['request_status'] as int,
      canSeeLocation: map['can_see_location'] as bool,
      nameInContacts: map['name_in_contacts'] as String,
      fcm: map['fcm'] as String?,
      phone: map['phone'] as String?,
      isPremium: map['is_premium'] as bool? ?? false,
      isLocationEnabled: map['is_location_enabled'] as bool,
      latitude:
          map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
    );
  }

  // Converts a FriendProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'friend_id': friendId,
      'user_id': userId,
      'edited_name': editedName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'request_status': requestStatus,
      'can_see_location': canSeeLocation,
      'name_in_contacts': nameInContacts,
      'fcm': fcm,
      'phone': phone,
      'is_premium': isPremium,
      'is_location_enabled': isLocationEnabled,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  FriendsProfileModel copyWith({
    String? id,
    String? friendId,
    String? userId,
    String? editedName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    int? requestStatus,
    bool? canSeeLocation,
    String? nameInContacts,
    String? fcm,
    String? phone,
    bool? isPremium,
    bool? isLocationEnabled,
    double? latitude,
    double? longitude,
  }) {
    return FriendsProfileModel(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      userId: userId ?? this.userId,
      editedName: editedName ?? this.editedName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      requestStatus: requestStatus ?? this.requestStatus,
      canSeeLocation: canSeeLocation ?? this.canSeeLocation,
      nameInContacts: nameInContacts ?? this.nameInContacts,
      fcm: fcm ?? this.fcm,
      phone: phone ?? this.phone,
      isPremium: isPremium ?? this.isPremium,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
