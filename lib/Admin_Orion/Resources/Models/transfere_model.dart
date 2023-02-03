import 'package:flutter/material.dart';

class PlancomptableModel {
  final String classe;
  final String compte;
  final String souscompte;
  final int userId;

  PlancomptableModel({
    required this.classe,
    required this.compte,
    required this.souscompte,
    required this.userId,
  });
  static fromJson(json) {
    return PlancomptableModel(
        classe: json['classe'],
        compte: json['compte'],
        souscompte: json['souscompte'],
        userId: int.parse(json['userId'].toString()));
  }

  toJson() {
    return {
      "classe": classe,
      "compte": compte,
      "souscompte": souscompte,
      "userId": userId.toString(),
    };
  }
}
