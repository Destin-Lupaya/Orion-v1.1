import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/caution.provider.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Helpers/transaction.helper.dart';
import 'package:orion/Resources/Models/caution.model.dart';
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

class NewCautionPage extends StatefulWidget {
  // final bool updatingData;

  NewCautionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewCautionPage> createState() => _NewCautionPageState();
}

class _NewCautionPageState extends State<NewCautionPage> {
  TransactionsStateProvider? _transactionProvider;

  TransactionsStateProvider getProvider({required bool listen}) {
    _transactionProvider = Provider.of<TransactionsStateProvider>(
        navKey.currentContext!,
        listen: listen);
    return _transactionProvider!;
  }

  final TextEditingController _clientCtrller = TextEditingController();
  final TextEditingController _montantCtrller = TextEditingController();
  final TextEditingController _motifCtrller =
      TextEditingController(text: 'R.A.S');

  @override
  void initState() {
    super.initState();
  }

  bool isExternalTransaction = false;
  String? clientID, currency;

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
                physics: const BouncingScrollPhysics(),
                children: [
                  CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: "Dépôt caution",
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
                                      child: SearchableTextFormFieldWidget(
                                          overlayColor:
                                              AppColors.kBlackLightColor,
                                          hintText: 'Client',
                                          textColor: AppColors.kWhiteColor,
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          editCtrller: _clientCtrller,
                                          callback: (data) {
                                            clientID = data.toString();
                                            print(clientID);
                                            setState(() {});
                                          },
                                          data: context
                                              .read<ClientProvider>()
                                              .dataList
                                              .map((e) => e.toJson())
                                              .toList(),
                                          displayColumn: 'name',
                                          secondDisplayColumn: 'phone',
                                          indexColumn: 'id')),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: TextFormFieldWidget(
                                          inputType: TextInputType.number,
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'Montant',
                                          isEnabled: true,
                                          editCtrller: _montantCtrller,
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
                                      child: CustomDropdownButton(
                                          dropdownColor:
                                              AppColors.kBlackLightColor,
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          textColor: AppColors.kWhiteColor,
                                          value: currency,
                                          hintText: 'Devise',
                                          callBack: (value) {
                                            setState(() {
                                              currency = value;
                                            });
                                          },
                                          items: const ['USD', 'CDF'])),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: TextFormFieldWidget(
                                          inputType: TextInputType.text,
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'Motif',
                                          isEnabled: true,
                                          editCtrller: _motifCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 5)),
                                ],
                              ),
                              Consumer<TransactionsStateProvider>(
                                  builder: (context, transactionProvider, _) {
                                return appStateProvider.isAsync == false
                                    ? CustomButton(
                                        backColor: AppColors.kYellowColor,
                                        text: 'Enregistrer',
                                        textColor: AppColors.kBlackColor,
                                        callback: () {
                                          if (_montantCtrller.text.isEmpty) {
                                            Message.showToast(
                                                msg:
                                                    'Veuillez remplir tous les champs');
                                            return;
                                          }
                                          if (double.tryParse(_montantCtrller
                                                  .text
                                                  .trim()) ==
                                              null) {
                                            Message.showToast(
                                                msg:
                                                    'Veuillez saisir un montant valide');
                                            return;
                                          }
                                          if (clientID == null) {
                                            Message.showToast(
                                                msg:
                                                    'Veuillez choisir un client');
                                            return;
                                          }
                                          if (currency == null) {
                                            Message.showToast(
                                                msg:
                                                    'Veuillez choisir une devise');
                                            return;
                                          }
                                          Dialogs
                                              .showDialogWithActionCustomContent(
                                                  context: context,
                                                  title: 'Confirmation',
                                                  content: TextWidgets.text300(
                                                      title:
                                                          'Vous allez ajouter une caution du client ${_clientCtrller.text.trim()}',
                                                      fontSize: 14,
                                                      textColor: AppColors
                                                          .kBlackColor),
                                                  callback: () {
                                                    CautionHistoryModel data =
                                                        CautionHistoryModel(
                                                            external_clients_id:
                                                                clientID!,
                                                            account_id: context
                                                                .read<
                                                                    UserStateProvider>()
                                                                .clientAccountData[
                                                                    'id']!
                                                                .toString(),
                                                            typeOperation:
                                                                "Dépôt",
                                                            amount: double.parse(
                                                                _montantCtrller
                                                                    .text
                                                                    .trim()),
                                                            currency: currency,
                                                            motif: _motifCtrller
                                                                .text
                                                                .trim());
                                                    // print(data.toJson());
                                                    // return;
                                                    context
                                                        .read<CautionProvider>()
                                                        .saveData(
                                                            body: data,
                                                            callback: () {
                                                              Navigator.pop(
                                                                  context);
                                                            });
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
