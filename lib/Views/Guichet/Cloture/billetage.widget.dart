import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Demands/helper.dart';
import 'package:provider/provider.dart';

class BilletageWidgetPage extends StatefulWidget {
  Map userAccount;
  bool? isCheckingBills;
  BilletageWidgetPage(
      {Key? key, this.isCheckingBills, required this.userAccount})
      : super(key: key);

  @override
  _BilletageWidgetPageState createState() => _BilletageWidgetPageState();
}

class _BilletageWidgetPageState extends State<BilletageWidgetPage> {
  ConnectedUser? connectedUser;

  @override
  void initState() {
    Map encloseBills =
        Provider.of<ClotureProvider>(context, listen: false).encloseBills;
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (encloseBills.isEmpty) return;
      for (var i = 0; i < encloseBills['data'].length; i++) {
        if (encloseBills['data'][i]['billet'] == 'usd') {
          Map billets = jsonDecode(encloseBills['data'][i]['nombre']);
          // print(billets['20']);
          // print(billets['10']);
          // print(billets['5']);
          _100BillsCtrller.text = billets['100'].toString().trim();
          _50BillsCtrller.text = billets['50'].toString().trim();
          _20BillsCtrller.text = billets['20'].toString().trim();
          _10BillsCtrller.text = billets['10'].toString().trim();
          _5BillsCtrller.text = billets['5'].toString().trim();
          _1BillsCtrller.text = billets['1'].toString().trim();
        }
        if (encloseBills['data'][i]['billet'] == 'cdf') {
          Map billets = jsonDecode(encloseBills['data'][i]['nombre']);
          _20000CDFCtrller.text = billets['20000'].toString().trim();
          _10000CDFCtrller.text = billets['10000'].toString().trim();
          _5000CDFCtrller.text = billets['5000'].toString().trim();
          _1000CDFCtrller.text = billets['1000'].toString().trim();
          _500CDFCtrller.text = billets['500'].toString().trim();
          _200CDFCtrller.text = billets['200'].toString().trim();
          _100CDFCtrller.text = billets['100'].toString().trim();
          _50CDFCtrller.text = billets['50'].toString().trim();
        }
      }
    });
  }

  final TextEditingController _100BillsCtrller = TextEditingController(),
      _50BillsCtrller = TextEditingController(),
      _20BillsCtrller = TextEditingController(),
      _10BillsCtrller = TextEditingController(),
      _5BillsCtrller = TextEditingController(),
      _1BillsCtrller = TextEditingController();

  final TextEditingController _20000CDFCtrller = TextEditingController(),
      _10000CDFCtrller = TextEditingController(),
      _5000CDFCtrller = TextEditingController(),
      _1000CDFCtrller = TextEditingController(),
      _500CDFCtrller = TextEditingController(),
      _200CDFCtrller = TextEditingController(),
      _100CDFCtrller = TextEditingController(),
      _50CDFCtrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width / 2,
        // color: AppColors.kBlackLightColor,
        child:
            Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
          return ListView(shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                CardWidget(
                  backColor: AppColors.kBlackLightColor,
                  title:
                      '${widget.isCheckingBills == true ? "Vérification" : ""} Billetage',
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (widget.isCheckingBills == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: AppColors.kYellowColor),
                          const SizedBox(width: 16),
                          TextWidgets.text300(
                              title:
                                  "Signalez seulement les billets qui sont invalides",
                              fontSize: 14,
                              textColor: AppColors.kYellowColor),
                        ],
                      ),
                    const SizedBox(height: 16),
                    TextWidgets.textBold(
                        title: "Billet en USD",
                        fontSize: 16,
                        textColor: AppColors.kWhiteColor),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 100',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _100BillsCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 50',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _50BillsCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 20',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _20BillsCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 10',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _10BillsCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 5',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _5BillsCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 1',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _1BillsCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextWidgets.textBold(
                        title: "Billet en CDF",
                        fontSize: 16,
                        textColor: AppColors.kWhiteColor),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 20.000',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _20000CDFCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 10.000',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _10000CDFCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 5000',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _5000CDFCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 1000',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _1000CDFCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 500',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _500CDFCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 200',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _200CDFCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 100',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _100CDFCtrller,
                              maxLines: 1),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                              hintText: 'Billet de 50',
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                              editCtrller: _50CDFCtrller,
                              maxLines: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            text: 'Enregisrter',
                            backColor: AppColors.kGreenColor,
                            textColor: AppColors.kWhiteColor,
                            isEnabled: true,
                            callback: () {
                              if (double.tryParse(
                                          _100BillsCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(
                                          _50BillsCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(
                                          _20BillsCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(
                                          _10BillsCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(_5BillsCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(_1BillsCtrller.text.trim()) ==
                                      null) {
                                Message.showToast(
                                    msg: 'Billetage USD invalide');
                                return;
                              }
                              if (double.tryParse(
                                          _20000CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(
                                          _10000CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(
                                          _5000CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(
                                          _1000CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(_500CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(_100CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(_50CDFCtrller.text.trim()) ==
                                      null ||
                                  double.tryParse(_200CDFCtrller.text.trim()) ==
                                      null) {
                                Message.showToast(
                                    msg: 'Billetage CDF invalide');
                                return;
                              }
                              Map bills = {
                                "data": [
                                  {
                                    "billet": "usd",
                                    "nombre": jsonEncode({
                                      "100": _100BillsCtrller.text.trim(),
                                      "50": _50BillsCtrller.text.trim(),
                                      "20": _20BillsCtrller.text.trim(),
                                      "10": _10BillsCtrller.text.trim(),
                                      "5": _5BillsCtrller.text.trim(),
                                      "1": _1BillsCtrller.text.trim(),
                                    })
                                  },
                                  {
                                    "billet": "cdf",
                                    "nombre": jsonEncode({
                                      "20000": _20000CDFCtrller.text.trim(),
                                      "10000": _10000CDFCtrller.text.trim(),
                                      "5000": _5000CDFCtrller.text.trim(),
                                      "1000": _1000CDFCtrller.text.trim(),
                                      "500": _500CDFCtrller.text.trim(),
                                      "200": _200CDFCtrller.text.trim(),
                                      "100": _100CDFCtrller.text.trim(),
                                      "50": _50CDFCtrller.text.trim(),
                                    })
                                  },
                                ]
                              };

                              double totalUSD = 0, totalCDF = 0;
                              Dialogs.showModal(
                                  title: 'Résumé',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        TextWidgets.textBold(
                                          title: "Résumé du billetage",
                                          fontSize: 24,
                                          textColor: AppColors.kWhiteColor,
                                        ),
                                        ...List.generate(bills['data'].length,
                                            (index) {
                                          // print(widget.encloseData['billetage']);
                                          Map billDetails = jsonDecode(
                                              bills['data'][index]['nombre']);
                                          if (bills['data'][index]['billet'] ==
                                              'usd') {
                                            for (int i = 0;
                                                i <
                                                    billDetails.keys
                                                        .toList()
                                                        .length;
                                                i++) {
                                              totalUSD += double.parse(
                                                      billDetails[billDetails
                                                          .keys
                                                          .toList()[i]]) *
                                                  double.parse(billDetails.keys
                                                      .toList()[i]);
                                            }
                                          }
                                          if (bills['data'][index]['billet'] ==
                                              'cdf') {
                                            for (int i = 0;
                                                i <
                                                    billDetails.keys
                                                        .toList()
                                                        .length;
                                                i++) {
                                              totalCDF += double.parse(
                                                      billDetails[billDetails
                                                          .keys
                                                          .toList()[i]]) *
                                                  double.parse(billDetails.keys
                                                      .toList()[i]);
                                            }
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextWidgets.textBold(
                                                  title: bills['data'][index]
                                                          ['billet']
                                                      .toString()
                                                      .toUpperCase(),
                                                  fontSize: 14,
                                                  textColor:
                                                      AppColors.kWhiteColor),
                                              Row(),
                                              Wrap(
                                                children: [
                                                  ...List.generate(
                                                      billDetails.keys.length,
                                                      (billsIndex) {
                                                    return TextWidgets.textWithLabel(
                                                        title:
                                                            "${billDetails.keys.toList()[billsIndex]} ${bills['data'][index]['billet'].toString().toUpperCase()}",
                                                        fontSize: 12,
                                                        textColor: AppColors
                                                            .kWhiteColor,
                                                        value: billDetails[
                                                            billDetails.keys
                                                                    .toList()[
                                                                billsIndex]]);
                                                  })
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                        const SizedBox(height: 16),
                                        Divider(
                                            color:
                                                AppColors.kTextFormWhiteColor,
                                            thickness: 1),
                                        TextWidgets.textBold(
                                          title: "Montant de cloture",
                                          fontSize: 16,
                                          textColor: AppColors.kWhiteColor,
                                        ),
                                        TextWidgets.textHorizontalWithLabel(
                                            title: "USD",
                                            fontSize: 16,
                                            textColor: AppColors.kWhiteColor,
                                            value: totalUSD.toString()),
                                        TextWidgets.textHorizontalWithLabel(
                                            title: "CDF",
                                            fontSize: 16,
                                            textColor: AppColors.kWhiteColor,
                                            value: totalCDF.toString()),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: CustomButton(
                                                  text: 'Annuler',
                                                  backColor:
                                                      AppColors.kBlackColor,
                                                  textColor:
                                                      AppColors.kWhiteColor,
                                                  callback: () {
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                            Flexible(
                                              child: CustomButton(
                                                  text: 'Je confirme',
                                                  backColor:
                                                      AppColors.kGreenColor,
                                                  textColor:
                                                      AppColors.kWhiteColor,
                                                  callback: () {
                                                    if (double.parse(widget
                                                                .userAccount[
                                                                    'sold_cash_usd']
                                                                .toString()) !=
                                                            totalUSD ||
                                                        double.parse(widget
                                                                .userAccount[
                                                                    'sold_cash_cdf']
                                                                .toString()) !=
                                                            totalCDF) {
                                                      Dialogs.showDialogNoAction(
                                                          context: context,
                                                          title: 'Erreur',
                                                          content:
                                                              "Le billetage ne correspond pas aux soldes en caisse.\nVeuillez revérifier le billetage");
                                                      return;
                                                    }
                                                    Provider.of<ClotureProvider>(
                                                            context,
                                                            listen: false)
                                                        .setEncloseBills(bills);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ]),
                )
              ]);
        }));
  }
}
