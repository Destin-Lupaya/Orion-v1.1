import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/applogo.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/radio_button.dart';
import 'package:orion/Resources/Models/client_model.dart';
import 'package:orion/Views/Login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Resources/Components/button.dart';
import '../../../Resources/Components/text_fields.dart';
import '../../../Resources/Components/texts.dart';
import '../../../Resources/global_variables.dart';
import '../../../Resources/responsive.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final ScrollController _controller = ScrollController();

  // Identity
  final TextEditingController _nameCtrller = TextEditingController();
  final TextEditingController _lastnameCtrller = TextEditingController();
  final TextEditingController _surnameCtrller = TextEditingController();

// Contact
  final TextEditingController _phoneCtrller = TextEditingController();
  final TextEditingController _emailCtrller = TextEditingController();
  final TextEditingController _pwdCtrller = TextEditingController();

  // Verification fields
  final TextEditingController _field1Ctrller = TextEditingController();
  final TextEditingController _field2Ctrller = TextEditingController();
  final TextEditingController _field3Ctrller = TextEditingController();
  final TextEditingController _field4Ctrller = TextEditingController();
  final TextEditingController _field5Ctrller = TextEditingController();
  int currentStep = 0;
  bool isEmailVerifMode = false, isSMSVerifMode = false;
  String gender = "Masculin";
  String role = "Client";

  @override
  void initState() {
    super.initState();
    _field1Ctrller.addListener(() {
      if (_field1Ctrller.text.isNotEmpty) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kBlackLightColor,
        appBar:
            AppBar(elevation: 0, backgroundColor: AppColors.kTransparentColor),
        body: Responsive(
          mobile: centerWidget(widgets: [loginFormWidget()]),
          tablet:
              centerWidget(widgets: [welcomeMsgWidget(), loginFormWidget()]),
          web: centerWidget(widgets: [welcomeMsgWidget(), loginFormWidget()]),
        ));
  }

  centerWidget({required List<Widget> widgets}) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 5,
              color: AppColors.kBlackColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
              child: Row(
                children: widgets,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
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
            color: AppColors.kBlackColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogo(size: Size(100, 100)),
            TextWidgets.textBold(
                title: 'Welcome to Orion',
                fontSize: 25,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 25,
            ),
            TextWidgets.text300(
                title: 'For Building Trust',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 16,
            ),
            TextWidgets.text300(
                title:
                    'Create your account for free to get benefit of our plateform. \nGet your credit in the right time at the right place',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
          ],
        ),
      ),
    );
  }

  loginFormWidget() {
    return Expanded(child:
        Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
            borderRadius: !Responsive.isMobile(context)
                ? BorderRadius.only(
                    topRight: Radius.circular(kDefaultPadding / 2),
                    bottomRight: Radius.circular(kDefaultPadding / 2))
                : BorderRadius.circular(kDefaultPadding / 2),
            color: AppColors.kWhiteColor),
        child: ListView(
          children: [
            TextWidgets.textBold(
                title: 'Orion',
                fontSize: 25,
                align: TextAlign.center,
                textColor: AppColors.kBlackColor),
            TextWidgets.text300(
                title: 'Create your free account now',
                fontSize: 18,
                align: TextAlign.center,
                textColor: AppColors.kBlackColor),
            const SizedBox(
              height: 20,
            ),
            Stepper(
              // type: StepperType.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              currentStep: currentStep,
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              onStepContinue: () async {
                if (currentStep == 0) {
                  if (_nameCtrller.text.isEmpty ||
                      _lastnameCtrller.text.isEmpty) {
                    return Message.showToast(
                        msg: 'Veuillez saisir nom et un postnom');
                  }
                } else if (currentStep == 1) {
                  if (_pwdCtrller.text.isEmpty) {
                    return Message.showToast(
                        msg: 'Veuillez saisir un mot de passe');
                  }
                  if (_phoneCtrller.text.isEmpty) {
                    return Message.showToast(msg: 'Veuillez saisir un num tel');
                  }
                  if (_emailCtrller.text.isEmpty) {
                    return Message.showToast(msg: 'Veuillez saisir un email');
                  }
                  if (isEmailVerifMode == false && isSMSVerifMode == false) {
                    return Message.showToast(
                        msg: 'Veuillez choisir un mode de vérification');
                  }
                  if (_phoneCtrller.text.isEmpty && isSMSVerifMode == true) {
                    return Message.showToast(
                        msg: 'Veuillez saisir un numero de téléphone');
                  }
                  if (_emailCtrller.text.isEmpty && isEmailVerifMode == true) {
                    return Message.showToast(msg: 'Veuillez saisir un email');
                  }
                } else {
                  Map data = {
                    "password": _pwdCtrller.text.trim(),
                    "fname": _nameCtrller.text.trim(),
                    "lname": _lastnameCtrller.text.trim(),
                    "pname": _surnameCtrller.text.trim(),
                    "telephon": _phoneCtrller.text.trim(),
                    "email": _emailCtrller.text.trim(),
                    "genre": gender.trim(),
                    "role": role.trim(),
                  };
                  // var response =
                  //     await Provider.of<AppStateProvider>(context, listen: false)
                  //         .httpPost(url: BaseUrl.addUser, body: data);
                  Provider.of<UserStateProvider>(context, listen: false)
                      .createNewUser(
                          context: context,
                          clientModel: ClientModel.fromJson(data),
                          callback: () {
                            Navigator.pop(context);
                          });
                }
                if (currentStep < 2) {
                  setState(() {
                    currentStep++;
                  });
                }
              },
              // controlsBuilder: (BuildContext context,
              //     {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
              //   return Row(
              //     children: [
              //       currentStep > 0
              //           ? Expanded(
              //               child: Container(
              //                   margin: const EdgeInsets.all(5),
              //                   child: CustomButton(
              //                       text: 'Precedent',
              //                       backColor: AppColors.kGreyColor,
              //                       textColor: AppColors.kBlackColor,
              //                       callback: () {
              //                         onStepCancel!();
              //                       })))
              //           : Container(),
              //       Expanded(
              //         child: Container(
              //           margin: const EdgeInsets.all(5),
              //           child: CustomButton(
              //             text: 'Continue',
              //             backColor: AppColors.kBlackColor,
              //             textColor: AppColors.kWhiteColor,
              //             callback: () {
              //               onStepContinue!();
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   );
              // },
              steps: [
                Step(
                    title: Text(
                      'Identite',
                      style: TextStyle(color: AppColors.kBlackColor),
                    ),
                    state: currentStep == 0
                        ? StepState.editing
                        : currentStep < 0
                            ? StepState.disabled
                            : StepState.complete,
                    content: Stack(
                      children: [
                        Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(
                              bottom: 0, right: 0, left: 0),
                          child: Column(
                            children: [
                              TextFormFieldWidget(
                                  backColor: AppColors.kTextFormBackColor,
                                  hintText: 'Nom',
                                  editCtrller: _nameCtrller,
                                  textColor: AppColors.kBlackColor,
                                  maxLines: 1),
                              TextFormFieldWidget(
                                  backColor: AppColors.kTextFormBackColor,
                                  hintText: 'Post-nom',
                                  editCtrller: _lastnameCtrller,
                                  textColor: AppColors.kBlackColor,
                                  maxLines: 1),
                              TextFormFieldWidget(
                                  backColor: AppColors.kTextFormBackColor,
                                  hintText: 'Prenom',
                                  editCtrller: _surnameCtrller,
                                  textColor: AppColors.kBlackColor,
                                  maxLines: 1),
                              CustomDropdownButton(
                                  value: gender,
                                  backColor: AppColors.kTextFormBackColor,
                                  textColor: AppColors.kBlackColor,
                                  hintText: 'Sexe',
                                  callBack: (value) {
                                    gender = value;
                                    setState(() {});
                                  },
                                  items: const ["Masculin", "Feminin"]),
                              const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: AppColors.kBlackColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextWidgets.textBold(
                                      title: 'Ou',
                                      fontSize: 25,
                                      align: TextAlign.center,
                                      textColor: AppColors.kBlackColor),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      // width: double.maxFinite,
                                      height: 2,
                                      color: AppColors.kBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.facebook,
                                        size: 30,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.g_mobiledata_rounded,
                                        size: 30,
                                        color: Colors.redAccent,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Step(
                    title: Text(
                      "Connexion et contacts",
                      style: TextStyle(color: AppColors.kBlackColor),
                    ),
                    state: currentStep == 1
                        ? StepState.editing
                        : currentStep < 1
                            ? StepState.disabled
                            : StepState.complete,
                    content: Column(
                      children: [
                        CustomDropdownButton(
                            value: role,
                            hintText: 'Type de compte',
                            backColor: AppColors.kTextFormBackColor,
                            textColor: AppColors.kBlackColor,
                            callBack: (value) {
                              role = value;
                              setState(() {});
                            },
                            items: const ["Client", "Lender"]),
                        TextFormFieldWidget(
                            backColor: AppColors.kTextFormBackColor,
                            hintText: 'Phone number',
                            editCtrller: _phoneCtrller,
                            textColor: AppColors.kBlackColor,
                            maxLines: 1),
                        TextFormFieldWidget(
                            backColor: AppColors.kTextFormBackColor,
                            hintText: 'E-mail',
                            editCtrller: _emailCtrller,
                            textColor: AppColors.kBlackColor,
                            maxLines: 1),
                        TextFormFieldWidget(
                            backColor: AppColors.kTextFormBackColor,
                            hintText: 'Password',
                            editCtrller: _pwdCtrller,
                            textColor: AppColors.kBlackColor,
                            maxLines: 1),
                        const SizedBox(height: 20),
                        Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.zero,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidgets.textBold(
                                    title:
                                        'Mode de verification et notification du compte',
                                    fontSize: 14,
                                    align: TextAlign.left,
                                    textColor: AppColors.kBlackColor),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomRadioButton(
                                        value: isEmailVerifMode,
                                        textColor: AppColors.kBlackColor,
                                        label: 'Email',
                                        callBack: () {
                                          setState(() {
                                            isEmailVerifMode = true;
                                            isSMSVerifMode = false;
                                          });
                                        }),
                                    CustomRadioButton(
                                        textColor: AppColors.kBlackColor,
                                        value: isSMSVerifMode,
                                        label: 'SMS',
                                        callBack: () {
                                          setState(() {
                                            isSMSVerifMode = true;
                                            isEmailVerifMode = false;
                                          });
                                        }),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    )),
                Step(
                    title: Text(
                      'Code de verification',
                      style: TextStyle(color: AppColors.kBlackColor),
                    ),
                    state: currentStep == 2
                        ? StepState.editing
                        : currentStep < 2
                            ? StepState.disabled
                            : StepState.complete,
                    content: Stack(
                      children: [
                        Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(
                              bottom: 0, right: 0, left: 0),
                          child: Column(
                            children: [
                              TextWidgets.text300(
                                  title: 'Verifiez et validez votre compte',
                                  fontSize: 18,
                                  align: TextAlign.center,
                                  textColor: AppColors.kBlackColor),
                              const SizedBox(
                                height: 30,
                              ),
                              TextWidgets.text300(
                                  title:
                                      '${isEmailVerifMode ? 'Email' : 'Numéro'} à vérifier',
                                  fontSize: 14,
                                  align: TextAlign.center,
                                  textColor: AppColors.kBlackColor),
                              const SizedBox(
                                height: 10,
                              ),
                              TextWidgets.textBold(
                                  title: isEmailVerifMode
                                      ? _emailCtrller.text.toString().trim()
                                      : _phoneCtrller.text.trim(),
                                  fontSize: 14,
                                  align: TextAlign.center,
                                  textColor: AppColors.kBlackColor),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentStep--;
                                  });
                                },
                                child: TextWidgets.text300(
                                    title:
                                        'Changer ${isEmailVerifMode ? 'le mail' : 'le numéro'} de vérification',
                                    fontSize: 12,
                                    align: TextAlign.center,
                                    textColor: AppColors.kBlackColor),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormVerification(
                                        backColor: AppColors.kTextFormBackColor,
                                        hintText: '*',
                                        editCtrller: _field2Ctrller,
                                        textColor: AppColors.kBlackColor,
                                        maxLines: 1),
                                  ),
                                  Expanded(
                                    child: TextFormVerification(
                                        backColor: AppColors.kTextFormBackColor,
                                        hintText: '*',
                                        editCtrller: _field3Ctrller,
                                        textColor: AppColors.kBlackColor,
                                        maxLines: 1),
                                  ),
                                  Expanded(
                                    child: TextFormVerification(
                                        backColor: AppColors.kTextFormBackColor,
                                        hintText: '*',
                                        editCtrller: _field4Ctrller,
                                        textColor: AppColors.kBlackColor,
                                        maxLines: 1),
                                  ),
                                  Expanded(
                                    child: TextFormVerification(
                                        backColor: AppColors.kTextFormBackColor,
                                        hintText: '*',
                                        editCtrller: _field5Ctrller,
                                        textColor: AppColors.kBlackColor,
                                        maxLines: 1),
                                  ),
                                  Expanded(
                                    child: TextFormVerification(
                                        backColor: AppColors.kTextFormBackColor,
                                        hintText: '*',
                                        editCtrller: TextEditingController(),
                                        textColor: AppColors.kBlackColor,
                                        maxLines: 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextWidgets.text300(
                        title: 'Connecter mon compte',
                        fontSize: 16,
                        align: TextAlign.center,
                        textColor: AppColors.kBlackColor)),
                onTap: () {
                  Provider.of<MenuStateProvider>(context, listen: false)
                      .setDefault(pageData: {
                    "name": "Connect",
                    "page": const LoginPage()
                  });
                }),
            const SizedBox(height: 20),
          ],
        ),
      );
    }));
  }
}
