import 'package:flutter/material.dart';

class MenuModel {
  final String title;
  final Widget page;
  final IconData icon;
  MenuModel({required this.title, required this.page, required this.icon});
  fromJson(json) {
    return MenuModel(
        title: json['title'], page: json['page'], icon: json['icon']);
  }

  toJson() {
    return MenuModel(title: title, page: page, icon: icon);
  }
}
