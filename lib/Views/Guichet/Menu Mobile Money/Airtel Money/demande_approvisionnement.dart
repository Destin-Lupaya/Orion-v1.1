import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Demands/new_demand.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class DemandeApprovList extends StatefulWidget {
  final bool updatingData;
  final Map accountData;
  final Map activityData;

  DemandeApprovList(
      {Key? key,
      required this.accountData,
      required this.activityData,
      required this.updatingData})
      : super(key: key);

  @override
  State<DemandeApprovList> createState() => _DemandeApprovListState();
}

class _DemandeApprovListState extends State<DemandeApprovList> {
  final TextEditingController _searchCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Consumer<TransactionsStateProvider>(
                    builder: (context, transactionProvider, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                            text: "Imprimer",
                            backColor: AppColors.kGreenColor,
                            textColor: AppColors.kWhiteColor,
                            callback: () {
                              reportDemand(
                                  title: "Demandes",
                                  data: transactionProvider.demands
                                      .where((demand) =>
                                          demand['receiver_id']
                                                  .toString()
                                                  .trim() ==
                                              Provider.of<UserStateProvider>(
                                                      navKey.currentContext!,
                                                      listen: false)
                                                  .clientAccountData['id']
                                                  .toString() ||
                                          demand['sender_id']
                                                  .toString()
                                                  .trim() ==
                                              Provider.of<UserStateProvider>(
                                                      navKey.currentContext!,
                                                      listen: false)
                                                  .clientAccountData['id']
                                                  .toString())
                                      .toList());
                            }),
                      ),
                      Expanded(child: Container()),
                    ],
                  );
                }),
                Row(
                  children: [
                    !Responsive.isMobile(context)
                        ? Expanded(flex: 2, child: Container())
                        : Container(),
                    if (Responsive.isWeb(context))
                      Expanded(
                        child: SearchTextFormFieldWidget(
                            backColor: AppColors.kTextFormWhiteColor,
                            hintText: 'Recherchez...',
                            isObsCured: false,
                            editCtrller: _searchCtrller,
                            textColor: AppColors.kWhiteColor,
                            maxLines: 1),
                      ),
                  ],
                )
              ],
            ),
            // if (Responsive.isWeb(context)) filterWidget(),
            // const SizedBox(
            //   height: 20,
            // ),
            buildLoansList(context: context)
          ],
        ),
      ),
    );
  }

  String statusFilter = "Initiated",
      creditFilter = "Approvisionez-vous chez l' agregateur";

  filterWidget() {
    return Row(
      children: [
        Expanded(
            child: CustomDropdownButton(
                backColor: AppColors.kWhiteDarkColor,
                value: statusFilter,
                hintText: 'Status',
                callBack: (value) {},
                items: const [
              "Initiated",
              "En cours d'étude",
              "En attente",
              "Pending",
              "Denied"
            ])),
        Expanded(
            child: CustomDropdownButton(
                backColor: AppColors.kWhiteDarkColor,
                value: creditFilter,
                hintText: 'Type Historique',
                callBack: (value) {},
                items: const [
              "Approvisionez-vous chez l' agregateur",
              "Approvisionnement Inter-Agent"
            ])),
      ],
    );
  }

  buildLoansList({required BuildContext context}) {
    return Consumer<TransactionsStateProvider>(
      builder: (context, transactionProvider, _) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionProvider.demands
                  .where((demand) {
                    return (demand['receiver_id'].toString().trim() ==
                                Provider.of<UserStateProvider>(
                                        navKey.currentContext!,
                                        listen: false)
                                    .clientAccountData['id']
                                    .toString() ||
                            demand['sender_id'].toString().trim() ==
                                Provider.of<UserStateProvider>(
                                        navKey.currentContext!,
                                        listen: false)
                                    .clientAccountData['id']
                                    .toString()) &&
                        (demand['activity_id'] == null ||
                            (demand['activity_id'].toString().trim() ==
                                    widget.activityData['activity_id']
                                        .toString()
                                        .trim() &&
                                demand['activity_id'] != null)) &&
                        !demand['alerte']
                            .toString()
                            .toLowerCase()
                            .contains('approv');
                  })
                  .toList()
                  .length,
              itemBuilder: (context, int paybackIndex) {
                return ListItem(
                    accountData: widget.accountData,
                    activityData: widget.activityData,
                    data: transactionProvider.demands
                        .where((demand) =>
                            (demand['receiver_id'].toString().trim() ==
                                    Provider.of<UserStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .clientAccountData['id']
                                        .toString() ||
                                demand['sender_id'].toString().trim() ==
                                    Provider.of<UserStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .clientAccountData['id']
                                        .toString()) &&
                            (demand['activity_id'] == null ||
                                (demand['activity_id'].toString().trim() ==
                                        widget.activityData['activity_id']
                                            .toString()
                                            .trim() &&
                                    demand['activity_id'] != null)) &&
                            !demand['alerte']
                                .toString()
                                .toLowerCase()
                                .contains('approv'))
                        .toList()[paybackIndex]);
              },
            ),
          ],
        );
      },
    );
  }
}

class ListItem extends StatefulWidget {
  final Map data, accountData, activityData;

  const ListItem(
      {Key? key,
      required this.data,
      required this.accountData,
      required this.activityData})
      : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  Color borderColor = AppColors.kTransparentColor;
  bool isViewingMore = false;

  @override
  void initState() {
    super.initState();
    if (widget.data['alerte'].toString().trim().toLowerCase() == 'urgent') {
      borderColor = AppColors.kRedColor;
    }
    if (widget.data['alerte'].toString().trim().toLowerCase() == 'preventif') {
      borderColor = AppColors.kGreenColor;
    }
    if (widget.data['alerte'].toString().trim().toLowerCase() ==
        'rupture de stock') {
      borderColor = AppColors.kYellowColor;
    }
    if (widget.data['status'].toString().trim().toLowerCase() != 'pending') {
      borderColor = AppColors.kGreenColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
            // onTap: null,
            onTap: () {
              setState(() {
                isViewingMore = !isViewingMore;
              });
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: Colors.yellow, width: 2))),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    color: AppColors.kBlackLightColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Card(
                        color: AppColors.kWhiteColor.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                                widget.data['sender_id'].toString() ==
                                        Provider.of<UserStateProvider>(
                                                navKey.currentContext!,
                                                listen: false)
                                            .clientAccountData['id']
                                            .toString()
                                    ? Icons.call_missed_outgoing_outlined
                                    : Icons.call_missed_outlined,
                                color: widget.data['sender_id'].toString() ==
                                        Provider.of<UserStateProvider>(
                                                navKey.currentContext!,
                                                listen: false)
                                            .clientAccountData['id']
                                            .toString()
                                    ? AppColors.kGreenColor
                                    : AppColors.kRedColor,
                                size: 30)),
                      ),
                      trailing: Card(
                        color: AppColors.kWhiteColor.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextWidgets.textBold(
                                overflow: TextOverflow.ellipsis,
                                title:
                                    "${widget.data['type_devise'].toString()} ${widget.data['amount'].toString()}",
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor)),
                      ),
                      title: TextWidgets.textBold(
                          overflow: TextOverflow.ellipsis,
                          title: widget.accountData['id'].toString() ==
                                  widget.data['sender_id'].toString()
                              ? Provider.of<TransactionsStateProvider>(
                                      navKey.currentContext!,
                                      listen: false)
                                  .othersAccounts
                                  .where((account) =>
                                      account['id'].toString() ==
                                      widget.data['receiver_id'].toString())
                                  .toList()[0]['names']
                                  .toString()
                                  .toUpperCase()
                              : Provider.of<TransactionsStateProvider>(
                                      navKey.currentContext!,
                                      listen: false)
                                  .othersAccounts
                                  .where((account) =>
                                      account['id'].toString() ==
                                      widget.data['sender_id'].toString())
                                  .toList()[0]['names']
                                  .toString()
                                  .toUpperCase(),
                          fontSize: 14,
                          textColor: AppColors.kWhiteColor),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            TextWidgets.text300(
                                overflow: TextOverflow.ellipsis,
                                title: widget.data['status']
                                    .toString()
                                    .toUpperCase(),
                                fontSize: 12,
                                textColor: AppColors.kGreyColor),
                            const SizedBox(height: 8),
                            Visibility(
                                visible: isViewingMore,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (widget.data['receiver_id']
                                                            .toString() ==
                                                        Provider.of<UserStateProvider>(
                                                                navKey
                                                                    .currentContext!,
                                                                listen: false)
                                                            .clientAccountData[
                                                                'id']
                                                            .toString() &&
                                                    widget.data['status']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'terminated') {
                                                  Message.showToast(
                                                      msg:
                                                          "La demande n'est plus de votre ressort");
                                                  return;
                                                } else if (widget
                                                            .data['receiver_id']
                                                            .toString() ==
                                                        Provider.of<UserStateProvider>(
                                                                navKey
                                                                    .currentContext!,
                                                                listen: false)
                                                            .clientAccountData[
                                                                'id']
                                                            .toString() &&
                                                    ['accepted', 'terminated']
                                                        .contains(widget
                                                            .data['status']
                                                            .toString()
                                                            .toLowerCase()) &&
                                                    widget.data['status']
                                                            .toString()
                                                            .toLowerCase() !=
                                                        'pending') {
                                                  Message.showToast(
                                                      msg:
                                                          "La demande n'est plus de votre ressort");
                                                  return;
                                                }
                                                showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (context) =>
                                                        Center(
                                                            child: DemandPage(
                                                          accountData: widget
                                                              .accountData,
                                                          activityData: widget
                                                              .activityData,
                                                          demandData:
                                                              widget.data,
                                                          updatingData: true,
                                                        )));
                                              },
                                              child: Card(
                                                  color: AppColors.kWhiteColor
                                                      .withOpacity(0.1),
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      child: TextWidgets.text300(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          title:
                                                              'Suivre la demande',
                                                          fontSize: 12,
                                                          textColor: AppColors
                                                              .kGreyColor))),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                          runAlignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          runSpacing: 8,
                                          spacing: 8,
                                          children: [
                                            TextWidgets.textWithLabel(
                                                title: 'Jour',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget.data[
                                                            'created_at'] !=
                                                        null
                                                    ? DateTime.parse(widget
                                                            .data['created_at']
                                                            .toString())
                                                        .toString()
                                                        .substring(0, 10)
                                                    : ''),
                                            TextWidgets.textWithLabel(
                                                title: 'Montant deboursé',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget.data[
                                                            'amount_send'] !=
                                                        null
                                                    ? "${widget.data['type_devise'].toString()} ${widget.data['amount_send'].toString()}"
                                                    : ""),
                                            TextWidgets.textWithLabel(
                                                title: 'Type Transaction',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget
                                                    .data['type_transaction']
                                                    .toString()),
                                            TextWidgets.textWithLabel(
                                                title: 'Status',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget.data['status']
                                                    .toString()),
                                          ]),
                                    ]))
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Center(
              child: Container(
                  // width: 10,
                  // height: 10,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.kWhiteColor),
                  child: widget
                                  .data['status']
                                  .toString()
                                  .trim()
                                  .toLowerCase() ==
                              'validated' ||
                          widget.data['status']
                                  .toString()
                                  .trim()
                                  .toLowerCase() ==
                              'accepted' ||
                          widget.data['status']
                                  .toString()
                                  .trim()
                                  .toLowerCase() ==
                              'paid'
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.kGreenColor,
                          size: 15,
                        )
                      : widget.data['status'].toString().trim().toLowerCase() ==
                              'pending'
                          ? Icon(
                              Icons.autorenew,
                              color: AppColors.kBlackColor,
                              size: 15,
                            )
                          : Icon(
                              Icons.clear,
                              color: AppColors.kRedColor,
                              size: 15,
                            )),
            ),
          ),
        ],
      ),
    );
  }
}
