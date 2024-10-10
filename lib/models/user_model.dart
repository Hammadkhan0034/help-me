class UserModel {
  final String id;
  final String name;
  final String phone;
  final String fcm;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.fcm,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'fcm': fcm,
    };
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      fcm: map['fcm'] as String,
    );
  }
  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, phone: $phone, fcm: $fcm}';
  }
}
