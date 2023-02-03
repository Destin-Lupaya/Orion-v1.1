class LoanModel {
  final int? id;
  final String name;
  final String description;
  final double taux;
  final double montantMin;
  final double montantMax;
  final String modeCalcul;
  final String? overDueFees;

  LoanModel(
      {this.id,
      required this.name,
      required this.description,
      required this.taux,
      required this.montantMin,
      required this.montantMax,
      required this.modeCalcul,
      this.overDueFees});

  static fromJSON(json) {
    return LoanModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      name: json['designation'].toString(),
      description: json['description'].toString(),
      taux: double.parse(json['taux'].toString()),
      montantMin: double.parse(json['montantMin'].toString()),
      montantMax: double.parse(json['montantMax'].toString()),
      modeCalcul: json['modeCalcul'].toString(),
      overDueFees: json['overDueFees'],
    );
  }

  toJson() {
    return {
      'name': name,
      'description': description,
      'taux': taux,
      'montantMin': montantMin,
      'montantMax': montantMax,
      'modeCalcul': modeCalcul,
      'overDueFees': overDueFees
    };
  }
}
