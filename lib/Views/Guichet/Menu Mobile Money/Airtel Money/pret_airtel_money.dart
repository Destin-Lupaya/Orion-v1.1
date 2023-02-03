import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Historique/list_item_widget.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/sorti_airtel_money.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class PretListPage extends StatefulWidget {
  final Map activityData, accountData;

  PretListPage(
      {Key? key, required this.accountData, required this.activityData})
      : super(key: key);

  @override
  State<PretListPage> createState() => _PretListPageState();
}

class _PretListPageState extends State<PretListPage> {
  final TextEditingController _searchCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  List data = [];

  initData() {
    if (Provider.of<TransactionsStateProvider>(context, listen: false)
                .transactions[widget.activityData['activity_id'].toString()] !=
            null &&
        Provider.of<TransactionsStateProvider>(context, listen: false)
            .transactions[widget.activityData['activity_id'].toString()]
            .isNotEmpty) {
      data = Provider.of<TransactionsStateProvider>(context, listen: false)
          .transactions[widget.activityData['activity_id'].toString()]
          .where((trans) =>
              trans['account_id'].toString().trim() ==
                  Provider.of<UserStateProvider>(navKey.currentContext!,
                          listen: false)
                      .clientAccountData['id']
                      .toString()
                      .trim() &&
              !trans['type_payment']
                  .toString()
                  .toLowerCase()
                  .contains('paiement') &&
              (trans['type_payment']
                      .toString()
                      .toLowerCase()
                      .contains('pret') ||
                  trans['type_payment']
                      .toString()
                      .toLowerCase()
                      .contains('emprunt')))
          .toList();
      // print(Provider
      //     .of<TransactionsStateProvider>(context, listen: false)
      //     .transactions[widget.activityData['activity_id'].toString()]);
      setState(() {});
    }
    // print(Provider
    //     .of<TransactionsStateProvider>(context, listen: false)
    //     .transactions[widget.activityData['activity_id'].toString()]);
  }

  TransactionsStateProvider getTransactionProvider({bool listen = false}) {
    return Provider.of<TransactionsStateProvider>(context, listen: listen);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppColors.kBlackColor.withOpacity(0.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          pretReport(
                              title: "Historique des prets",
                              inputs: getTransactionProvider(listen: false)
                                  .targetedActivity['inputs'],
                              data: data);
                        }),
                  ),
                  Expanded(child: Container()),
                ],
              );
            }),
            SingleChildScrollView(
                scrollDirection: Axis.vertical, child: buildLoansList()),
          ]),
        ));
  }

  buildList() {
    return Consumer<TransactionsStateProvider>(
        builder: (context, transactionProvider, _) {
      return DataTable(
          columns: <DataColumn>[
            DataColumn(
                label: TextWidgets.textBold(
                    title: "Date",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor)),
            DataColumn(
                label: TextWidgets.textBold(
                    title: "Ref",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor)),
            DataColumn(
                label: TextWidgets.textBold(
                    title: "Status",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor)),
            DataColumn(
                label: TextWidgets.textBold(
                    title: "Operation",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor)),
            DataColumn(
                label: TextWidgets.textBold(
                    title: "Montant",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor)),
            ...getTransactionProvider().targetedActivity['inputs'].map(
                  (input) => DataColumn(
                      label: TextWidgets.textBold(
                          title: input['designation'],
                          fontSize: 16,
                          textColor: AppColors.kWhiteColor)),
                ),
            DataColumn(
                label: TextWidgets.textBold(
                    title: "Status",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor)),
          ],
          rows: List.generate(data.length, (index) {
            return DataRow(
                onSelectChanged: (value) {
                  if (!data[index]['type_operation']
                      .toString()
                      .toLowerCase()
                      .contains('externe')) {
                    return;
                  }
                  if (data[index]['status'].toString().toLowerCase() ==
                      'paid') {
                    Message.showToast(msg: 'Cette transaction est deja payée');
                    return;
                  }
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Center(
                              child: SortiAirtelmoneyPage(
                            // accountData: widget.accountData,
                            activityData: widget.activityData,
                            targetedData: data[index],
                            updatingData: true,
                          )));
                },
                cells: [
                  DataCell(TextWidgets.text300(
                      title: data[index]['dateTrans'] != null
                          ? DateTime.parse(data[index]['dateTrans'].toString())
                              .toString()
                              .substring(0, 10)
                          : '',
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor)),
                  DataCell(TextWidgets.text300(
                      title: data[index]['refkey'].toString(),
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor)),
                  DataCell(TextWidgets.text300(
                      title: data[index]['status'].toString(),
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor)),
                  DataCell(TextWidgets.text300(
                      title: data[index]['type_operation'].toString(),
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor)),
                  DataCell(TextWidgets.text300(
                      title:
                          "${data[index]['type_devise'].toString()} ${data[index]['amount'].toString()}",
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor)),
                  ...data[index]
                      .keys
                      .toList()
                      .where((key) => key.toString().contains('col_'))
                      .toList()
                      .map((el) => DataCell(TextWidgets.text300(
                          title: transactionProvider.transactions[
                                  widget.activityData['activity_id'].toString()]
                              .where((trans) =>
                                  trans['account_id'].toString().trim() ==
                                      Provider.of<UserStateProvider>(navKey.currentContext!, listen: false)
                                          .clientAccountData['id']
                                          .toString()
                                          .trim() &&
                                  (trans['type_operation']
                                          .toString()
                                          .toLowerCase()
                                          .contains('pret') ||
                                      trans['type_operation']
                                          .toString()
                                          .toLowerCase()
                                          .contains('emprunt')))
                              .toList()[index][el]
                              .toString(),
                          fontSize: 12,
                          textColor: AppColors.kWhiteColor))),
                  DataCell(data[index]['status'].toString().toLowerCase() ==
                              'validated' &&
                          !data[index]['type_operation']
                              .toString()
                              .toLowerCase()
                              .contains('externe')
                      ? Icon(Icons.check_circle, color: AppColors.kGreenColor)
                      : data[index]['status'].toString().toLowerCase() ==
                                  'paid' &&
                              data[index]['type_operation']
                                  .toString()
                                  .toLowerCase()
                                  .contains('externe')
                          ? Icon(Icons.check_circle,
                              color: AppColors.kGreenColor)
                          : Icon(Icons.more_horiz,
                              color: AppColors.kYellowColor)),
                ]);
          }));
    });
  }

  buildLoansList() {
    return Consumer<TransactionsStateProvider>(
      builder: (context, transactionProvider, _) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          initData();
        });
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length > 15
              ? data.sublist(0, 15).toList().length
              : data.length,
          itemBuilder: (context, int index) {
            return ListItem(
                accountData: widget.accountData,
                activityData: widget.activityData,
                data: data[index]);
          },
        );
      },
    );
  }
}
