class PaybackModel {
  final int? id;
  int? loans_id;
  final String refundDate;
  final double amount, interestRate;
  final double? overDueFees;
  List? payment;

  PaybackModel(
      {this.id,
      this.loans_id,
      required this.refundDate,
      required this.amount,
      required this.interestRate,
      required this.overDueFees,
      this.payment});

  static fromJSON(json) {
    return PaybackModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        loans_id:
            json['id'] != null ? int.parse(json['loans_id'].toString()) : 0,
        refundDate: json['refundDate'].toString(),
        amount: double.parse(json['amount'].toString()),
        interestRate: double.parse(json['interestRate'].toString()),
        overDueFees: json['overDueFees'] != null
            ? double.parse(json['overDueFees'].toString())
            : 0,
        payment: json['payment'] ?? []);
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "loans_id": loans_id.toString().trim(),
      "refundDate": refundDate.toString().trim(),
      "amount": amount.toString(),
      "interestRate": interestRate.toString(),
      "overDueFees": overDueFees.toString(),
      if (payment!.isNotEmpty) "payment": payment
    };
  }
}
