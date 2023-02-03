class ExternalClientModel {
  final String name, phone;
  String? email;
  int? id;
  double? caution, pointsClient;

  ExternalClientModel(
      {required this.name,
      required this.phone,
      this.email,
      this.id,
      this.caution,
      this.pointsClient});
  static fromJson(json) {
    return ExternalClientModel(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      id: json['id'],
      caution: double.tryParse(json['caution'].toString()) ?? 0,
      pointsClient: double.tryParse(json['pointsClient'].toString()) ?? 0,
    );
  }

  toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      if (id != null) "id": id,
    };
  }
}
