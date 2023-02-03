import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/main.dart';

double kDefaultPadding = 20;

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

  static pushAndRemove({required BuildContext context, required Widget page}) {
    Navigator.pushAndRemoveUntil(context,
        CupertinoPageRoute(builder: (context) => page), (route) => false);
  }
}

class Message {
  static showToast({required String msg}) {
    // Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: msg);
    Dialogs.showDialogNoAction(
        context: navKey.currentContext!, title: "Notification", content: msg);
  }
}

class BaseUrl {
  // http://api-app.okapishop.net/api/users
  static String ipOnline = "http://orion-api.ohadaexpress.com/public";
  // static String ip = "http://192.168.2.106:8100";
  static String ip = "http://127.0.0.1:8000";
  static String apiUrl = "$ipOnline/api";
  // static String apiUrl = "http://192.168.2.106:8000/api";
  static String getLogin = '$apiUrl/user/login';
  static String addUser = '$apiUrl/users';

  static String getHistory = '$apiUrl/transaction';
  static String getActivity = '$apiUrl/activity';
  static String getAccountActivity = '$apiUrl/accountactivity';
  static String getDemande = '$apiUrl/demande';
  static String getAccount = '$apiUrl/account';
  static String branch = '$apiUrl/branch';
  static String branchActivity = '$apiUrl/branch_activity';
  static String addPointConfig = '$apiUrl/add-point-config';
  static String getPointConfig = '$apiUrl/get-point-config';
  static String getClientPoint = '$apiUrl/get-client-point';
  static String getStats = '$apiUrl/stats';
  static String getCountStats = '$apiUrl/stats-count';
}

enum EnumActions { Save, Update, Delete, View }
