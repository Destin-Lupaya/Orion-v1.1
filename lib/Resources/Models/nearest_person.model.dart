class NearestPersonModel {
  final int? id;
  final String nom;
  final String relation;
  final String adresse, contact, email;
  NearestPersonModel(
      {this.id,
      required this.nom,
      required this.relation,
      required this.adresse,
      required this.contact,
      required this.email});

  static fromJson(json) {
    return NearestPersonModel(
      id: int.parse(json['id'].toString()),
      nom: json['nom'].toString(),
      relation: json['relation'].toString(),
      adresse: json['adresse'],
      contact: json['contact'],
      email: json['email'],
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
    };
  }
}
