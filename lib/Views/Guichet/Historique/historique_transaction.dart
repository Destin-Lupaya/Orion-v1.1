import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/search_page.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Historique/list_item_widget.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class HistortransList extends StatefulWidget {
  final Map activityData, accountData;
  final bool isFullHistory;

  HistortransList({Key? key,
    required this.accountData,
    required this.activityData,
    required this.isFullHistory})
      : super(key: key);

  @override
  State<HistortransList> createState() => _HistortransListState();
}

class _HistortransListState extends State<HistortransList> {
  final TextEditingController _searchCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() {
    if (getTransProvider(listen: false)
        .transactions
        .isNotEmpty &&
        getTransProvider(listen: false)
            .transactions[
        widget.activityData['activity_id'].toString()] !=
            null) {
      // List dataBrut =
      data = getTransProvider(listen: false)
          .transactions[widget.activityData['activity_id'].toString()]
          .where((trans) =>
      trans['account_id'].toString().trim() ==
          Provider
              .of<UserStateProvider>(
              navKey.currentContext!,
              listen: false)
              .clientAccountData['id']
              .toString()
              .trim()
          &&
          ((trans['type_operation']
              .toString()
              .toLowerCase()
              .indexOf('pret') > 1 ||
              trans['type_operation']
                  .toString()
                  .toLowerCase().
              indexOf('emprunt') > 1
          ) || (!trans['type_operation']
              .toString()
              .toLowerCase()
              .contains('pret') && !trans['type_operation']
              .toString()
              .toLowerCase()
              .contains('emprunt'))))
          .toList();
      setState(() {});
    }
  }

  TransactionsStateProvider getTransProvider({bool listen = false}) {
    return Provider.of<TransactionsStateProvider>(context, listen: false);
  }

  List data = [];

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
                                  reportView(
                                      title: widget.isFullHistory == false
                                          ? "Historique des transactions"
                                          : "Transactions",
                                      inputs: getTransProvider(listen: false)
                                          .targetedActivity['inputs'],
                                      data: widget.isFullHistory == false
                                          ? transactionProvider
                                          .transactions[widget
                                          .activityData['activity_id']
                                          .toString()]
                                          .where((trans) =>
                                      trans['account_id'].toString().trim() ==
                                          Provider
                                              .of<UserStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                              .clientAccountData['id']
                                              .toString()
                                              .trim() &&
                                          !(trans['type_operation']
                                              .toString()
                                              .toLowerCase()
                                              .contains('pret') ||
                                              trans['type_operation']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains('emprunt')))
                                          .toList()
                                          : transactionProvider
                                          .transactions[widget
                                          .activityData['activity_id']
                                          .toString()]);
                                }),
                          ),
                          Expanded(
                            child: CustomButton(
                                text: "Voir tout",
                                backColor: AppColors.kGreenColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          SearchPage(
                                              activityData: transactionProvider
                                                  .targetedActivity,
                                              data: transactionProvider
                                                  .transactions[widget
                                                  .activityData['activity_id']
                                                  .toString()].where((trans) =>
                                              trans['account_id'].toString().trim() ==
                                                  Provider
                                                      .of<UserStateProvider>(
                                                      navKey.currentContext!,
                                                      listen: false)
                                                      .clientAccountData['id']
                                                      .toString()
                                                      .trim()).toList()),
                                          fullscreenDialog: true));
                                }),
                          ),
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
                      );
                    }),
              ],
            ),
            // if (Responsive.isWeb(context)) filterWidget(),
            const SizedBox(
              height: 20,
            ),
            // if (Responsive.isWeb(context)) buildLoansList(context: context)
            SingleChildScrollView(
                scrollDirection: Axis.vertical, child: buildLoansList())
          ],
        ),
      ),
    );
  }

  String statusFilter = "Initiated",
      creditFilter = "Voir l'historique Virtuel";

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
                  "Voir l'historique Virtuel",
                  "Voir l'historique Cash"
                ])),
      ],
    );
  }

  buildLoansList() {
    return Consumer<TransactionsStateProvider>(
      builder: (context, transactionProvider, _) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          initData();
        });
        return data.isNotEmpty
            ? Column(children: List.generate(
            data.length > 15 ? data
                .sublist(0, 15)
                .toList()
                .length : data.length, (index) =>
            ListItem(accountData: widget.accountData,
              activityData: widget.activityData,
              data: data[index],)))
            : Container();
      },
    );
  }
}


