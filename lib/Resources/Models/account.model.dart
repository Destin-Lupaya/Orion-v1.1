import 'package:orion/Resources/Models/account_activities.model.dart';

class AccountModel {
  int users_id, branch_id;
  int? statusActive, id;
  double soldCashUsd,
      soldCashCdf,
      soldPretUsd,
      soldPretCdf,
      soldEmptuntCdf,
      soldEmpruntUsd;
  String? createdAt, userNames;
  List<AccountActivityModel> activities;

  AccountModel(
      {this.id,
      required this.users_id,
      required this.branch_id,
      required this.soldCashCdf,
      required this.soldCashUsd,
      required this.soldPretUsd,
      required this.soldPretCdf,
      required this.soldEmpruntUsd,
      required this.soldEmptuntCdf,
      this.statusActive,
      this.userNames,
      this.createdAt,
      this.activities = const []});
  static fromJSON(json) {
    return AccountModel(
        id: int.tryParse(json['id'].toString()) ?? 0,
        users_id: json['users_id'],
        branch_id: json['branch_id'],
        soldCashCdf: double.tryParse(json['sold_cash_cdf'].toString()) ?? 0,
        soldCashUsd: double.tryParse(json['sold_cash_usd'].toString()) ?? 0,
        soldPretUsd: double.tryParse(json['sold_pret_usd'].toString()) ?? 0,
        soldPretCdf: double.tryParse(json['sold_pret_cdf'].toString()) ?? 0,
        soldEmpruntUsd:
            double.tryParse(json['sold_emprunt_usd'].toString()) ?? 0,
        soldEmptuntCdf:
            double.tryParse(json['sold_emptunt_cdf'].toString()) ?? 0,
        userNames: json['names'],
        createdAt: json['created_at'],
        statusActive: int.tryParse(json['statusActive'].toString()) ?? 0,
        activities: json['activities'] != null
            ? json['activities'] is List<AccountActivityModel>
                ? json['activities']
                : List<AccountActivityModel>.from(json['activities']
                    .map((item) => AccountActivityModel.fromJSON(item)))
            : []);
  }

  toJSON() {
    return {
      "id": id,
      "users_id": users_id,
      "branch_id": branch_id,
      "sold_cash_usd": soldCashUsd,
      "sold_cash_cdf": soldCashCdf,
      "sold_pret_usd": soldPretUsd,
      "sold_pret_cdf": soldPretCdf,
      "sold_emprunt_usd": soldEmpruntUsd,
      "sold_emprunt_cdf": soldEmptuntCdf,
      'created_at': createdAt,
      'userNames': userNames,
      'statusActive': statusActive,
      "activities": activities.map((e) => e.toJSON()).toList()
    };
  }
}
