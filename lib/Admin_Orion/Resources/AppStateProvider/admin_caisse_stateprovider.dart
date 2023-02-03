import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/account_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Models/account_activities.model.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class AdminCaisseStateProvider extends ChangeNotifier {
  List<CaisseModel> caisseData = [];

  initData() {
    caisseActivity.clear();
    caisseData.clear();
    branches.clear();
    // activities.clear();
  }

  addcaisse(
      {required BuildContext context,
      required CaisseModel caisseModel,
      required bool updatingData,
      required Function callback}) async {
    // return print(caisseModel.toJson());
    if (((caisseModel.solde_cash_CDF == 0 || caisseModel.solde_cash_USD == 0) &&
            caisseModel.stock == 0) &&
        Provider.of<AdminUserStateProvider>(context, listen: false)
                .clients
                .where((client) =>
                    client.id!.toString() == caisseModel.caissier.toString())
                .toList()[0]
                .role
                .toString()
                .toLowerCase() ==
            'comptable') {
      return Message.showToast(
          msg: 'Le comptable ne doit pas avoir des soldes nulls');
    }
    if (caisseActivity.isEmpty) {
      return Message.showToast(msg: 'Veuillez ajouter au moins une activite');
    }
    if (Provider.of<AdminUserStateProvider>(context, listen: false)
            .clients
            .where((client) =>
                client.id!.toString() == caisseModel.caissier.toString())
            .toList()[0]
            .role
            .toString()
            .toLowerCase() ==
        'comptable') {
      bool hasError = false;
      for (var activity in caisseActivity) {
        if ((double.parse(activity['virtual_usd'].toString().trim()) == 0 ||
                double.parse(activity['virtual_cdf'].toString().trim()) == 0) &&
            double.parse(activity['stock'].toString().trim()) == 0) {
          hasError = true;
        }
      }
      if (hasError == true) {
        Message.showToast(
            msg:
                'Le comtable ne doit pas avoir des soldes nulls. Verifiez le solde de certaines activités');
        return;
      }
    }
    // return;
    List accountActivity = [];
    for (int c = 0; c < caisseActivity.length; c++) {
      print('building account activity');
      caisseActivity[c].remove('name');
      accountActivity.add(caisseActivity[c]);
      print('account activity built');
    }
    print('sending to api');
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.getAccount, body: {
      "account": caisseModel.toJson(),
      "activities": accountActivity
    });
    print('data sent');
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('success response');
      caisseData.add(CaisseModel.fromJson(jsonDecode(response.body)[0]));
      print('adding to list');
      // saveCaisseActivity(
      //     caisse: CaisseModel.fromJson(jsonDecode(response.body)[0]),
      //     caisseActivity: caisseActivity);
      caisseActivity.clear();
      print('clearing activity');
      notifyListeners();
      print('updating data');
      callback();
      print('callback called');
      Dialogs.showDialogNoAction(
          context: navKey.currentContext!,
          title: "Success",
          content: "Caisse ajoutée avec succès");
      print('message displayed');
    } else if (response.statusCode == 500) {
      print('time out or error occured');
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      print('server error');
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  saveCaisseActivity(
      {required List caisseActivity, required CaisseModel caisse}) async {
    for (int c = 0; c < caisseActivity.length; c++) {
      caisseActivity[c].remove('name');
      caisseActivity[c]['account_id'] = caisse.id!.toString().trim();
    }
    notifyListeners();
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpPost(
            url: BaseUrl.getAccountActivity, body: {"data": (caisseActivity)});
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      caisseActivity.clear();

      Dialogs.showDialogNoAction(
          context: navKey.currentContext!,
          title: "Success",
          content: "Caisse ajoutée avec succès");
      // print("accounts : "+response.body);
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  updateCaisseActivity(
      {required AccountActivityModel caisseActivity,
      required Function callback}) async {
    if (caisseActivity.id == null) {
      Dialogs.showDialogNoAction(
          context: navKey.currentContext!,
          title: "Erreur",
          content:
              "Données invalides, nous ne pouvons pas modifier cette activité");
      return;
    }
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpPut(
            url: "${BaseUrl.getAccountActivity}/${caisseActivity.id}",
            body: caisseActivity.toJSON());
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      callback();
      Dialogs.showDialogNoAction(
          context: navKey.currentContext!,
          title: "Success",
          content: "Caisse modifiée avec succès");
      // print("accounts : "+response.body);
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  updateCaisse(
      {required CaisseModel caisse,
      BuildContext? context,
      required Function callback}) {
    if (caisse.solde_cash_CDF == null || caisse.solde_cash_USD == null
        //creationActiviteModel.telephone == null
        ) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }
    caisseData[caisseData.indexWhere(
        (element) => element.id!.toString() == caisse.id!.toString())] = caisse;
    callback();
    notifyListeners();
    print('caisse updated');
  }

  List caisseActivity = [];

  addCaisseActivity({required List caisses}) {
    for (int i = 0; i < caisses.length; i++) {
      if (caisseActivity
          .where((activity) =>
              activity['activity_id'].toString() ==
              caisses[i]['activity_id'].toString())
          .toList()
          .isEmpty) {
        caisseActivity.add(caisses[i]);
      }
    }

    notifyListeners();
  }

  clearCaisseActivity() {
    caisseActivity.clear();
    notifyListeners();
  }

  List branches = [];

  saveBranch(
      {required Map branch,
      bool? updatingData,
      required Function callback}) async {
    if (branch.keys
        .toList()
        .where((key) => branch[key].isEmpty || branch[key] == null)
        .toList()
        .isNotEmpty) {
      Message.showToast(msg: 'Veuillez remplir tous les champs');
      return;
    }
    Response response;
    if (updatingData != null && updatingData == true) {
      response = await Provider.of<adminAppStateProvider>(
              navKey.currentContext!,
              listen: false)
          .httpPut(
              url: "${BaseUrl.branch}/${branch['id'].toString()}",
              body: branch);
    } else {
      response = await Provider.of<adminAppStateProvider>(
              navKey.currentContext!,
              listen: false)
          .httpPost(url: BaseUrl.branch, body: branch);
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body != null) {
        if (updatingData != null && updatingData == true) {
          branches
              .where((branchData) =>
                  branchData['id'].toString() ==
                  jsonDecode(response.body)['id'].toString())
              .toList()[0] = jsonDecode(response.body);
        } else {
          branches.add(jsonDecode(response.body));
        }

        Dialogs.showDialogNoAction(
            context: navKey.currentContext!,
            title: "Success",
            content:
                "La branche a été ${updatingData != null && updatingData == true ? 'modifiée' : 'ajoutée'} avec succès");
        notifyListeners();
        Navigator.pop(navKey.currentContext!);
        callback();
      } else {
        Message.showToast(msg: 'Error occured');
      }
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  List accounts = [], activitiesAccount = [];

  getBranches({required bool isRefresh}) async {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.branch);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      branches.clear();
      if (response.body != null) {
        branches = jsonDecode(response.body);
        notifyListeners();
      } else {
        Message.showToast(msg: 'Error occured');
      }
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getAccount() async {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.getAccount);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      caisseData.clear();
      var decoded = jsonDecode(response.body);
      for (int i = 0; i < decoded.length; i++) {
        caisseData.add(CaisseModel.fromJson(decoded[i]));
      }
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  getAccountActivities({required String accountID}) async {
    // if (caisseData[caisseData.indexWhere(
    //         (account) => account.id!.toString().trim() == accountID.trim())] ==
    //     null) {
    //   return;
    // }
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpGet(url: "${BaseUrl.getAccount}/$accountID");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);

      caisseData[caisseData.indexWhere((account) =>
              account.id!.toString().trim() ==
              decoded['account']['id'].toString().trim())]
          .activities = decoded['activities'];
      setData();
      // print("account activity : "+response.body);
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
    if (caisseData.isNotEmpty) {
      for (int i = 0; i < caisseData.length; i++) {
        if (caisseData[i].activities.isNotEmpty) {
          for (int j = 0; j < caisseData[i].activities.length; j++) {
            caisseData[i].activities[j]['activity'] =
                Provider.of<AdminUserStateProvider>(navKey.currentContext!,
                        listen: false)
                    .activitiesdata
                    .where((activity) =>
                        activity.id!.toString().trim() ==
                        caisseData[i]
                            .activities[j]['activity_id']
                            .toString()
                            .trim())
                    .toList()[0]
                    .toJson();
          }
        }
      }
    }
    // print(accounts);
    notifyListeners();
  }
}
