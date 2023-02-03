import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Models/Guichet_Model/creation_caisse_model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

class CaisseStateProvider extends ChangeNotifier {
  int userId = 1;

  List<CaisseModel> caisseData = [];

  addcaisse(
      {required BuildContext context,
      required CaisseModel caisseModel,
      required bool updatingData,
      required Function callback}) async {
    if (caisseModel.Nom_caisse.isEmpty ||
        caisseModel.utilisateur.isEmpty ||
        caisseModel.activite.isEmpty ||
        caisseModel.Telephone.isEmpty ||
        caisseModel.Virtuel_CDF.isEmpty ||
        caisseModel.Virtuel_USD.isEmpty) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    var response;
    // if (updatingData == false) {
    //   response = await Provider.of<AppStateProvider>(context, listen: false)
    //       .httpPost(url: BaseUrl.wayOfPayments, body: caisseModel.toJson());
    // } else {
    //   response = await Provider.of<AppStateProvider>(context, listen: false)
    //       .httpPut(url: BaseUrl.wayOfPayments, body: caisseModel.toJson());
    // }
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    if (response.body != "error") {
      CaisseModel caisseModelResponse =
          CaisseModel.fromJson(jsonDecode(response.body));
      if (updatingData == true) {
        caisseData.where((caisseModel) {
          return caisseModel.id! == caisseModelResponse.id;
        }).toList()[0] = caisseModelResponse;
      } else {
        caisseData.add(caisseModelResponse);
      }

      callback();
      Message.showToast(msg: 'Informations ajoutees avec succes');
    } else {
      Message.showToast(msg: 'Une erreur est survenue');
    }
    //calculateUserScore();
    notifyListeners();
  }
  //
  // String id = "2";
  //
  // getconstepargne(
  //     {required BuildContext context, required bool isRefreshed}) async {
  //   if (caisseData.isNotEmpty && isRefreshed == false) return;
  //   caisseData.clear();
  //   Provider.of<AppStateProvider>(context, listen: false).changeAppState();
  //   var response =
  //       await Provider.of<AppStateProvider>(context, listen: false).httpGet(
  //     url: BaseUrl.wayOfPayments,
  //   );
  //   Provider.of<AppStateProvider>(context, listen: false).changeAppState();
  //   if (response.body != "error") {
  //     List decoded = jsonDecode(response.body);
  //     if (decoded.isEmpty) {
  //       return Message.showToast(msg: 'Aucune donnée trouvée');
  //     }
  //     for (var data in decoded) {
  //       caisseData.add(CaisseModel.fromJson(data));
  //     }
  //     notifyListeners();
  //   } else {
  //     Message.showToast(
  //         msg: 'Impossible de recuperer les donnees des possession');
  //   }
  // }
}
