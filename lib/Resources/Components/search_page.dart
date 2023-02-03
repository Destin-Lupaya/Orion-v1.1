import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final Map activityData;

  // final bool isFullHistory;
  final List data;
  final List? activities;

  SearchPage(
      {Key? key,
      required this.activityData,
      required this.data,
      this.activities})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchCtrller = TextEditingController();
  final TextEditingController _startDateCtrller = TextEditingController();
  final TextEditingController _endDateCtrller = TextEditingController();
  List displayData = [];

  @override
  void initState() {
    super.initState();
    displayData = widget.data;
    _searchCtrller.addListener(() {
      displayData = widget.data
          .where((data) =>
              data['type_operation']
                  .toString()
                  .toLowerCase()
                  .contains(_searchCtrller.text.toLowerCase()) ||
              data['type_payment']
                  .toString()
                  .toLowerCase()
                  .contains(_searchCtrller.text.toLowerCase()) ||
              data['status']
                  .toString()
                  .toLowerCase()
                  .contains(_searchCtrller.text.toLowerCase()) ||
              data['jour']
                  .toString()
                  .toLowerCase()
                  .contains(_searchCtrller.text.toLowerCase()) ||
              data['refkey'].toString().contains(_searchCtrller.text.trim()))
          .toList();
      setState(() {});
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initFields();
    });
  }

  initFields() {
    if (widget.data.isNotEmpty) {
      removedFields = [
        "account_id",
        "users_id",
        "created_at",
        "updated_at",
        "source"
      ];
      dataFields = widget.data[0].keys
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
          index = dataFields[i].split('_')[1].toString();
          dataFields[i] = widget.activityData['inputs'][int.parse(index) - 1]
              ['designation'];
        }
      }

      // for (int i = 0; i < dataFields.length; i++) {
      //   if (removedFields.contains(dataFields[i])) {
      //     dataFields.remove(dataFields[i]);
      //   }
      // }
      setState(() {});
    }
  }

  List removedFields = [
        "account_id",
        "users_id",
        "created_at",
        "updated_at",
        "source"
      ],
      dataFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kBlackColor,
        ),
        body: Container(
          child: Card(
            margin: const EdgeInsets.all(0),
            color: AppColors.kBlackLightColor,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
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
                                dynamicFieldsReport(
                                    title: "Transactions",
                                    inputs: widget.activityData['inputs'],
                                    fields: dataFields,
                                    data: displayData);
                              }),
                        ),
                        Expanded(child: Container()),
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
          ),
        ));
  }

  String statusFilter = "Tout", creditFilter = "Voir l'historique Virtuel";

  filterWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: CustomDropdownButton(
                    backColor: AppColors.kGreyColor,
                    textColor: AppColors.kWhiteColor,
                    dropdownColor: AppColors.kBlackLightColor,
                    value: statusFilter,
                    hintText: 'Operation',
                    callBack: (value) {
                      statusFilter = value;
                      if (value == "Tout") {
                        displayData = widget.data;
                        setState(() {});
                        return;
                      }
                      displayData = widget.data
                          .where((data) =>
                              data['type_operation']
                                  .toString()
                                  .trim()
                                  .toLowerCase() ==
                              (value.toString().trim().toLowerCase()))
                          .toList();
                      setState(() {});
                    },
                    items: [
                  "Tout",
                  ...widget.data
                      .map((data) => data['type_operation'].toString())
                      .toSet()
                      .toList()
                ])),
            Expanded(
              child: TextFormFieldWidget(
                  backColor: AppColors.kTextFormWhiteColor,
                  hintText: 'Recherchez...',
                  editCtrller: _searchCtrller,
                  textColor: AppColors.kWhiteColor,
                  maxLines: 1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
                    onTap: () async {
                      await showDatePicker(
                              context: context,
                              initialDate: DateTime.now()
                                  .subtract(const Duration(days: 90)),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 90)),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          _startDateCtrller.text =
                              value.toString().substring(0, 10);
                          if (_endDateCtrller.text.isNotEmpty &&
                              _startDateCtrller.text.isNotEmpty) {
                            displayData = widget.data
                                .where((data) =>
                                    DateTime.parse(data['dateTrans'].toString())
                                            .compareTo(DateTime.parse(
                                                _startDateCtrller.text)) >=
                                        0 &&
                                    DateTime.parse(_endDateCtrller.text)
                                            .compareTo(DateTime.parse(
                                                data['dateTrans']
                                                    .toString())) >=
                                        0)
                                .toList();
                            setState(() {});
                            return;
                          }
                          displayData = widget.data
                              .where((data) =>
                                  DateTime.parse(data['dateTrans'].toString())
                                      .compareTo(DateTime.parse(
                                          _startDateCtrller.text)) >=
                                  0)
                              .toList();
                          setState(() {});
                        }
                      });
                    },
                    child: TextFormFieldWidget(
                        backColor: AppColors.kTextFormWhiteColor,
                        hintText: 'A partir du',
                        editCtrller: _startDateCtrller,
                        textColor: AppColors.kWhiteColor,
                        isEnabled: false,
                        maxLines: 1))),
            Expanded(
                child: GestureDetector(
                    onTap: () async {
                      await showDatePicker(
                              context: context,
                              initialDate: _startDateCtrller.text.isNotEmpty
                                  ? DateTime.parse(_startDateCtrller.text)
                                  : DateTime.now()
                                      .subtract(const Duration(days: 90)),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 90)),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          _endDateCtrller.text =
                              value.toString().substring(0, 10);
                          if (_endDateCtrller.text.isNotEmpty &&
                              _startDateCtrller.text.isNotEmpty) {
                            displayData = widget.data
                                .where((data) =>
                                    DateTime.parse(data['dateTrans'].toString())
                                            .compareTo(DateTime.parse(
                                                _startDateCtrller.text)) >=
                                        0 &&
                                    DateTime.parse(_endDateCtrller.text)
                                            .compareTo(DateTime.parse(
                                                data['dateTrans']
                                                    .toString())) >=
                                        0)
                                .toList();
                            setState(() {});
                            return;
                          }
                          displayData = widget.data
                              .where((data) =>
                                  DateTime.parse(_endDateCtrller.text)
                                      .compareTo(DateTime.parse(
                                          data['dateTrans'].toString())) >=
                                  0)
                              .toList();
                          setState(() {});
                        }
                      });
                    },
                    child: TextFormFieldWidget(
                        backColor: AppColors.kTextFormWhiteColor,
                        hintText: "Jusqu'au",
                        editCtrller: _endDateCtrller,
                        textColor: AppColors.kWhiteColor,
                        isEnabled: false,
                        maxLines: 1))),
          ],
        ),
      ],
    );
  }

  buildList() {
    return Consumer<TransactionsStateProvider>(
        builder: (context, transactionProvider, _) {
      // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //   initFields();
      // });
      return dataFields.isNotEmpty
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
                      title: widget.activityData['inputs']
                              .map((input) => input['designation'].toString())
                              .contains(dataFields[indexCol].toString())
                          ? displayData[index][
                                  'col_${widget.activityData['inputs'].indexWhere((input) => input['designation'].toString().toLowerCase() == dataFields[indexCol].toString().toLowerCase()) + 1}']
                              .toString()
                          : displayData[index][dataFields[indexCol]]
                                  ?.toString() ??
                              '',
                      fontSize: 12,
                      textColor: AppColors.kWhiteColor));
                }));
              }))
          : Container();
    });
  }
}
