import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Models/caution.model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class CautionProvider extends ChangeNotifier {
  List<CautionHistoryModel> dataList = [];
  saveData({
    required CautionHistoryModel body,
    required Function callback,
  }) async {
    // return print(body.toJson());
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.cautions, body: body.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: 'Caution enregistrée  avec succès...');
      if (decoded != null) {
        // dataList.insert(0, CautionHistoryModel.fromJson(decoded));
      }
      // refreshData();
      notifyListeners();
      callback();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: decoded is String
              ? decoded
              : 'Echec de connexion, veuillez réessayer');
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: decoded['message']?.toString().trim() ??
              'Une erreur est survenue');
    }
  }

  getData({bool? isRefresh = false}) async {
    if (isRefresh == false && dataList.isNotEmpty) {
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.externalClient);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      List data = jsonDecode(response.body);
      if (data.isEmpty) return;
      dataList = List<CautionHistoryModel>.from(
          data.map((e) => CautionHistoryModel.fromJson(e)));
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  refreshData() {
    dataList = List<CautionHistoryModel>.from(dataList);
    notifyListeners();
  }
}
