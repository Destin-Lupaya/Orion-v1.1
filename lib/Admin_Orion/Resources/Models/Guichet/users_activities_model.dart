import 'package:flutter/material.dart';

class UsersActivitiesModel {
  final int? id;
  final String id_activities;
  final String designation;
  final String affected_by;

  UsersActivitiesModel({
    this.id,
    required this.id_activities,
    required this.designation,
    required this.affected_by,
  });
  static fromJson(json) {
    return UsersActivitiesModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        id_activities: json['id_activities'].toString().trim(),
        designation: json['designation'].toString().trim(),
        affected_by: json['affected_by'].toString().trim());
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "id_activities": id_activities.toString().trim(),
      "designation": designation.toString().trim(),
      "affected_by": affected_by.toString().trim(),
    };
  }
}
