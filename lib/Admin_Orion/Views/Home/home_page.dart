import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

import '../../Resources/responsive.dart';
import 'menu.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AdminMainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<AdminUserStateProvider>(context, listen: false)
          .getActivitiesData(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminMenuStateProvider>(
        builder: (context, menuStateProvider, child) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            backgroundColor: AppColors.kBlackColor,
            title: Text(menuStateProvider.currentMenu == null ||
                    menuStateProvider.currentMenu == 'Accueil'
                ? 'Orion administration'
                : menuStateProvider.currentMenu)),
        drawer: Responsive.isWeb(context)
            ? null
            : const Drawer(
                child: MenuWidget(),
              ),
        body: Responsive(
            mobile: menuStateProvider.activePage,
            tablet: menuStateProvider.activePage,
            web: Row(
              children: [
                Container(
                  width: 250,
                  padding: EdgeInsets.zero,
                  child: const MenuWidget(),
                ),
                Expanded(flex: 6, child: menuStateProvider.activePage),
              ],
            )),
      );
    });
  }
}
