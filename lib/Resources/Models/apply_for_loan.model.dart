import 'dart:convert';

class ApplyForLoanModel {
  final int? id;
  final double loanAmount, loanPaymentDuration;
  final List<Map<String, dynamic>> paybackCalendar;
  final List? associatedFiles;
  final int userId;

  ApplyForLoanModel(
      {this.id,
      required this.loanAmount,
      required this.loanPaymentDuration,
      required this.paybackCalendar,
      required this.associatedFiles,
      required this.userId});
  static fromJson(json) {
    return ApplyForLoanModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        loanAmount: double.parse(json['loanAmount'].toString()),
        loanPaymentDuration: double.parse(json['loanPaymentDuration']),
        paybackCalendar: json['paybackCalendar'],
        associatedFiles: json['associatedFiles'],
        userId: int.parse(json['userId'].toString()));
  }

  toJson() {
    return {
      id: id.toString(),
      loanAmount: loanAmount.toString(),
      loanPaymentDuration: loanPaymentDuration.toString(),
      paybackCalendar: jsonEncode(paybackCalendar),
      associatedFiles: jsonEncode(associatedFiles),
      userId: userId.toString()
    };
  }
}
