import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
//import 'package:admin_andema/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/applogo.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class adminLoginPage extends StatefulWidget {
  const adminLoginPage({Key? key}) : super(key: key);

  @override
  _adminLoginPageState createState() => _adminLoginPageState();
}

class _adminLoginPageState extends State<adminLoginPage> {
  final PageController _controller = PageController();
  bool isPwdObscured = true;
  final TextEditingController _emailCtrller = TextEditingController(),
      _passwordCtrller = TextEditingController();

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
        controller: _controller,
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 5,
              color: AppColors.kBlackLightColor,
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
            color: AppColors.kGreenColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(size: Size(50, 50)),
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
                    'Authentifiez-vous avec votre  nom d\'utilisateur et  mot de pass.\n Faites vos transferts bancaires et mobile money ici',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
          ],
        ),
      ),
    );
  }

  loginFormWidget() {
    return Expanded(
      child: Consumer<adminAppStateProvider>(
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
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Consumer<adminAppStateProvider>(
                          builder: (context, appStateProvider, _) {
                        return appStateProvider.isAsync == false
                            ? CustomButton(
                                text: 'Se Connecter',
                                backColor: AppColors.kBlackColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () {
                                  Provider.of<AdminUserStateProvider>(context,
                                          listen: false)
                                      .loginUser(
                                          context: context,
                                          clientModel: {
                                            "email": _emailCtrller.text.trim(),
                                            "psw": _passwordCtrller.text.trim()
                                          },
                                          callback: () {
                                            Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        const AdminMainPage()));
                                          });
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.kYellowColor),
                                ),
                              );
                      }),
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
                          title: 'Login now to continue',
                          fontSize: 18,
                          align: TextAlign.center,
                          textColor: AppColors.kBlackColor),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormFieldWidget(
                          hintText: 'Username',
                          textColor: AppColors.kBlackColor,
                          backColor: AppColors.kTextFormBackColor,
                          editCtrller: _emailCtrller,
                          maxLines: 1),
                      TextFormFieldWidget(
                          hintText: 'Password',
                          isObsCured: isPwdObscured,
                          textColor: AppColors.kBlackColor,
                          backColor: AppColors.kTextFormBackColor,
                          editCtrller: _passwordCtrller,
                          maxLines: 1),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          TextWidgets.text300(
                              title: 'Forgot password?',
                              fontSize: 16,
                              textColor:
                                  AppColors.kBlackColor.withOpacity(0.5)),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
