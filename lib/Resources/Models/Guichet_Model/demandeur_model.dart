import 'package:flutter/material.dart';

class DemandeurModel {
  final int? id;
  final int? users_id;
  final String alert;
  final String montant;
  final String? commentaire;
  final String request_id;
  final String customer;
  final String numero;
  final String status;
  final String amount_served;
  final String fournisseur;

  DemandeurModel(
      {this.id,
      required this.alert,
      this.commentaire,
      required this.montant,
      required this.request_id,
      required this.customer,
      required this.numero,
      required this.status,
      required this.amount_served,
      required this.fournisseur,
      this.users_id});
  static fromJson(json) {
    return DemandeurModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        users_id: int.parse(json['users_id'].toString()),
        alert: json['alert'].toString().trim(),
        commentaire: json['commentaire'].toString().trim(),
        montant: json['montant'].toString().trim(),
        request_id: json['request_id'].toString().trim(),
        customer: json['customer'].toString().trim(),
        numero: json['numero'].toString().trim(),
        status: json['status'].toString().trim(),
        amount_served: json['amount_served'].toString().trim(),
        fournisseur: json['fournisseur'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "users_id": users_id.toString(),
      "alert": alert.toString().trim(),
      "commentaire": commentaire.toString(),
      "montant": montant.toString().trim(),
      "request_id": request_id.toString(),
      "customer": alert.toString().trim(),
      "numero": numero.toString().trim(),
      "amount_served": montant.toString().trim(),
      "fournisseur": request_id.toString()
    };
  }
}
