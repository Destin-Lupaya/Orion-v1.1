import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Helpers/account_helper.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Views/Guichet/Historique/dynamic_transactions_history.dart';
import 'package:provider/provider.dart';

class GlobalReportPage extends StatefulWidget {
  final bool? isDetailedAccountView;
  final Map? branch;

  const GlobalReportPage({Key? key, this.branch, this.isDetailedAccountView})
      : super(key: key);

  @override
  _GlobalReportPageState createState() => _GlobalReportPageState();
}

class _GlobalReportPageState extends State<GlobalReportPage> {
  List caisseData = [], activities = [], activitiesID = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getBranchData();
    });
  }

  getBranchData() async {
    var response = await Provider.of<adminAppStateProvider>(context,
            listen: false)
        .httpGet(url: '${BaseUrl.branch}/${widget.branch!["id"].toString()}');
    // await Provider.of<TransactionsStateProvider>(context, listen: false)
    //     .getActivities(activityID: selectedActivity!.id!.toString().trim());
    if (response.statusCode == 200) {
      // print(response.body);
      if (jsonDecode(response.body)['message'] != null) {
        Message.showToast(msg: "Cette branche ou activité n'existe pas");
        return;
      }
      var decoded = jsonDecode(response.body);
      caisseData = decoded['accounts'];
      activities = decoded['account_activity'];
      activitiesID = activities
          .map((activity) => activity['activity_id'].toString())
          .toSet()
          .toList();
      setState(() {});
    }
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
          height: MediaQuery.of(context).size.height * .85,
          // color: AppColors.kBlackLightColor,
          child: Consumer<AppStateProvider>(
              builder: (context, appStateProvider, child) {
            return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ListView(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  Consumer<AdminCaisseStateProvider>(
                      builder: (context, adminCaisseProvider, _) {
                    return CardWidget(
                      title: "Rapport branche ${widget.branch?['name']}",
                      backColor: AppColors.kBlackLightColor,
                      content: Column(
                        children: [
                          Column(children: [
                            Row(children: [
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.kGreyColor)),
                                    child: TextWidgets.text500(
                                        title: "Services",
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor)),
                              ),
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.kWhiteColor)),
                                    child: TextWidgets.text500(
                                        title: "USD",
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor)),
                              ),
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.kWhiteColor)),
                                      child: TextWidgets.text500(
                                          title: "CDF",
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor))),
                            ]),
                            activities.isNotEmpty && caisseData.isNotEmpty
                                ? Column(children: [
                                    Column(
                                        children: List.generate(
                                            activitiesID.length,
                                            (index) => GestureDetector(
                                                  onTap: () async {
                                                    await Provider.of<
                                                                TransactionsStateProvider>(
                                                            context,
                                                            listen: false)
                                                        .getTransactions(
                                                            isRefresh: true,
                                                            activityID:
                                                                activitiesID[
                                                                        index]
                                                                    .toString());
                                                    await Provider.of<
                                                                TransactionsStateProvider>(
                                                            context,
                                                            listen: false)
                                                        .getActivities(
                                                            isRefresh: true,
                                                            activityID:
                                                                activitiesID[
                                                                        index]
                                                                    .toString());
                                                    // return;
                                                    showCupertinoModalPopup(
                                                        context: context,
                                                        builder: (context) =>
                                                            Center(
                                                                child:
                                                                    DynamicHistoryTransList(
                                                              activityData: Provider.of<
                                                                          TransactionsStateProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .activities
                                                                  .where((activity) =>
                                                                      activity['activity']
                                                                              [
                                                                              'id']
                                                                          .toString()
                                                                          .trim() ==
                                                                      activitiesID[
                                                                              index]
                                                                          .toString())
                                                                  .toList()[0],
                                                              data: Provider.of<
                                                                          TransactionsStateProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .transactions[
                                                                      activitiesID[
                                                                              index]
                                                                          .toString()]
                                                                  .toList(),
                                                            )));
                                                  },
                                                  child: Row(children: [
                                                    Expanded(
                                                      child: Container(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 16,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .kWhiteColor)),
                                                          child: TextWidgets.text300(
                                                              title: activities
                                                                  .where((activity) =>
                                                                      activity['activity_id']
                                                                          .toString() ==
                                                                      activitiesID[index]
                                                                          .toString())
                                                                  .toSet()
                                                                  .toList()[0]['name'],
                                                              fontSize: 14,
                                                              textColor: AppColors.kWhiteColor)),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .kWhiteColor)),
                                                          child: TextWidgets.text300(
                                                              title: (AccountHelper.sumData(
                                                                      dataList:
                                                                          activities,
                                                                      column:
                                                                          'virtual_usd',
                                                                      key:
                                                                          'activity_id',
                                                                      value: activitiesID[index]
                                                                          .toString()))
                                                                  .toStringAsFixed(
                                                                      2),
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kWhiteColor)),
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 5),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .kWhiteColor)),
                                                            child: TextWidgets.text300(
                                                                title: (AccountHelper.sumData(
                                                                        dataList:
                                                                            activities,
                                                                        column:
                                                                            'virtual_cdf',
                                                                        key:
                                                                            'activity_id',
                                                                        value: activitiesID[index]
                                                                            .toString()))
                                                                    .toStringAsFixed(
                                                                        2),
                                                                fontSize: 14,
                                                                textColor: AppColors
                                                                    .kWhiteColor))),
                                                  ]),
                                                ))),
                                    Visibility(
                                      visible: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          displayAccountDetails(
                                              column: 'sold_pret',
                                              title: "Pret",
                                              canSumActivities: true,
                                              activityColumn: 'pret');
                                        },
                                        child: Row(children: [
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .kWhiteColor)),
                                                child: TextWidgets.text300(
                                                    title: "Pret",
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kWhiteColor)),
                                          ),
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .kWhiteColor)),
                                                child: TextWidgets.text300(
                                                    title: (AccountHelper.sumData(
                                                                dataList:
                                                                    caisseData,
                                                                column:
                                                                    'sold_pret_usd') +
                                                            AccountHelper.sumData(
                                                                dataList:
                                                                    activities,
                                                                column:
                                                                    'pret_usd'))
                                                        .toStringAsFixed(2),
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kWhiteColor)),
                                          ),
                                          Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .kWhiteColor)),
                                                  child: TextWidgets.text300(
                                                      title: (AccountHelper.sumData(
                                                                  dataList:
                                                                      caisseData,
                                                                  column:
                                                                      'sold_pret_cdf') +
                                                              AccountHelper.sumData(
                                                                  dataList:
                                                                      activities,
                                                                  column:
                                                                      'pret_cdf'))
                                                          .toStringAsFixed(2),
                                                      fontSize: 14,
                                                      textColor: AppColors.kWhiteColor))),
                                        ]),
                                      ),
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          displayAccountDetails(
                                              column: 'sold_emprunt',
                                              title: "Emprunt",
                                              canSumActivities: true,
                                              activityColumn: 'emprunt');
                                        },
                                        child: Row(children: [
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .kWhiteColor)),
                                                child: TextWidgets.text300(
                                                    title: "Emprunt",
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kWhiteColor)),
                                          ),
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .kWhiteColor)),
                                                child: TextWidgets.text300(
                                                    title: (AccountHelper.sumData(
                                                                dataList:
                                                                    caisseData,
                                                                column:
                                                                    'sold_emprunt_usd') +
                                                            AccountHelper.sumData(
                                                                dataList:
                                                                    activities,
                                                                column:
                                                                    'emprunt_usd'))
                                                        .toStringAsFixed(2),
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kWhiteColor)),
                                          ),
                                          Expanded(
                                              child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .kWhiteColor)),
                                                  child: TextWidgets.text300(
                                                      title:
                                                          "${caisseData.map((account) => account['sold_emprunt_cdf']).toList().reduce((prev, next) => double.parse(prev.toString()) + double.parse(next.toString())) + activities.map((activity) => activity['emprunt_cdf']).toList().reduce((prev, next) => double.parse(prev.toString()) + double.parse(next.toString()))}",
                                                      fontSize: 14,
                                                      textColor: AppColors
                                                          .kWhiteColor))),
                                        ]),
                                      ),
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          displayAccountDetails(
                                            column: 'sold_cash',
                                            title: "Cash",
                                          );
                                        },
                                        child: Row(children: [
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .kWhiteColor)),
                                                child: TextWidgets.text300(
                                                    title: "CASH",
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kWhiteColor)),
                                          ),
                                          Expanded(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .kWhiteColor)),
                                                child: TextWidgets.text300(
                                                    title: (AccountHelper.sumData(
                                                            dataList:
                                                                caisseData,
                                                            column:
                                                                'sold_cash_usd'))
                                                        .toStringAsFixed(2),
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kWhiteColor)),
                                          ),
                                          Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16,
                                                          vertical: 5),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .kWhiteColor)),
                                                  child: TextWidgets.text300(
                                                      title: (AccountHelper.sumData(
                                                              dataList:
                                                                  caisseData,
                                                              column:
                                                                  'sold_cash_cdf'))
                                                          .toStringAsFixed(2),
                                                      fontSize: 14,
                                                      textColor: AppColors
                                                          .kWhiteColor))),
                                        ]),
                                      ),
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        AppColors.kWhiteColor)),
                                            child: TextWidgets.textBold(
                                                title: "Total",
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        AppColors.kWhiteColor)),
                                            child: TextWidgets.textBold(
                                                title: (AccountHelper
                                                            .sumMultipleLists(
                                                                dataList: [
                                                              caisseData,
                                                              activities
                                                            ],
                                                                columnsList: [
                                                              [
                                                                'sold_cash_usd',
                                                                'sold_pret_usd'
                                                              ],
                                                              [
                                                                'virtual_usd',
                                                                'pret_usd'
                                                              ]
                                                            ]) -
                                                        AccountHelper.sumData(
                                                          dataList: caisseData,
                                                          column:
                                                              'sold_emprunt_usd',
                                                        ) -
                                                        AccountHelper.sumData(
                                                          dataList: activities,
                                                          column: 'emprunt_usd',
                                                        ))
                                                    .toStringAsFixed(2),
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor)),
                                      ),
                                      Expanded(
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .kWhiteColor)),
                                              child: TextWidgets.textBold(
                                                  title: (AccountHelper
                                                              .sumMultipleLists(
                                                                  dataList: [
                                                                caisseData,
                                                                activities
                                                              ],
                                                                  columnsList: [
                                                                [
                                                                  'sold_cash_cdf',
                                                                  'sold_pret_cdf'
                                                                ],
                                                                [
                                                                  'virtual_cdf',
                                                                  'pret_cdf'
                                                                ]
                                                              ]) -
                                                          AccountHelper.sumData(
                                                            dataList:
                                                                caisseData,
                                                            column:
                                                                'sold_emprunt_cdf',
                                                          ) -
                                                          AccountHelper.sumData(
                                                            dataList:
                                                                activities,
                                                            column:
                                                                'emprunt_cdf',
                                                          ))
                                                      .toStringAsFixed(2),
                                                  fontSize: 14,
                                                  textColor:
                                                      AppColors.kWhiteColor))),
                                    ]),
                                  ])
                                : Container(
                                    child: TextWidgets.text300(
                                        title: "No data",
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor))
                          ]),
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

  displayAccountDetails(
      {required String column,
      required String title,
      bool? canSumActivities = false,
      String activityColumn = ''}) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                // height: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidgets.textBold(
                        title: "Solde $title des caisses",
                        fontSize: 18,
                        textColor: AppColors.kBlackColor),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex:2, child:Container(),
                            // child: TextWidgets.text500(
                            //     title: "Caissier",
                            //     fontSize: 14,
                            //     textColor: AppColors.kBlackColor)
                                ),
                        Expanded(
                            child: TextWidgets.text500(
                                title: "USD",
                                fontSize: 14,
                                textColor: AppColors.kBlackColor)),
                        Expanded(
                            child: TextWidgets.text500(
                                title: "CDF",
                                fontSize: 14,
                                textColor: AppColors.kBlackColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                        children: List.generate(caisseData.length, (index) {
                      // double virtualSum = 0;
                      // if (canSumActivities == true) {
                      //   virtualSum = AccountHelper.sumData(
                      //       dataList: activities
                      //           .where((activity) =>
                      //               activity['account_id'].toString() ==
                      //               caisseData[index]['id'].toString())
                      //           .toList(),
                      //       column: "${activityColumn}_usd");
                      // }
                      return Container(
                        margin: const EdgeInsets.only(bottom:8.0),
                        decoration:BoxDecoration(border:Border(bottom: BorderSide(color: AppColors.kGreyColor.withOpacity(0.5), width:1))),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidgets.text500(
                                  title: caisseData[index]['names'],
                                  fontSize: 12,
                                  textColor: AppColors.kBlackColor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex:2,
                                      child: TextWidgets.text300(
                                          title: "Caisse"
                                              .toString(),
                                          fontSize: 14,
                                          textColor: AppColors.kBlackColor)),
                                  Expanded(
                                      child: TextWidgets.text300(
                                          title:
                                              "${caisseData[index]["${column}_usd"]}"
                                                  .toString(),
                                          fontSize: 14,
                                          textColor: AppColors.kBlackColor)),
                                  Expanded(
                                      child: TextWidgets.text300(
                                          title:
                                              "${caisseData[index]["${column}_cdf"]}"
                                                  .toString(),
                                          fontSize: 14,
                                          textColor: AppColors.kBlackColor))
                                ],
                              ),
                              if(canSumActivities==true)TextWidgets.text500(
                                  title: "Activités",
                                  fontSize: 12,
                                  textColor: AppColors.kGreyColor),
                              if(canSumActivities==true)Column(
                                  children: List.generate(
                                      activities
                                          .where((activity) =>
                                              activity['account_id'].toString() ==
                                              caisseData[index]['id'].toString())
                                          .toList()
                                          .length, (activityIndex) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex:2,
                                        child: TextWidgets.text300(
                                            title:
                                                "${activities.where((activity) => activity['account_id'].toString() == caisseData[index]['id'].toString()).toList()[activityIndex]["name"]}"
                                                    .toString(),
                                            fontSize: 14,
                                            textColor: AppColors.kBlackColor)),
                                    Expanded(
                                        child: TextWidgets.text300(
                                            title:
                                                "${activities.where((activity) => activity['account_id'].toString() == caisseData[index]['id'].toString()).toList()[activityIndex]["${activityColumn}_usd"]}"
                                                    .toString(),
                                            fontSize: 14,
                                            textColor: AppColors.kBlackColor)),
                                    Expanded(
                                        child: TextWidgets.text300(
                                            title:
                                                "${activities.where((activity) => activity['account_id'].toString() == caisseData[index]['id'].toString()).toList()[activityIndex]["${activityColumn}_cdf"]}"
                                                    .toString(),
                                            fontSize: 14,
                                            textColor: AppColors.kBlackColor))
                                  ],
                                );
                              }))
                            ],
                          ),
                        ),
                      );
                    }))
                  ],
                ),
              ),
            ));
  }

  displayReport() {
    return Column(children: [
      Row(children: [
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kGreyColor)),
              child: TextWidgets.text500(
                  title: "Services",
                  fontSize: 14,
                  textColor: AppColors.kWhiteColor)),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kWhiteColor)),
              child: TextWidgets.text500(
                  title: "USD",
                  fontSize: 14,
                  textColor: AppColors.kWhiteColor)),
        ),
        Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kWhiteColor)),
                child: TextWidgets.text500(
                    title: "CDF",
                    fontSize: 14,
                    textColor: AppColors.kWhiteColor))),
      ]),
      activities.isNotEmpty && caisseData.isNotEmpty
          ? Column(children: [
              Column(
                  children: List.generate(
                      activitiesID.length,
                      (index) => GestureDetector(
                            onTap: () async {
                              await Provider.of<TransactionsStateProvider>(
                                      context,
                                      listen: false)
                                  .getTransactions(
                                      isRefresh: true,
                                      activityID:
                                          activitiesID[index].toString());
                              await Provider.of<TransactionsStateProvider>(
                                      context,
                                      listen: false)
                                  .getActivities(
                                      isRefresh: true,
                                      activityID:
                                          activitiesID[index].toString());
                              // return;
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => Center(
                                          child: DynamicHistoryTransList(
                                        activityData: Provider.of<
                                                    TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .activities
                                            .where((activity) =>
                                                activity['activity']['id']
                                                    .toString()
                                                    .trim() ==
                                                activitiesID[index].toString())
                                            .toList()[0],
                                        data: Provider.of<
                                                    TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .transactions[
                                                activitiesID[index].toString()]
                                            .toList(),
                                      )));
                            },
                            child: Row(children: [
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.kWhiteColor)),
                                    child: TextWidgets.text300(
                                        title: activities
                                            .where((activity) =>
                                                activity['activity_id']
                                                    .toString() ==
                                                activitiesID[index].toString())
                                            .toSet()
                                            .toList()[0]['name'],
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor)),
                              ),
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.kWhiteColor)),
                                    child: TextWidgets.text300(
                                        title: (AccountHelper.sumData(
                                                dataList: activities,
                                                column: 'virtual_usd',
                                                key: 'activity_id',
                                                value: activitiesID[index]
                                                    .toString()))
                                            .toStringAsFixed(2),
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor)),
                              ),
                              Expanded(
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.kWhiteColor)),
                                      child: TextWidgets.text300(
                                          title: (AccountHelper.sumData(
                                                  dataList: activities,
                                                  column: 'virtual_cdf',
                                                  key: 'activity_id',
                                                  value: activitiesID[index]
                                                      .toString()))
                                              .toStringAsFixed(2),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor))),
                            ]),
                          ))),
              Visibility(
                visible: true,
                child: Row(children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.text300(
                            title: "Pret",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.text300(
                            title: (AccountHelper.sumData(
                                        dataList: caisseData,
                                        column: 'sold_pret_usd') +
                                    AccountHelper.sumData(
                                        dataList: activities,
                                        column: 'pret_usd'))
                                .toStringAsFixed(2),
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.kWhiteColor)),
                          child: TextWidgets.text300(
                              title: (AccountHelper.sumData(
                                          dataList: caisseData,
                                          column: 'sold_pret_cdf') +
                                      AccountHelper.sumData(
                                          dataList: activities,
                                          column: 'pret_cdf'))
                                  .toStringAsFixed(2),
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor))),
                ]),
              ),
              Visibility(
                visible: true,
                child: Row(children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.text300(
                            title: "Emprunt",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.text300(
                            title: (AccountHelper.sumData(
                                        dataList: caisseData,
                                        column: 'sold_emprunt_usd') +
                                    AccountHelper.sumData(
                                        dataList: activities,
                                        column: 'emprunt_usd'))
                                .toStringAsFixed(2),
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.kWhiteColor)),
                          child: TextWidgets.text300(
                              title:
                                  "${caisseData.map((account) => account['sold_emprunt_cdf']).toList().reduce((prev, next) => double.parse(prev.toString()) + double.parse(next.toString())) + activities.map((activity) => activity['emprunt_cdf']).toList().reduce((prev, next) => double.parse(prev.toString()) + double.parse(next.toString()))}",
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor))),
                ]),
              ),
              Visibility(
                visible: true,
                child: Row(children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.text300(
                            title: "CASH",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.text300(
                            title: (AccountHelper.sumData(
                                    dataList: caisseData,
                                    column: 'sold_cash_usd'))
                                .toStringAsFixed(2),
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor)),
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.kWhiteColor)),
                          child: TextWidgets.text300(
                              title: (AccountHelper.sumData(
                                      dataList: caisseData,
                                      column: 'sold_cash_cdf'))
                                  .toStringAsFixed(2),
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor))),
                ]),
              ),
              Row(children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.kWhiteColor)),
                      child: TextWidgets.textBold(
                          title: "Total",
                          fontSize: 14,
                          textColor: AppColors.kWhiteColor)),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.kWhiteColor)),
                      child: TextWidgets.textBold(
                          title: (AccountHelper.sumMultipleLists(dataList: [
                                    caisseData,
                                    activities
                                  ], columnsList: [
                                    ['sold_cash_usd', 'sold_pret_usd'],
                                    ['virtual_usd', 'pret_usd']
                                  ]) -
                                  AccountHelper.sumData(
                                    dataList: caisseData,
                                    column: 'sold_emprunt_usd',
                                  ) -
                                  AccountHelper.sumData(
                                    dataList: activities,
                                    column: 'emprunt_usd',
                                  ))
                              .toStringAsFixed(2),
                          fontSize: 14,
                          textColor: AppColors.kWhiteColor)),
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.kWhiteColor)),
                        child: TextWidgets.textBold(
                            title: (AccountHelper.sumMultipleLists(dataList: [
                                      caisseData,
                                      activities
                                    ], columnsList: [
                                      ['sold_cash_cdf', 'sold_pret_cdf'],
                                      ['virtual_cdf', 'pret_cdf']
                                    ]) -
                                    AccountHelper.sumData(
                                      dataList: caisseData,
                                      column: 'sold_emprunt_cdf',
                                    ) -
                                    AccountHelper.sumData(
                                      dataList: activities,
                                      column: 'emprunt_cdf',
                                    ))
                                .toStringAsFixed(2),
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor))),
              ]),
            ])
          : Container(
              child: TextWidgets.text300(
                  title: "No data",
                  fontSize: 14,
                  textColor: AppColors.kWhiteColor))
    ]);
  }
}
