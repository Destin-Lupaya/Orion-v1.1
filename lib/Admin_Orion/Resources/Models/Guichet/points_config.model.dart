class PointConfigModel {
  int? id;
  String name;
  double toUSD, toCDF;
  double? value;
  PointConfigModel(
      {this.id,
      required this.name,
      this.value,
      required this.toUSD,
      required this.toCDF});
  static fromJSON(json) {
    return PointConfigModel(
        id: int.tryParse(json['id'].toString()),
        name: json['name'],
        toUSD: double.tryParse(json['to_usd'].toString()) ?? 0,
        toCDF: double.tryParse(json['to_cdf'].toString()) ?? 0,
        value: double.tryParse(json['value'].toString()) ?? 1);
  }

  toJSON() {
    return {
      "value": value?.toString() ?? '1',
      "name": name.toString().trim(),
      'to_usd': toUSD.toString().trim(),
      'to_cdf': toCDF.toString().trim(),
    };
  }
}
