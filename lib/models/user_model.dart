class UserModel {
  final String id;
  final String name;
  final String phone;
  final String fcm;
  final bool? isPremium;

  final bool isLocationEnabled;
  final double? latitude;
  final double? longitude;
  final DateTime? subscriptionExpiryDate;
  final String? primaryIndoor, primaryOutdoor;
  UserModel({
    required this.isLocationEnabled,
    required this.id,
    required this.name,
    required this.phone,
    required this.fcm,
    this.latitude,
    this.longitude,
    this.isPremium,
    this.subscriptionExpiryDate,
    this.primaryIndoor,
    this.primaryOutdoor,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'fcm': fcm,
      'is_location_enabled': isLocationEnabled,
      'is_premium': isPremium,
      // 'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'primary_indoor': primaryIndoor,
      'primary_outdoor': primaryOutdoor,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] as String,
        name: map['name'] as String,
        phone: map['phone'] as String,
        fcm: map['fcm'] as String,
        isPremium: map['is_premium'] ?? false as bool?,
        latitude: map['latitude'],
        longitude: map['longitude'],
        subscriptionExpiryDate: map['subscription_expiry_date'] == null
            ? null
            : DateTime.parse(map['subscription_expiry_date']),
        primaryIndoor: map['primary_indoor'],
        primaryOutdoor: map['primary_outdoor'],
        isLocationEnabled: map['is_location_enabled'] ?? false);
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, phone: $phone, fcm: $fcm, isPremium: $isPremium, latitude: $latitude, longitude: $longitude, subscriptionExpiryDate: $subscriptionExpiryDate}';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? fcm,
    bool? isPremium,
    bool? isLocationEnabled,
    double? latitude,
    double? longitude,
    DateTime? subscriptionExpiryDate,
    String? primaryIndoor,
    String? primaryOutdoor,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      fcm: fcm ?? this.fcm,
      isPremium: isPremium ?? this.isPremium,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      subscriptionExpiryDate:
          subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      primaryIndoor: primaryIndoor ?? this.primaryIndoor,
      primaryOutdoor: primaryOutdoor ?? this.primaryOutdoor,
    );
  }
}
