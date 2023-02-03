class CreatActiviteModel {
  final int? id;
  final String designation;
  final String description;
  final String? avatar, web_visibility;
  final String? cashIn;
  final String? cashOut;
  final int? users_id;
  double? points;
  List? inputs;
  int? hasStock = 0, hasNegativeSold = 0, active;
  CreatActiviteModel(
      {this.id,
      required this.designation,
      required this.description,
      this.avatar,
      this.web_visibility,
      this.cashIn,
      this.cashOut,
      this.users_id,
      this.inputs,
      this.hasStock,
      this.hasNegativeSold,
      this.points = 0,
      this.active});
  static fromJson(json) {
    return CreatActiviteModel(
        designation: json['name'].toString().trim(),
        description: json['description'].toString().trim(),
        web_visibility: json['web_visibility'].toString().trim(),
        avatar: json['avatar'].toString().trim(),
        cashIn: json['cashIn'],
        cashOut: json['cashOut'],
        inputs: json['inputs'],
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        hasStock: json['hasStock'] ?? 0,
        hasNegativeSold: json['hasNegativeSold'] ?? 0,
        points: double.tryParse(json['points'].toString()) ?? 0,
        users_id: json['users_id'] != null
            ? int.parse(json['users_id'].toString())
            : 0,
        active: json['statusActive'] ?? 0);
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "users_id": users_id.toString().trim(),
      "name": designation.toString().trim(),
      "description": description.toString().trim(),
      "web_visibility": web_visibility.toString().trim(),
      "avatar": avatar.toString(),
      "inputs": inputs,
      "hasStock": hasStock,
      "hasNegativeSold": hasNegativeSold,
      "points": points,
      if (cashIn != null) "cashIn": cashIn.toString(),
      if (cashOut != null) "cashOut": cashOut.toString(),
    };
  }
}
