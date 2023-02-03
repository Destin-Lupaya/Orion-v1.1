import 'package:flutter/material.dart';

class MenuModel {
  final String title;
  final Widget page;
  final IconData icon;
  final String? action;
  MenuModel(
      {required this.title,
      required this.page,
      required this.icon,
      this.action});
  fromJson(json) {
    return MenuModel(
        title: json['title'],
        page: json['page'],
        icon: json['icon'],
        action: json['action']);
  }
}
