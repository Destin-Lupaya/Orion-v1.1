import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/provider.dart';

class IncidentEnclosePage extends StatefulWidget {
  String clotureID;
  IncidentEnclosePage({Key? key, required this.clotureID}) : super(key: key);

  @override
  _IncidentEnclosePageState createState() => _IncidentEnclosePageState();
}

class _IncidentEnclosePageState extends State<IncidentEnclosePage> {
  final TextEditingController _amountCtrller = TextEditingController();
  String? incidentType, currency;
  TransactionsStateProvider? transactionProvider;

  @override
  void initState() {
    // print(widget.encloseData['billetage']);
    transactionProvider =
        Provider.of<TransactionsStateProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height * .85,
        // color: AppColors.kBlackLightColor,
        child:
            Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
          return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ListView(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: 'Incidents de la cloture',
                      content: Column(children: [
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Row(children: [
                              Expanded(
                                  child: TextFormFieldWidget(
                                maxLines: 1,
                                hintText: 'Montant ',
                                editCtrller: _amountCtrller,
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              )),
                              Flexible(
                                  child: CustomDropdownButton(
                                      dropdownColor: AppColors.kBlackLightColor,
                                      backColor: AppColors.kTextFormWhiteColor,
                                      textColor: AppColors.kWhiteColor,
                                      value: currency,
                                      hintText: 'Devise',
                                      callBack: (data) {
                                        currency = data;
                                        setState(() {});
                                      },
                                      items: const ["USD", "CDF"])),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: CustomDropdownButton(
                                    dropdownColor: AppColors.kBlackLightColor,
                                    backColor: AppColors.kTextFormWhiteColor,
                                    textColor: AppColors.kWhiteColor,
                                    value: incidentType,
                                    hintText: 'Type d\'incident',
                                    callBack: (data) {
                                      incidentType = data;
                                      setState(() {});
                                    },
                                    items: const [
                                  "Manquant",
                                  "Excedant",
                                  "Paiement montant manquant"
                                ])),
                            Expanded(
                              child: CustomButton(
                                text: 'Valider',
                                backColor: AppColors.kRedColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () {
                                  Dialogs.showDialogWithActionCustomContent(
                                      context: context,
                                      title: "Confirmation",
                                      content: Container(
                                          child: TextWidgets.text300(
                                              title:
                                                  "Voulez-vous vraiment enregistrer cet incident?",
                                              fontSize: 14,
                                              textColor: AppColors.kGreyColor)),
                                      callback: () {
                                        Navigator.pop(context);
                                        Map data = {
                                          "cloture_account_id":
                                              widget.clotureID,
                                          "montant": _amountCtrller.text.trim(),
                                          "currency": currency,
                                          "type_incident": incidentType,
                                        };
                                        context
                                            .read<ClotureProvider>()
                                            .addIncidents(
                                                body: data, callback: () {});
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ]),
                    )
                  ]));
        }));
  }
}
