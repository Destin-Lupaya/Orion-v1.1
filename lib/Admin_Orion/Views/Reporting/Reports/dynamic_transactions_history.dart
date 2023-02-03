import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/create_activity_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/provider.dart';

class DynamicHistoryTransList extends StatefulWidget {
  final Map branch;

  // // final bool isFullHistory;
  // final List data;
  final List<CreatActiviteModel>? activities;

  DynamicHistoryTransList(
      {Key? key,
      required this.branch,
      // required this.data,
      this.activities})
      : super(key: key);

  @override
  State<DynamicHistoryTransList> createState() =>
      _DynamicHistoryTransListState();
}

class _DynamicHistoryTransListState extends State<DynamicHistoryTransList> {
  final TextEditingController _searchCtrller = TextEditingController();
  List displayData = [];

  @override
  void initState() {
    super.initState();
    // displayData = widget.data;
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   initFields();
    // });
  }

  List transactions = [];

  getBranchData() async {
    var response = await Provider.of<adminAppStateProvider>(context,
            listen: false)
        .httpGet(
            url:
                '${BaseUrl.branchActivity}/{"activity_id":"${selectedActivity!.id!.toString()}", "branch_id":"${widget.branch["id"].toString()}"}');
    // await Provider.of<TransactionsStateProvider>(context, listen: false)
    //     .getActivities(activityID: selectedActivity!.id!.toString().trim());
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) is String) {
        Message.showToast(msg: "Cette branche ou activité n'existe pas");
        return;
      }
      var decoded = jsonDecode(response.body);
      transactions = decoded['trans'];
      displayData = transactions;
      inputs = decoded['inputs'];
      dataFields.clear();
      initFields();
    }
  }

  initFields() {
    if (transactions.isNotEmpty) {
      dataFields = transactions[0]
          .keys
          .toList()
          .where((field) =>
              field != 'account_id' &&
              field != 'users_id' &&
              field != 'updated_at' &&
              field != 'source' &&
              field != 'created_at')
          .toList();
      for (int i = 0; i < dataFields.length; i++) {
        String index = "";
        // print(dataFields[i]);
        if (dataFields[i].contains('col_')) {
          if (!dataFields[i].contains('id')) {
            index = dataFields[i].split('_')[1].toString();
            dataFields[i] = inputs[int.parse(index) - 1]['designation'];
          }
        }
      }
    }
    setState(() {});
  }

  CreatActiviteModel? selectedActivity;
  List removedFields = [], dataFields = [], inputs = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width - 40
          : MediaQuery.of(context).size.width / 1.5,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .85, minHeight: 300),
      child: Consumer<adminAppStateProvider>(
          builder: (context, appStateProvider, _) {
        return ModalProgress(
            isAsync: appStateProvider.isAsync,
            progressColor: AppColors.kYellowColor,
            child: Card(
              color: AppColors.kBlackLightColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.activities != null
                        ? Wrap(
                            children: List.generate(
                                widget.activities!.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        selectedActivity =
                                            widget.activities![index];
                                        setState(() {});
                                        getBranchData();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              border: Border.all(
                                                  color: selectedActivity !=
                                                              null &&
                                                          selectedActivity!.id!
                                                                  .toString() ==
                                                              widget
                                                                  .activities![
                                                                      index]
                                                                  .id!
                                                                  .toString()
                                                      ? AppColors.kGreenColor
                                                      : AppColors
                                                          .kTransparentColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.all(8),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextWidgets.textBold(
                                                    title: widget
                                                        .activities![index]
                                                        .designation
                                                        .toString(),
                                                    fontSize: 12,
                                                    textColor:
                                                        AppColors.kWhiteColor),
                                                const SizedBox(height: 8),
                                                TextWidgets.textBold(
                                                    title: widget
                                                        .activities![index]
                                                        .description
                                                        .toString(),
                                                    fontSize: 12,
                                                    textColor:
                                                        AppColors.kWhiteColor),
                                              ])),
                                    )),
                          )
                        : Container(),
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
                                  dynamicFieldsReport(
                                      title:
                                          "Transactions branche ${widget.branch['name'].toString()}",
                                      inputs: inputs,
                                      fields: dataFields,
                                      data: displayData);
                                }),
                          ),
                          // if (Responsive.isWeb(context))
                          Expanded(child: Container())
                        ],
                      );
                    }),
                    filterWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    // if (Responsive.isWeb(context)) buildLoansList(context: context)
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal, child: buildList())
                  ],
                ),
              ),
            ));
      }),
    );
  }

  String statusFilter = "Tout", creditFilter = "Voir l'historique Virtuel";

  filterWidget() {
    return Row(
      children: [
        Expanded(
            child: CustomDropdownButton(
                backColor: AppColors.kBlackColor,
                textColor: AppColors.kWhiteColor,
                value: statusFilter,
                hintText: 'Operation',
                callBack: (value) {},
                items: [
              "Tout",
              ...displayData
                  .map((data) => data['type_operation'].toString().trim())
                  .toSet()
                  .toList()
            ])),
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
  }

  buildList() {
    return Consumer<TransactionsStateProvider>(
        builder: (context, transactionProvider, _) {
      return dataFields.isNotEmpty && transactions.isNotEmpty
          ? DataTable(
              columns: List.generate(dataFields.length, (index) {
                return DataColumn(
                    label: TextWidgets.textBold(
                        title: dataFields[index].toString().toUpperCase(),
                        fontSize: 16,
                        textColor: AppColors.kWhiteColor));
              }),
              rows: List.generate(displayData.length, (index) {
                return DataRow(
                    cells: List.generate(dataFields.length, (indexCol) {
                  return DataCell(TextWidgets.text300(
                      title: inputs
                              .map((input) => input['designation'])
                              .contains(dataFields[indexCol].toString())
                          ? displayData[index][
                                  'col_${inputs.indexWhere((input) => input['designation'].toString().toLowerCase() == dataFields[indexCol].toString().toLowerCase()) + 1}']
                              .toString()
                          : displayData[index][dataFields[indexCol]].toString(),
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor));
                }));
              }))
          : Container();
    });
  }
}
