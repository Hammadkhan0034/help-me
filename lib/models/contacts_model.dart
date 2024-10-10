class ContactsModel {
  final String? id;
  final String phone;
  final DateTime? addedAt;

  const ContactsModel({
    this.id,
    required this.phone,
    this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'added_at': addedAt?.toIso8601String(),
    };
  }

  // Factory constructor to create ContactsModel from a Map
  factory ContactsModel.fromMap(Map<String, dynamic> map) {
    return ContactsModel(
      id: map['id'],
      phone: map['phone'],
      addedAt: map['added_at'] != null ? DateTime.parse(map['added_at']) : null,
    );
  }

  @override
  String toString() {
    return 'ContactsModel{id: $id, phone: $phone, addedAt: $addedAt}';
  }
}
