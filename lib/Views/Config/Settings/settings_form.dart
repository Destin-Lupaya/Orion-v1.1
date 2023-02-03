import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/applogo.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Guichet/caisse.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Views/Config/Settings/Guichet/transfe_activity.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/accounts_stat_widget.dart';
import 'package:orion/Views/Login/login_page.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late UserStateProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserStateProvider>(context, listen: false);
    _nameCtrller.text = userProvider.clientData!.names ?? '';
    _usernameCtrller.text = userProvider.clientData!.username ?? '';
    _mailCtrller.text = userProvider.clientData!.email ?? '';
    _telephCtrller.text = userProvider.clientData!.telephone ?? '';
  }

  final TextEditingController _nameCtrller = TextEditingController();
  final TextEditingController _usernameCtrller = TextEditingController();
  final TextEditingController _pwdCtrller = TextEditingController();
  final TextEditingController _mailCtrller = TextEditingController();
  final TextEditingController _telephCtrller = TextEditingController();
  final TextEditingController _lastPwdCtrller = TextEditingController();
  final TextEditingController _retypeCtrller = TextEditingController();
  bool updateAccount = false, updatePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidgets.textBold(
                title: "Profile",
                fontSize: 36,
                textColor: AppColors.kBlackColor,
                align: TextAlign.center),
            // TextWidgets.text300(
            //     title:
            //         "Je suis un ${userProvider.clientData!.role} chez Okapi Shop",
            //     fontSize: 18,
            //     textColor: AppColors.kBlackColor,
            //     align: TextAlign.center),
            // const SizedBox(height: 64),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                direction:
                    Responsive.isWeb(context) ? Axis.horizontal : Axis.vertical,
                children: [
                  // Card(
                  //   child: userDetails(),
                  // ),
                  const SizedBox(width: 16),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userCard(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (Provider.of<TransactionsStateProvider>(
                                      navKey.currentContext!,
                                      listen: false)
                                  .accounts
                                  .isNotEmpty &&
                              (Provider.of<TransactionsStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .accounts[0]['activities'] !=
                                      null &&
                                  Provider.of<TransactionsStateProvider>(
                                          navKey.currentContext!,
                                          listen: false)
                                      .accounts[0]['activities']
                                      .isNotEmpty))
                            const Card(
                              elevation: 0,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: AccountStatWidget(),
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  userCard() {
    return Container(
      // width: 400,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidgets.textBold(
              title: "A propos",
              fontSize: 18,
              textColor: AppColors.kBlackColor,
              align: TextAlign.center),
          const SizedBox(height: 36),
          Center(
            child: Container(
              padding: const EdgeInsets.all(0),
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: const AppLogo(
                  size: Size(90, 90),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, color: AppColors.kGreyColor),
              const SizedBox(width: 8),
              TextWidgets.text300(
                  title: userProvider.clientData!.names!,
                  fontSize: 16,
                  textColor: AppColors.kBlackColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.mail, color: AppColors.kGreyColor),
              const SizedBox(width: 8),
              TextWidgets.text300(
                  title: userProvider.clientData!.email!,
                  fontSize: 16,
                  textColor: AppColors.kBlackColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.assignment_ind_rounded, color: AppColors.kGreyColor),
              const SizedBox(width: 8),
              TextWidgets.text300(
                  title: userProvider.clientData!.code,
                  fontSize: 16,
                  textColor: AppColors.kBlackColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.radio_button_checked_rounded,
                  color: AppColors.kGreyColor),
              const SizedBox(width: 8),
              TextWidgets.text300(
                  title: userProvider.clientData!.status.toLowerCase() == 'oui'
                      ? 'Actif'
                      : "Inactif",
                  fontSize: 16,
                  textColor: AppColors.kBlackColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.category, color: AppColors.kGreyColor),
              const SizedBox(width: 8),
              TextWidgets.text300(
                  title: userProvider.clientData!.role,
                  fontSize: 16,
                  textColor: AppColors.kBlackColor),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () {
              Dialogs.showModal(
                  title: 'Mot de passe',
                  backColor: AppColors.kWhiteColor,
                  content: updatePwd());
            },
            leading: Icon(Icons.lock_outline_rounded,
                color: AppColors.kBlackColor, size: 35),
            title: TextWidgets.textBold(
                title: 'Mot de passe',
                fontSize: 16,
                textColor: AppColors.kBlackColor),
            subtitle: TextWidgets.text300(
                title: 'Modifier votre mot passe',
                fontSize: 12,
                textColor: AppColors.kBlackColor),
          ),
          if (Provider.of<UserStateProvider>(context, listen: false)
                  .clientData
                  ?.role
                  .toString()
                  .toLowerCase() !=
              'caissier')
            ListTile(
              onTap: () {
                Dialogs.showChoiceDialog(
                    context: context,
                    title: "Gerer les caisses",
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () {
                            Provider.of<AdminCaisseStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .getAccount();
                            Provider.of<AdminUserStateProvider>(context,
                                    listen: false)
                                .getActivitiesData(isRefresh: true);
                            Provider.of<AdminCaisseStateProvider>(context,
                                    listen: false)
                                .getBranches(isRefresh: true);
                            Provider.of<AdminUserStateProvider>(context,
                                    listen: false)
                                .getUsersData(isRefreshed: true);
                            Navigator.pop(context);
                            Dialogs.showModal(
                                backColor: AppColors.kWhiteColor,
                                title: "Modifier une caisse",
                                content: const DisplayCaissePage());

                            // showCupertinoModalPopup(
                            //     context: context,
                            //     builder: (context) => Container(
                            //           width: Responsive.isWeb(context)
                            //               ? MediaQuery.of(context)
                            //                       .size
                            //                       .width /
                            //                   1.5
                            //               : MediaQuery.of(context)
                            //                       .size
                            //                       .width -
                            //                   40,
                            //           child: const Center(
                            //               child: DisplayCaissePage()),
                            //         ));
                          },
                          tileColor: AppColors.kTextFormWhiteColor,
                          title: TextWidgets.textNormal(
                              title:
                                  "Ajouter une caisse ou des activités à une caisse",
                              fontSize: 14,
                              textColor: AppColors.kBlackColor),
                        ),
                        ListTile(
                          tileColor: AppColors.kTextFormWhiteColor,
                          onTap: () {
                            Dialogs.showNormalModal(
                                // title: "Gerer les caisses",
                                content: const TransferActivityPage());
                          },
                          title: TextWidgets.textNormal(
                              title: "Transferer une activité",
                              fontSize: 14,
                              textColor: AppColors.kBlackColor),
                        ),
                        // ListTile(
                        //   tileColor: AppColors.kTextFormWhiteColor,
                        //   onTap: () {},
                        //   title: TextWidgets.textNormal(
                        //       title:
                        //           "Ajouter des activités à une caisse",
                        //       fontSize: 14,
                        //       textColor: AppColors.kBlackColor),
                        // ),
                      ],
                    ));
              },
              leading: Icon(Icons.account_balance_wallet,
                  color: AppColors.kBlackColor, size: 35),
              title: TextWidgets.textBold(
                  title: 'Caisses',
                  fontSize: 16,
                  textColor: AppColors.kBlackColor),
              subtitle: TextWidgets.text300(
                  title: 'Faire la gestion des caisses',
                  fontSize: 12,
                  textColor: AppColors.kBlackColor),
            ),
          ListTile(
            onTap: () {
              Dialogs.showDialogWithActionCustomContent(
                  context: context,
                  title: 'Confirmation',
                  content: Column(
                    children: [
                      TextWidgets.text300(
                          title:
                              'Voulez-vous déconnecter votre compte?\nVous serez obligé de vous reconnecter',
                          fontSize: 14,
                          textColor: AppColors.kBlackColor)
                    ],
                  ),
                  callback: () {
                    prefs.clear();
                    // Provider.of<MenuStateProvider>(context, listen: false)
                    //     .initMenu(context: context);
                    Navigation.pushReplaceNavigate(
                        context: context, page: LoginPage());
                    Provider.of<UserStateProvider>(context, listen: false)
                        .logOut();
                  });
            },
            leading: Icon(Icons.logout_rounded,
                color: AppColors.kBlackColor, size: 35),
            title: TextWidgets.textBold(
                title: 'Déconnexion',
                fontSize: 16,
                textColor: AppColors.kBlackColor),
            subtitle: TextWidgets.text300(
                title: 'Déconnecter mon compte',
                fontSize: 12,
                textColor: AppColors.kBlackColor),
          ),
          const SizedBox(height: 8),
          if (updatePassword == true) updatePwd(),
        ],
      ),
    );
  }

  // userDetails() {
  //   return Container(
  //       padding: const EdgeInsets.all(8.0),
  //       width: Responsive.isWeb(context) ? 200 : double.maxFinite,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           TextWidgets.textBold(
  //               title: "Details",
  //               fontSize: 18,
  //               textColor: AppColors.kBlackColor,
  //               align: TextAlign.center),
  //           const SizedBox(height: 36),
  //           TextWidgets.text300(
  //               title: userProvider.clientData!.names!,
  //               fontSize: 20,
  //               textColor: AppColors.kBlackColor),
  //           const SizedBox(height: 16),
  //           TextWidgets.textWithLabel(
  //               title: "E-mail",
  //               value: userProvider.clientData!.email!,
  //               fontSize: 14,
  //               textColor: AppColors.kBlackColor),
  //           const SizedBox(height: 8),
  //           TextWidgets.textWithLabel(
  //               title: "Code",
  //               value: userProvider.clientData!.code,
  //               fontSize: 14,
  //               textColor: AppColors.kBlackColor),
  //           const SizedBox(height: 8),
  //           TextWidgets.textWithLabel(
  //               title: "Role",
  //               value: userProvider.clientData!.role,
  //               fontSize: 14,
  //               textColor: AppColors.kBlackColor),
  //           const SizedBox(height: 8),
  //           TextWidgets.textWithLabel(
  //               title: "Actif",
  //               value: userProvider.clientData!.status,
  //               fontSize: 14,
  //               textColor: AppColors.kBlackColor),
  //           const SizedBox(height: 24),
  //           Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // CustomButton(
  //               //     text: 'Modifier',
  //               //     backColor: AppColors.kYellowColor,
  //               //     textColor: AppColors.kBlackColor,
  //               //     callback: () {
  //               //       setState(() {
  //               //         updateAccount = !updateAccount;
  //               //         updatePassword = false;
  //               //       });
  //               //     }),
  //               // const SizedBox(height: 8),
  //               CustomButton(
  //                   text: 'Securité',
  //                   backColor: AppColors.kGreenColor,
  //                   textColor: AppColors.kWhiteColor,
  //                   callback: () {
  //                     setState(() {
  //                       updatePassword = !updatePassword;
  //                       updateAccount = false;
  //                     });
  //                   }),
  //               if (Provider.of<UserStateProvider>(context, listen: false)
  //                       .clientData
  //                       ?.role
  //                       .toString()
  //                       .toLowerCase() !=
  //                   'caissier')
  //                 CustomButton(
  //                     text: 'Gerer les caisses',
  //                     backColor: AppColors.kGreenColor,
  //                     textColor: AppColors.kWhiteColor,
  //                     callback: () {
  //                       Dialogs.showChoiceDialog(
  //                           context: context,
  //                           title: "Gerer les caisses",
  //                           content: Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               ListTile(
  //                                 onTap: () {
  //                                   Provider.of<AdminCaisseStateProvider>(
  //                                           navKey.currentContext!,
  //                                           listen: false)
  //                                       .getAccount();
  //                                   Provider.of<AdminUserStateProvider>(context,
  //                                           listen: false)
  //                                       .getActivitiesData(isRefresh: true);
  //                                   Provider.of<AdminCaisseStateProvider>(
  //                                           context,
  //                                           listen: false)
  //                                       .getBranches(isRefresh: true);
  //                                   Provider.of<AdminUserStateProvider>(context,
  //                                           listen: false)
  //                                       .getUsersData(isRefreshed: true);
  //                                   Navigator.pop(context);
  //                                   Dialogs.showModal(
  //                                       title: "Modifier une caisse",
  //                                       content: DisplayCaissePage());

  //                                   // showCupertinoModalPopup(
  //                                   //     context: context,
  //                                   //     builder: (context) => Container(
  //                                   //           width: Responsive.isWeb(context)
  //                                   //               ? MediaQuery.of(context)
  //                                   //                       .size
  //                                   //                       .width /
  //                                   //                   1.5
  //                                   //               : MediaQuery.of(context)
  //                                   //                       .size
  //                                   //                       .width -
  //                                   //                   40,
  //                                   //           child: const Center(
  //                                   //               child: DisplayCaissePage()),
  //                                   //         ));
  //                                 },
  //                                 tileColor: AppColors.kTextFormWhiteColor,
  //                                 title: TextWidgets.textNormal(
  //                                     title:
  //                                         "Ajouter une caisse ou des activités à une caisse",
  //                                     fontSize: 14,
  //                                     textColor: AppColors.kBlackColor),
  //                               ),
  //                               ListTile(
  //                                 tileColor: AppColors.kTextFormWhiteColor,
  //                                 onTap: () {
  //                                   Dialogs.showNormalModal(
  //                                       // title: "Gerer les caisses",
  //                                       content: const TransferActivityPage());
  //                                 },
  //                                 title: TextWidgets.textNormal(
  //                                     title: "Transferer une activité",
  //                                     fontSize: 14,
  //                                     textColor: AppColors.kBlackColor),
  //                               ),
  //                               // ListTile(
  //                               //   tileColor: AppColors.kTextFormWhiteColor,
  //                               //   onTap: () {},
  //                               //   title: TextWidgets.textNormal(
  //                               //       title:
  //                               //           "Ajouter des activités à une caisse",
  //                               //       fontSize: 14,
  //                               //       textColor: AppColors.kBlackColor),
  //                               // ),
  //                             ],
  //                           ));
  //                     }),
  //               CustomButton(
  //                   text: 'Logout',
  //                   backColor: AppColors.kRedColor,
  //                   textColor: AppColors.kBlackColor,
  //                   callback: () {
  //                     Dialogs.showDialogWithActionCustomContent(
  //                         context: context,
  //                         title: 'Confirmation',
  //                         content: Column(
  //                           children: [
  //                             TextWidgets.text300(
  //                                 title:
  //                                     'Voulez-vous déconnecter votre compte?\nVous serez obligé de vous reconnecter',
  //                                 fontSize: 14,
  //                                 textColor: AppColors.kBlackColor)
  //                           ],
  //                         ),
  //                         callback: () {
  //                           prefs.clear();
  //                           // Provider.of<MenuStateProvider>(context, listen: false)
  //                           //     .initMenu(context: context);
  //                           Navigation.pushReplaceNavigate(
  //                               context: context, page: LoginPage());
  //                           Provider.of<UserStateProvider>(context,
  //                                   listen: false)
  //                               .logOut();
  //                         });
  //                   }),
  //             ],
  //           )
  //         ],
  //       ));
  // }

  updateUser() {
    return Card(
      elevation: 0,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextWidgets.textBold(
            title: "Modifier l'utilisateur",
            fontSize: 20,
            textColor: AppColors.kBlackColor),
        Row(children: [
          Expanded(
            child: TextFormFieldWidget(
              maxLines: 1,
              editCtrller: _nameCtrller,
              hintText: 'Noms',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormWhiteColor,
            ),
          ),
          Expanded(
            child: TextFormFieldWidget(
              maxLines: 1,
              editCtrller: _usernameCtrller,
              hintText: 'Nom d\'Utilisateur',
              textColor: AppColors.kBlackColor,
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
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormWhiteColor,
            ),
          ),
          Expanded(
            child: TextFormFieldWidget(
              maxLines: 1,
              editCtrller: _mailCtrller,
              hintText: 'Email',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormWhiteColor,
            ),
          ),
        ]),
        Row(
          children: [
            Expanded(
              child: Consumer<UserStateProvider>(
                  builder: (context, userStateProvider, _) {
                return CustomButton(
                  text: 'Enregistrer',
                  backColor: AppColors.kYellowColor,
                  textColor: AppColors.kBlackColor,
                  callback: () {
                    Map data = {
                      "id": userProvider.clientData!.id!.toString(),
                      "names": _nameCtrller.text.trim(),
                      "telephone": _telephCtrller.text.trim(),
                      "email": _mailCtrller.text.trim(),
                      "username": _usernameCtrller.text.trim(),
                      "statusActive": "1",
                    };
                    if (data['names'].isEmpty ||
                        data['email'] == null ||
                        data['telephone'] == null ||
                        data['username'] == null ||
                        data['psw'] == null) {
                      return Message.showToast(
                          msg: "Veuillez remplir les champs");
                    }
                    userStateProvider.updateUser(
                        context: context,
                        client: data,
                        callback: () {
                          _nameCtrller.text = "";
                          _telephCtrller.text = "";
                          _mailCtrller.text = "";
                          _usernameCtrller.text = "";
                          _pwdCtrller.text = "";
                          _lastPwdCtrller.text = "";
                          _retypeCtrller.text = "";
                        });
                  },
                );
              }),
            ),
            Expanded(child: Container())
          ],
        )
      ]),
    );
  }

  updatePwd() {
    return Card(
      elevation: 0,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextWidgets.textBold(
            title: "Modifier le mot de passe",
            fontSize: 20,
            textColor: AppColors.kBlackColor),
        Row(children: [
          Expanded(
            child: TextFormFieldWidget(
              maxLines: 1,
              editCtrller: _lastPwdCtrller,
              hintText: 'Ancien Mot de passe',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
            ),
          ),
          Expanded(
            child: TextFormFieldWidget(
              maxLines: 1,
              editCtrller: _pwdCtrller,
              hintText: 'Nouveau Mot de passe',
              textColor: AppColors.kBlackColor,
              backColor: AppColors.kTextFormBackColor,
            ),
          ),
        ]),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormFieldWidget(
                maxLines: 1,
                editCtrller: _retypeCtrller,
                hintText: 'Retapez',
                textColor: AppColors.kBlackColor,
                backColor: AppColors.kTextFormBackColor,
              ),
            ),
            Expanded(
              child: Consumer<UserStateProvider>(
                  builder: (context, userStateProvider, _) {
                return CustomButton(
                  text: 'Enregistrer',
                  backColor: AppColors.kYellowColor,
                  textColor: AppColors.kBlackColor,
                  callback: () {
                    // print(_pwdCtrller.text.trim() !=
                    //     userProvider.clientData!.password!.trim());
                    //     print(_pwdCtrller.text.trim());
                    //     print(
                    //     userProvider.clientData!.password!.trim());
                    if (_pwdCtrller.text.isEmpty ||
                        _lastPwdCtrller.text.isEmpty ||
                        _retypeCtrller.text.isEmpty) {
                      return Message.showToast(
                          msg: "Veuillez Remplir tous les champs");
                    }
                    if (_pwdCtrller.text.trim() != _retypeCtrller.text.trim()) {
                      return Message.showToast(
                          msg: "Les mots de passe ne correspondent pas");
                    }
                    if (_lastPwdCtrller.text.trim() !=
                        userProvider.clientData!.password!.trim()) {
                      return Message.showToast(
                          msg: "Ancien mot de passe incorrect");
                    }
                    Map data = {
                      "id": userProvider.clientData!.id!.toString(),
                      "pin": _pwdCtrller.text.trim(),
                      "psw": _pwdCtrller.text.trim(),
                    };
                    userStateProvider.updateUser(
                        context: context,
                        client: data,
                        callback: () {
                          _nameCtrller.text = "";
                          _telephCtrller.text = "";
                          _mailCtrller.text = "";
                          _usernameCtrller.text = "";
                          _pwdCtrller.text = "";
                          _lastPwdCtrller.text = "";
                          _retypeCtrller.text = "";
                        });
                  },
                );
              }),
            ),
          ],
        )
      ]),
    );
  }
}
