import 'dart:ui';

import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';

import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/dropdown_button.dart';

import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';

import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/account_model.dart';

import 'package:orion/Admin_Orion/Resources/Models/utilisateur_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class UpdateUserPage extends StatefulWidget {
  final bool updatingData;
  final ClientModel? clientModel;
  const UpdateUserPage({Key? key, required this.updatingData, this.clientModel})
      : super(key: key);
  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

List<String> typeactiviteList = ["Mobile Money", "Autres"];
late String typeactiviteMode = "Mobile Money";

String? nomFournisseur;
String? membreInterne;

String? nomMembre;

class _UpdateUserPageState extends State<UpdateUserPage> {
  final PageController _controller = PageController();
  final TextEditingController _nameCtrller = TextEditingController();
  final TextEditingController _roleCtrller = TextEditingController();
  final TextEditingController _usernameCtrller = TextEditingController();
  final TextEditingController _pwdCtrller = TextEditingController();
  final TextEditingController _mailCtrller = TextEditingController();
  final TextEditingController _telephCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _nameCtrller.text = widget.clientModel!.names.trim();
      _usernameCtrller.text = widget.clientModel!.username.toString().trim();
      _roleCtrller.text = widget.clientModel!.password.toString().trim();
      _mailCtrller.text = widget.clientModel!.email.toString().trim();
      _telephCtrller.text = widget.clientModel!.telephone.toString().trim();
      _pwdCtrller.text = widget.clientModel!.password.toString().trim();
      currentUser = widget.clientModel!.role.toString();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //Provider.of<UserStateProvider>(context, listen: false)
      // .getuser(context: context, isRefreshed: false);
    });
  }

  List<String> genderList = ["Homme", "Femme"];
  String currentGender = "Homme";
  List<String> typeUserList = ["Caissier", "Agregateur", "admin"];
  String currentUser = "Caissier";

  // String currentRole = "Backoffice";
  String currentUserType = "Backoffice";
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height * .85,
        // color: AppColors.kBlackLightColor,
        child: Consumer<adminAppStateProvider>(
            builder: (context, appStateProvider, _) {
          return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                }),
                child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: 'Ajouter un utilisateur',
                      titleColor: AppColors.kWhiteColor,
                      content: Wrap(
                        children: [
                          Row(children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                maxLines: 1,
                                editCtrller: _nameCtrller,
                                hintText: 'Noms',
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                maxLines: 1,
                                editCtrller: _usernameCtrller,
                                hintText: 'Nom d\'Utilisateur',
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                          ]),
                          Row(children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                maxLines: 1,
                                editCtrller: _telephCtrller,
                                hintText: 'Telephone',
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                maxLines: 1,
                                editCtrller: _mailCtrller,
                                hintText: 'Email',
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                          ]),
                          Row(children: [
                            Expanded(
                              child: CustomDropdownButton(
                                  backColor: AppColors.kTextFormBackColor
                                      .withOpacity(1),
                                  textColor: AppColors.kWhiteColor,
                                  value: currentUser,
                                  hintText: "Role",
                                  callBack: (newValue) {
                                    setState(() {
                                      currentUser = newValue;
                                    });
                                  },
                                  items: [
                                    ...typeUserList,
                                    if (navKey.currentContext!
                                            .read<UserStateProvider>()
                                            .clientData
                                            ?.role
                                            .toLowerCase() ==
                                        'admin')
                                      "Comptable"
                                  ]),
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                maxLines: 1,
                                editCtrller: _pwdCtrller,
                                hintText: 'Mot de passe',
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                          ]),
                          Consumer<AdminUserStateProvider>(
                              builder: (context, userStateProvider, _) {
                            return Row(children: [
                              Expanded(
                                child: CustomButton(
                                  text: widget.clientModel?.statusActive == "1"
                                      ? 'Suspendre'
                                      : "Réactiver",
                                  backColor:
                                      AppColors.kRedColor.withOpacity(0.5),
                                  textColor: AppColors.kWhiteColor,
                                  callback: () {
                                    Map data = {
                                      "id": widget.clientModel!.id!.toString(),
                                      "names": _nameCtrller.text.trim(),
                                      "telephone": _telephCtrller.text.trim(),
                                      "email": _mailCtrller.text.trim(),
                                      "username": _usernameCtrller.text.trim(),
                                      "psw": _pwdCtrller.text.trim(),
                                      "role": currentUser,
                                      "statusActive":
                                          widget.clientModel?.statusActive ==
                                                  "1"
                                              ? 0
                                              : 1,
                                    };
                                    if (data['names'].isEmpty ||
                                        data['email'] == null ||
                                        data['telephone'] == null ||
                                        data['username'] == null ||
                                        data['psw'] == null) {
                                      return Message.showToast(
                                          msg:
                                              'Veuillez remplir tous les champs');
                                    }
                                    // return print(data);
                                    userStateProvider.updateUser(
                                        context: context,
                                        client: data,
                                        //updatingData: widget.updatingData,
                                        callback: () {});
                                  },
                                ),
                              ),
                              Expanded(
                                  child: CustomButton(
                                text: 'Modifier',
                                backColor: AppColors.kYellowColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () {
                                  Map data = {
                                    "id": widget.clientModel!.id!.toString(),
                                    "names": _nameCtrller.text.trim(),
                                    "telephone": _telephCtrller.text.trim(),
                                    "email": _mailCtrller.text.trim(),
                                    "username": _usernameCtrller.text.trim(),
                                    "psw": _pwdCtrller.text.trim(),
                                    "role": currentUser,
                                    "statusActive": "1",
                                  };
                                  if (data['names'].isEmpty ||
                                      data['email'] == null ||
                                      data['telephone'] == null ||
                                      data['username'] == null ||
                                      data['psw'] == null) {
                                    return Message.showToast(
                                        msg:
                                            'Veuillez remplir tous les champs');
                                  }
                                  // return print(data);
                                  userStateProvider.updateUser(
                                      context: context,
                                      client: data,
                                      //updatingData: widget.updatingData,
                                      callback: () {});
                                },
                              ))
                            ]);
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }));
  }
}
