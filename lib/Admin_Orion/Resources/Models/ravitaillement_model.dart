import 'package:flutter/material.dart';

class TypegarantiModel {
  final String typegaranti;
  final int userId;

  TypegarantiModel({
    required this.typegaranti,
    required this.userId,
  });
  static fromJson(json) {
    return TypegarantiModel(typegaranti: json['typegaranti'],userId: int.parse(json['userId'].toString()));
  }

  toJson() {
    return {
      "typegaranti": typegaranti,
      "userId": userId.toString(),
    };
  }
}
