import 'package:flutter/material.dart';

class ApprovisionnementModel {
  final int? id;
  final String nom_Expediteur;
  final String? commentaire;
  final String montant;
  final String password;

  ApprovisionnementModel({
    this.id,
    required this.nom_Expediteur,
    this.commentaire,
    required this.montant,
    required this.password,
  });
  static fromJson(json) {
    return ApprovisionnementModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        nom_Expediteur: json['nom_Expediteur'].toString().trim(),
        commentaire: json['commentaire'].toString().trim(),
        montant: json['montant'].toString().trim(),
        password: json['password'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "nom_Expediteur": nom_Expediteur.toString().trim(),
      "commentaire": commentaire.toString(),
      "montant": montant.toString().trim(),
      "password": password.toString().trim()
    };
  }
}
