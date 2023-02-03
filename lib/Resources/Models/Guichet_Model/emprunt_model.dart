import 'package:flutter/material.dart';

class EmpruntModel {
  final int? id;
  final int users_id;
  final String nom_Expediteur;
  final String? commentaire;
  final String montant;
  final String password;

  EmpruntModel({
    this.id,
    required this.nom_Expediteur,
    this.commentaire,
    required this.montant,
    required this.password,
    required this.users_id,
  });
  static fromJson(json) {
    return EmpruntModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        users_id: int.parse(json['users_id'].toString()),
        nom_Expediteur: json['nom_Expediteur'].toString().trim(),
        commentaire: json['commentaire'].toString().trim(),
        montant: json['montant'].toString().trim(),
        password: json['password'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "users_id": users_id.toString(),
      "nom_Expediteur": nom_Expediteur.toString().trim(),
      "commentaire": commentaire.toString(),
      "montant": montant.toString().trim(),
      "password": password.toString().trim()
    };
  }
}
