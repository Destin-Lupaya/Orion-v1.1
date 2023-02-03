import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkTheme = ThemeData(
      primaryColor: AppColors.kBlackColor,
      canvasColor: AppColors.kBlackLightColor,
      // accentColor: AppColors.kBlackColor.withOpacity(0.5),
      colorScheme: const ColorScheme.dark(),
      scaffoldBackgroundColor: AppColors.kBlackLightColor);
  static ThemeData lightTheme = ThemeData(
      primaryColor: AppColors.kWhiteColor,
      colorScheme: const ColorScheme.light(),
      scaffoldBackgroundColor: AppColors.kWhiteDarkColor);
}
