import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/Components/applogo.dart';
import 'package:provider/provider.dart';

import '../../Resources/responsive.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppStateProvider>(context, listen: false)
        .initUI(context: context);
    // Provider.of<UserStateProvider>(context, listen: false)
    //     .tryGetOnline(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuStateProvider>(
        builder: (context, menuStateProvider, child) {
      return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            backgroundColor: AppColors.kBlackColor,
            title: Row(
              children: [
                if (Responsive.isWeb(context))
                  const AppLogo(size: Size(50, 50)),
                const SizedBox(width: 16),
                Text(menuStateProvider.currentMenu == null ||
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
        body: Responsive(
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
      );
    });
  }
}
