import 'package:flutter/material.dart';

class FraiscommissionModel {
  final int? id;
  final String designation;
  final String modeCalcule;
  final String value;
  final String sous_comptes_id;
  final String groupeFees;
  final int users_id;

  FraiscommissionModel({
    this.id,
    required this.designation,
    required this.modeCalcule,
    required this.value,
    required this.sous_comptes_id,
    required this.groupeFees,
    required this.users_id,
  });
  static fromJson(json) {
    return FraiscommissionModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        designation: json['designation'].toString().trim(),
        modeCalcule: json['modeCalcule'].toString().trim(),
        value: json['value'].toString().trim(),
        sous_comptes_id: json['sous_comptes_id'].toString().trim(),
        groupeFees: json['groupeFees'].toString().trim(),
        users_id: int.parse(json['users_id'].toString()));
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "designation": designation.toString().trim(),
      "modeCalcule": modeCalcule.toString().trim(),
      "value": value.toString().trim(),
      "sous_comptes_id": sous_comptes_id.toString().trim(),
      "groupeFees": groupeFees.toString().trim(),
      "users_id": users_id.toString(),
    };
  }
}
