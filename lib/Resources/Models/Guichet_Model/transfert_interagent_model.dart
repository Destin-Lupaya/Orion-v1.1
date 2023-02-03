import 'package:flutter/material.dart';

class TransferEntreAgentModel {
  final int? id;
  final String provenance;
  final String destination;
  final String montant;
  final String type_compte;
  final String datetime;

  TransferEntreAgentModel({
    this.id,
    required this.provenance,
    required this.destination,
    required this.montant,
    required this.type_compte,
    required this.datetime,
  });
  static fromJson(json) {
    return TransferEntreAgentModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        provenance: json['provenance'].toString().trim(),
        destination: json['destination'].toString().trim(),
        montant: json['montant'].toString().trim(),
        type_compte: json['type_compte'].toString().trim(),
        datetime: json['datetime'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString(),
      "provenance": provenance.toString().trim(),
      "destination": destination.toString().trim(),
      "montant": montant.toString().trim(),
      "type_compte": type_compte.toString(),
      "datetime": datetime.toString().trim(),
    };
  }
}
