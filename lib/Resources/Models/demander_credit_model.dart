import 'package:flutter/material.dart';

class DemCreditModel {
  final String creditencours;
  final String moderemboursement;
  final String validationetsoumission;
  final String misajour;
  final String notification;

  DemCreditModel(
      {required this.creditencours,
      required this.moderemboursement,
      required this.validationetsoumission,
      required this.misajour,
      required this.notification});
  fromJson(json) {
    return DemCreditModel(
        creditencours: json['creditencours'],
        moderemboursement: json['moderemboursement'],
        validationetsoumission: json['validationetsoumission'],
        misajour: json['misajour'],
        notification: json['notification']);
  }

  toJson() {
    return DemCreditModel(
        creditencours: creditencours,
        moderemboursement: moderemboursement,
        validationetsoumission: validationetsoumission,
        misajour: misajour,
        notification: notification);
  }
}
