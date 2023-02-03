class DebtsModel {
  final String type, details;
  double prix;
  final int? id;

  DebtsModel(
      {required this.type, required this.details, required this.prix, this.id});

  static fromJson(json) {
    return DebtsModel(
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
