import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/sorti_airtel_money.dart';
import 'package:provider/provider.dart';

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
  // Color borderColor = AppColors.kTransparentColor;
  bool isViewingMore = false;

  TransactionsStateProvider getTransactionProvider({bool listen = false}) {
    return Provider.of<TransactionsStateProvider>(context, listen: listen);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsStateProvider>(
        builder: (context, transactionProvider, _) {
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
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    // border: Border.all(color: borderColor),
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
                                widget.data['type_payment']
                                            .toString()
                                            .toLowerCase()
                                            .contains('pret') ||
                                        widget.data['type_operation']
                                            .toString()
                                            .toLowerCase()
                                            .contains('retrait')
                                    ? Icons.call_missed_outgoing_outlined
                                    : Icons.call_missed_outlined,
                                color: !widget.data['type_payment']
                                            .toString()
                                            .toLowerCase()
                                            .contains('pret') &&
                                        !widget.data['type_operation']
                                            .toString()
                                            .toLowerCase()
                                            .contains('retrait')
                                    ? AppColors.kGreenColor
                                    : AppColors.kRedColor,
                                size: 30)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            color: AppColors.kWhiteColor.withOpacity(0.2),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextWidgets.textBold(
                                    overflow: TextOverflow.ellipsis,
                                    title:
                                        "${widget.data['type_devise'].toString()} ${widget.data['amount'].toString()}",
                                    fontSize: 12,
                                    textColor: AppColors.kWhiteColor)),
                          ),
                          IconButton(
                              padding: const EdgeInsets.all(5.0),
                              onPressed: () {
                                reportRecu(
                                    title: Provider.of<UserStateProvider>(
                                            context,
                                            listen: false)
                                        .clientData!
                                        .names!,
                                    data: widget.data,
                                    inputs: getTransactionProvider()
                                        .targetedActivity['inputs']);
                              },
                              icon: Icon(Icons.print,
                                  color: AppColors.kWhiteColor))
                        ],
                      ),
                      title: TextWidgets.textBold(
                          overflow: TextOverflow.ellipsis,
                          title: widget.data['type_operation']
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
                                title: widget.data['type_payment']
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
                                                if (!widget.data['type_payment']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains('pret') &&
                                                    !widget.data['type_payment']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains('emprunt')) {
                                                  return;
                                                }
                                                if (widget.data['status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'paid') {
                                                  Message.showToast(
                                                      msg:
                                                          'Cette transaction est deja payée');
                                                  return;
                                                }
                                                showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (context) =>
                                                        Center(
                                                            child:
                                                                SortiAirtelmoneyPage(
                                                          // accountData: widget.accountData,
                                                          activityData: widget
                                                              .activityData,
                                                          targetedData:
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
                                                              'Suivre la transaction',
                                                          fontSize: 12,
                                                          textColor: AppColors
                                                              .kGreyColor))),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                          // mainAxisAlignment: MainAxisAlignment
                                          //     .spaceBetween,
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
                                                            'dateTrans'] !=
                                                        null
                                                    ? DateTime.parse(widget
                                                            .data['dateTrans']
                                                            .toString())
                                                        .toString()
                                                        .substring(0, 10)
                                                    : ''),
                                            TextWidgets.textWithLabel(
                                                title: 'refkey',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget.data['refkey']
                                                    .toString()),
                                            TextWidgets.textWithLabel(
                                                title: 'Type Transaction',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget
                                                    .data['type_operation']
                                                    .toString()),
                                            TextWidgets.textWithLabel(
                                                title: 'Status',
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.kWhiteColor,
                                                value: widget.data['status']
                                                    .toString()),
                                            ...widget.data.keys
                                                .toList()
                                                .where((key) => key
                                                    .toString()
                                                    .contains('col_'))
                                                .toList()
                                                .map((el) =>
                                                    TextWidgets.textWithLabel(
                                                        title:
                                                            "${getTransactionProvider().targetedActivity['inputs'][int.parse(el.split('_')[1].toString()) - 1]['designation']}",
                                                        value: widget.data[el]
                                                            .toString(),
                                                        fontSize: 14,
                                                        textColor: AppColors
                                                            .kWhiteColor)),
                                          ]),
                                    ]))
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
