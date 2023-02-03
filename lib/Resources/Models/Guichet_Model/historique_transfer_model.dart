import 'package:flutter/material.dart';

class HistoriqueTransModel {
  final int? id;
  final int? users_id;
  final String date;
  final String demandeur;
  final double montant;
  final String type_transaction;
  final String devise;
  final String niveau_alerte;
  final String total;

  HistoriqueTransModel(
      {this.id,
      required this.niveau_alerte,
      required this.date,
      required this.montant,
      required this.type_transaction,
      required this.devise,
      required this.total,
      required this.demandeur,
      this.users_id});
  static fromJson(json) {
    return HistoriqueTransModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        users_id: int.parse(json['users_id'].toString()),
        date: json['date'].toString().trim(),
        demandeur: json['demandeur'].toString().trim(),
        montant: json['montant'] ?? [],
        type_transaction: json['type_transaction'].toString().trim(),
        devise: json['devise'].toString().trim(),
        total: json['total'].toString().trim(),
        niveau_alerte: json['niveau_alerte'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "users_id": users_id.toString(),
      "date": date.toString().trim(),
      "demandeur": demandeur.toString(),
      "montant": montant.toString().trim(),
      "type_transaction": type_transaction.toString(),
      "devise": devise.toString().trim(),
      "total": total.toString().trim(),
      "niveau_alerte": niveau_alerte.toString().trim(),
    };
  }
}
