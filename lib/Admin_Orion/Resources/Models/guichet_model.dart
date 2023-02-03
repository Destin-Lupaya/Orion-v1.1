import 'package:flutter/material.dart';

class TauximpotModel {
  final String tauxpositif;
  final String tauxnegatif;
  final int userId;

  TauximpotModel({
    required this.tauxpositif,
    required this.tauxnegatif,
    required this.userId,
  });
  static fromJson(json) {
    return TauximpotModel(
        tauxpositif: json['tauxpositif'],
        tauxnegatif: json['tauxnegatif'],
        userId: int.parse(json['userId'].toString()));
  }

  toJson() {
    return {
      "tauxpositif": tauxpositif,
      "tauxnegatif": tauxnegatif,
      "userId": userId.toString(),
    };
  }
}
