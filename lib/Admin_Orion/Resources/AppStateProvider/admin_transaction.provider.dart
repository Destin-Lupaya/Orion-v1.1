import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class AdminTransactionProvider extends ChangeNotifier {
  List dataList = [], filteredData = [];
  getData({required bool isRefresh, String? accountID}) async {
    if (dataList
            .where((element) =>
                element['account_id'].toString().trim() == accountID)
            .toList()
            .isNotEmpty &&
        accountID != null &&
        isRefresh == false) {
      getFilteredData(accountID: accountID);
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.getPret);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body != null) {
        if (accountID == null) {
          dataList = jsonDecode(response.body);
        } else {
          dataList.addAll(jsonDecode(response.body));
        }
        getFilteredData(accountID: accountID);
        notifyListeners();
      } else {
        Message.showToast(msg: 'Error occured');
      }
      // print(dataList);
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getFilteredData({String? accountID}) {
    filteredData.clear();
    notifyListeners();
    if (accountID == null) {
      filteredData = List.from(dataList);
      notifyListeners();
      return;
    }
    filteredData = List.from(dataList
        .where(
            (element) => element['account_id'].toString().trim() == accountID)
        .toList());
    notifyListeners();
  }
}
