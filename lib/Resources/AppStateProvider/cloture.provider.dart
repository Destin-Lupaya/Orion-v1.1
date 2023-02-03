import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class ClotureProvider extends ChangeNotifier {
  Map encloseBills = {};
  setEncloseBills(Map data) {
    encloseBills = data;
    notifyListeners();
  }

  List encloseDayData = [];

  closingDay({
    required Map body,
    required Function callback,
  }) async {
    // return print(body);
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.cloture, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      encloseDayData.add(decoded);
      // encloseDayData
      //     .where((enclose) =>
      // enclose['id'].toString().trim() ==
      //         decoded['id'].toString().trim())
      //     .toList()[0] = (decoded['demand']);
      // transactions.add(decoded['trans']['trans1']);
      notifyListeners();
      callback();
      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  addIncidents({
    required Map body,
    required Function callback,
  }) async {
    // return print(body);
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.incident, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // var decoded = jsonDecode(response.body);
      Message.showToast(msg: 'Incident enregistré');
      // encloseDayData
      //     .where((enclose) =>
      // enclose['id'].toString().trim() ==
      //         decoded['id'].toString().trim())
      //     .toList()[0] = (decoded['demand']);
      // transactions.add(decoded['trans']['trans1']);
      notifyListeners();
      callback();
      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  acceptEncloseDay({
    required Map encloseData,
    // required Map body,
    required Function callback,
  }) async {
    // return print(body);
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPut(
            url:
                "${BaseUrl.cloture}/${encloseData['cloture']['id'].toString()}",
            body: encloseData);
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      // print(response.body);
      // encloseDayData
      //     .where((enclose) =>
      //         enclose['id'].toString().trim() ==
      //         decoded['id'].toString().trim())
      //     .toList()[0] = (decoded['cloture']);
      // transactions.add(decoded['trans']['trans1']);
      notifyListeners();
      callback();
      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
      encloseBills.clear();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getEncloseData({bool? isRefresh = false}) async {
    if (isRefresh == false && encloseDayData.isNotEmpty) {
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.cloture);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print(response.body);
      encloseDayData = jsonDecode(response.body);
      encloseDayData = List.from(encloseDayData.reversed);
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
