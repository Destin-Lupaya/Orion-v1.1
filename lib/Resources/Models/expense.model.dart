class ExpenseModel {
  final String type, details;
  double prix;
  final int? id;

  ExpenseModel(
      {this.id, required this.type, required this.details, required this.prix});

  static fromJson(json) {
    return ExpenseModel(
        id: int.parse(json['id'].toString()),
        type: json['type'],
        details: json['details'],
        prix: double.parse(json['prix'].toString()));
  }

  toJson() {
    return {
      "id": id,
      "type": type,
      "details": details,
      "prix": prix,
    };
  }
}
