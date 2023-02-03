import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Cloture/billetage.widget.dart';
import 'package:orion/Views/Guichet/Cloture/enclose_helper.dart';
import 'package:provider/provider.dart';

class EndDayPage extends StatefulWidget {
  final bool updatingData;
  final Map accountData;
  final Map? encloseData;

  const EndDayPage(
      {Key? key,
      required this.accountData,
      required this.updatingData,
      this.encloseData})
      : super(key: key);

  @override
  _EndDayPageState createState() => _EndDayPageState();
}

class _EndDayPageState extends State<EndDayPage> {
  Map? receiverInfo;
  Map? senderInfo;
  // Map? receiverUser;
  TransactionsStateProvider? transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider =
        Provider.of<TransactionsStateProvider>(context, listen: false);
    if (widget.updatingData == true && widget.encloseData != null) {
      if (widget.accountData['id'].toString() ==
          widget.encloseData!['sender_id'].toString()) {
        receiverInfo = transactionProvider!.othersAccounts
            .where((account) =>
                account['id'].toString() ==
                widget.encloseData!['receiver_id'].toString())
            .toList()[0];
        // receiverUser = transactionProvider!.allUsers
        //     .where((user) =>
        //         user['id'].toString() == receiverInfo!['users_id'].toString())
        //     .toList()[0];
        senderInfo = widget.accountData;
      } else {
        senderInfo = transactionProvider!.othersAccounts
            .where((account) =>
                account['id'].toString() ==
                // widget.encloseData!['sender_id'].toString())
                widget.encloseData!['sender_id'].toString())
            .toList()[0];

        receiverInfo = widget.accountData;
      }
    } else {
      if (Provider.of<UserStateProvider>(context, listen: false)
              .clientData!
              .role
              .toString()
              .toLowerCase() ==
          'caissier') {
        receiverInfo = transactionProvider!.othersAccounts.firstWhere(
            (account) =>
                account['branch_id'].toString() ==
                    widget.accountData['branch_id'].toString() &&
                transactionProvider!.allUsers
                        .where((user) =>
                            user['id'].toString() ==
                            account['users_id'].toString())
                        .toList()[0]['role']
                        .toString()
                        .toLowerCase() ==
                    'agregateur',
            orElse: () => null);

        senderInfo = widget.accountData;
      }
      if (Provider.of<UserStateProvider>(context, listen: false)
              .clientData!
              .role
              .toString()
              .toLowerCase() ==
          'agregateur') {
        // print(transactionProvider!.othersAccounts.length);
        senderInfo = widget.accountData;
        receiverInfo = transactionProvider!.othersAccounts.firstWhere(
            (account) => transactionProvider!.allUsers
                .where((user) =>
                    user['id'].toString() == account['users_id'].toString() &&
                    user['role'].toString().toLowerCase().contains('comptable'))
                .toList()
                .isNotEmpty,
            orElse: () => null);
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (senderInfo != null) {
        // receiverInfo = await transactionProvider!.getReceiverAccountActivities(
        //     accountID: receiverInfo!['id'].toString());
        // print(receiverInfo);
        if (widget.updatingData == true && widget.encloseData != null) {
          getActivitiesDifferences();
        }
      }
    });
  }

  List activitiesToUpdate = [];
  getActivitiesDifferences() async {
    // if (widget.updatingData == true && widget.encloseData != null) {
    //   if (widget.accountData['id'].toString() ==
    //       widget.encloseData!['sender_id'].toString()) {
    //     receiverInfo = await transactionProvider!.getReceiverAccountActivities(
    //         accountID: receiverInfo!['id'].toString());
    //   } else {
    //
    //   }
    // }
    senderInfo = await transactionProvider!
        .getReceiverAccountActivities(accountID: senderInfo!['id'].toString());

    for (int i = 0; i < senderInfo!['activities'].length; i++) {
      if (!receiverInfo!['activities']
          .map((e) => e['activity_id'])
          .toList()
          .contains(senderInfo!['activities'][i]['activity_id'])) {
        activitiesToUpdate.add(senderInfo!['activities'][i]);
      }
    }
    print(activitiesToUpdate);
  }

  @override
  Widget build(BuildContext context) {
    double totalUSD = 0, totalCDF = 0;
    if (context
        .select<ClotureProvider, Map>((provider) => provider.encloseBills)
        .isNotEmpty) {
      Map bills = context.read<ClotureProvider>().encloseBills;
      for (var i = 0; i < bills['data'].length; i++) {
        Map billDetails = jsonDecode(bills['data'][i]['nombre']);
        if (bills['data'][i]['billet'] == 'usd') {
          for (int i = 0; i < billDetails.keys.toList().length; i++) {
            totalUSD += double.parse(
                    billDetails[billDetails.keys.toList()[i]].toString()) *
                double.parse(billDetails.keys.toList()[i].toString());
          }
        }
        if (bills['data'][i]['billet'] == 'cdf') {
          for (int i = 0; i < billDetails.keys.toList().length; i++) {
            totalCDF += double.parse(
                    billDetails[billDetails.keys.toList()[i]].toString()) *
                double.parse(billDetails.keys.toList()[i].toString());
          }
        }
      }
    }
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width / 2,
        // color: AppColors.kBlackLightColor,
        child:
            Consumer<AppStateProvider>(builder: (context, appStateProvider, _) {
          return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ListView(shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: 'Clôturer ma journée',
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: AppColors.kYellowColor),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(children: [
                                TextWidgets.text300(
                                    title:
                                        'La clôture concerne les soldes en CASH, ceux en virtuel ne sont pas concernés',
                                    fontSize: 14,
                                    textColor: AppColors.kYellowColor),
                                const SizedBox(height: 10),
                                TextWidgets.text300(
                                    title:
                                        'Cette action va transférer tous vos cash vers le compte de votre supérieur.',
                                    fontSize: 14,
                                    textColor: AppColors.kYellowColor),
                              ]),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        cardStatsWidget(
                            title: "CASH",
                            subtitle: "Solde actuel en cash",
                            backColor: AppColors.kTextFormWhiteColor,
                            textColor: AppColors.kWhiteColor,
                            icon: Icons.credit_card,
                            currency: "",
                            value:
                                "${transactionProvider?.accounts[0]['sold_cash_cdf'].toString()} CDF",
                            value2:
                                "${transactionProvider?.accounts[0]['sold_cash_usd'].toString()} USD"),
                        cardStatsWidget(
                            title: "PRET",
                            subtitle: "Solde actuel en pret",
                            backColor: AppColors.kTextFormWhiteColor,
                            textColor: AppColors.kWhiteColor,
                            icon: Icons.credit_card,
                            currency: "",
                            value:
                                "${transactionProvider?.accounts[0]['sold_pret_cdf'].toString()} CDF",
                            value2:
                                "${transactionProvider?.accounts[0]['sold_pret_cdf'].toString()} USD"),
                        cardStatsWidget(
                            title: "EMPRUNT",
                            subtitle: "Solde actuel en emprunt",
                            backColor: AppColors.kTextFormWhiteColor,
                            textColor: AppColors.kWhiteColor,
                            icon: Icons.credit_card,
                            currency: "",
                            value:
                                "${transactionProvider?.accounts[0]['sold_emprunt_cdf'].toString()} CDF",
                            value2:
                                "${transactionProvider?.accounts[0]['sold_emprunt_cdf'].toString()} USD"),
                        const SizedBox(height: 8),
                        TextWidgets.textBold(
                            title: "Solde des activités",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor),
                        const SizedBox(height: 8),
                        ...List.generate(
                            transactionProvider
                                ?.accounts[0]['activities'].length, (index) {
                          return cardStatsWidget(
                              title: transactionProvider!.accounts[0]
                                      ['activities'][index]['name']
                                  .toString(),
                              subtitle:
                                  "STOCK: ${transactionProvider!.accounts[0]['activities'][index]['stock'].toString()}",
                              backColor: AppColors.kTextFormWhiteColor,
                              textColor: AppColors.kWhiteColor,
                              icon: Icons.credit_card,
                              currency: "",
                              value:
                                  "${transactionProvider!.accounts[0]['activities'][index]['virtual_cdf'].toString()} CDF",
                              value2:
                                  "${transactionProvider!.accounts[0]['activities'][index]['virtual_usd'].toString()} USD");
                        }),
                        const SizedBox(height: 8),
                        TextWidgets.textBold(
                            title: "Le compte de cloture",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor),
                        const SizedBox(height: 8),
                        receiverInfo != null
                            ? GestureDetector(
                                onTap: () {
                                  Dialogs.showChoiceDialog(
                                      title: 'Choisissez une caisse',
                                      content: Column(
                                        children: [
                                          ...List.generate(
                                              transactionProvider!
                                                  .othersAccounts.length,
                                              (index) => GestureDetector(
                                                    onTap: () {
                                                      receiverInfo =
                                                          transactionProvider!
                                                                  .othersAccounts[
                                                              index];
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Card(
                                                      elevation: 1,
                                                      child: ListTile(
                                                        tileColor: AppColors
                                                            .kTextFormWhiteColor,
                                                        title: TextWidgets.textBold(
                                                            title: transactionProvider
                                                                    ?.othersAccounts[
                                                                        index][
                                                                        'names']
                                                                    ?.toString()
                                                                    .toUpperCase() ??
                                                                '',
                                                            fontSize: 14,
                                                            textColor: AppColors
                                                                .kBlackColor),
                                                        subtitle: TextWidgets.text300(
                                                            title: transactionProvider
                                                                            ?.othersAccounts[
                                                                        index]
                                                                    ['role'] ??
                                                                '',
                                                            fontSize: 14,
                                                            textColor: AppColors
                                                                .kBlackColor),
                                                      ),
                                                    ),
                                                  ))
                                        ],
                                      ));
                                },
                                child: cardStatsWidget(
                                    title: receiverInfo!['names']
                                        .toString()
                                        .toUpperCase(),
                                    subtitle:
                                        "Le compte qui recevra la cloture",
                                    backColor: AppColors.kTextFormWhiteColor,
                                    textColor: AppColors.kWhiteColor,
                                    icon: Icons.person_rounded,
                                    currency: "",
                                    value: "",
                                    value2: receiverInfo!['role']
                                        .toString()
                                        .toUpperCase()))
                            : TextWidgets.textNormal(
                                title: "Aucun compte trouvé",
                                fontSize: 14,
                                textColor: AppColors.kGreyColor),
                        Row(
                          children: [
                            Consumer<ClotureProvider>(
                                builder: (context, clotureProvider, _) {
                              return Flexible(
                                fit: FlexFit.loose,
                                child: ListTile(
                                  tileColor: AppColors.kTextFormWhiteColor,
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: BilletageWidgetPage(
                                              userAccount: senderInfo!,
                                            ),
                                          );
                                        });
                                  },
                                  title: TextWidgets.textBold(
                                      title:
                                          clotureProvider.encloseBills.isEmpty
                                              ? "Billetage"
                                              : "Billetage effectué",
                                      fontSize: 14,
                                      textColor: AppColors.kWhiteColor),
                                  subtitle: TextWidgets.text300(
                                      title: clotureProvider
                                              .encloseBills.isEmpty
                                          ? "Cliquez ici pour faire le billetage"
                                          : "CDF ${totalCDF.toString()}  -   USD ${totalUSD.toString()}",
                                      fontSize: 14,
                                      textColor: AppColors.kWhiteColor),
                                  trailing: Icon(
                                      clotureProvider.encloseBills.isEmpty
                                          ? Icons.pending_actions_rounded
                                          : Icons.check_circle,
                                      color: AppColors.kWhiteColor),
                                ),
                              );
                            }),
                            Flexible(
                              fit: FlexFit.loose,
                              child: CustomButton(
                                text: 'Clôturer',
                                backColor: AppColors.kRedColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () {
                                  Dialogs.showDialogWithActionCustomContent(
                                      context: context,
                                      title: "Confirmation",
                                      content: Container(
                                          child: TextWidgets.text300(
                                              title:
                                                  "Voulez-vous vraiment cloturer votre compte?",
                                              fontSize: 14,
                                              textColor: AppColors.kGreyColor)),
                                      callback: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        EncloseHelper(
                                                senderInfo: senderInfo,
                                                receiverInfo: receiverInfo)
                                            .submitEncloseDay(
                                                activitiesUpdated:
                                                    activitiesToUpdate);
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

  cardStatsWidget(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color textColor,
      required Color backColor,
      required String value,
      required String value2,
      required String currency}) {
    return Container(
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
                          fontSize: 12,
                          textColor: textColor),
                      TextWidgets.text300(
                          overflow: TextOverflow.ellipsis,
                          title: subtitle,
                          fontSize: 12,
                          textColor: textColor),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, color: textColor),
                  )
                ],
              ),
              const SizedBox(
                height: 0,
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
                          title: currency, fontSize: 14, textColor: textColor),
                    ],
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
