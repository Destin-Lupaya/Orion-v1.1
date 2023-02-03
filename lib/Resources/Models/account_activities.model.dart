import 'package:collection/collection.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class AccountActivityModel {
  int account_id, activity_id;
  double virtualUSD, virtualCDF, stock;
  String? createdAt, activityName;
  int? id;

  AccountActivityModel(
      {required this.account_id,
      required this.activity_id,
      required this.virtualUSD,
      required this.virtualCDF,
      required this.stock,
      this.createdAt,
      this.activityName,
      this.id});
  static fromJSON(json) {
    return AccountActivityModel(
        id: int.tryParse(json['id'].toString()),
        account_id: int.parse(json['account_id'].toString()),
        activity_id: int.parse(json['activity_id'].toString()),
        virtualUSD: double.tryParse(json['virtual_usd'].toString()) ?? 0,
        virtualCDF: double.tryParse(json['virtual_cdf'].toString()) ?? 0,
        stock: double.tryParse(json['stock'].toString()) ?? 0,
        createdAt: json['created_at'],
        activityName: navKey.currentContext!
            .read<TransactionsStateProvider>()
            .activities
            .firstWhereOrNull((element) =>
                element['id'].toString() ==
                json['activity_id'].toString())['name']);
  }

  toJSON() {
    return {
      "id": id,
      "account_id": account_id,
      "activity_id": activity_id,
      "virtualUSD": virtualUSD,
      "virtualCDF": virtualCDF,
      "stock": stock,
      'created_at': createdAt,
      'activityName': activityName,
    };
  }
}
