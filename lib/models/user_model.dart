class UserModel {
  final String id;
  final String name;
  final String phone;
  final String fcm;
  final bool? isPremium;
  final DateTime? subscriptionExpiryDate;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.fcm,
    this.isPremium,
    this.subscriptionExpiryDate,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'fcm': fcm,
      'is_premium': isPremium,
      'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] as String,
        name: map['name'] as String,
        phone: map['phone'] as String,
        fcm: map['fcm'] as String,
        isPremium: map['is_premium']?? false as bool?,
        subscriptionExpiryDate: map['subscription_expiry_date']);
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, phone: $phone, fcm: $fcm, isPremium: $isPremium, subscriptionExpiryDate: $subscriptionExpiryDate}';
  }
}
