import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Dashboard/Stats/stats.model.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class StatsDataProvider extends ChangeNotifier {
  List<StatModel> statsData = [];
  Map countStats = {
    "countCaution": 0,
    "countClient": 0,
    "countDemands": 0,
  };

  static List decodedData = [];
  getData({String? branchID}) async {
    // if (caisseData[caisseData.indexWhere(
    //         (account) => account.id!.toString().trim() == accountID.trim())] ==
    //     null) {
    //   return;
    // }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: "${BaseUrl.getStats}");
    var responseCount = await Provider.of<AppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.getCountStats);
    countStats = jsonDecode(responseCount.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map stats = {};
      var decoded = jsonDecode(response.body);
      decodedData = decoded.toList();
      // print(decoded.toList()[0]['cashIn'].firstWhere(
      //     (item) => (double.tryParse(item['amount'].toString()) ?? 0) > 0));
      // statsData=List<StatModel>.from(decoded.map((item)=>StatModel(title: parseDate(date: item['date'].toString()),value: double.tryParse(item['amount'].toString()))))
      notifyListeners();
      getWeeklyTransactions();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime.parse(startDate
          .add(Duration(days: i))
          .toString()
          .split(' ')[0]
          .toString()));
    }
    return days;
  }

  static String startDate = DateTime.now()
      .subtract(const Duration(days: 30))
      .toString()
      .split(' ')[0];
  List datesData = [
    {
      "date": '0000-00-00',
      'cashIn': 0,
      'cashOut': 0,
    }
  ];
  List dates = [
    {
      "date": '0000-00-00',
      'cashIn': 0,
      'cashOut': 0,
    }
  ];
  // = getDaysInBetween(DateTime.parse(startDate), DateTime.now())
  //     .map((e) => {
  //           "date": e.toString().substring(0, 10),
  //           'cashIn': decodedData[0]['cashIn'].toList().firstWhereOrNull(
  //                   (item) =>
  //                       item['date'].toString().substring(0, 10) ==
  //                       e.toString().substring(0, 10))?['amount'] ??
  //               0.001,
  //           'cashOut': 0
  //         })
  //     .toList();
  double maxAmount = 0;
  getWeeklyTransactions({bool? isRefresh = false}) async {
    if (decodedData.isNotEmpty) {
      dates = getDaysInBetween(DateTime.parse(startDate), DateTime.now())
          .map((e) => {
                "date": e.toString().substring(0, 10),
                'cashIn': decodedData[0]['cashIn'].toList().firstWhere(
                        (item) =>
                            item['date'].toString().substring(0, 10) ==
                            e.toString().substring(0, 10),
                        orElse: () => null)?['amount'] ??
                    0,
                'cashOut': decodedData[0]['cashOut'].toList().firstWhere(
                        (item) =>
                            item['date'].toString().substring(0, 10) ==
                            e.toString().substring(0, 10),
                        orElse: () => null)?['amount'] ??
                    0,
              })
          .toList();
      List data = [];
      data = List.from(dates);
      notifyListeners();
      double maxCashIn = 0, maxCashOut = 0;
      data.sort((prev, next) => double.parse(prev['cashIn'].toString())
          .compareTo(double.parse(next['cashIn'].toString())));
      maxCashIn = double.parse(data.last['cashIn'].toString());

      data.sort((prev, next) => double.parse(prev['cashOut'].toString())
          .compareTo(double.parse(next['cashOut'].toString())));
      maxCashOut = double.parse(data.last['cashOut'].toString());
      if (maxCashIn > maxCashOut) {
        maxAmount = maxCashIn;
      } else {
        maxAmount = maxCashOut;
      }
      // print(maxCashIn);
      // print(maxCashOut);
      notifyListeners();
    }
    // print(dates);
  }
}
