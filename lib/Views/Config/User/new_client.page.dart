import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Helpers/transaction.helper.dart';
import 'package:orion/Resources/Models/external_client.model.dart';

// import 'package:orion/Resources/Components/textsargent_model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

//import "package:dialog/~file~";
blockSeparator({required String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(),
      const SizedBox(
        height: 20,
      ),
      TextWidgets.text500(
          title: title,
          fontSize: 14,
          textColor: AppColors.kWhiteColor.withOpacity(0.5)),
    ],
  );
}

class NewClientPage extends StatefulWidget {
  final bool updatingData;

  NewClientPage({
    Key? key,
    required this.updatingData,
  }) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  TransactionsStateProvider? _transactionProvider;

  TransactionsStateProvider getProvider({required bool listen}) {
    _transactionProvider = Provider.of<TransactionsStateProvider>(
        navKey.currentContext!,
        listen: listen);
    return _transactionProvider!;
  }

  final TextEditingController _nameCtrller = TextEditingController();
  final TextEditingController _emailCtrller = TextEditingController();
  final TextEditingController _clientNumberCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool isExternalTransaction = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.kTransparentColor,
        child: Container(
            width: !Responsive.isWeb(context)
                ? MediaQuery.of(context).size.width - 40
                : MediaQuery.of(context).size.width / 1.7,

            // height: MediaQuery.of(context).size.height * .85,
            // color: AppColors.kBlackLightColor,
            child: Consumer<AppStateProvider>(
                builder: (context, appStateProvider, _) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                shrinkWrap: true,
                physics: widget.updatingData == false
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                children: [
                  CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: "Nouveau client",
                      titleColor: AppColors.kWhiteColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              blockSeparator(title: 'Coordonnees du client'),
                              Flex(
                                direction: !Responsive.isMobile(context)
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                mainAxisSize: !Responsive.isMobile(context)
                                    ? MainAxisSize.max
                                    : MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: TextFormFieldWidget(
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'Nom complet',
                                          isEnabled: true,
                                          editCtrller: _nameCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 1)),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: TextFormFieldWidget(
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'N° Téléphone',
                                          isEnabled: true,
                                          editCtrller: _clientNumberCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 1)),
                                ],
                              ),
                              Flex(
                                direction: !Responsive.isMobile(context)
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                mainAxisSize: !Responsive.isMobile(context)
                                    ? MainAxisSize.max
                                    : MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: TextFormFieldWidget(
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'E-mail',
                                          isEnabled: true,
                                          editCtrller: _emailCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 1)),
                                  Flexible(
                                      fit: FlexFit.loose, child: Container()),
                                ],
                              ),
                              Consumer<TransactionsStateProvider>(
                                  builder: (context, transactionProvider, _) {
                                return appStateProvider.isAsync == false
                                    ? CustomButton(
                                        backColor: AppColors.kYellowColor,
                                        text: widget.updatingData == false
                                            ? 'Enregistrer'
                                            : "Modifier",
                                        textColor: AppColors.kBlackColor,
                                        callback: () {
                                          if (_nameCtrller.text.isEmpty ||
                                              _clientNumberCtrller
                                                  .text.isEmpty) {
                                            Message.showToast(
                                                msg:
                                                    'Veuillez remplir tous les champs');
                                            return;
                                          }
                                          if (!_clientNumberCtrller.text
                                              .contains('+')) {
                                            Message.showToast(
                                                msg:
                                                    'Numéro de téléphone incorrect, veuillez spécifier le code pays');
                                            return;
                                          }
                                          ExternalClientModel data =
                                              ExternalClientModel(
                                                  name:
                                                      _nameCtrller.text.trim(),
                                                  phone: _clientNumberCtrller
                                                      .text
                                                      .trim(),
                                                  email: _emailCtrller.text
                                                      .trim());
                                          context
                                              .read<ClientProvider>()
                                              .saveData(
                                                  body: data,
                                                  callback: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                        })
                                    : Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.kYellowColor),
                                        ),
                                      );
                              })
                            ],
                          )
                        ],
                      ))
                ],
              );
            })));
    //     ),
    //   ),
    // );
  }
}
