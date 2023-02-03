import 'package:flutter/material.dart';

class CaisseModel {
  final int? id;
  final String Nom_caisse;
  final String utilisateur;
  final String activite;
  final String Telephone;
  final String Virtuel_CDF;
  final String Virtuel_USD;

  CaisseModel({
    this.id,
    required this.Nom_caisse,
    required this.utilisateur,
    required this.activite,
    required this.Telephone,
    required this.Virtuel_CDF,
    required this.Virtuel_USD,
  });
  static fromJson(json) {
    return CaisseModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        Nom_caisse: json['Nom_caisse'].toString().trim(),
        utilisateur: json['utilisateur'].toString().trim(),
        activite: json['activite'].toString().trim(),
        Telephone: json['Telephone'].toString().trim(),
        Virtuel_CDF: json['Virtuel_CDF'].toString().trim(),
        Virtuel_USD: json['Virtuel_USD'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "Nom_caisse": Nom_caisse.toString().trim(),
      "utilisateur": utilisateur.toString(),
      "activite": activite.toString().trim(),
      "Telephone": Telephone.toString().trim(),
      "Virtuel_CDF": Virtuel_CDF.toString().trim(),
      "Virtuel_USD": Virtuel_USD.toString().trim(),
    };
  }
}
