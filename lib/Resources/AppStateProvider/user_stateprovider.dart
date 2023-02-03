import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Views/Home/home_page.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/caution.provider.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Models/client_model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/gestion_menu_airtel.dart';
import 'package:orion/Views/Home/home_page.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class UserStateProvider extends ChangeNotifier {
  double cashCDF = 250000;
  double cashUSD = 7500;
  double stockVirtuelCDF = 580000;
  double stockVirtuelUSD = 1890;
  int userId = 1;
  double singleStepValue = 10;

  List usersData = [];

  List providerData = [];
  List customerrData = [];

  calculateUserScore() {}

  ClientModel? clientData;

  initUserData({required BuildContext context, required bool isRefreshed}) {
    getUserData();
  }

  createNewUser(
      {required BuildContext context,
      required ClientModel clientModel,
      required Function callback}) async {
    if (clientModel.fname == null ||
        clientModel.lname == null ||
        clientModel.password == null) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    var response = await Provider.of<AppStateProvider>(context, listen: false)
        .httpPost(url: BaseUrl.addUser, body: clientModel.toJson());
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    if (response.body != "error") {
      if (response.body != null) {
        Message.showToast(msg: 'User created successfuly');
        clientData = ClientModel.fromJson(jsonDecode(response.body));

        Provider.of<AppStateProvider>(context, listen: false)
            .changeConnexionState(context: context);
        callback();
        notifyListeners();
      } else {
        Message.showToast(msg: 'Error occured');
      }
    } else {
      Message.showToast(msg: 'Error occured on the server');
    }
  }

  updateUser(
      {required Map client,
      BuildContext? context,
      required Function callback}) async {
    var response = await Provider.of<AppStateProvider>(navKey.currentContext!,
            listen: false)
        .httpPut(
            url: "${BaseUrl.addUser}/${client['id'].toString()}", body: client);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Message.showToast(msg: "Utilisateur modifié avec succès");
      clientData = ClientModel.fromJson(jsonDecode(response.body));
      // clients.add(ClientModel.fromJson(jsonDecode(response.body)));
      callback();
      notifyListeners();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  Map clientAccountData = {};

  loginUser(
      {required BuildContext context,
      required Map clientModel,
      required Function callback}) async {
    if (clientModel['email'].toString().isEmpty ||
        clientModel['psw'].toString().isEmpty) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }
    var response = await Provider.of<AppStateProvider>(context, listen: false)
        .httpPost(url: BaseUrl.getLogin, body: clientModel);
    // debugPrint(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body != null) {
        if (!jsonDecode(response.body)['user']['role']
            .toString()
            .toLowerCase()
            .contains('admin')) {
          if (jsonDecode(response.body)['account'].isEmpty) {
            Dialogs.showDialogNoAction(
                context: navKey.currentContext!,
                title: "Error",
                content: "Votre compte n'a aucune caisse");
            return;
          }
          clientAccountData = jsonDecode(response.body)['account'][0];
        }

        clientData = ClientModel.fromJson(jsonDecode(response.body)['user']);

        Provider.of<AppStateProvider>(context, listen: false)
            .changeConnexionState(context: context);
        Provider.of<MenuStateProvider>(context, listen: false).setDefault(
            pageData: {"name": "Activites", "page": GestionAirtelPage()});
        callback();
        prefs.setString("userData", response.body);
        getUserData(mustPush: true);
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

  logOut() {
    pickedFiles.clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .allUsers
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .accounts
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .activities
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .activitiesAccount
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .demands
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .factures
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .othersAccounts
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .transactions
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .accountActivity
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .targetedActivity
        .clear();
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .accountData
        .clear();
    Provider.of<ClotureProvider>(navKey.currentContext!, listen: false)
        .encloseBills
        .clear();
    Provider.of<ClotureProvider>(navKey.currentContext!, listen: false)
        .encloseDayData
        .clear();
    Provider.of<CautionProvider>(navKey.currentContext!, listen: false)
        .dataList
        .clear();
    notifyListeners();
  }

  List<PlatformFile> pickedFiles = [];

  addFiles(
      {required BuildContext context,
      required List<PlatformFile> picked,
      required Function callback}) async {
    if (picked.isEmpty) {
      return Message.showToast(msg: 'Veuillez choisir au moins un fichier');
    }
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    // var response = await Provider.of<AppStateProvider>(context, listen: false)
    //     .httpPost(
    //         url: Uri(host: "http://192.169.2.137/andema/user/add"),
    // await Future.delayed(const Duration(seconds: 2));
    //         body: personalInfo.toJson());
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    Message.showToast(msg: 'Informations ajoutees avec succes');
    picked.forEach((file) {
      pickedFiles.add(file);
    });
    // pickedFiles.add(picked);
    // print(creditHistoryData);
    callback();
    // if (response.statusCode == 200) {
    //   Message.showToast(msg: 'Informations ajoutees avec succes');
    // } else {
    //   Message.showToast(msg: 'Une erreur est survenue');
    // }
    calculateUserScore();
    notifyListeners();
  }

  getUserData({bool? mustPush = false}) {
    var isUserConnected = checkUserConnected();
    if (mustPush == true && isUserConnected != null) {
      if (clientData!.role.toLowerCase().contains('admin')) {
        Navigator.pushReplacement(navKey.currentContext!,
            CupertinoPageRoute(builder: (context) => AdminMainPage()));
      } else {
        Navigator.pushReplacement(navKey.currentContext!,
            CupertinoPageRoute(builder: (context) => HomePage()));
      }
    }
    // print(user);
    notifyListeners();
  }

  Widget? checkUserConnected() {
    var savedUser = prefs.getString('userData');
    Map user = savedUser != null ? jsonDecode(savedUser) : {};
    if (user.isEmpty) {
      Message.showToast(msg: "Nous n'avons trouvé aucun compte");
      return null;
    }
    if (!user['user']['role'].toString().toLowerCase().contains('admin')) {
      if (user['account'].isEmpty) {
        Dialogs.showDialogNoAction(
            context: navKey.currentContext!,
            title: "Error",
            content: "Votre compte n'a aucune caisse");
        return null;
      }
      clientAccountData = user['account'][0];
    }
    clientData = ClientModel.fromJson(user['user']);
    userId = clientData!.id!;
    if (clientData!.role.toLowerCase().contains('admin')) {
      return AdminMainPage();
    } else {
      return HomePage();
    }
  }
}
