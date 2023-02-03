import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Models/account.model.dart';
import 'package:orion/Resources/Models/account_activities.model.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class AccountProvider extends ChangeNotifier {
  List<AccountModel> dataList = [];
  AccountModel? senderAccount, receiverAccount;

  getData(
      {bool? isRefresh = false,
      int? accountID,
      bool? isReceiver = false}) async {
    if ((isRefresh == false && dataList.isNotEmpty && accountID == null) ||
        (accountID != null &&
            dataList
                    .firstWhereOrNull((element) =>
                        element.id.toString() == accountID.toString())
                    ?.activities !=
                null &&
            dataList
                .firstWhereOrNull(
                    (element) => element.id.toString() == accountID.toString())!
                .activities
                .isNotEmpty)) {
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: "${BaseUrl.getAccount}/${accountID ?? ''}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (accountID != null) {
        Map decoded = jsonDecode(response.body);
        // print(decoded);
        dataList
                .firstWhereOrNull(
                    (element) => element.id.toString() == accountID.toString())
                // .toList()[0]
                ?.activities =
            List<AccountActivityModel>.from(decoded['activities']
                .map((item) => AccountActivityModel.fromJSON(item)));
        if (isReceiver == false) {
          senderAccount = dataList.firstWhereOrNull(
              (element) => element.id.toString() == accountID.toString());
        } else {
          receiverAccount = dataList.firstWhereOrNull(
              (element) => element.id.toString() == accountID.toString());
        }
        // print(senderAccount?.toJSON());
        notifyListeners();
        return;
      }
      List data = jsonDecode(response.body);
      // print(data);
      if (data.isEmpty) return;
      dataList =
          List<AccountModel>.from(data.map((e) => AccountModel.fromJSON(e)));
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }
}
