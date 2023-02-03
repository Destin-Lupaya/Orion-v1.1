import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Supply/request_supply_page.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class SupplyPage extends StatefulWidget {
  final Map accountData;

  const SupplyPage({Key? key, required this.accountData}) : super(key: key);

  @override
  _SupplyPageState createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> {
  Map? receiverInfo;
  Map? receiverUser;
  TransactionsStateProvider? transProvider;

  @override
  void initState() {
    super.initState();
    transProvider =
        Provider.of<TransactionsStateProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<TransactionsStateProvider>(navKey.currentContext!,
              listen: false)
          .getDemands();
      data = Provider.of<TransactionsStateProvider>(navKey.currentContext!,
              listen: false)
          .demands
          .where((demand) =>
              demand['alerte'].toString().toLowerCase() ==
                  'approvisionnement' &&
              (demand['sender_id'].toString() ==
                      widget.accountData['id'].toString() ||
                  demand['receiver_id'].toString() ==
                      widget.accountData['id'].toString()))
          .toList();

      displayData = data;
      setState(() {});
    });
  }

  List data = [], displayData = [];

  bool isCash = true;
  String? receiverID, choosedDevise = "USD";
  Map activityData = {};

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
                      title: 'Approvisionner un compte',
                      content: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomButton(
                                text: 'Nouvel approvisionnement',
                                backColor: AppColors.kGreenColor,
                                textColor: AppColors.kWhiteColor,
                                isEnabled: true,
                                callback: () {
                                  Navigator.pop(navKey.currentContext!);
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => Center(
                                              child: RequestSupplyPage(
                                            accountData: Provider.of<
                                                        TransactionsStateProvider>(
                                                    navKey.currentContext!,
                                                    listen: false)
                                                .accounts[0]!,
                                            updatingData: false,
                                          )));
                                },
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                        const SizedBox(height: 16),
                        tabWidget(titles: [
                          "Approvisionnements reçus",
                          "Approvisionnement effectués"
                        ]),
                        const SizedBox(height: 8),
                        Consumer<TransactionsStateProvider>(
                            builder: (context, transactionsProvider, _) {
                          if (currentTab == "Mes approvisionnements") {
                            data = Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .demands
                                .where((demand) =>
                                    demand['alerte'].toString().toLowerCase() ==
                                        'approvisionnement' &&
                                    (demand['sender_id'].toString() ==
                                        widget.accountData['id'].toString()))
                                .toList();
                          } else {
                            data = Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .demands
                                .where((demand) =>
                                    demand['alerte'].toString().toLowerCase() ==
                                        'approvisionnement' &&
                                    demand['receiver_id'].toString() ==
                                        widget.accountData['id'].toString())
                                .toList();
                          }

                          // displayData = data;
                          return Column(
                              children: List.generate(data.length, (index) {
                            return cardStatsWidget(
                                data: data[index],
                                backColor: AppColors.kBlackColor,
                                textColor: AppColors.kWhiteColor,
                                icon: Icons.credit_card,
                                currency: "",
                                value:
                                    "${data[index]['amount'].toString()} ${data[index]['type_devise'].toString()}",
                                value2:
                                    "${data[index]['type_transaction'].toString()}");
                          }));
                        }),
                      ]),
                    )
                  ]));
        }));
  }

  cardStatsWidget(
      {required Map data,
      required IconData icon,
      required Color textColor,
      required Color backColor,
      required String value,
      required String value2,
      required String currency,
      double? width}) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (context) => Center(
                    child: RequestSupplyPage(
                  accountData: Provider.of<TransactionsStateProvider>(
                          navKey.currentContext!,
                          listen: false)
                      .accounts[0]!,
                  updatingData: true,
                  supplyData: data,
                )));
      },
      child: Container(
        width: width,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: activityData.isNotEmpty &&
                          activityData['id'].toString() == data['id'].toString()
                      ? AppColors.kGreenColor
                      : AppColors.kTransparentColor,
                  width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Card(
            color: backColor,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
            child: Container(
              // width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Card(
                    color: textColor.withOpacity(0.2),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                          data['sender_id'].toString() ==
                                  widget.accountData['id'].toString()
                              ? Icons.call_missed_outlined
                              : Icons.call_missed_outgoing_outlined,
                          color: data['sender_id'].toString() ==
                                  widget.accountData['id'].toString()
                              ? AppColors.kGreenColor
                              : AppColors.kRedColor,
                          size: 30),
                    ),
                  ),
                  Expanded(
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
                                    title: widget.accountData['id']
                                                .toString() ==
                                            data['sender_id'].toString()
                                        ? transProvider!.othersAccounts
                                            .where((account) =>
                                                account['id'].toString() ==
                                                data['receiver_id'].toString())
                                            .toList()[0]['names']
                                            .toString()
                                            .toUpperCase()
                                        : transProvider!.othersAccounts
                                            .where((account) =>
                                                account['id'].toString() ==
                                                data['sender_id'].toString())
                                            .toList()[0]['names']
                                            .toString()
                                            .toUpperCase(),
                                    fontSize: 12,
                                    textColor: textColor),
                                TextWidgets.text300(
                                    overflow: TextOverflow.ellipsis,
                                    title: data['created_at']
                                        .toString()
                                        .substring(0, 10),
                                    fontSize: 12,
                                    textColor: textColor),
                              ],
                            )),
                            Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Card(
                                  elevation: 0,
                                  color: AppColors.kYellowColor,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: TextWidgets.text300(
                                        overflow: TextOverflow.ellipsis,
                                        title: data['status'].toString().trim(),
                                        fontSize: 12,
                                        textColor: backColor),
                                  ),
                                ),
                              ],
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
                                  title: value,
                                  fontSize: 14,
                                  textColor: textColor),
                            ])),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextWidgets.textBold(
                                    title: value2,
                                    fontSize: 14,
                                    textColor: textColor),
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String currentTab = "";

  tabWidget({required List<String> titles}) {
    if (currentTab == "") {
      currentTab = titles[0];
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kTextFormWhiteColor,
      ),
      child: Row(
        children: List.generate(titles.length, (index) {
          return Expanded(
              child: tabButton(
                  title: titles[index], textColor: AppColors.kWhiteColor));
        }),
      ),
    );
  }

  tabButton({required String title, required Color textColor}) {
    return GestureDetector(
      onTap: () {
        if (currentTab == title) {
          return;
        }
        currentTab = title;
        setState(() {});
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
                bottom: BorderSide(
                    color: currentTab == title ? textColor : Colors.transparent,
                    width: 2)),
          ),
          child: Center(
              child: TextWidgets.textNormal(
                  title: title,
                  fontSize: 16,
                  textColor: currentTab == title
                      ? textColor
                      : textColor.withOpacity(0.6)))),
    );
  }
}
