class PointModel {
  final int? id;
  final String client_number;
  final double points, points_consomes;
  final String? created_at;
  PointModel(
      {this.id,
      required this.client_number,
      required this.points,
      required this.points_consomes,
      this.created_at});
  static fromJson(json) {
    return PointModel(
      client_number: json['client_number'].toString().trim(),
      points_consomes:
          double.tryParse(json['points_consomes'].toString().trim()) ?? 0,
      points: double.tryParse(json['points'].toString().trim()) ?? 0,
      created_at: json['created_at'],
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
    );
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "client_number": client_number.toString().trim(),
      "points": points.toString().trim(),
      "points_consomes": points_consomes.toString().trim(),
      "created_at": created_at ?? DateTime.now(),
    };
  }
}
