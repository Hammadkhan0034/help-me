class ContactsModel {

  final String name;

  final String number;

  ContactsModel({required this.name, required this.number});

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      name: json["name"],
      number: json["number"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "number": number,
    };
  }

  @override
  String toString() {
    return 'ContactsModel{name: $name, number: $number}';
  }

}
