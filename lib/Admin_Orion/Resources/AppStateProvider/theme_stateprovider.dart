import 'package:flutter/material.dart';

class adminThemeStateProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.dark;

  bool get isDarkMode => theme == ThemeMode.dark;

  toogleTheme(bool isDarkOn) {
    theme == isDarkOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
