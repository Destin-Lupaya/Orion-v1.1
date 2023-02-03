import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Admin_Orion/Resources/Components/empty_model.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Helpers/validators.dart';
import 'package:orion/Admin_Orion/Resources/Models/utilisateur_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Views/Guichet/update_user.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/titlebar.widget.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<adminAppStateProvider>(
        builder: (context, appStateProvider, _) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.kGreenColor,
          onPressed: () {
            Dialogs.showModal(
                title: 'Utilisateurs',
                content: const CreateUserPage(updatingData: false));
          },
          child: Icon(Icons.add, color: AppColors.kWhiteColor),
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleBarWidget(
                  searchCtrller: TextEditingController(),
                  title: 'Utilisateurs',
                  callback: () {
                    Provider.of<AdminUserStateProvider>(context, listen: false)
                        .getUsersData(isRefreshed: false);
                  }),
              const DisplayUserPageState()
            ],
          ),
        ),
      );
    });
  }
}

class CreateUserPage extends StatefulWidget {
  final bool updatingData;
  final ClientModel? clientModel;

  const CreateUserPage({Key? key, required this.updatingData, this.clientModel})
      : super(key: key);

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

String? nomFournisseur;
String? membreInterne;

String? nomMembre;

class _CreateUserPageState extends State<CreateUserPage> {
  final PageController _controller = PageController();
  final TextEditingController _nameCtrller = TextEditingController();
  final TextEditingController _roleCtrller = TextEditingController();
  final TextEditingController _usernameCtrller = TextEditingController();
  final TextEditingController _pwdCtrller = TextEditingController();
  final TextEditingController _mailCtrller = TextEditingController();
  final TextEditingController _telephCtrller = TextEditingController();
  final TextEditingController _pwhCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _nameCtrller.text = widget.clientModel!.names.trim();
      _usernameCtrller.text = widget.clientModel!.username.toString().trim();
      _roleCtrller.text = widget.clientModel!.password.toString().trim();
      _mailCtrller.text = widget.clientModel!.email.toString().trim();
      _telephCtrller.text = widget.clientModel!.telephone.toString().trim();
      _pwhCtrller.text = widget.clientModel!.password.toString().trim();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<AdminUserStateProvider>(context, listen: false)
          .getUsersData(isRefreshed: false);
    });
  }

  List<String> genderList = ["Homme", "Femme"];
  String currentGender = "Homme";
  List<String> typeUserList = ["Caissier", "Agregateur", "Comptable", "admin"];
  String currentUser = "Caissier";

  // String currentRole = "Backoffice";
  String currentUserType = "Backoffice";

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      backColor: AppColors.kBlackLightColor,
      titleColor: AppColors.kWhiteColor,
      title: 'Ajouter un utilisateur',
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
                  backColor: AppColors.kTextFormBackColor.withOpacity(1),
                  textColor: AppColors.kWhiteColor,
                  value: currentUser,
                  hintText: "Role",
                  callBack: (newValue) {
                    setState(() {
                      currentUser = newValue;
                    });
                  },
                  items: typeUserList),
            ),
            Expanded(
              child: TextFormFieldWidget(
                maxLines: 1,
                isObsCured: true,
                editCtrller: _pwdCtrller,
                hintText: 'Mot de passe',
                textColor: AppColors.kWhiteColor,
                backColor: AppColors.kTextFormWhiteColor,
              ),
            ),
          ]),
          Consumer<AdminUserStateProvider>(
              builder: (context, userStateProvider, _) {
            return CustomButton(
              canSync: true,
              text: 'Enregistrer',
              backColor: AppColors.kYellowColor,
              textColor: AppColors.kWhiteColor,
              callback: () {
                if (Validators.emailValidator(_mailCtrller.text.trim()) !=
                    null) {
                  Message.showToast(
                      msg: "Veuillez saisir une adresse mail valide");
                  return;
                }
                Map data = {
                  "names": _nameCtrller.text.trim(),
                  "telephone": _telephCtrller.text.trim(),
                  "email": _mailCtrller.text.trim(),
                  "username": _usernameCtrller.text.trim(),
                  "psw": _pwdCtrller.text.trim(),
                  "pin": _pwdCtrller.text.trim(),
                  "role": currentUser,
                  "code": _nameCtrller.text.trim().substring(0, 2) +
                      "${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().millisecond}",
                  "statusActive": "1",
                };

                userStateProvider.addclient(
                    context: context,
                    clientModel: data,
                    updatingData: widget.updatingData,
                    callback: () {
                      _nameCtrller.text = "";
                      _telephCtrller.text = "";
                      _mailCtrller.text = "";
                      _usernameCtrller.text = "";
                      _pwdCtrller.text = "";
                      currentUser = "Caissier";
                    });
              },
            );
          })
        ],
      ),
    );
  }
}

class DisplayUserPageState extends StatelessWidget {
  const DisplayUserPageState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUserStateProvider>(
      builder: (context, userStateProvider, child) {
        // print(userStateProvider.clients.length);
        return userStateProvider.clients.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Container(
                  //         alignment: Alignment.centerRight,
                  //         child: IconButton(
                  //             onPressed: () {
                  //               Provider.of<AdminUserStateProvider>(context,
                  //                       listen: false)
                  //                   .getUsersData(isRefreshed: false);
                  //             },
                  //             icon: Icon(Icons.autorenew,
                  //                 color: AppColors.kBlackColor))),
                  //   ],
                  // ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userStateProvider.clients.length,
                        itemBuilder: (context, int index) {
                          return ListItem(
                              data: userStateProvider.clients[index].toJson());
                        }),
                  )
                ],
              )
            : Column(mainAxisSize: MainAxisSize.min, children: [
                EmptyModel(color: AppColors.kGreyColor),
                Container(
                  width: 200,
                  child: CustomButton(
                      text: "Actualiser",
                      backColor: Colors.grey[200]!,
                      textColor: AppColors.kBlackColor,
                      callback: () {
                        Provider.of<AdminUserStateProvider>(context,
                                listen: false)
                            .getUsersData(isRefreshed: true);
                      }),
                ),
              ]);
      },
    );
  }
}

class ListItem extends StatefulWidget {
  final Map data;

  const ListItem({Key? key, required this.data}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  // Color borderColor = AppColors.kTransparentColor;
  bool isViewingMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
            // onTap: null,
            onTap: () {
              setState(() {
                isViewingMore = !isViewingMore;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  // border: Border.all(color: borderColor),
                  color: AppColors.kTextFormBackColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: Card(
                      color: AppColors.kWhiteColor.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(Icons.person,
                              color: AppColors.kBlackColor, size: 30)),
                    ),
                    trailing: Card(
                      color: AppColors.kWhiteColor.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextWidgets.textBold(
                              overflow: TextOverflow.ellipsis,
                              title:
                                  widget.data['code'].toString().toUpperCase(),
                              fontSize: 14,
                              textColor: AppColors.kBlackColor)),
                    ),
                    title: TextWidgets.textBold(
                        overflow: TextOverflow.ellipsis,
                        title: widget.data['names'].toString().toUpperCase(),
                        fontSize: 14,
                        textColor: AppColors.kBlackColor),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextWidgets.text300(
                              overflow: TextOverflow.ellipsis,
                              title:
                                  widget.data['role'].toString().toUpperCase(),
                              fontSize: 12,
                              textColor: AppColors.kGreyColor),
                          const SizedBox(height: 8),
                          Visibility(
                              visible: isViewingMore,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => Center(
                                                          child: UpdateUserPage(
                                                        clientModel: ClientModel
                                                            .fromJson(
                                                                widget.data),
                                                        updatingData: true,
                                                      )));
                                            },
                                            child: Card(
                                                color: AppColors.kBlackColor
                                                    .withOpacity(0.1),
                                                child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: TextWidgets.text300(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        title:
                                                            'Modifier l\'utilisateur',
                                                        fontSize: 12,
                                                        textColor: AppColors
                                                            .kGreyColor))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                        // mainAxisAlignment: MainAxisAlignment
                                        //     .spaceBetween,
                                        runAlignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        runSpacing: 8,
                                        spacing: 8,
                                        children: [
                                          TextWidgets.textWithLabel(
                                              title: 'Nom',
                                              fontSize: 14,
                                              textColor: AppColors.kBlackColor,
                                              value: widget.data['names']
                                                  .toString()
                                                  .toUpperCase()),
                                          TextWidgets.textWithLabel(
                                              title: 'E-mail',
                                              fontSize: 14,
                                              textColor: AppColors.kBlackColor,
                                              value: widget.data['email']
                                                  .toString()
                                                  .toLowerCase()),
                                          TextWidgets.textWithLabel(
                                              title: 'Phone ',
                                              fontSize: 14,
                                              textColor: AppColors.kBlackColor,
                                              value: widget.data['telephone']
                                                  .toString()),
                                          TextWidgets.textWithLabel(
                                              title: 'Role ',
                                              fontSize: 14,
                                              textColor: AppColors.kBlackColor,
                                              value: widget.data['role']
                                                  .toString()),
                                          TextWidgets.textWithLabel(
                                              title: 'Statut ',
                                              fontSize: 14,
                                              textColor: widget
                                                          .data['statusActive']
                                                          .toString() ==
                                                      "1"
                                                  ? AppColors.kGreenColor
                                                  : AppColors.kRedColor,
                                              value: widget.data['statusActive']
                                                          .toString() ==
                                                      "1"
                                                  ? "Actif"
                                                  : "Inactif"),
                                        ]),
                                  ]))
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
