class PersonalInfoModel {
  final int? userID;
  final String nom,
      postnom,
      prenom,
      dateNaissance,
      sexe,
      etatCivil,
      paysResidence,
      adresse;

  PersonalInfoModel(
      {this.userID,
      required this.nom,
      required this.postnom,
      required this.prenom,
      required this.dateNaissance,
      required this.sexe,
      required this.etatCivil,
      required this.paysResidence,
      required this.adresse});

  static fromJson(json) {
    return PersonalInfoModel(
      userID: int.parse(json['userID'].toString()),
      nom: json['nom'],
      postnom: json['postnom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      sexe: json['sexe'],
      etatCivil: json['etatCivil'],
      paysResidence: json['paysResidence'],
      adresse: json['adresse'],
    );
  }

  toJson() {
    return {
      "userID": userID,
      "nom": nom,
      "postnom": postnom,
      "prenom": prenom,
      "dateNaissance": dateNaissance,
      "sexe": sexe,
      "etatCivil": etatCivil,
      "paysResidence": paysResidence,
      "adresse": adresse,
    };
  }
}
