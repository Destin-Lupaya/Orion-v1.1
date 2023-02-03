import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Helpers/date_parser.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Cloture/cloture_incidents.page.dart';
import 'package:orion/Views/Guichet/Cloture/enclose_helper.dart';
import 'package:provider/provider.dart';

class AcceptEnclosePage extends StatefulWidget {
  final bool updatingData;
  final Map accountData;
  final Map encloseData;

  const AcceptEnclosePage(
      {Key? key,
      required this.accountData,
      required this.updatingData,
      required this.encloseData})
      : super(key: key);

  @override
  _AcceptEnclosePageState createState() => _AcceptEnclosePageState();
}

class _AcceptEnclosePageState extends State<AcceptEnclosePage> {
  final TextEditingController _receivedUSDCtrller = TextEditingController(),
      _receivedCDFCtrller = TextEditingController(),
      _commentCtrller = TextEditingController(text: "R.A.S");
  Map? receiverInfo;
  Map? senderInfo;

  // Map? receiverUser, senderUser;
  TransactionsStateProvider? transactionProvider;
  EncloseAction? encloseAction;

  @override
  void initState() {
    // print(widget.encloseData['billetage']);
    transactionProvider =
        Provider.of<TransactionsStateProvider>(context, listen: false);
    super.initState();

    if (widget.updatingData == true) {
      encloseAction = EncloseAction.Update;
      senderInfo = transactionProvider!.othersAccounts
          .where((account) =>
              account['id'].toString() ==
              widget.encloseData['sender_id'].toString())
          .toList()[0];
      receiverInfo = widget.accountData;
      if (widget.accountData['id'].toString() ==
          widget.encloseData['sender_id'].toString()) {
        encloseAction = EncloseAction.View;
      }
      if (widget.accountData['id'].toString() ==
          widget.encloseData['receiver_id'].toString()) {
        encloseAction = EncloseAction.Update;
      }
      if (widget.encloseData['status'].toString().toLowerCase() == 'accepted') {
        encloseAction = EncloseAction.View;
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (senderInfo != null) {
        // receiverInfo = await transactionProvider!.getReceiverAccountActivities(
        //     accountID: receiverInfo!['id'].toString());
        // print(receiverInfo);
        if (widget.updatingData == true) {
          getActivitiesDifferences();
        }
      }
    });
  }

  List senderMovingActivities = [], senderExistingActivities = [];

  getActivitiesDifferences() async {
    senderInfo = await transactionProvider!
        .getReceiverAccountActivities(accountID: senderInfo!['id'].toString());

    for (int i = 0; i < senderInfo!['activities'].length; i++) {
      if (!receiverInfo!['activities']
          .map((e) => e['activity_id'])
          .toList()
          .contains(senderInfo!['activities'][i]['activity_id'])) {
        Map data = senderInfo!['activities'][i];
        data.remove('avatar');
        data.remove('name');
        data.remove('created_at');
        data.remove('updated_at');
        senderMovingActivities.add(data);
      } else {
        Map data = senderInfo!['activities'][i];
        data.remove('avatar');
        data.remove('name');
        data.remove('created_at');
        data.remove('updated_at');
        senderExistingActivities.add(data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height * .85,
        color: AppColors.kTransparentColor,
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
                      title: 'Details de la cloture',
                      content: Column(children: [
                        const SizedBox(height: 16),
                        cardStatsWidget(
                            hasDetails: true,
                            title: encloseAction == EncloseAction.View &&
                                    widget.accountData['id'].toString() ==
                                        senderInfo!['id'].toString()
                                ? receiverInfo!['names']
                                    .toString()
                                    .toUpperCase()
                                : senderInfo!['names'].toString().toUpperCase(),
                            subtitle:
                                widget.encloseData['date_send'].toString(),
                            backColor: AppColors.kTextFormWhiteColor,
                            textColor: AppColors.kWhiteColor,
                            icon: Icons.credit_card,
                            currency: "",
                            value:
                                "${widget.encloseData['amount_cdf'].toString()} CDF",
                            value2:
                                "${widget.encloseData['amount_usd'].toString()} USD"),
                        if (encloseAction == EncloseAction.View &&
                            widget.encloseData['status']
                                    .toString()
                                    .toLowerCase() ==
                                'accepted')
                          ...List.generate(
                              widget.encloseData['activities'].length, (index) {
                            // Map data =
                            // widget.encloseData['activities'][index];
                            // print(data);
                            return GestureDetector(
                              child: cardStatsWidget(
                                  title: widget.encloseData['activities'][index]
                                          ['name']
                                      .toString()
                                      .toUpperCase(),
                                  subtitle:
                                      "Stock : ${widget.encloseData['activities'][index]['stock'].toString()} -> ${widget.encloseData['activities'][index]['received_stock'].toString()}",
                                  backColor: AppColors.kTextFormWhiteColor,
                                  textColor: AppColors.kWhiteColor,
                                  icon: Icons.credit_card,
                                  currency: "",
                                  value:
                                      "CDF: ${widget.encloseData['activities'][index]['amount_cdf'].toString()}  -> ${widget.encloseData['activities'][index]['received_cdf'].toString()}",
                                  value2:
                                      "USD: ${widget.encloseData['activities'][index]['amount_usd'].toString()}  -> ${widget.encloseData['activities'][index]['received_usd'].toString()}"),
                            );
                          }),
                        if (encloseAction == EncloseAction.View &&
                            widget.encloseData['status']
                                    .toString()
                                    .toLowerCase() ==
                                'accepted')
                          cardStatsWidget(
                              title: "Montant recu",
                              subtitle: widget.encloseData['date_received']
                                  .toString(),
                              backColor: AppColors.kTextFormWhiteColor,
                              textColor: AppColors.kWhiteColor,
                              icon: Icons.credit_card,
                              currency: "",
                              value:
                                  "${widget.encloseData['received_cdf'].toString()} CDF",
                              value2:
                                  "${widget.encloseData['received_usd'].toString()} USD"),
                        if (encloseAction == EncloseAction.View &&
                            widget.encloseData['status']
                                    .toString()
                                    .toLowerCase() ==
                                'accepted')
                          cardStatsWidget(
                              title: "Solde",
                              subtitle: "Solde de la cloture",
                              backColor: AppColors.kTextFormWhiteColor,
                              textColor: AppColors.kWhiteColor,
                              icon: Icons.credit_card,
                              currency: "",
                              value:
                                  "${(double.parse(widget.encloseData['received_cdf'].toString()) - double.parse(widget.encloseData['amount_cdf'].toString())).toStringAsFixed(2)} CDF",
                              value2:
                                  "${(double.parse(widget.encloseData['received_usd'].toString()) - double.parse(widget.encloseData['amount_usd'].toString())).toStringAsFixed(2)} USD"),
                        const SizedBox(height: 16),
                        if (encloseAction == EncloseAction.Update)
                          Column(
                            children: [
                              Row(children: [
                                Expanded(
                                    child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Cash reçu CDF',
                                  editCtrller: _receivedCDFCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                )),
                                Expanded(
                                    child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Cash reçu USD',
                                  editCtrller: _receivedUSDCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                )),
                              ]),
                              ...List.generate(
                                  widget.encloseData['activities'].length,
                                  (index) {
                                // Map data =
                                // widget.encloseData['activities'][index];
                                // print(data);
                                return GestureDetector(
                                  onTap: () {
                                    TextEditingController _cdfCtrller =
                                            TextEditingController(),
                                        _usdCtrller = TextEditingController(),
                                        _stockCtrller = TextEditingController();
                                    Dialogs.showDialogWithActionCustomContent(
                                        context: context,
                                        title:
                                            'Montants reçus ${widget.encloseData['activities'][index]['name']}',
                                        content: Column(
                                          children: [
                                            TextFormFieldWidget(
                                                hintText: 'USD',
                                                textColor:
                                                    AppColors.kBlackColor,
                                                backColor: AppColors
                                                    .kTextFormBackColor,
                                                editCtrller: _usdCtrller,
                                                maxLines: 1),
                                            TextFormFieldWidget(
                                                hintText: 'CDF',
                                                textColor:
                                                    AppColors.kBlackColor,
                                                backColor: AppColors
                                                    .kTextFormBackColor,
                                                editCtrller: _cdfCtrller,
                                                maxLines: 1),
                                            TextFormFieldWidget(
                                                hintText: 'Stock',
                                                textColor:
                                                    AppColors.kBlackColor,
                                                backColor: AppColors
                                                    .kTextFormBackColor,
                                                editCtrller: _stockCtrller,
                                                maxLines: 1),
                                          ],
                                        ),
                                        callback: () {
                                          if (double.tryParse(_usdCtrller.text.trim()) == null ||
                                              double.tryParse(_cdfCtrller.text
                                                      .trim()) ==
                                                  null ||
                                              double.tryParse(_stockCtrller.text
                                                      .trim()) ==
                                                  null) {
                                            Message.showToast(
                                                msg:
                                                    'Certaines valeurs saisies sont incorrectes');
                                            return;
                                          }
                                          widget.encloseData['activities']
                                                  [index]['received_usd'] =
                                              double.parse(
                                                  _usdCtrller.text.trim());
                                          widget.encloseData['activities']
                                                  [index]['received_cdf'] =
                                              double.parse(
                                                  _cdfCtrller.text.trim());
                                          widget.encloseData['activities']
                                                  [index]['received_stock'] =
                                              double.parse(
                                                  _stockCtrller.text.trim());
                                          if (widget.accountData['activities']
                                              .map(
                                                  (item) => item['activity_id'])
                                              .toList()
                                              .contains(widget
                                                      .encloseData['activities']
                                                  [index]['activity_id'])) {
                                            widget.accountData['activities']
                                                    .where((element) =>
                                                        element['activity_id']
                                                            .toString() ==
                                                        widget.encloseData[
                                                                'activities']
                                                                [index]
                                                                ['activity_id']
                                                            .toString())
                                                    .toList()[0]['virtual_cdf'] +=
                                                double.parse(
                                                    _cdfCtrller.text.trim());
                                            widget.accountData['activities']
                                                    .where((element) =>
                                                        element['activity_id']
                                                            .toString() ==
                                                        widget.encloseData[
                                                                'activities']
                                                                [index]
                                                                ['activity_id']
                                                            .toString())
                                                    .toList()[0]['virtual_usd'] +=
                                                double.parse(
                                                    _usdCtrller.text.trim());
                                            widget.accountData['activities']
                                                    .where((element) =>
                                                        element['activity_id']
                                                            .toString() ==
                                                        widget.encloseData[
                                                                'activities']
                                                                [index]
                                                                ['activity_id']
                                                            .toString())
                                                    .toList()[0]['stock'] +=
                                                double.parse(
                                                    _stockCtrller.text.trim());
                                          }

                                          if (senderExistingActivities
                                              .map(
                                                  (item) => item['activity_id'])
                                              .toList()
                                              .contains(widget
                                                      .encloseData['activities']
                                                  [index]['activity_id'])) {
                                            senderExistingActivities
                                                    .where((element) =>
                                                        element['activity_id']
                                                            .toString() ==
                                                        widget.encloseData[
                                                                'activities']
                                                                [index]
                                                                ['activity_id']
                                                            .toString())
                                                    .toList()[0]['virtual_cdf'] -=
                                                double.parse(
                                                    _cdfCtrller.text.trim());
                                            senderExistingActivities
                                                    .where((element) =>
                                                        element['activity_id']
                                                            .toString() ==
                                                        widget.encloseData[
                                                                'activities']
                                                                [index]
                                                                ['activity_id']
                                                            .toString())
                                                    .toList()[0]['virtual_usd'] -=
                                                double.parse(
                                                    _usdCtrller.text.trim());
                                            senderExistingActivities
                                                    .where((element) =>
                                                        element['activity_id']
                                                            .toString() ==
                                                        widget.encloseData[
                                                                'activities']
                                                                [index]
                                                                ['activity_id']
                                                            .toString())
                                                    .toList()[0]['stock'] -=
                                                double.parse(
                                                    _stockCtrller.text.trim());
                                          }
                                          setState(() {});
                                          Navigator.pop(context);
                                          // print(widget.encloseData['activities']);
                                        });
                                  },
                                  child: cardStatsWidget(
                                      title: widget.encloseData['activities']
                                              [index]['name']
                                          .toString()
                                          .toUpperCase(),
                                      subtitle:
                                          "Stock : ${widget.encloseData['activities'][index]['stock'].toString()} -> ${widget.encloseData['activities'][index]['received_stock'].toString()}",
                                      backColor: AppColors.kTextFormWhiteColor,
                                      textColor: AppColors.kWhiteColor,
                                      icon: Icons.credit_card,
                                      currency: "",
                                      value:
                                          "CDF: ${widget.encloseData['activities'][index]['amount_cdf'].toString()}  -> ${widget.encloseData['activities'][index]['received_cdf'].toString()}",
                                      value2:
                                          "USD: ${widget.encloseData['activities'][index]['amount_usd'].toString()}  -> ${widget.encloseData['activities'][index]['received_usd'].toString()}"),
                                );
                              }),
                              // TextFormFieldWidget(
                              //   maxLines: 5,
                              //   hintText: 'Commentez la cloture',
                              //   editCtrller: _commentCtrller,
                              //   textColor: AppColors.kWhiteColor,
                              //   backColor: AppColors.kTextFormWhiteColor,
                              // )
                            ],
                          ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (encloseAction == EncloseAction.Update)
                              Expanded(
                                child: CustomButton(
                                  text: 'Valider',
                                  backColor: AppColors.kRedColor,
                                  textColor: AppColors.kWhiteColor,
                                  callback: () {
                                    if (_receivedCDFCtrller.text
                                            .trim()
                                            .isEmpty ||
                                        double.tryParse(_receivedCDFCtrller.text
                                                .trim()) ==
                                            null || _receivedUSDCtrller.text
                                        .trim()
                                        .isEmpty ||
                                        double.tryParse(_receivedUSDCtrller.text
                                            .trim()) ==
                                            null) {
                                      Message.showToast(msg: 'Certains montants cash saisis sont invalides');
                                      return;
                                    }
                                    Dialogs.showDialogWithActionCustomContent(
                                        context: context,
                                        title: "Confirmation",
                                        content: Container(
                                            child: TextWidgets.text300(
                                                title:
                                                    "Voulez-vous vraiment valider la cloture?",
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kGreyColor)),
                                        callback: () {
                                          for (int i = 0;
                                              i < senderMovingActivities.length;
                                              i++) {
                                            senderMovingActivities[i]
                                                    ['account_id'] =
                                                receiverInfo!['id'];
                                          }
                                          Map data = {
                                            "senderActivities":
                                                senderExistingActivities,
                                            "movingActivities":
                                                senderMovingActivities,
                                            "receiverActivities": widget
                                                .accountData['activities']
                                                .map((item) {
                                              item.remove('avatar');
                                              item.remove('name');
                                              item.remove('created_at');
                                              item.remove('updated_at');
                                              return item;
                                            }).toList()
                                          };
                                          Navigator.pop(context);
                                          // return print(data);
                                          EncloseHelper(
                                                  encloseData:
                                                      widget.encloseData,
                                                  senderInfo: senderInfo,
                                                  receiverInfo: receiverInfo)
                                              .validateCashEnclose(
                                                  activitiesData: data,
                                                  billetage: widget
                                                      .encloseData['billetage'],
                                                  comment: _commentCtrller.text
                                                      .trim(),
                                                  amountUSD: _receivedUSDCtrller
                                                      .text
                                                      .trim(),
                                                  amountCDF: _receivedCDFCtrller
                                                      .text
                                                      .trim());
                                        });
                                  },
                                ),
                              ),
                          ],
                        ),
                        // TextWidgets.textWithLabel(
                        //     title: 'Commentaire',
                        //     fontSize: 16,
                        //     textColor: AppColors.kWhiteColor,
                        //     value: widget.encloseData['commentaire']),
                        Card(
                          elevation: 0,
                          color: AppColors.kTextFormWhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidgets.textBold(
                                    title: "Incidents",
                                    fontSize: 16,
                                    textColor: AppColors.kWhiteColor),
                                GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => Center(
                                                child: IncidentEnclosePage(
                                              clotureID: widget
                                                  .encloseData['id']
                                                  .toString(),
                                            )));
                                  },
                                  child: Icon(Icons.add,
                                      color: AppColors.kWhiteColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        ...List.generate(
                            widget.encloseData['incidents'].length,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    tileColor:
                                        AppColors.kWhiteColor.withOpacity(0.05),
                                    title: TextWidgets.textBold(
                                        title: widget.encloseData['incidents']
                                            [index]['type_incident'],
                                        fontSize: 16,
                                        textColor: AppColors.kWhiteColor),
                                    subtitle: TextWidgets.text300(
                                        title: parseDateWithTime(
                                            date: widget
                                                .encloseData['incidents'][index]
                                                    ['created_at']
                                                .toString()),
                                        fontSize: 12,
                                        textColor: AppColors.kWhiteColor
                                            .withOpacity(0.7)),
                                    trailing: TextWidgets.textBold(
                                        title: widget.encloseData['incidents']
                                                [index]['montant'] +
                                            ' ' +
                                            widget.encloseData['incidents']
                                                [index]['currency'],
                                        fontSize: 16,
                                        textColor: AppColors.kWhiteColor),
                                  ),
                                ))
                      ]),
                    )
                  ]));
        }));
  }

  bool isDetailsVisible = false;

  cardStatsWidget(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color textColor,
      required Color backColor,
      required String value,
      required String value2,
      required String currency,
      bool? hasDetails = false}) {
    return GestureDetector(
      onTap: hasDetails != true
          ? null
          : () {
              setState(() {
                isDetailsVisible = !isDetailsVisible;
              });
            },
      child: Container(
        color: AppColors.kTransparentColor,
        child: Card(
          color: backColor,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
          child: Container(
            // width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidgets.textBold(
                            overflow: TextOverflow.ellipsis,
                            title: title,
                            fontSize: 14,
                            textColor: textColor),
                        const SizedBox(height: 8),
                        TextWidgets.text300(
                            overflow: TextOverflow.ellipsis,
                            title: subtitle,
                            fontSize: 12,
                            textColor: textColor.withOpacity(0.6)),
                      ],
                    )),
                    Card(
                      elevation: 0,
                      color: AppColors.kBlackColor,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: TextWidgets.text300(
                            overflow: TextOverflow.ellipsis,
                            title:
                                widget.encloseData['status'].toString().trim(),
                            fontSize: 12,
                            textColor: textColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Row(children: [
                      TextWidgets.textBold(
                          title: value, fontSize: 14, textColor: textColor),
                    ])),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextWidgets.textBold(
                            title: value2, fontSize: 14, textColor: textColor),
                        const SizedBox(
                          width: 10,
                        ),
                        TextWidgets.textBold(
                            title: currency,
                            fontSize: 14,
                            textColor: textColor),
                      ],
                    )),
                  ],
                ),
                if (hasDetails == true)
                  Visibility(
                      visible: isDetailsVisible,
                      child: Column(
                        children: [
                          Divider(
                              color: AppColors.kTextFormWhiteColor,
                              thickness: 1),
                          TextWidgets.textBold(
                              title: "Billetage",
                              fontSize: 18,
                              textColor: textColor),
                          if (widget.encloseData['billetage'] != null)
                            ...List.generate(
                                widget.encloseData['billetage'].length,
                                (index) {
                              // print(
                              //     widget.encloseData['billetage'][index]['id']);
                              Map bills = jsonDecode(widget
                                  .encloseData['billetage'][index]['nombre']);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidgets.textBold(
                                      title: widget.encloseData['billetage']
                                              [index]['billet']
                                          .toString()
                                          .toUpperCase(),
                                      fontSize: 14,
                                      textColor: textColor),
                                  Row(),
                                  Wrap(
                                    children: [
                                      ...List.generate(bills.keys.length,
                                          (billsIndex) {
                                        return TextWidgets.textWithLabel(
                                            title:
                                                "${bills.keys.toList()[billsIndex]} ${widget.encloseData['billetage'][index]['billet'].toString().toUpperCase()}",
                                            fontSize: 12,
                                            textColor: textColor,
                                            value: bills[bills.keys
                                                .toList()[billsIndex]]);
                                      })
                                    ],
                                  )
                                ],
                              );
                            }),
                        ],
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
