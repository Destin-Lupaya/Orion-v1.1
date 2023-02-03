class CreditHistoryModel {
  final String institution, address, startDate, loanStatus;
  final double amount;
  final String? completedDate;
  final int? id;
  final int users_id;
  CreditHistoryModel(
      {required this.institution,
      required this.address,
      required this.startDate,
      this.completedDate,
      required this.loanStatus,
      required this.amount,
      this.id,
      required this.users_id});

  static fromJson(json) {
    return CreditHistoryModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      users_id: int.parse(json['users_id'].toString()),
      address: json['address'].toString(),
      institution: json['institution'].toString(),
      loanStatus: json['loanStatus'].toString(),
      startDate: json['startDate'].toString(),
      completedDate: json['completedDate'].toString(),
      amount: double.parse(json['amount'].toString()),
    );
  }

  toJson() {
    return {
      "address": address.toString(),
      "institution": institution.toString(),
      "loanStatus": loanStatus.toString(),
      "startDate": startDate.toString(),
      if (completedDate != '') "completedDate": completedDate.toString(),
      "amount": amount.toString(),
      "id": id.toString(),
      "users_id": users_id.toString()
    };
  }
}
