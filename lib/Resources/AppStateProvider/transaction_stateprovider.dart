import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class TransactionsStateProvider extends ChangeNotifier {
  DateTime? lastActivitiesCheck;
  List accounts = [], // User account
      othersAccounts =
          [], //Other users accounts (cash solds) to make duplex transactions
      allUsers = [],
      activitiesAccount =
          [], //Other users accounts activities(virtual solds) to make duplex transactions
      activities = [],
      demands = [];

  Map accountActivity = {}, //User account activity which include virtual solds
      targetedActivity = {}, // Activitiy associated to the account activity
      accountData = {}, //User account which include cash solds
      otherAccountData = {};

  updateActiveActivity({required Map activity}) {
    accountActivity = {};
    accountActivity = activity;
    notifyListeners();
  }

  updateAccount({required Map account}) {
    accountData = {};
    accountData = account;
    notifyListeners();
  }

  setOthersAccountData({required Map data}) {
    otherAccountData = {};
    otherAccountData = data['account'];
    otherAccountData['activities'] = data['activities'];
    notifyListeners();
  }

  getAccount(
      {String? accountID,
      Function? callback,
      Function? errorCallback,
      String? activityID,
      bool isRefresh = false,
      bool? isReceiver = false}) async {
    String url = BaseUrl.getCaisse;
    if (accountID != null) {
      url = "${BaseUrl.getCaisse}/$accountID";
    }

    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: url);
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (accountID == null && isReceiver == false) {
        othersAccounts = jsonDecode(response.body);
      } else {
        // print('updating receiver account');
        // othersAccounts
        //     .where((account) => account['id'].toString() == accountID)
        //     .toList()[0] = jsonDecode(response.body)['account'];
        // notifyListeners();
        // print('new account in all');
        // print(othersAccounts
        //     .where((account) => account['id'].toString() == accountID)
        //     .toList()[0]);
        // print('returned account');
        // print(response.body);
        List userActivities = jsonDecode(response.body)['activities'];
        // othersAccounts
        //     .where((account) => account['id'].toString() == accountID)
        //     .toList()[0]['activities'] = userActivities;
        setOthersAccountData(data: jsonDecode(response.body));
        if (activityID != null &&
            userActivities
                .where((activity) =>
                    activity['activity_id'].toString() == activityID)
                .toList()
                .isNotEmpty) {
          callback!();
        } else {
          errorCallback!();
        }
        print('account updated');
      }
      notifyListeners();
    } else if (response.statusCode == 500) {
      errorCallback!();
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      errorCallback!();
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  updateSingleAccount(Map accountData, Map activityData) {
    // othersAccount
  }

  getUsers({bool isRefresh = false}) async {
    String url = BaseUrl.addUser;
    if (allUsers.isNotEmpty && isRefresh == false) {
      return;
    }
    // print(accountID);
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: url);
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      allUsers = jsonDecode(response.body);
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getActivities({String? activityID, bool? isRefresh}) async {
    String url = BaseUrl.getActivity;
    if (activityID != null) {
      url = "${BaseUrl.getActivity}/$activityID";
      if (activities
              .where(
                  (activity) => activity['id'].toString().trim() == activityID)
              .toList()
              .isNotEmpty &&
          (isRefresh == null || isRefresh == false)) {
        return;
      }
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      if (activityID == null) {
        activities = decoded;
        notifyListeners();
        return;
      }
      if (activities
          .where((activity) =>
              activity['id'].toString().trim() ==
              decoded['activity']['id'].toString().trim())
          .toList()
          .isNotEmpty) {
        activities
            .where((activity) =>
                activity['id'].toString().trim() ==
                decoded['activity']['id'].toString().trim())
            .toList()[0]['inputs'] = decoded['inputs'];
        targetedActivity = activities
            .where((activity) =>
                activity['id'].toString().trim() ==
                decoded['activity']['id'].toString().trim())
            .toList()[0];
        print('targeted activity set');
      }
      notifyListeners();
    } else if (response.statusCode == 408) {
      Message.showToast(msg: "Erreur de connexion veuillez réessayer");
    } else {
      Message.showToast(msg: "Une erreur est survenue, veuillez reessayer");
    }
  }

  getAccountActivities({String? accountID}) async {
    // print(activeActivity);
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(
            url:
                "${BaseUrl.getCaisse}/${Provider.of<UserStateProvider>(navKey.currentContext!, listen: false).clientAccountData['id'].toString()}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print(response.body);
      var decoded = jsonDecode(response.body);
      Map newAccount = decoded['account'];
      newAccount['activities'] = decoded['activities'];
      // print(newAccount);
      accounts.clear();
      accounts.add(newAccount);
      if (accountActivity.isNotEmpty) {
        updateAccount(account: accounts[0]);
        updateActiveActivity(
            activity: accounts[0]['activities'].firstWhere((activity) =>
                activity['id'].toString() == accountActivity['id'].toString()));
        // print(activeActivity);
      }
      lastActivitiesCheck = DateTime.now();
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getReceiverAccountActivities({required String accountID}) async {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: "${BaseUrl.getCaisse}/$accountID");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print(response.body);
      var decoded = jsonDecode(response.body);
      Map newAccount = decoded['account'];
      newAccount['activities'] = decoded['activities'];
      return newAccount;
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
      return null;
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
      return null;
    }
  }

  Map transactions = {};

  getTransactions({required String activityID, bool? isRefresh}) async {
    if (transactions.containsKey(activityID) &&
        transactions[activityID].isNotEmpty &&
        (isRefresh == null || isRefresh == false)) {
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: '${BaseUrl.getHistory}/{"activity_id":"$activityID"}');
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // if (!transactions.containsKey(activityID)) {
      transactions[activityID.toString()] = jsonDecode(response.body);
      transactions[activityID.toString()] =
          List.from(transactions[activityID.toString()].reversed);
      // print(transactions[activityID.toString()]);
      // }
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  setData() {
    if (accounts.isNotEmpty) {
      for (int i = 0; i < accounts.length; i++) {
        if (accounts[i]["activities"].isNotEmpty) {
          for (int j = 0; j < accounts[i]["activities"].length; j++) {
            accounts[i]["activities"][j]['activity'] = activities
                .where((activity) =>
                    activity['id'].toString().trim() ==
                    accounts[i]["activities"][j]['activity_id']
                        .toString()
                        .trim())
                .toList()[0];
          }
        }
      }
    }
    notifyListeners();
  }

  envoiVirtuel3check(
      {required Map body,
      required Function callback,
      Function? rollback}) async {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.getHistory, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      // print(decoded);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      if (transactions[body['activity']['activity_id'].toString()] != null) {
        transactions[body['activity']['activity_id'].toString()]
            .insert(0, body['trans']);
      } else {
        transactions[body['activity']['activity_id'].toString()] = [
          body['trans']
        ];
      }
      if (decoded['account'] != null) {
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['account']['id'].toString().trim())
            .toList()[0]['sold_cash_cdf'] = decoded['account']['sold_cash_cdf'];
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['account']['id'].toString().trim())
            .toList()[0]['sold_cash_usd'] = decoded['account']['sold_cash_usd'];
      }

      List accountActivities = accounts
          .where((account) =>
              account['id'].toString().trim() ==
              (decoded['account']?['id']?.toString().trim() ??
                  accountData['id'].toString().trim()))
          .toList()[0]['activities'];
      accountActivities
          .where((activity) =>
              activity['id'].toString().trim() ==
              decoded['activity']['id'].toString().trim())
          .toList()[0]['virtual_cdf'] = decoded['activity']['virtual_cdf'];
      accountActivities
          .where((activity) =>
              activity['id'].toString().trim() ==
              decoded['activity']['id'].toString().trim())
          .toList()[0]['virtual_usd'] = decoded['activity']['virtual_usd'];
      accounts
          .where((account) =>
              account['id'].toString().trim() ==
              (decoded['account']?['id']?.toString().trim() ??
                  accountData['id'].toString().trim()))
          .toList()[0]['activities'] = accountActivities;
      notifyListeners();
      callback();
      // Navigator.pop(navKey.currentContext!);

    } else if (response.statusCode == 500) {
      rollback != null ? rollback() : null;
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      rollback != null ? rollback() : null;
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  makeBill({required Map body, required Function callback}) async {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.facture, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      // print(decoded);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      // transactions[body['activity']['id']].add(body['trans']);

      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
      notifyListeners();
      callback();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  submitDemand({
    required Map body,
    required Function callback,
    required BuildContext context,
  }) async {
    // if (typeoperation == 'Depot') {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.getDemands, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      demands.insert(0, decoded);
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

  Map submittedSupply = {};

  submitSupplyRequest({
    required Map body,
    required Function callback,
    required BuildContext context,
  }) async {
    // if (typeoperation == 'Depot') {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.getDemands, body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      demands.insert(0, decoded);
      submittedSupply = decoded;
      notifyListeners();
      callback();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  demandResponse(
      {required Map body,
      required Function callback,
      bool? canUpdateAccount = false}) async {
    // return print(body);
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPut(
            url:
                "${BaseUrl.getDemands}/${body['demand']['id'].toString().trim()}",
            body: body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      demands
          .where((demand) =>
              demand['id'].toString().trim() ==
              decoded['demand']['id'].toString().trim())
          .toList()[0] = (decoded['demand']);
      // transactions.add(decoded['trans']['trans1']);
      notifyListeners();
      callback();
      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
      getAccountActivities();
      // if (canUpdateAccount == true) {
      //   print('updating account');
      //
      //   // getAccount(
      //   //     accountID: decoded['demand']['receiver_id'].toString(),
      //   //     callback: () {},
      //   //     errorCallback: () {});
      // }
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  billPayment({
    required Map body,
    required Map activityData,
    required Function callback,
  }) async {
    // if (typeoperation == 'Depot') {
    // return print('${BaseUrl.facture}/{"activity_id":"${activityData["activity_id"].toString().trim()}"}');
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPut(
            url:
                '${BaseUrl.facture}/{"activity_id":"${activityData["activity_id"].toString().trim()}"}',
            body: body);
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      getFactures(activityID: activityData['activity_id'].toString());
      notifyListeners();
      callback();
      // Navigator.pop(navKey.currentContext!);

    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  pretPayment({
    required Map body,
    required Map account,
    required Map activityData,
    required Function callback,
  }) async {
    // print(account);
    // print(activityData);
    //  print('${BaseUrl.getHistory}/{"activity_id":"${activityData["inputs"][0]["activity_id"].toString().trim()}"}');
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPut(
            url:
                '${BaseUrl.getHistory}/{"activity_id":"${activityData["inputs"][0]["activity_id"].toString().trim()}"}',
            body: body);

    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var accountResult = await Provider.of<AppStateProvider>(
              navKey.currentContext!,
              listen: false)
          .httpPut(
              url: "${BaseUrl.getCaisse}/${account['id'].toString()}}",
              body: account);
      if (accountResult.statusCode >= 200 && accountResult.statusCode < 300) {
        var decoded = jsonDecode(accountResult.body);
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['id'].toString().trim())
            .toList()[0]['sold_cash_cdf'] = decoded['sold_cash_cdf'];
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['id'].toString().trim())
            .toList()[0]['sold_cash_usd'] = decoded['sold_cash_usd'];
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['id'].toString().trim())
            .toList()[0]['sold_pret_cdf'] = decoded['sold_pret_cdf'];
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['id'].toString().trim())
            .toList()[0]['sold_pret_usd'] = decoded['sold_pret_usd'];
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['id'].toString().trim())
            .toList()[0]['sold_emprunt_cdf'] = decoded['sold_emprunt_cdf'];
        accounts
            .where((account) =>
                account['id'].toString().trim() ==
                decoded['id'].toString().trim())
            .toList()[0]['sold_emprunt_usd'] = decoded['sold_emprunt_usd'];
      }
      Message.showToast(
          msg: 'Votre transaction a été effectuée avec succès...');
      Navigator.pop(navKey.currentContext!);
      getTransactions(
          activityID: activityData["inputs"][0]["activity_id"].toString());
      notifyListeners();
      callback();
      // Navigator.pop(navKey.currentContext!);

    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getDemands({bool? isRefresh = false}) async {
    if (isRefresh == false && demands.isNotEmpty) {
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.getDemands);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print(response.body);
      demands = jsonDecode(response.body);
      demands = List.from(demands.reversed);
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  Map factures = {};

  getFactures({required String activityID, bool? isRefresh}) async {
    if (factures.containsKey(activityID) &&
        factures[activityID] != null &&
        (isRefresh == null || isRefresh == false)) {
      return;
    }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: '${BaseUrl.facture}/{"activity_id":"$activityID"}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // print(response.body);
      factures[activityID.toString()] = jsonDecode(response.body);
      factures[activityID.toString()] =
          List.from(factures[activityID.toString()].reversed);
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
