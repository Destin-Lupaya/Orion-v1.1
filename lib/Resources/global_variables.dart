import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/main.dart';

double kDefaultPadding = 20;

List<String> genderList = ['Masculin', 'Feminin'];

Map<String, String> headers = {
  // 'Accept': 'application/json; charset=UTF-8',
  'Content-Type': 'application/json',
  // 'Authorization': 'Bearer ${Provider.of<AppStateProvider>(navKey.currentContext!, listen: false).userToken}'
};

class AppColors {
  static Color kPrimaryColor = Colors.blue.shade900;
  static Color kSecondaryColor = Colors.blue;
  static Color kBlackColor = const Color.fromRGBO(24, 24, 24, 1);
  static Color kBlackLightColor = const Color.fromRGBO(60, 60, 60, 1);
  static Color kWhiteColor = Colors.white;
  static Color kWhiteDarkColor = Colors.grey.shade400;
  static Color kGreenColor = Colors.green;
  static Color kRedColor = Colors.red;
  static Color kGreyColor = Colors.grey;
  // static Color kYellowColor = const Color.fromRGBO(255, 184, 57, 1);
  static Color kYellowColor = const Color.fromRGBO(255, 185, 35, 1);
  static Color kTextFormWhiteColor = Colors.white.withOpacity(0.1);
  static Color kTextFormBackColor = Colors.black.withOpacity(0.1);
  static Color kTransparentColor = Colors.transparent;
}

class Navigation {
  static pushNavigate({required BuildContext context, required Widget page}) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  static pushReplaceNavigate(
      {required BuildContext context, required Widget page}) {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => page));
  }
}

class Theme {
  // Enum themeVariant={"Light", Dark};

}

class Message {
  static showToast({required String msg}) {
    // Fluttertoast.showToast(
    //     toastLength: Toast.LENGTH_LONG, msg: msg, gravity: ToastGravity.BOTTOM);
    Dialogs.showDialogNoAction(
        context: navKey.currentContext!, title: "Notification", content: msg);
  }
}

class BaseUrl {
  // static String ip = "http://192.168.2.106:8100";
  static String ip = "http://127.0.0.1:8000";
  static String ipOnline = "http://orion-api.ohadaexpress.com/public";
  static String apiUrl = "$ipOnline/api";
  static String getLogin = '$apiUrl/user/login';
  static String addUser = '$apiUrl/users';
  // static String user = '$apiUrl/users/';
  static String getCaisse = '$apiUrl/account';
  static String getHistory = '$apiUrl/transaction';
  static String getPret = '$apiUrl/trans_pret/pret';
  static String getActivity = '$apiUrl/activity';
  static String getDemands = '$apiUrl/demande';
  static String facture = '$apiUrl/facture';
  static String cloture = '$apiUrl/cloture';
  static String incident = '$apiUrl/add-incident';
  static String externalClient = '$apiUrl/external-client';
  static String cautions = '$apiUrl/caution';
  // static String  = '$apiUrl/caution';
}
