import 'package:flutter/material.dart';

class TypeuserModel {
  final String userbackoffice;
  final String userclient;
  final int userId;

  TypeuserModel({
    required this.userbackoffice,
    required this.userclient,
    required this.userId,
  });

  static fromJson(json) {
    return TypeuserModel(
        userbackoffice: json['userbackoffice'],
        userclient: json['userclient'],
        userId: int.parse(json['userId'].toString()));
  }

  toJson() {
    return {
      "userbackoffice": userbackoffice.toString(),
      "userclient": userclient.toString(),
      "userId": userId.toString()
    };
  }
}
