import 'package:orion/Admin_Orion/Views/Home/home_page.dart';
import 'package:orion/Admin_Orion/Views/Login/login_page.dart';
import 'package:orion/Resources/Models/menu_model.dart';
import 'package:orion/Views/Login/login_page.dart';
import 'package:flutter/material.dart';

class MenuStateProvider extends ChangeNotifier {
  String currentMenu = 'Client';
  List<MenuModel> menu = [
    MenuModel(
        action: 'replace',
        title: 'Client',
        icon: Icons.home,
        page: const LoginPage()),
    MenuModel(
        action: 'replace',
        title: 'Administration',
        page: const adminLoginPage(),
        icon: Icons.settings),
  ];

  initMenu({required BuildContext context}) {
    menu = [
      // MenuModel(title: 'Accueil', icon: Icons.home, page: const LoginPage()),
      MenuModel(
        title: 'Client',
        icon: Icons.login,
        page: const LoginPage(),
        action: 'replace',
      ),
      MenuModel(
          action: 'replace',
          title: 'Administration',
          page: const AdminMainPage(),
          icon: Icons.settings),
    ];
    setDefault(pageData: {"name": 'Client', "page": const LoginPage()});
    // title: 'Accueil',
    // page: const LoanCalculationPage(),
    notifyListeners();
  }

  addMenu({required List<MenuModel> menus}) {
    for (var i = 0; i < menus.length; i++) {
      if (menu.where((element) {
        return element.title == menus[i].title;
      }).isNotEmpty) {
        return;
      }
      menu.add(menus[i]);
    }
    notifyListeners();
  }

  removeMenu({required MenuModel menus}) {
    if (menu.where((element) {
      return element.title == menus.title;
    }).isNotEmpty) {
      menu.removeWhere((element) => element.title == menus.title);
    }
    notifyListeners();
  }

  getActivePage() {
    activePage = menu
        .where((menu) {
          return menu.title.toLowerCase() == currentMenu.toLowerCase();
        })
        .toList()[0]
        .page;
    // notifyListeners();
  }

  Widget activePage = const LoginPage();
  // Widget activePage = const LoanCalculationPage();

  changeMenu({required String newMenuValue}) {
    currentMenu = newMenuValue;
    getActivePage();
    notifyListeners();
  }

  setDefault({required Map pageData}) {
    currentMenu = pageData['name'];
    activePage = pageData['page'];
    notifyListeners();
  }
}
