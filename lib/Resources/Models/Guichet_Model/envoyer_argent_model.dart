import 'package:flutter/material.dart';

class EnvoieModel {
  final int? id;
  final String Nom_beneficiaire;
  final String? commentaire;
  final String montant;
  final String password;
  final int users_id;

  EnvoieModel(
      {this.id,
      required this.Nom_beneficiaire,
      this.commentaire,
      required this.montant,
      required this.password,
      required this.users_id});
  static fromJson(json) {
    return EnvoieModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        users_id: int.parse(json['users_id'].toString()),
        Nom_beneficiaire: json['Nom_beneficiaire'].toString().trim(),
        commentaire: json['commentaire'].toString().trim(),
        password: json['password'].toString().trim(),
        montant: json['montant'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "users_id": users_id.toString(),
      "Nom_beneficiaire": Nom_beneficiaire.toString().trim(),
      "commentaire": commentaire.toString(),
      "montant": montant.toString().trim(),
      "password": password.toString().trim(),
    };
  }
}
