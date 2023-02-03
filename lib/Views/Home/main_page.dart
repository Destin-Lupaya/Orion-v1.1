import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Views/Home/menu.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

import '../../Resources/responsive.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<AppStateProvider>(context, listen: false)
          .initUI(context: context);
      Provider.of<AdminUserStateProvider>(context, listen: false)
          .getUsersData(isRefreshed: false);
      navKey.currentContext!.read<TransactionsStateProvider>().getDemands();
      navKey.currentContext!
          .read<PointsConfigProvider>()
          .getData(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MenuStateProvider, AppStateProvider>(
        builder: (context, menuStateProvider, appStateProvider, child) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            backgroundColor: AppColors.kBlackColor,
            title: Row(
              children: [
                Responsive.isWeb(context)
                    ? Text('Orion')
                    : Text(menuStateProvider.currentMenu == null ||
                            menuStateProvider.currentMenu == 'Accueil'
                        ? 'Orion'
                        : menuStateProvider.currentMenu),
                if (Responsive.isWeb(context))
                  Expanded(
                    child: Consumer<MenuStateProvider>(
                        builder: (context, menuStateProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(menuStateProvider.menu.length,
                            (index) {
                          return MenuItem(
                              title: menuStateProvider.menu[index].title,
                              action: menuStateProvider.menu[index].action,
                              icon: menuStateProvider.menu[index].icon,
                              textColor: AppColors.kWhiteColor,
                              hoverColor: AppColors.kYellowColor,
                              backColor: Colors.transparent);
                        }),
                      );
                    }),
                  ),
              ],
            )),
        drawer: Responsive.isWeb(context)
            ? null
            : const Drawer(
                child: MenuWidget(),
              ),
        body: ModalProgress(
          isAsync: appStateProvider.isAsync,
          progressColor: AppColors.kYellowColor,
          child: Responsive(
              mobile: menuStateProvider.activePage,
              tablet: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: menuStateProvider.activePage,
                  ),
                ],
              ),
              web: Row(
                children: [
                  // const Expanded(
                  //   flex: 2,
                  //   child: MenuWidget(),
                  // ),
                  Expanded(flex: 6, child: menuStateProvider.activePage),
                ],
              )),
        ),
      );
    });
  }
}
