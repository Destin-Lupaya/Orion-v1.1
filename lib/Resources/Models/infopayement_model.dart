import 'package:flutter/material.dart';

class InfopayModel {
  final String bankcard;
  final String ewallet;

  InfopayModel({required this.bankcard, required this.ewallet});
  fromJson(json) {
    return InfopayModel(bankcard: json['bankcard'], ewallet: json['ewallet']);
  }

  toJson() {
    return InfopayModel(bankcard: bankcard, ewallet: ewallet);
  }
}
