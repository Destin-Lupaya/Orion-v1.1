import 'package:flutter/material.dart';

class RemboursCreditModel {
  final String date;
  final String fraispenalite;
  final String modepaiement;
  final String solde;
  final String compte;
  final String notification;

  RemboursCreditModel(
      {required this.date,
      required this.fraispenalite,
      required this.modepaiement,
      required this.solde,
      required this.compte,
      required this.notification});
  fromJson(json) {
    return RemboursCreditModel(
        date: json['date'],
        fraispenalite: json['fraispenalite'],
        modepaiement: json['modepaiement'],
        solde: json['solde'],
        compte: json['compte'],
        notification: json['notification']);
  }

  toJson() {
    return RemboursCreditModel(
        date: date,
        fraispenalite: fraispenalite,
        modepaiement: modepaiement,
        solde: solde,
        compte: compte,
        notification: notification);
  }
}
