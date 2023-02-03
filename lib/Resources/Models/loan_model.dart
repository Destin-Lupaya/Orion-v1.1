class LoanModel {
  final int? id;
  final String designation;
  final String description;
  final double insterestRate;
  final double minamount;
  final double maxamount;
  final String modeCalcule;
  final String? overDueFees;
  List? fees;

  LoanModel(
      {this.id,
      required this.designation,
      required this.description,
      required this.insterestRate,
      required this.minamount,
      required this.maxamount,
      required this.modeCalcule,
      this.overDueFees,
      this.fees});

  static fromJSON(json) {
    return LoanModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      designation: json['designation'].toString(),
      description: json['description'].toString(),
      insterestRate: double.parse(json['insterestRate'].toString()),
      minamount: double.parse(json['minamount'].toString()),
      maxamount: double.parse(json['maxamount'].toString()),
      modeCalcule: json['modeCalcule'].toString(),
      overDueFees: json['overDueFees'],
      fees: json['fees'],
    );
  }

  toJson() {
    return {
      'id': id.toString(),
      'designation': designation,
      'description': description,
      'insterestRate': insterestRate,
      'minamount': minamount.toString(),
      'maxamount': maxamount.toString(),
      'modeCalcule': modeCalcule,
      'overDueFees': overDueFees.toString(),
      'fees': fees
    };
  }
}
