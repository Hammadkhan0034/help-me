class PhoneNumberModel{
  final String name, phone;

  const PhoneNumberModel({
    required this.name,
    required this.phone,
  });

  
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumberModel &&
          runtimeType == other.runtimeType &&
          (phone == other.phone || phone.contains(other.phone) || other.phone.contains(phone));

  @override
  int get hashCode => phone.hashCode;
}