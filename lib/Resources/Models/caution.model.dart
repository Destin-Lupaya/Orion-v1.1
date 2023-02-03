class CautionHistoryModel {
  final String external_clients_id, account_id, typeOperation;
  String? activity_id, currency, motif;
  double amount;
  int? id;

  CautionHistoryModel(
      {required this.external_clients_id,
      required this.account_id,
      required this.typeOperation,
      this.activity_id,
      required this.amount,
      this.currency,
      this.motif,
      this.id});

  static fromJson(json) {
    return CautionHistoryModel(
        external_clients_id: json['external_clients_id'],
        account_id: json['account_id'],
        typeOperation: json['type_operation'],
        amount: json['amount'],
        currency: json['currency'] ?? 'USD',
        motif: json['motif'] ?? 'R.A.S',
        activity_id: json['activity_id'],
        id: int.tryParse(json['id']));
  }

  toJson() {
    return {
      "external_clients_id": external_clients_id,
      "account_id": account_id,
      "type_operation": typeOperation,
      "amount": amount,
      "currency": currency ?? 'USD',
      "motif": motif ?? 'R.A.S',
      "activity_id": activity_id,
      "id": id
    };
  }
}
