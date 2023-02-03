import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/account_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Reports/pret.report.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:provider/provider.dart';

class TransactionsReportPage extends StatefulWidget {
  const TransactionsReportPage({Key? key}) : super(key: key);

  @override
  _TransactionsReportPageState createState() => _TransactionsReportPageState();
}

class _TransactionsReportPageState extends State<TransactionsReportPage> {
  List<CaisseModel> caisseData = [];

  @override
  void initState() {
    super.initState();
    caisseData = Provider.of<AdminCaisseStateProvider>(context, listen: false)
        .caisseData;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kTransparentColor,
      child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .85,
              minHeight: MediaQuery.of(context).size.height * .50),
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height * .85,
          // color: AppColors.kBlackLightColor,
          child: Consumer<AppStateProvider>(
              builder: (context, appStateProvider, child) {
            return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ListView(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  Consumer<AdminCaisseStateProvider>(
                      builder: (context, adminCaisseProvider, _) {
                    // print(adminCaisseProvider
                    //     .caisseData[0].toJson());
                    return CardWidget(
                      title: "Rapport des caisses",
                      backColor: AppColors.kBlackLightColor,
                      content: Column(
                        children: [
                          ...List.generate(
                              adminCaisseProvider.branches.length,
                              (branchIndex) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpansionTile(
                                      backgroundColor:
                                          AppColors.kTextFormBackColor,
                                      collapsedBackgroundColor:
                                          AppColors.kTextFormWhiteColor,
                                      childrenPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 5),
                                      title: TextWidgets.textBold(
                                          title: "Branche " +
                                              adminCaisseProvider
                                                  .branches[branchIndex]['name']
                                                  .toString()
                                                  .toUpperCase(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                      children: [
                                        ...List.generate(
                                            adminCaisseProvider.caisseData
                                                .where((account) =>
                                                    account.branch_id!
                                                        .toString() ==
                                                    adminCaisseProvider
                                                        .branches[branchIndex]
                                                            ['id']
                                                        .toString())
                                                .toList()
                                                .length, (index) {
                                          CaisseModel singleAccountData =
                                              adminCaisseProvider.caisseData
                                                  .where((account) =>
                                                      account.branch_id!
                                                          .toString() ==
                                                      adminCaisseProvider
                                                          .branches[branchIndex]
                                                              ['id']
                                                          .toString())
                                                  .toList()[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ExpansionTile(
                                              backgroundColor:
                                                  AppColors.kTextFormBackColor,
                                              collapsedBackgroundColor:
                                                  AppColors.kTextFormWhiteColor,
                                              childrenPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 5),
                                              title: TextWidgets.textNormal(
                                                  title: "Caissier " +
                                                      singleAccountData
                                                          .caissierName
                                                          .toString()
                                                          .toUpperCase(),
                                                  fontSize: 12,
                                                  textColor:
                                                      AppColors.kWhiteColor),
                                              onExpansionChanged: (value) {
                                                if (value == true) {
                                                  adminCaisseProvider
                                                      .getAccountActivities(
                                                          accountID:
                                                              singleAccountData
                                                                  .id!
                                                                  .toString()
                                                                  .trim());
                                                }
                                              },
                                              children: [
                                                singleAccountData
                                                        .activities.isNotEmpty
                                                    ? Column(children: [
                                                        accountWIdget(
                                                            singleAccountData,
                                                            branchIndex,
                                                            index),
                                                      ])
                                                    : Container(
                                                        child: TextWidgets.text300(
                                                            title: "No data",
                                                            fontSize: 14,
                                                            textColor: AppColors
                                                                .kWhiteColor))
                                              ],
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  )),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          })),
    );
  }

  Column accountWIdget(CaisseModel account, int branchIndex, int index) {
    return Column(
      children: [
        Column(
            children: List.generate(
                account.activities.length,
                (indexActivities) => Card(
                      color: AppColors.kBlackLightColor,
                      elevation: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                child: TextWidgets.textBold(
                                    title: account.activities[indexActivities]
                                        ['activity']['name'],
                                    fontSize: 14,
                                    textColor: AppColors.kWhiteColor)),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      child: TextWidgets.text300(
                                          title:
                                              "USD ${account.activities[indexActivities]['virtual_usd']}",
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor)),
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        child: TextWidgets.text300(
                                            title:
                                                "CDF ${account.activities[indexActivities]['virtual_cdf']}",
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor))),
                              ],
                            ),
                          ]),
                    ))),
        GestureDetector(
          onTap: () {
            Dialogs.showModal(
                title: 'Pret et emprunt',
                content: LoanReportWidget(
                  accountID: account.id?.toString(),
                ));
          },
          child: Card(
            color: AppColors.kBlackLightColor,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: TextWidgets.textBold(
                        title: "Pret",
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: TextWidgets.text300(
                              title:
                                  "USD ${account.solde_pret_usd!.toStringAsFixed(2)}",
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor)),
                    ),
                    Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: TextWidgets.text300(
                                title:
                                    "CDF ${account.solde_pret_cdf!.toStringAsFixed(2)}",
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor))),
                  ],
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Dialogs.showModal(
                title: 'Pret et emprunt',
                content: LoanReportWidget(
                  accountID: account.id?.toString(),
                ));
          },
          child: Card(
            color: AppColors.kBlackLightColor,
            elevation: 0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: TextWidgets.textBold(
                      title: "Emprunt",
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: TextWidgets.text300(
                            title:
                                "USD ${account.solde_emprunt_usd!.toStringAsFixed(2)}",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: TextWidgets.text300(
                              title:
                                  "CDF ${account.solde_emprunt_cdf!.toStringAsFixed(2)}",
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor))),
                ],
              ),
            ]),
          ),
        ),
        Card(
          color: AppColors.kBlackLightColor,
          elevation: 0,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: TextWidgets.textBold(
                    title: "CASH",
                    fontSize: 14,
                    textColor: AppColors.kWhiteColor)),
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: TextWidgets.text300(
                          title:
                              "USD ${account.solde_cash_USD.toStringAsFixed(2)}",
                          fontSize: 14,
                          textColor: AppColors.kWhiteColor)),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: TextWidgets.text300(
                            title:
                                "CDF ${account.solde_cash_CDF.toStringAsFixed(2)}",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor))),
              ],
            ),
          ]),
        ),
        Card(
          color: AppColors.kBlackLightColor,
          elevation: 0,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: TextWidgets.textBold(
                    title: "Total",
                    fontSize: 14,
                    textColor: AppColors.kWhiteColor)),
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: TextWidgets.textBold(
                          title:
                              "USD ${(account.solde_cash_USD + account.solde_pret_usd! - account.solde_emprunt_usd! + account.activities.map((activity) => activity['virtual_usd']).reduce((value, element) => value + element)).toStringAsFixed(2)}",
                          fontSize: 14,
                          textColor: AppColors.kWhiteColor)),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: TextWidgets.textBold(
                            title:
                                "CDF ${(account.solde_cash_CDF + account.solde_pret_cdf! - account.solde_emprunt_cdf! + account.activities.map((activity) => activity['virtual_cdf']).reduce((value, element) => value + element)).toStringAsFixed(2)}",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor))),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
