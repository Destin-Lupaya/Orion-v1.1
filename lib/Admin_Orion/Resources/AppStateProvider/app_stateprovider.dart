import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:orion/Admin_Orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart' as gV_admin;
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Views/Login/login_page.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

//import '../../main.dart';

class adminAppStateProvider extends ChangeNotifier {
  bool isAsync = false;
  changeAppState() {
    isAsync = !isAsync;
    // print(isAsync);
    // print('changing state');
    notifyListeners();
  }

  Future<Response> httpPost({required String url, required Map body}) async {
    // print("post $url");
    try {
      // print('changing state');
      changeAppState();
      Response response = await http
          .post(Uri.parse(url), body: jsonEncode(body), headers: headers)
          .timeout(Duration(seconds: 30));
      // print("post" + response.body + "post");
      debugPrint(response.body);
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
      print("put" + response.body + "post");
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
    prefs.clear();
    Provider.of<AdminMenuStateProvider>(context, listen: false).setDefault();
    gV_admin.Navigation.pushAndRemove(
        context: context, page: const LoginPage());
  }
}
