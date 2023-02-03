import 'package:flutter/material.dart';

class HistoriqueModel {
  final int? id;
  final String designation;
  final String caissier;
  final String description;
  final String? type_activite;
  final String solde_virtuel_CDF;
  final String solde_virtuel_USD;
  final String solde_cash_CDF;
  final String solde_cash_USD;
  final String? telephone;

  HistoriqueModel({
    this.id,
    this.telephone,
    required this.designation,
    required this.caissier,
    required this.description,
    this.type_activite,
    required this.solde_virtuel_CDF,
    required this.solde_virtuel_USD,
    required this.solde_cash_CDF,
    required this.solde_cash_USD,
  });
  static fromJson(json) {
    return HistoriqueModel(
        designation: json['designation'].toString().trim(),
        description: json['description'].toString().trim(),
        caissier: json['caissier'].toString().trim(),
        telephone: json['telephone'].toString().trim(),
        type_activite: json['type_activite'].toString().trim(),
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        solde_virtuel_CDF: json['solde_virtuel_CDF'].toString().trim(),
        solde_virtuel_USD: json['solde_virtuel_USD'].toString().trim(),
        solde_cash_CDF: json['solde_cash_CDF'].toString().trim(),
        solde_cash_USD: json['solde_cash_USD'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "designation": designation.toString().trim(),
      "caissier": caissier.toString().trim(),
      "description": description.toString().trim(),
      "telephone": telephone.toString().trim(),
      "type_activite": type_activite.toString(),
      "solde_virtuel_CDF": solde_virtuel_CDF.toString(),
      "solde_virtuel_USD": solde_virtuel_USD.toString(),
      "solde_cash_CDF": solde_cash_CDF.toString(),
      "solde_cash_USD": solde_cash_USD.toString(),
    };
  }
}
