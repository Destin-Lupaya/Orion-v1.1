import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/applogo.dart';
import 'package:orion/Views/Home/home_page.dart';
import 'package:provider/provider.dart';

import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/text_fields.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/global_variables.dart';
import '../../../Resources/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCtrller = TextEditingController(),
      _pwdCtrller = TextEditingController();
  bool isPwdObscured = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kBlackLightColor,
        body: Responsive(
          mobile: centerWidget(widgets: [loginFormWidget()]),
          tablet:
              centerWidget(widgets: [welcomeMsgWidget(), loginFormWidget()]),
          web: centerWidget(widgets: [welcomeMsgWidget(), loginFormWidget()]),
        ));
  }

  centerWidget({required List<Widget> widgets}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 5,
              color: AppColors.kBlackColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
              child: Row(
                children: widgets,
              ),
            )
          ],
        ),
      ),
    );
  }

  welcomeMsgWidget() {
    return Expanded(
      child: Container(
        // height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(kDefaultPadding / 2),
              bottomLeft: Radius.circular(kDefaultPadding / 2)),
          // color: AppColors.kGreenColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(size: Size(100, 100)),
            TextWidgets.textBold(
                title: 'Bienvenue dans ORION',
                fontSize: 25,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 25,
            ),
            TextWidgets.text300(
                title: 'Pour la traçabilite dans la gestion',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 16,
            ),
            TextWidgets.text300(
                title:
                    'Authentifiez-vous avec votre  nom d\'utilisateur et  mot de passe.',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
          ],
        ),
      ),
    );
  }

  loginFormWidget() {
    return Expanded(child: Consumer<AppStateProvider>(
      builder: (context, appStateProvider, _) {
        return SingleChildScrollView(
            child: Container(
          // height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: !Responsive.isMobile(context)
                  ? BorderRadius.only(
                      topRight: Radius.circular(kDefaultPadding / 2),
                      bottomRight: Radius.circular(kDefaultPadding / 2))
                  : BorderRadius.circular(kDefaultPadding / 2),
              color: AppColors.kWhiteColor),
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    // child: Image.asset("Assets/Images/logo_h_black.png")
                  )),
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    // color: AppColors.kBlackColor.withOpacity(0.5),
                  )),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(bottom: 50, right: 0, left: 0),
                child: Column(
                  children: [
                    TextWidgets.textBold(
                        title: 'Orion',
                        fontSize: 25,
                        align: TextAlign.center,
                        textColor: AppColors.kBlackColor),
                    TextWidgets.text300(
                        title: 'Connectez-vous pour continuer',
                        fontSize: 18,
                        align: TextAlign.center,
                        textColor: AppColors.kBlackColor),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormFieldWidget(
                        backColor: AppColors.kTextFormBackColor,
                        hintText: 'Nom d\'Utilisateur',
                        editCtrller: _emailCtrller,
                        textColor: AppColors.kBlackColor,
                        maxLines: 1),
                    TextFormFieldWidget(
                        backColor: AppColors.kTextFormBackColor,
                        hintText: 'Mot de Pass',
                        isObsCured: isPwdObscured,
                        editCtrller: _pwdCtrller,
                        textColor: AppColors.kBlackColor,
                        maxLines: 1),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: appStateProvider.isAsync == false
                          ? CustomButton(
                              text: 'Se Connecter',
                              backColor: AppColors.kBlackColor,
                              textColor: AppColors.kWhiteColor,
                              callback: () {
                                Provider.of<UserStateProvider>(context,
                                        listen: false)
                                    .loginUser(
                                        context: context,
                                        clientModel: {
                                          "email": _emailCtrller.text.trim(),
                                          "psw": _pwdCtrller.text.trim()
                                        },
                                        callback: () {});
                              },
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.kYellowColor),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    ));
  }
}
