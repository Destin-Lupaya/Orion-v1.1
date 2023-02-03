import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/Models/menu_model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Views/Config/Settings/settings_form.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/gestion_menu_airtel.dart';
import 'package:orion/Views/Home/main_page.dart';
import 'package:orion/Views/Login/login_page.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class AppStateProvider extends ChangeNotifier {
  bool isAsync = false;
  bool isConnected = false;
  changeAppState() {
    isAsync = !isAsync;
    // print('changing state');
    notifyListeners();
  }

  initUI({required BuildContext context}) {
    if (prefs.getString('userData') != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        changeConnexionState(context: context);
        Provider.of<MenuStateProvider>(context, listen: false).setDefault(
            pageData: {"name": "Activites", "page": GestionAirtelPage()});
      });
    }
  }

  changeConnexionState({required BuildContext context}) {
    Provider.of<MenuStateProvider>(context, listen: false).addMenu(menus: [
      // MenuModel(
      //     title: 'Acceuil', icon: Icons.dashboard, page: AcceuilOrionPage()),

      MenuModel(
          title: 'Activites', page: GestionAirtelPage(), icon: Icons.person),
      MenuModel(
          title: 'Profil', page: const SettingPage(), icon: Icons.settings),
      // MenuModel(
      //     title: 'Mes credits',
      //     page: const ProfilePage(),
      //     icon: Icons.credit_card)
    ]);
    Provider.of<MenuStateProvider>(context, listen: false).removeMenu(
        menus: MenuModel(
            title: 'Client', page: const LoginPage(), icon: Icons.login));
    Provider.of<MenuStateProvider>(context, listen: false).removeMenu(
        menus: MenuModel(
            title: 'Administration',
            page: const MainPage(),
            icon: Icons.login));
    isConnected = !isConnected;
    notifyListeners();
  }

  Set<String> phonenumbers = Set();
  setPhonenumber() {
    for (int i = 0; i < membreInscrit.length; i++) {
      phonenumbers.add(membreInscrit[i]['phone number'].toString());
    }
    notifyListeners();
  }

  List membreInscrit = [];
  fetchMembreInscrit({required BuildContext context}) async {
    if (membreInscrit.isNotEmpty) return;
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    var response = await Provider.of<AppStateProvider>(context, listen: false)
        .httpGet(url: BaseUrl.addUser);
    Provider.of<AppStateProvider>(context, listen: false).changeAppState();
    if (response.body != "error") {
      var decoded = jsonDecode(response.body);
      membreInscrit = decoded;
      Message.showToast(msg: 'Chargement numero des membres terminés');
      notifyListeners();
      setPhonenumber();
    } else {
      print(response.statusCode);
      Message.showToast(msg: 'Error occured, try again later');
    }
  }

  Future<Response> httpPost({required String url, required Map body}) async {
    print("post $body");
    try {
      // print('changing state');
      changeAppState();
      Response response = await http
          .post(Uri.parse(url), body: jsonEncode(body), headers: headers)
          .timeout(Duration(seconds: 30));
      print(response.statusCode);
      debugPrint("post" + response.body + "post");
      changeAppState();
      // print('changing state');
      return response;
    } on TimeoutException catch (e) {
      changeAppState();
      print('Timeout');
      return Response(jsonEncode("Echec de connexin, veuillez réessayer"), 500);
    } on SocketException {
      changeAppState();
      return Response(jsonEncode("Verifiez votre connexion"), 500);
    } catch (error) {
      changeAppState();
      print(error.toString());
      return Response(
          jsonEncode("Une erreur est survenue, veuillez réessayer"), 500);
    }
  }

  Future<Response> httpPut({required String url, required Map body}) async {
    // print("put $url");
    try {
      changeAppState();
      Response response = await http
          .put(Uri.parse(url), body: jsonEncode(body), headers: headers)
          .timeout(Duration(seconds: 30));
      debugPrint("put" + response.body + "post");
      changeAppState();
      return response;
    } on TimeoutException catch (e) {
      changeAppState();
      print('Timeout');
      return Response(jsonEncode("Echec de connexin, veuillez réessayer"), 500);
    } on SocketException {
      changeAppState();
      return Response(jsonEncode("Verifiez votre connexion"), 500);
    } catch (error) {
      changeAppState();
      print(error.toString());
      return Response(
          jsonEncode("Une erreur est survenue, veuillez réessayer"), 500);
    }
  }

  Future<Response> httpDelete({required String url}) async {
    // print("delete $url");
    changeAppState();
    try {
      Response response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: 30));
      // print(response.body);
      changeAppState();
      return response;
    } on TimeoutException catch (e) {
      changeAppState();
      print('Timeout');
      return Response(jsonEncode("Echec de connexin, veuillez réessayer"), 500);
    } on SocketException {
      changeAppState();
      return Response(jsonEncode("Verifiez votre connexion"), 500);
    } catch (error) {
      changeAppState();
      print(error.toString());
      return Response(
          jsonEncode("Une erreur est survenue, veuillez réessayer"), 500);
    }
  }

  Future<Response> httpGet({required String url}) async {
    // print("get $url");
    changeAppState();
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(Duration(seconds: 30));
      // print(response.statusCode.toString() + "get");
      changeAppState();
      return response;
    } on TimeoutException catch (e) {
      changeAppState();
      print('Timeout');
      return Response(jsonEncode("Echec de connexin, veuillez réessayer"), 500);
    } on SocketException {
      changeAppState();
      return Response(jsonEncode("Verifiez votre connexion"), 500);
    } catch (error) {
      changeAppState();
      print(error.toString());
      return Response(
          jsonEncode("Une erreur est survenue, veuillez réessayer"), 500);
    }
  }

  logOut({required BuildContext context}) {
    Provider.of<MenuStateProvider>(context, listen: false)
        .setDefault(pageData: {"name": "Accueil", "page": const MainPage()});
    // .setDefault(
    //     pageData: {"name": "Accueil", "page": const LoanCalculationPage()});
    Navigation.pushReplaceNavigate(context: context, page: const LoginPage());
  }
}
