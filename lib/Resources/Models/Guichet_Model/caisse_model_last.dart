import 'package:flutter/material.dart';

class TypesdecreditModel {
  final int? id;
  final String designation;
  final int insterestRate;
  final String modeCalcule;
  final String description;
  final int users_id;
  final int minamount;
  final int maxamount;
  final int periode;
  final String decaissement_sous_comptes_id;
  final String payement_capitale_sous_comptes_id;
  final String payement_interest_sous_comptes_id;
  final String constitution_epargnes_id;

  TypesdecreditModel({
    this.id,
    required this.designation,
    required this.insterestRate,
    required this.modeCalcule,
    required this.description,
    required this.users_id,
    required this.minamount,
    required this.maxamount,
    required this.periode,
    required this.decaissement_sous_comptes_id,
    required this.payement_capitale_sous_comptes_id,
    required this.payement_interest_sous_comptes_id,
    required this.constitution_epargnes_id,
  });
  static fromJson(json) {
    return TypesdecreditModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        designation: json['designation'].toString().trim(),
        insterestRate: json['insterestRate'] != null
            ? int.parse(json['insterestRate'].toString())
            : 0,
        modeCalcule: json['modeCalcule'].toString().trim(),
        description: json['description'].toString().trim(),
        minamount: json['minamount'] != null
            ? int.parse(json['minamount'].toString())
            : 0,
        maxamount: json['maxamount'] != null
            ? int.parse(json['maxamount'].toString())
            : 0,
        periode:
            json['periode'] != null ? int.parse(json['periode'].toString()) : 0,
        decaissement_sous_comptes_id:
            json['decaissement_sous_comptes_id'].toString().trim(),
        payement_capitale_sous_comptes_id:
            json['payement_capitale_sous_comptes_id'].toString().trim(),
        payement_interest_sous_comptes_id:
            json['payement_interest_sous_comptes_id'].toString().trim(),
        constitution_epargnes_id:
            json['constitution_epargnes_id'].toString().trim(),
        users_id: int.parse(json['users_id'].toString()));
  }

  toJson() {
    return {
      "id": id.toString(),
      "designation": designation.toString().trim(),
      "insterestRate": insterestRate.toString(),
      "modeCalcule": modeCalcule.toString().trim(),
      "description": description.toString().trim(),
      "minamount": minamount.toString(),
      "maxamount": maxamount.toString(),
      "periode": periode.toString(),
      "decaissement_sous_comptes_id":
          decaissement_sous_comptes_id.toString().trim(),
      "payement_capitale_sous_comptes_id":
          payement_capitale_sous_comptes_id.toString().trim(),
      "payement_interest_sous_comptes_id":
          payement_interest_sous_comptes_id.toString().trim(),
      "constitution_epargnes_id": constitution_epargnes_id.toString().trim(),
      "users_id": users_id.toString()
    };
  }
}
