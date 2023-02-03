import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/point.model.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/points_config.model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class PointsConfigProvider extends ChangeNotifier {
  List<PointConfigModel> dataList = [];

  saveData(
      {required PointConfigModel data,
      EnumActions? action = EnumActions.Save}) async {
    if (data.name.isEmpty || data.toUSD.isNaN || data.toCDF.isNaN) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }
    Response response;
    if (action == EnumActions.Save) {
      response = await Provider.of<adminAppStateProvider>(
              navKey.currentContext!,
              listen: false)
          .httpPost(url: BaseUrl.addPointConfig, body: data.toJSON());
    } else {
      response = await Provider.of<adminAppStateProvider>(
              navKey.currentContext!,
              listen: false)
          .httpPut(
              url: "${BaseUrl.addPointConfig}/${data.id}", body: data.toJSON());
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      dataList.insert(0, PointConfigModel.fromJSON(response.body));
      Message.showToast(msg: "Enregistrement effectué avec succès");
      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getData({bool? isRefresh = false}) async {
    if (dataList.isNotEmpty && isRefresh == false) {
      return;
    }
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.getPointConfig);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      dataList = List<PointConfigModel>.from(
          decoded.map((e) => PointConfigModel.fromJSON(e)));
      // print(dataList);
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  PointModel? clientPoints;
  getClientPoints({required String clientID}) async {
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpGet(url: "${BaseUrl.getClientPoint}/$clientID");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      if (decoded.isEmpty) return;
      clientPoints = PointModel.fromJson(decoded);
      if (clientPoints == null) return;
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  double calculateClientPoint(
      {required PointModel clientPoint,
      required String devise,
      String? action = 'in'}) {
    PointConfigModel? pointConfig = dataList
        .firstWhereOrNull((item) => item.name.toLowerCase().contains('point'));
    if (pointConfig == null) return 0;
    double pointCash = 0;
    if (devise.toLowerCase() == 'cdf') {
      pointCash = (clientPoints?.points ?? 0) * (pointConfig.toCDF);
    }
    if (devise.toLowerCase() == 'usd') {
      pointCash = (clientPoints?.points ?? 0) * (pointConfig.toUSD);
    }
    return pointCash;
  }

  double calculateClientPointAmount(
      {required double amount, required String devise}) {
    // print(dataList);
    PointConfigModel? pointConfig = dataList
        .firstWhereOrNull((item) => item.name.toLowerCase().contains('point'));
    // print(pointConfig?.toJSON());
    if (pointConfig == null) return 0;
    double pointCash = 0;
    if (devise.toLowerCase() == 'cdf') {
      pointCash = amount / (pointConfig.toCDF);
      return pointCash;
    }
    if (devise.toLowerCase() == 'usd') {
      pointCash = amount / (pointConfig.toUSD);
      return pointCash;
    }
    return 0;
  }
}
