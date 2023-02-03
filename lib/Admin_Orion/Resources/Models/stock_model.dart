import 'package:flutter/material.dart';

class SouscompteModel {
  final String id;
  final String number;
  final String name;
  final String reference;
  final String nodes;
  final String compteid;
  final String userId;
  SouscompteModel(
      {required this.id,
      required this.number,
      required this.name,
      required this.reference,
      required this.nodes,
      required this.compteid,
      required this.userId});
  static fromJson(json) {
    return SouscompteModel(
        id: json['id'],
        number: json['number'],
        name: json['name'],
        reference: json['reference'],
        nodes: json['nodes'],
        compteid: json['compteid'],
        userId: json['userId']);
  }

  toJson() {
    return {
      "id": id,
      "number": number,
      "name": name,
      "reference": reference,
      "nodes": nodes,
      "compteid": compteid,
      "userId": userId,
    };
  }
}
