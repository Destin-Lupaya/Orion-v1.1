import 'package:flutter/material.dart';

class EtudedocModel {
  final String montant;
  final String echeance;
  final String client;
  final String encours;
  final String rejete;
  final String acceptee;

  EtudedocModel(
      {required this.montant,
      required this.echeance,
      required this.client,
      required this.encours,
      required this.rejete,
      required this.acceptee});
  fromJson(json) {
    return EtudedocModel(
        montant: json['montant'],
        echeance: json['echeance'],
        client: json['client'],
        encours: json['encours'],
        rejete: json['rejete'],
        acceptee: json['acceptee']);
  }

  toJson() {
    return EtudedocModel(
        montant: montant,
        echeance: echeance,
        client: client,
        encours: encours,
        rejete: rejete,
        acceptee: acceptee);
  }
}
