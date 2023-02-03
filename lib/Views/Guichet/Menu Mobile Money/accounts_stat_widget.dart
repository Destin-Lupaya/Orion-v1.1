import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

class AccountStatWidget extends StatelessWidget {
  const AccountStatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsStateProvider>(
        builder: (context, transactionProvider, _) {
      double pretCDF = 0, pretUSD = 0;
      double empruntCDF = 0, empruntUSD = 0;
      return Column(
        children: [
          TextWidgets.textBold(
              title: "Mon compte",
              fontSize: 18,
              textColor: AppColors.kBlackColor,
              align: TextAlign.center),
          const SizedBox(height: 36),
          transactionProvider.accounts[0]['activities'].isNotEmpty
              ? Column(children: [
                  Column(
                      children: List.generate(
                          transactionProvider.accounts[0]['activities'].length,
                          (indexActivities) {
                    pretCDF += double.parse(transactionProvider.accounts[0]
                            ['activities'][indexActivities]['pret_cdf']
                        .toString());
                    pretUSD += double.parse(transactionProvider.accounts[0]
                            ['activities'][indexActivities]['pret_usd']
                        .toString());

                    empruntCDF += double.parse(transactionProvider.accounts[0]
                            ['activities'][indexActivities]['emprunt_cdf']
                        .toString());
                    empruntUSD += double.parse(transactionProvider.accounts[0]
                            ['activities'][indexActivities]['emprunt_usd']
                        .toString());
                    return Card(
                        color: AppColors.kBlackLightColor,
                        elevation: 0,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: TextWidgets.textBold(
                                      title: transactionProvider.accounts[0]
                                              ['activities'][indexActivities]
                                          ['name'],
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
                                                "USD ${transactionProvider.accounts[0]['activities'][indexActivities]['virtual_usd']}",
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor)),
                                  ),
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        child: TextWidgets.text300(
                                            title:
                                                "Stock ${transactionProvider.accounts[0]['activities'][indexActivities]['stock']}",
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
                                                  "CDF ${transactionProvider.accounts[0]['activities'][indexActivities]['virtual_cdf']}",
                                              fontSize: 14,
                                              textColor:
                                                  AppColors.kWhiteColor))),
                                ],
                              ),
                            ]));
                  })),
                  Card(
                      color: AppColors.kBlackLightColor,
                      elevation: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
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
                                              "USD ${(double.parse(transactionProvider.accounts[0]['sold_pret_usd'].toString()) + pretUSD).toStringAsFixed(3)}",
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
                                                "CDF ${(double.parse(transactionProvider.accounts[0]['sold_pret_cdf'].toString()) + pretCDF).toStringAsFixed(3)}",
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor))),
                              ],
                            ),
                          ])),
                  Card(
                      color: AppColors.kBlackLightColor,
                      elevation: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
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
                                              "USD ${(double.parse(transactionProvider.accounts[0]['sold_emprunt_usd'].toString()) + empruntUSD).toStringAsFixed(3)}",
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor)),
                                ),
                                Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        alignment: Alignment.centerRight,
                                        child: TextWidgets.text300(
                                            title:
                                                "CDF ${(double.parse(transactionProvider.accounts[0]['sold_emprunt_cdf'].toString()) + empruntCDF).toStringAsFixed(3)}",
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor))),
                              ],
                            ),
                          ])),
                  Card(
                      color: AppColors.kBlackLightColor,
                      elevation: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
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
                                              "USD ${transactionProvider.accounts[0]['sold_cash_usd'].toString()}",
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor)),
                                ),
                                Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        alignment: Alignment.centerRight,
                                        child: TextWidgets.text300(
                                            title:
                                                "CDF ${transactionProvider.accounts[0]['sold_cash_cdf'].toString()}",
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor))),
                              ],
                            ),
                          ])),
                  Card(
                      color: AppColors.kBlackLightColor,
                      elevation: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
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
                                              "USD ${(double.parse(transactionProvider.accounts[0]['sold_cash_usd'].toString()) + double.parse(transactionProvider.accounts[0]['sold_pret_usd'].toString()) - double.parse(transactionProvider.accounts[0]['sold_emprunt_usd'].toString()) + pretUSD - empruntUSD + transactionProvider.accounts[0]['activities'].map((activity) => double.parse(activity['virtual_usd'].toString())).reduce((value, element) => value + element)).toString()}",
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor)),
                                ),
                                Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        alignment: Alignment.centerRight,
                                        child: TextWidgets.textBold(
                                            title:
                                                "CDF ${(double.parse(transactionProvider.accounts[0]['sold_cash_cdf'].toString()) + double.parse(transactionProvider.accounts[0]['sold_pret_cdf'].toString()) - double.parse(transactionProvider.accounts[0]['sold_emprunt_cdf'].toString()) + pretCDF - empruntCDF + transactionProvider.accounts[0]['activities'].map((activity) => double.parse(activity['virtual_cdf'].toString())).reduce((value, element) => value + element)).toString()}",
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor))),
                              ],
                            ),
                          ])),
                ])
              : Container(
                  child: TextWidgets.text300(
                      title: "No data",
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor))
        ],
      );
    });
  }
}
