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
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'fcm': fcm,
      'is_location_enabled': isLocationEnabled,
      'is_premium': isPremium,
      'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
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
        subscriptionExpiryDate: map['subscription_expiry_date'],
        isLocationEnabled: map['is_location_enabled'] ?? false);
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, phone: $phone, fcm: $fcm, isPremium: $isPremium, latitude: $latitude, longitude: $longitude, subscriptionExpiryDate: $subscriptionExpiryDate}';
  }
}
