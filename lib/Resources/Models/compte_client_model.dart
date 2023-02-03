import 'package:flutter/material.dart';

class CompteModel {
  final String id;
  final String names;
  final String contacts;
  final String adressmail;
  final String numtelephone;
  final String motdpass;

  CompteModel(
      {required this.id,
      required this.names,
      required this.contacts,
      required this.adressmail,
      required this.numtelephone,
      required this.motdpass});
  fromJson(json) {
    return CompteModel(
        id: json['id'],
        names: json['names'],
        contacts: json['contacts'],
        adressmail: json['adressmail'],
        numtelephone: json['numtelephone'],
        motdpass: json['motdpass']);
  }

  toJson() {
    return {
      id: id,
      names: names,
      contacts: contacts,
      adressmail: adressmail,
      numtelephone: numtelephone,
      motdpass: motdpass
    };
  }
}
