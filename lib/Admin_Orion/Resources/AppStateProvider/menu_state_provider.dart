import 'package:orion/Admin_Orion/Resources/Models/menu_model.dart';

import 'package:orion/Admin_Orion/Views/Config/Settings/settings.dart';
import 'package:orion/Admin_Orion/Views/Config/User/create_user.dart';
import 'package:orion/Admin_Orion/Views/Guichet/branches_page.dart';

import 'package:orion/Admin_Orion/Views/Guichet/caisse.dart';
import 'package:orion/Admin_Orion/Views/Guichet/create_activity.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Dashboard/Stats/dashboard.page.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Dashboard/home_dashboard_page.dart';

import 'package:flutter/material.dart';

class AdminMenuStateProvider extends ChangeNotifier {
  String currentMenu = 'Accueil';
  List<MenuModel> menu = [
    MenuModel(
        title: 'Accueil', icon: Icons.home_outlined, page: HomeDashboardPage()),
    MenuModel(
        title: 'Branches',
        icon: Icons.short_text_sharp,
        page: const BranchePage()),
    MenuModel(
        title: 'Utilisateurs', icon: Icons.person, page: const UsersPage()),
    MenuModel(
        title: 'Activités',
        icon: Icons.local_activity,
        page: const ActivityPage()),
    // MenuModel(
    //     title: 'Activites de l\'Utilisateur',
    //     icon: Icons.person,
    //     page: UsersActivitiesPage(
    //       updatingData: false,
    //     )),
    MenuModel(
        title: 'Caisse',
        icon: Icons.account_balance_outlined,
        page: const CaissePage()),
    // MenuModel(
    //     title: 'My Profile', icon: Icons.person, page: const ProfilePage()),
    MenuModel(title: 'Paramètres', icon: Icons.settings, page: SettingsPage()),
  ];
  getActivePage() {
    activePage = menu
        .where((menu) {
          return menu.title.toLowerCase() == currentMenu.toLowerCase();
        })
        .toList()[0]
        .page;
  }

  Widget activePage = HomeDashboardPage();

  changeMenu({required String newMenuValue}) {
    currentMenu = newMenuValue;
    // return print(currentMenu);
    getActivePage();
    notifyListeners();
  }

  setDefault() {
    currentMenu = "Accueil";
    activePage = HomeDashboardPage();
    notifyListeners();
  }
}
