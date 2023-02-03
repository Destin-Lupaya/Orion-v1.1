class LoanModel {
  final String name;
  final String description;
  final double taux;
  final double montantMin;
  final double montantMax;
  final String modeCalcul;

  LoanModel(
      {required this.name,
      required this.description,
      required this.taux,
      required this.montantMin,
      required this.montantMax,
      required this.modeCalcul});

  static fromJSON(json) {
    return LoanModel(
      name: json['designation'].toString(),
      description: json['description'].toString(),
      taux: double.parse(json['taux'].toString()),
      montantMin: double.parse(json['montantMin'].toString()),
      montantMax: double.parse(json['montantMax'].toString()),
      modeCalcul: json['modeCalcul'].toString(),
    );
  }

  toJson() {
    return {
      'name': name,
      'description': description,
      'taux': taux,
      'montantMin': montantMin,
      'montantMax': montantMax,
      'modeCalcul': modeCalcul
    };
  }
}
