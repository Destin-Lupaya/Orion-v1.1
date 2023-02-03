class StatementPositionModel {
  final String type, description, category;
  double montant;
  final String? startDate;
  final int? id;
  final int users_id;

  StatementPositionModel(
      {required this.type,
      required this.description,
      required this.montant,
      this.id,
      this.startDate,
      required this.users_id,
      required this.category});

  static fromJson(json) {
    return StatementPositionModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        users_id: int.parse(json['users_id'].toString()),
        type: json['type'],
        description: json['description'],
        category: json['category'],
        startDate: json['startDate'],
        montant: double.parse(json['montant'].toString()));
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "type": type.toString(),
      "description": description.toString(),
      "category": category.toString(),
      "montant": montant.toString().trim(),
      "startDate": startDate != null
          ? startDate.toString().trim()
          : DateTime.now().toString(),
      "users_id": users_id.toString().trim(),
    };
  }
}
