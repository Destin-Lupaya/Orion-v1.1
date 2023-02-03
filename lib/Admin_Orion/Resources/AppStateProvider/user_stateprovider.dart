import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:orion/Admin_Orion//Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/account_model.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/create_activity_model.dart';
import 'package:orion/Admin_Orion/Resources/Models/utilisateur_model.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';
//import '../../main.dart';

class AdminUserStateProvider extends ChangeNotifier {
  int userId = 1;
  List<ClientModel> users = [];
  ClientModel? clientData;

  //ClientModel? clientDatas;

  List usersData = [];

  List customerrData = [];

  addclient(
      {required BuildContext context,
      required Map clientModel,
      required bool updatingData,
      required Function callback}) async {
    if (clientModel['names'].isEmpty ||
        clientModel['email'].isEmpty ||
        clientModel['telephone'].isEmpty ||
        clientModel['username'].isEmpty ||
        clientModel['psw'].isEmpty) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpPost(url: BaseUrl.addUser, body: clientModel);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Message.showToast(msg: "Utilisateur crées avec succès");
      ClientModel client = ClientModel.fromJson(jsonDecode(response.body));
      clients.add(client);
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

  updateUser(
      {required Map client,
      BuildContext? context,
      required Function callback}) async {
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpPut(
            url: "${BaseUrl.addUser}/${client['id'].toString()}", body: client);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Message.showToast(msg: "Utilisateur modifié avec succès");
      Navigator.pop(navKey.currentContext!);
      Navigator.pop(navKey.currentContext!);
      notifyListeners();
      getUsersData(isRefreshed: true);
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }

  List<ClientModel> clients = [];

  getUsersData({required bool isRefreshed}) async {
    // if (clients.isNotEmpty && isRefreshed == false) {
    //   return;
    // }

    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpGet(url: BaseUrl.addUser);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      clients.clear();
      var decoded = jsonDecode(response.body);
      // usersData=decoded;
      for (int i = 0; i < decoded.length; i++) {
        clients.add(ClientModel.fromJson(decoded[i]));
      }
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

  List<CaisseModel> activitiesList = [];

  List<CreatActiviteModel> createactivities = [];
  List<CreatActiviteModel> activitiesdata = [];

  List<PlatformFile> pickedFiles = [];
  Uint8List? imageBytes;

  addFiles(
      {required List<PlatformFile> picked, required Function callback}) async {
    if (picked.isEmpty) {
      return Message.showToast(msg: 'Veuillez choisir au moins un fichier');
    }
    pickedFiles = picked;
    // imageBytes = Uint8List.fromList(await pickedFiles.first.readStream!.single);
    notifyListeners();
  }

  addactivities(
      {required BuildContext context,
      required Map data,
      required bool updatingData,
      required var imgStream,
      required Function callback}) async {
    if (pickedFiles.isEmpty && updatingData == false) {
      print(pickedFiles.length);
      return Message.showToast(msg: "Veuillez choisir une icone de l'activité");
    }
    if (data.keys
        .toList()
        .where((key) => data[key] == '' || data[key] == null)
        .toList()
        .isNotEmpty) {
      Message.showToast(msg: 'Veuillez remplir tous les champs');
      return;
    }
    Response? response;
    if (updatingData == false) {
      print('saving new one');
      Provider.of<adminAppStateProvider>(context, listen: false)
          .changeAppState();
      var request =
          http.MultipartRequest("POST", Uri.parse(BaseUrl.getActivity));
      request.fields['name'] = data['activity']['name'];
      request.fields['description'] = data['activity']['description'];
      // request.fields['type'] = data['activity']['description'];
      request.fields['avatar'] = data['activity']['avatar'];
      request.fields['users_id'] = data['activity']['users_id']!.toString();
      request.fields['web_visibility'] =
          data['activity']['web_visibility']!.toString();
      request.fields['points'] = data['activity']['points'].toString();
      request.fields['statusActive'] = "1";
      request.fields['hasStock'] = data['activity']['hasStock'].toString();
      request.fields['hasNegativeSold'] =
          data['activity']['hasNegativeSold'].toString();
      if (data['activity']['cashIn'] != null) {
        request.fields['cashIn'] = data['activity']['cashIn']!.toString();
      }
      if (data['activity']['cashOut'] != null) {
        request.fields['cashOut'] = data['activity']['cashOut']!.toString();
      }
      if (data['inputs'] != null) {
        request.fields['inputs'] = jsonEncode(data['inputs']);
      }
      // return print(request.fields);
      if (pickedFiles.isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes('file', imgStream,
            filename: pickedFiles[0].name));
      }

      var res = await request.send();
      Provider.of<adminAppStateProvider>(context, listen: false)
          .changeAppState();
      response = await http.Response.fromStream(res);
    }
    debugPrint(response?.body);
    // return;
    // print('send');
    if (updatingData == true) {
      print('updating');
      response = await Provider.of<adminAppStateProvider>(
              navKey.currentContext!,
              listen: false)
          .httpPut(
              url: "${BaseUrl.getActivity}/${data['id'].toString()}",
              body: data);
    }
    // debugPrint(response.body);
    if (response != null &&
        response.statusCode >= 200 &&
        response.statusCode < 300) {
      if (updatingData == false) {
        Message.showToast(msg: "Activité créé avec succès");
        activitiesdata.insert(
            0, CreatActiviteModel.fromJson(jsonDecode(response.body)['save']));
      } else {
        Message.showToast(msg: "Activité modifié avec succès");
        getActivitiesData(isRefresh: true);
      }
      notifyListeners();
      callback();
    } else if (response?.statusCode == 500) {
      var decoded = jsonDecode(response?.body ?? "Une erreur est survenue");
      Message.showToast(msg: decoded);
    } else {
      var decoded =
          jsonDecode(response?.body ?? jsonEncode('Une errer est survenue'));
      Message.showToast(
          msg: decoded['message']?.toString().trim() ??
              'Une erreur est survenue');
    }
  }

  // getActivitiesData({required bool isRefreshed}) async {
  //   // if (activitiesdata.isNotEmpty && isRefreshed == false) {
  //   //   return;
  //   // }
  //   activitiesdata.clear();
  //   var response = await Provider.of<adminAppStateProvider>(
  //           navKey.currentContext!,
  //           listen: false)
  //       .httpGet(url: BaseUrl.getActivity);
  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     if (response.body != null) {
  //       var decoded = jsonDecode(response.body);
  //       for (int i = 0; i < decoded.length; i++) {
  //         activitiesdata.add(CreatActiviteModel.fromJson(decoded[i]));
  //       }
  //       activitiesdata.reversed;
  //       // print("accounts : "+response.body);
  //       notifyListeners();
  //     } else {
  //       Message.showToast(msg: 'Error occured');
  //     }
  //   } else if (response.statusCode == 408) {
  //     Message.showToast(msg: "Erreur de connexion veuillez réessayer");
  //   } else {
  //     Message.showToast(msg: "Une erreur est survenue, veuillez reessayer");
  //   }
  // }

  getActivitiesData({String? activityID, bool? isRefresh}) async {
    String url = BaseUrl.getActivity;
    if (activityID != null) {
      url = "${BaseUrl.getActivity}/$activityID";
      if (activitiesdata
              .where((activity) => activity.id!.toString().trim() == activityID)
              .toList()
              .isNotEmpty &&
          (isRefresh == null || isRefresh == false)) {
        return;
      }
    }
    var response = await Provider.of<adminAppStateProvider>(
            navKey.currentContext!,
            listen: false)
        .httpGet(url: url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      var decoded = jsonDecode(response.body);
      if (activityID != null) {
        activitiesdata
            .where((activity) =>
                activity.id!.toString().trim() ==
                decoded['activity']['id'].toString().trim())
            .toList()[0]
            .inputs = decoded['inputs'];
      } else {
        activitiesdata.clear();
        if (isRefresh != null && isRefresh == true) {
          var decoded = jsonDecode(response.body);
          for (int i = 0; i < decoded.length; i++) {
            activitiesdata.add(CreatActiviteModel.fromJson(decoded[i]));
          }
        }
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

  loginUser(
      {required BuildContext context,
      required Map clientModel,
      required Function callback}) async {
    // print(clientModel);
    if (clientModel['email'].isEmpty || clientModel['psw'].isEmpty) {
      return Message.showToast(msg: 'Veuillez remplir tous les champs');
    }

    var response =
        await Provider.of<adminAppStateProvider>(context, listen: false)
            .httpPost(url: BaseUrl.getLogin, body: clientModel);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (jsonDecode(response.body)['account'].isEmpty) {
        Dialogs.showDialogNoAction(
            context: navKey.currentContext!,
            title: "Error",
            content: "Votre compte n'a aucune caisse");
        return;
      }
      clientData = ClientModel.fromJson(jsonDecode(response.body)['user']);
      Provider.of<AdminMenuStateProvider>(context, listen: false).setDefault();
      callback();
    } else if (response.statusCode == 500) {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded);
    } else {
      var decoded = jsonDecode(response.body);
      Message.showToast(msg: decoded['message'].toString().trim());
    }
  }
}
