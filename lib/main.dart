import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_transaction.provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/stats.provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/theme_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/account_provider.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/caution.provider.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Views/Login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // Stripe.init(
  //     production: false,
  //     publicKey: Config.checkProd()['pubKey'],
  //     secretKey: Config.checkProd()['secKey'],
  //     useLogger: true);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MenuStateProvider()),
      ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ChangeNotifierProvider(create: (_) => UserStateProvider()),
      ChangeNotifierProvider(create: (_) => TransactionsStateProvider()),
      ChangeNotifierProvider(create: (_) => AdminUserStateProvider()),
      ChangeNotifierProvider(create: (_) => adminAppStateProvider()),
      ChangeNotifierProvider(create: (_) => AdminMenuStateProvider()),
      ChangeNotifierProvider(create: (_) => adminThemeStateProvider()),
      // ChangeNotifierProvider(create: (_) => CaisseStateProvider()),
      ChangeNotifierProvider(create: (_) => AdminCaisseStateProvider()),
      ChangeNotifierProvider(create: (_) => ClotureProvider()),
      ChangeNotifierProvider(create: (_) => PointsConfigProvider()),
      ChangeNotifierProvider(create: (_) => ClientProvider()),
      ChangeNotifierProvider(create: (_) => CautionProvider()),
      ChangeNotifierProvider(create: (_) => StatsDataProvider()),
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => AdminTransactionProvider()),
    ],
    child: const MyApp(),
  ));
}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orion | Manage your busness in secure way',
      //themeMode: Provider.of<MenuStateProvider>(context).theme,
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.light,
      // theme: Themes.lightTheme,
      theme: ThemeData(fontFamily: 'Roboto'),
      scrollBehavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      }),
      //home: const startupLoginPage(),
      home: prefs.getString("userData") == null
          ? const LoginPage()
          : Provider.of<UserStateProvider>(context, listen: false)
              .checkUserConnected()!,
      navigatorKey: navKey,
    );
  }
}
