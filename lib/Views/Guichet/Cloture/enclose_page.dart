import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Cloture/accept_enclose_page.dart';
import 'package:orion/Views/Guichet/Cloture/end_day_page.dart';
import 'package:orion/Views/Guichet/Demands/helper.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class EnclosePage extends StatefulWidget {
  final bool updatingData;
  final Map accountData;

  const EnclosePage({
    Key? key,
    required this.accountData,
    required this.updatingData,
  }) : super(key: key);

  @override
  _EnclosePageState createState() => _EnclosePageState();
}

class _EnclosePageState extends State<EnclosePage> {
  ConnectedUser? connectedUser;
  TransactionsStateProvider? transactionProvider;

  @override
  void initState() {
    transactionProvider =
        Provider.of<TransactionsStateProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ClotureProvider>(navKey.currentContext!, listen: false)
          .getEncloseData();
    });
  }

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
                  title: 'Clotures en cours',
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            text: 'Clôturer ma journée',
                            backColor: AppColors.kGreenColor,
                            textColor: AppColors.kWhiteColor,
                            isEnabled: Provider.of<UserStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .clientData!
                                        .role
                                        .toString()
                                        .toLowerCase() ==
                                    'comptable'
                                ? false
                                : true,
                            callback: () {
                              Navigator.pop(context);
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => Center(
                                          child: EndDayPage(
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
                        Expanded(child: Container()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    tabWidget(
                        titles: ["Clotures effectuées", "Clotures reçues"]),
                    const SizedBox(height: 8),
                    Consumer<ClotureProvider>(builder: (context, provider, _) {
                      // print(widget.accountData['id']);
                      List data = [];
                      if (currentTab == "Clotures effectuées") {
                        data = provider.encloseDayData
                            .where((enclose) =>
                                enclose['sender_id'].toString() ==
                                widget.accountData['id'].toString())
                            .toList();
                      } else {
                        data = provider.encloseDayData
                            .where((enclose) =>
                                widget.accountData['id'].toString() ==
                                enclose['receiver_id'].toString())
                            .toList();
                      }
                      return Column(
                          children: List.generate(data.length, (index) {
                        return cardStatsWidget(
                            encloseData: data[index],
                            title: "Test",
                            subtitle: data[index]['date_send'].toString(),
                            backColor: AppColors.kTextFormWhiteColor,
                            textColor: AppColors.kWhiteColor,
                            icon: Icons.credit_card,
                            currency: "",
                            value:
                                "${data[index]['amount_cdf'].toString()} CDF",
                            value2:
                                "${data[index]['amount_usd'].toString()} USD");
                      }));
                    }),
                  ]),
                )
              ]);
        }));
  }

  cardStatsWidget(
      {required Map encloseData,
      required String title,
      required String subtitle,
      required IconData icon,
      required Color textColor,
      required Color backColor,
      required String value,
      required String value2,
      required String currency}) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (context) => Center(
                    child: AcceptEnclosePage(
                  encloseData: encloseData,
                  accountData: Provider.of<TransactionsStateProvider>(
                          navKey.currentContext!,
                          listen: false)
                      .accounts[0]!,
                  updatingData: true,
                )));
      },
      child: Container(
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
                        encloseData['sender_id'].toString() ==
                                widget.accountData['id'].toString()
                            ? Icons.call_missed_outgoing_outlined
                            : Icons.call_missed_outlined,
                        color: encloseData['sender_id'].toString() ==
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
                                  title: widget.accountData['id'].toString() ==
                                          encloseData['sender_id'].toString()
                                      ? Provider.of<TransactionsStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .othersAccounts
                                          .where((account) =>
                                              account['id'].toString() ==
                                              encloseData['receiver_id']
                                                  .toString())
                                          .toList()[0]['names']
                                          .toString()
                                          .toUpperCase()
                                      : Provider.of<TransactionsStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .othersAccounts
                                          .where((account) =>
                                              account['id'].toString() ==
                                              encloseData['sender_id']
                                                  .toString())
                                          .toList()[0]['names']
                                          .toString()
                                          .toUpperCase(),
                                  fontSize: 12,
                                  textColor: textColor),
                              TextWidgets.text300(
                                  overflow: TextOverflow.ellipsis,
                                  title: subtitle,
                                  fontSize: 12,
                                  textColor: textColor),
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
                                      encloseData['status'].toString().trim(),
                                  fontSize: 12,
                                  textColor: textColor),
                            ),
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
