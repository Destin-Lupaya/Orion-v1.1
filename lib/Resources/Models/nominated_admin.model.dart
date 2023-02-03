class NominatedPersonModel {
  final int? id;
  final String nom;
  final String relation;
  final String adresse, contact;
  final String? email;
  final String? birthDate;
  final String? bankAccountNumber, bankAccountName;
  NominatedPersonModel(
      {this.id,
      required this.nom,
      required this.relation,
      required this.adresse,
      required this.contact,
      required this.email,
      this.birthDate,
      this.bankAccountName,
      this.bankAccountNumber});

  static fromJson(json) {
    return NominatedPersonModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      nom: json['nom'].toString(),
      relation: json['relation'].toString(),
      adresse: json['adresse'],
      contact: json['contact'],
      email: json['email'],
      birthDate: json['birthDate'],
      bankAccountName: json['bankAccountName'],
      bankAccountNumber: json['bankAccountNumber'],
    );
  }

  toJson() {
    return {
      "id": id,
      "nom": nom,
      "relation": relation,
      "adresse": adresse,
      "contact": contact,
      "email": email,
      "birthDate": birthDate,
      "bankAccountName": bankAccountName,
      "bankAccountNumber": bankAccountNumber,
    };
  }
}
