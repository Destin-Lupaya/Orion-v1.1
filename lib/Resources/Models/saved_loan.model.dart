import 'package:orion/Resources/Models/loan_model.dart';
import 'package:orion/Resources/Models/payback_calendar.model.dart';

class SavedLoanModel {
  final int? id;
  final LoanModel? loanTypeData;
  final int loan_types_id;
  final double amount;
  final String? refundMode;
  final String? status;
  final int duration;
  List<PaybackModel>? payback;
  List? feesPayment;

  SavedLoanModel(
      {this.id,
      this.refundMode,
      required this.loan_types_id,
      this.loanTypeData,
      required this.amount,
      required this.duration,
      this.status,
      this.payback,
      this.feesPayment});

  static fromJSON(json) {
    return SavedLoanModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      loan_types_id: int.parse(json['loan_types_id'].toString()),
      loanTypeData: json['loanData'] != null
          ? LoanModel.fromJSON(json['loanData'])
          : null,
      amount: double.parse(json['amount'].toString()),
      refundMode: json['refundMode'].toString(),
      status: json['status'] != null ? json['status'].toString() : "Initiated",
      duration: int.parse(json['duration'].toString()),
      payback: json['payback'] ?? [],
      feesPayment: json['feesPayment'] ?? [],
    );
  }

  toJson() {
    return {
      'id': id.toString().trim(),
      'loanData': loanTypeData,
      'loan_types_id': loan_types_id,
      'amount': amount.toString(),
      'refundMode': refundMode.toString(),
      'status': status.toString(),
      'duration': duration.toString(),
      'payback': payback,
      'feesPayment': feesPayment,
    };
  }
}
