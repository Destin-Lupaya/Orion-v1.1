import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Models/external_client.model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/tab.helper.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

blockSeparator({required String title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(),
      const SizedBox(
        height: 20,
      ),
      TextWidgets.text500(
          title: title, fontSize: 14, textColor: AppColors.kGreenColor),
    ],
  );
}

class MakeBillPage extends StatefulWidget {
  final bool updatingData;
  final Map accountData;
  final Map activityData;
  Map? billData;

  MakeBillPage(
      {Key? key,
      required this.updatingData,
      required this.accountData,
      required this.activityData,
      this.billData})
      : super(key: key);

  @override
  State<MakeBillPage> createState() => _MakeBillPageState();
}

class _MakeBillPageState extends State<MakeBillPage> {
  List<String> deviseModeList = ["USD", "CDF"];
  late String deviseMode = "USD";

  List<String> typeoperationModeList = ["Depot", "Retrait"];
  late String typeoperationMode = "Depot";
  final ScrollController _controller = ScrollController();
  final TextEditingController _montantCtrller = TextEditingController();
  final TextEditingController _quantityCtrller = TextEditingController();
  final TextEditingController _clientNumberCtrller = TextEditingController();
  final TextEditingController _pswCtrller = TextEditingController();
  final FocusNode node1 = FocusNode();
  List<TextEditingController> inputsController = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0;
        i < getTransactionProvider().targetedActivity['inputs'].length;
        i++) {
      inputsController.add(TextEditingController());
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.updatingData == true) {
        _montantCtrller.text = widget.billData!['amount'].toString();
        typeoperationMode =
            getTransactionProvider().targetedActivity['cashIn'].toString();
        // print(widget.billData!['type_devise'].toString());
        deviseMode = widget.billData!['type_devise'].toString();
        for (int c = 0;
            c <
                widget.billData!.keys
                    .toList()
                    .where((key) => key.toString().contains('col_'))
                    .toList()
                    .length;
            c++) {
          inputsController[c].text =
              widget.billData!["col_${c + 1}"].toString();
          // print(inputsController[c].text);
        }
        setState(() {});
      }
    });
  }

  TransactionsStateProvider getTransactionProvider({bool listen = false}) {
    return Provider.of<TransactionsStateProvider>(navKey.currentContext!,
        listen: listen);
  }

  String? clientID;
  ExternalClientModel? clientData;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.kTransparentColor,
        child: Container(
            width: !Responsive.isWeb(context)
                ? MediaQuery.of(context).size.width - 40
                : MediaQuery.of(context).size.width / 1.7,
            child: Consumer<AppStateProvider>(
                builder: (context, appStateProvider, _) {
              return ListView(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  CardWidget(
                    backColor: AppColors.kBlackLightColor,
                    title: 'Facture',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabHelperWidget(
                            title: "Devise",
                            tabs: [...deviseModeList],
                            tabBackColor: AppColors.kTextFormWhiteColor,
                            activeColor: Colors.grey.shade100,
                            inactiveTextColor: Colors.grey.shade200,
                            callback: (op) {
                              deviseMode = op;
                              setState(() {});
                            }),
                        blockSeparator(title: 'Coordonnees du Fournisseur'),
                        Flex(
                          direction: Responsive.isWeb(context)
                              ? Axis.horizontal
                              : Axis.vertical,
                          mainAxisSize: Responsive.isWeb(context)
                              ? MainAxisSize.max
                              : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              getTransactionProvider(listen: false)
                                  .targetedActivity['inputs']
                                  .length,
                              (index) => Flexible(
                                  fit: FlexFit.loose,
                                  child: TextFormFieldWidget(
                                    isEnabled: widget.updatingData == true
                                        ? false
                                        : true,
                                    maxLines: 1,
                                    hintText:
                                        getTransactionProvider(listen: false)
                                                .targetedActivity['inputs']
                                            [index]['designation'],
                                    editCtrller: inputsController[index],
                                    textColor: AppColors.kWhiteColor,
                                    backColor: AppColors.kTextFormWhiteColor,
                                  ))),
                        ),
                        Flex(
                          direction: !Responsive.isMobile(context)
                              ? Axis.horizontal
                              : Axis.vertical,
                          mainAxisSize: !Responsive.isMobile(context)
                              ? MainAxisSize.max
                              : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child: TextFormFieldWidget(
                                    backColor: AppColors.kTextFormWhiteColor,
                                    hintText: 'Montant',
                                    isEnabled: widget.updatingData == true
                                        ? false
                                        : true,
                                    editCtrller: _montantCtrller,
                                    textColor: AppColors.kWhiteColor,
                                    maxLines: 1)),
                            if (context.select<TransactionsStateProvider, int>(
                                    (provider) => provider
                                        .targetedActivity['hasStock']) ==
                                1)
                              Flexible(
                                  fit: FlexFit.loose,
                                  child:
                                      TextFormFieldWidget(
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'Quantité',
                                          isEnabled: widget.updatingData == true
                                              ? false
                                              : true,
                                          editCtrller: _quantityCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 1)),
                          ],
                        ),
                        Flex(
                          direction: !Responsive.isMobile(context)
                              ? Axis.horizontal
                              : Axis.vertical,
                          mainAxisSize: !Responsive.isMobile(context)
                              ? MainAxisSize.max
                              : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                fit: FlexFit.loose,
                                child: SearchableTextFormFieldWidget(
                                    overlayColor: AppColors.kBlackLightColor,
                                    callback: (data) {
                                      clientID = data.toString();
                                      clientData = context
                                          .read<ClientProvider>()
                                          .dataList
                                          .firstWhereOrNull((item) =>
                                              item.id.toString() ==
                                              clientID.toString());
                                      // print(clientData?.toJson());
                                      _clientNumberCtrller.text =
                                          _clientNumberCtrller.text;
                                      setState(() {});
                                    },
                                    data: context
                                        .read<ClientProvider>()
                                        .dataList
                                        .map((e) => e.toJson())
                                        .toList(),
                                    displayColumn: 'phone',
                                    // secondDisplayColumn: 'phone',
                                    indexColumn: 'id',
                                    backColor: AppColors.kTextFormWhiteColor,
                                    hintText: 'Numéro du client',
                                    isEnabled: widget.updatingData == true
                                        ? false
                                        : true,
                                    editCtrller: _clientNumberCtrller,
                                    textColor: AppColors.kWhiteColor,
                                    maxLines: 1)),
                            Flexible(fit: FlexFit.loose, child: Container()),
                          ],
                        ),
                        // TextFormFieldWidget(
                        //     backColor: AppColors.kTextFormWhiteColor,
                        //     hintText: 'Montant',
                        //     isEnabled:
                        //         widget.updatingData == true ? false : true,
                        //     editCtrller: _montantCtrller,
                        //     textColor: AppColors.kWhiteColor,
                        //     maxLines: 1),
                        Consumer<TransactionsStateProvider>(
                            builder: (context, transactionProvider, _) {
                          return appStateProvider.isAsync == false
                              ? Row(
                                  children: [
                                    if (widget.updatingData == true &&
                                        widget.billData!['status']
                                                .toString()
                                                .toLowerCase() !=
                                            'paid')
                                      Expanded(
                                          child: CustomButton(
                                              backColor: AppColors.kGreenColor,
                                              text: 'Payer la facture',
                                              textColor: AppColors.kWhiteColor,
                                              callback: () async {
                                                bool inputsError = false;
                                                for (int i = 0;
                                                    i < inputsController.length;
                                                    i++) {
                                                  if (inputsController[i]
                                                      .text
                                                      .isEmpty) {
                                                    inputsError = true;
                                                  }
                                                }
                                                if (_montantCtrller
                                                        .text.isEmpty ||
                                                    double.tryParse(
                                                            _montantCtrller
                                                                .text) ==
                                                        null) {
                                                  return Message.showToast(
                                                      msg:
                                                          'Veuillez saisir un montant valide');
                                                }
                                                if (inputsError == true) {
                                                  return Message.showToast(
                                                      msg:
                                                          'Veuillez remplir tous les champs');
                                                }
                                                return showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              content:
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      width: double
                                                                          .minPositive,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          TextFormFieldWidget(
                                                                              isObsCured: true,
                                                                              focusNode: node1,
                                                                              backColor: AppColors.kTextFormBackColor,
                                                                              hintText: 'PIN',
                                                                              editCtrller: _pswCtrller,
                                                                              textColor: AppColors.kBlackColor,
                                                                              //
                                                                              maxLines: 1)
                                                                        ],
                                                                      )),
                                                              actions: [
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'Annuler')),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      if (_pswCtrller
                                                                          .text
                                                                          .isEmpty) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                'Veuillez entre un code PIN');
                                                                      }
                                                                      if (_pswCtrller
                                                                              .text !=
                                                                          Provider.of<UserStateProvider>(context, listen: false)
                                                                              .clientData!
                                                                              .password!
                                                                              .toString()
                                                                              .trim()) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                'Code PIN incorrect');
                                                                      }
                                                                      _pswCtrller
                                                                          .text = "";

                                                                      //Checking for deposit (virtual money and amount)
                                                                      if (double.parse(_montantCtrller.text.trim()) > double.parse(widget.activityData['virtual_usd'].toString().trim()) &&
                                                                          deviseMode.toLowerCase() ==
                                                                              'usd' &&
                                                                          typeoperationMode.toLowerCase() ==
                                                                              getTransactionProvider().targetedActivity['cashIn'].toString().trim().toLowerCase()) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                "Solde virtuel insuffisant");
                                                                      }
                                                                      if (double.parse(_montantCtrller.text.trim()) > double.parse(widget.activityData['virtual_cdf'].toString().trim()) &&
                                                                          deviseMode.toLowerCase() ==
                                                                              'cdf' &&
                                                                          typeoperationMode.toLowerCase() ==
                                                                              getTransactionProvider().targetedActivity['cashIn'].toString().trim().toLowerCase()) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                "Solde virtuel insuffisant");
                                                                      }
                                                                      //Checking for withdrawal (cash and amount)

                                                                      if (double.parse(_montantCtrller.text.trim()) > double.parse(getTransactionProvider().accountData['sold_cash_usd'].toString().trim()) &&
                                                                          deviseMode.toLowerCase() ==
                                                                              'usd' &&
                                                                          typeoperationMode.toLowerCase() ==
                                                                              getTransactionProvider().targetedActivity['cashOut'].toString().trim().toLowerCase()) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                "Solde cash insuffisant");
                                                                      }
                                                                      if (double.parse(_montantCtrller.text.trim()) > double.parse(getTransactionProvider().accountData['sold_cash_cdf'].toString().trim()) &&
                                                                          deviseMode.toLowerCase() ==
                                                                              'cdf' &&
                                                                          typeoperationMode.toLowerCase() ==
                                                                              getTransactionProvider().targetedActivity['cashOut'].toString().trim().toLowerCase()) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                "Solde cash insuffisant");
                                                                      }
                                                                      if (typeoperationMode
                                                                          .isEmpty) {
                                                                        return Message.showToast(
                                                                            msg:
                                                                                "Veuillez choisir un type d'opération");
                                                                      }
                                                                      Map dynamicInputsValues =
                                                                          {};
                                                                      for (int i =
                                                                              0;
                                                                          i < getTransactionProvider().targetedActivity['inputs'].length;
                                                                          i++) {
                                                                        dynamicInputsValues
                                                                            .addAll({
                                                                          "col_${i + 1}":
                                                                              inputsController[i].text
                                                                        });
                                                                      }

                                                                      String
                                                                          uuid =
                                                                          "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                                                                      Map transactionData =
                                                                          {
                                                                        "refkey":
                                                                            uuid,
                                                                        "dateTrans": DateTime.now()
                                                                            .toString()
                                                                            .substring(0,
                                                                                10),
                                                                        "amount":
                                                                            double.parse(_montantCtrller.text.trim()).toStringAsFixed(3),
                                                                        "type_operation":
                                                                            typeoperationMode,
                                                                        "type_devise":
                                                                            deviseMode,
                                                                        "client_number":
                                                                            clientID,
                                                                        "type_payment":
                                                                            'Cash',
                                                                        "account_id": getTransactionProvider()
                                                                            .accountData['id']
                                                                            .toString(),
                                                                        "status":
                                                                            "validated",
                                                                        "source":
                                                                            "mobile",
                                                                        "users_id": Provider.of<UserStateProvider>(context,
                                                                                listen: false)
                                                                            .clientData!
                                                                            .id!
                                                                            .toString()
                                                                            .trim()
                                                                      };
                                                                      Navigator.pop(
                                                                          context);
                                                                      transactionData
                                                                          .addAll(
                                                                              dynamicInputsValues);
                                                                      // print(dynamicInputsValues);
                                                                      // return;
                                                                      var updatedData = await updateData(
                                                                          typeOperation:
                                                                              'depot',
                                                                          devise:
                                                                              deviseMode);
                                                                      if (updatedData ==
                                                                          null) {
                                                                        return;
                                                                      }
                                                                      // return print(updatedData);
                                                                      Map activityData =
                                                                          {
                                                                        "id": widget
                                                                            .activityData['id']
                                                                            .toString()
                                                                            .trim(),
                                                                        "activity_id": widget
                                                                            .activityData['activity_id']
                                                                            .toString()
                                                                            .trim(),
                                                                        'virtual_cdf': updatedData['virtuelCDF'] ==
                                                                                0
                                                                            ? widget.activityData['virtual_cdf'].toString().trim()
                                                                            : updatedData['virtuelCDF'].toString().trim(),
                                                                        'virtual_usd': updatedData['virtuelUSD'] ==
                                                                                0
                                                                            ? widget.activityData['virtual_usd'].toString().trim()
                                                                            : updatedData['virtuelUSD'].toString().trim(),
                                                                      };
                                                                      // return print(getTransactionProvider().targetedActivity);
                                                                      Map accountData =
                                                                          {
                                                                        "id": getTransactionProvider()
                                                                            .accountData['id']
                                                                            .toString()
                                                                            .trim(),
                                                                        'sold_cash_cdf': updatedData['cashCDF'] ==
                                                                                0
                                                                            ? getTransactionProvider().accountData['sold_cash_cdf'].toString()
                                                                            : updatedData['cashCDF'].toString().trim(),
                                                                        'sold_cash_usd': updatedData['cashUSD'] ==
                                                                                0
                                                                            ? getTransactionProvider().accountData['sold_cash_usd'].toString()
                                                                            : updatedData['cashUSD'].toString().trim(),
                                                                      };
                                                                      Map data =
                                                                          {
                                                                        "trans":
                                                                            transactionData,
                                                                        "activity":
                                                                            activityData,
                                                                        "account":
                                                                            accountData
                                                                      };

                                                                      widget.billData![
                                                                              'status'] =
                                                                          "Paid";
                                                                      //     print(data);
                                                                      // return print(widget.billData!);
                                                                      transactionProvider.billPayment(
                                                                          body: widget.billData!,
                                                                          activityData: activityData,
                                                                          callback: () async {
                                                                            await transactionProvider.envoiVirtuel3check(
                                                                                body: data,
                                                                                callback: () {},
                                                                                rollback: () {
                                                                                  widget.billData!['status'] = "Pending";
                                                                                  transactionProvider.billPayment(
                                                                                      body: widget.billData!,
                                                                                      activityData: widget.activityData,
                                                                                      callback: () {
                                                                                        // Navigator.of(navKey.currentContext!, rootNavigator: true).pop();
                                                                                        // Navigator.of(navKey.currentContext!, rootNavigator: true).pop();
                                                                                      });
                                                                                });
                                                                            Navigator.of(navKey.currentContext!, rootNavigator: true).pop();
                                                                            Navigator.of(navKey.currentContext!, rootNavigator: true).pop();
                                                                            transactionProvider.getFactures(activityID: widget.activityData['activity_id'].toString());
                                                                          });
                                                                    },
                                                                    child: Text(
                                                                        'Confirmer')),
                                                              ],
                                                            ));
                                              })),
                                    if (widget.updatingData == false)
                                      Expanded(
                                        child: CustomButton(
                                          backColor: AppColors.kYellowColor,
                                          text: 'Enregistrer',
                                          textColor: AppColors.kBlackColor,
                                          callback: () async {
                                            // onPressed:
                                            // () {
                                            bool inputsError = false;
                                            for (int i = 0;
                                                i < inputsController.length;
                                                i++) {
                                              if (inputsController[i]
                                                  .text
                                                  .isEmpty) {
                                                inputsError = true;
                                              }
                                            }
                                            if (_montantCtrller.text.isEmpty ||
                                                double.tryParse(
                                                        _montantCtrller.text) ==
                                                    null) {
                                              Message.showToast(
                                                  msg:
                                                      "Veuillez saisir un montant valide");
                                              return;
                                            }
                                            if (inputsError == true) {
                                              Message.showToast(
                                                  msg:
                                                      "Veuillez remplir tous les champs");
                                              return;
                                            }
                                            await showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                          content: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              width: double
                                                                  .minPositive,
                                                              height: 100,
                                                              child: Column(
                                                                children: [
                                                                  TextFormFieldWidget(
                                                                      focusNode:
                                                                          node1,
                                                                      backColor:
                                                                          AppColors
                                                                              .kTextFormBackColor,
                                                                      hintText:
                                                                          'PIN',
                                                                      editCtrller:
                                                                          _pswCtrller,
                                                                      textColor:
                                                                          AppColors
                                                                              .kBlackColor,
                                                                      //
                                                                      maxLines:
                                                                          1)
                                                                ],
                                                              )),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Annuler')),
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  if (_pswCtrller
                                                                      .text
                                                                      .isEmpty) {
                                                                    Message.showToast(
                                                                        msg:
                                                                            "Veuillez saisir code PIN");
                                                                    return;
                                                                  }
                                                                  if (_pswCtrller
                                                                          .text !=
                                                                      Provider.of<UserStateProvider>(
                                                                              context,
                                                                              listen: false)
                                                                          .clientData!
                                                                          .password!
                                                                          .toString()
                                                                          .trim()) {
                                                                    Message.showToast(
                                                                        msg:
                                                                            "Code PIN incorrect");
                                                                    return;
                                                                  }
                                                                  _pswCtrller
                                                                      .text = "";

                                                                  Map dynamicInputsValues =
                                                                      {};
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          getTransactionProvider()
                                                                              .targetedActivity['inputs']
                                                                              .length;
                                                                      i++) {
                                                                    dynamicInputsValues
                                                                        .addAll({
                                                                      "col_${i + 1}":
                                                                          inputsController[i]
                                                                              .text
                                                                    });
                                                                  }

                                                                  String uuid =
                                                                      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                                                                  Map transactionData =
                                                                      {
                                                                    "activity_id": widget
                                                                        .activityData[
                                                                            'activity_id']
                                                                        .toString(),
                                                                    // "refkey": uuid,
                                                                    "dateTrans": DateTime
                                                                            .now()
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                    "amount": double.parse(_montantCtrller
                                                                            .text
                                                                            .trim())
                                                                        .toStringAsFixed(
                                                                            3),
                                                                    "type_operation":
                                                                        "Facture",
                                                                    "type_devise":
                                                                        deviseMode,

                                                                    "status":
                                                                        "Pending",
                                                                    "source":
                                                                        "mobile",

                                                                    "users_id": Provider.of<UserStateProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .clientData!
                                                                        .id!
                                                                        .toString()
                                                                        .trim()
                                                                  };
                                                                  transactionData
                                                                      .addAll(
                                                                          dynamicInputsValues);
                                                                  // print(dynamicInputsValues);
                                                                  // return;
                                                                  Map data =
                                                                      transactionData;
                                                                  // return print(data);
                                                                  transactionProvider
                                                                      .makeBill(
                                                                          body:
                                                                              data,
                                                                          callback:
                                                                              () {
                                                                            transactionProvider.getFactures(activityID: widget.activityData['activity_id'].toString());
                                                                          });
                                                                },
                                                                child: const Text(
                                                                    'Confirmer')),
                                                          ],
                                                        ));
                                            // }
                                          },
                                        ),
                                      ),
                                  ],
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.kYellowColor),
                                  ),
                                );
                        })
                      ],
                    ),
                  )
                ],
              );
            })));
    //     ),
    //   ),
    // );
  }

  updateData({required String typeOperation, required String devise}) async {
    double cashUSD = 0, cashCDF = 0, virtuelUSD = 0, virtuelCDF = 0;
    //Withdrawal CDF
    //Deposit USD
    if (devise.toLowerCase() == 'usd' &&
        typeOperation.toLowerCase() == 'depot') {
      if (double.parse(widget.activityData['virtual_usd'].toString().trim()) <
          double.parse(_montantCtrller.text.trim())) {
        Message.showToast(
            msg:
                "Impossible de faire le ${getTransactionProvider().targetedActivity['cashin'].toString().trim()}, solde virtuel USD insuffisant");
        return null;
      }
      cashUSD = double.parse(getTransactionProvider()
              .accountData['sold_cash_usd']
              .toString()
              .trim()) +
          double.parse(_montantCtrller.text.trim());
      virtuelUSD =
          double.parse(widget.activityData['virtual_usd'].toString().trim()) -
              double.parse(_montantCtrller.text.trim());
    }
    if (devise.toLowerCase() == 'cdf' &&
        typeOperation.toLowerCase() == 'depot') {
      if (double.parse(widget.activityData['virtual_cdf'].toString().trim()) <
          double.parse(_montantCtrller.text.trim())) {
        Message.showToast(
            msg:
                "Impossible de faire le ${getTransactionProvider().targetedActivity['cashin'].toString().trim()}, solde virtuel CDF insuffisant");
        return null;
      }
      cashCDF = double.parse(getTransactionProvider()
              .accountData['sold_cash_cdf']
              .toString()
              .trim()) +
          double.parse(_montantCtrller.text.trim());
      virtuelCDF =
          double.parse(widget.activityData['virtual_cdf'].toString().trim()) -
              double.parse(_montantCtrller.text.trim());
    }
    Map updatedSoldData = {
      "cashCDF": cashCDF,
      "cashUSD": cashUSD,
      "virtuelUSD": virtuelUSD,
      "virtuelCDF": virtuelCDF,
    };
    return updatedSoldData;
  }
}

class BillsList extends StatefulWidget {
  final bool updatingData;
  final Map accountData;
  final Map activityData;

  BillsList(
      {Key? key,
      required this.accountData,
      required this.activityData,
      required this.updatingData})
      : super(key: key);

  @override
  State<BillsList> createState() => _BillsListState();
}

class _BillsListState extends State<BillsList> {
  final TextEditingController _searchCtrller = TextEditingController();
  List data = [];

  TransactionsStateProvider getTransactionProvider({bool listen = false}) {
    return Provider.of<TransactionsStateProvider>(navKey.currentContext!,
        listen: listen);
  }

  @override
  void initState() {
    super.initState();
    if (Provider.of<TransactionsStateProvider>(context, listen: false)
            .factures[widget.activityData['activity_id'].toString()] !=
        null) {
      data = getTransactionProvider()
          .factures[widget.activityData['activity_id'].toString()]
          .where(
              (facture) => facture['status'].toString().toLowerCase() != 'paid')
          .toList();
    }
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
                              reportView(
                                  title: "Factures",
                                  inputs: getTransactionProvider()
                                      .targetedActivity['inputs'],
                                  data: transactionProvider.factures[widget
                                      .activityData['activity_id']
                                      .toString()]);
                              // : transactionProvider.factures[widget
                              //         .activityData['activity_id'].toString()]);
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
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.vertical, child: buildLoansList())
          ],
        ),
      ),
    );
  }

  buildLoansList() {
    return Consumer<TransactionsStateProvider>(
      builder: (context, transactionProvider, _) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, int paybackIndex) {
                return ListItem(
                    accountData: widget.accountData,
                    activityData: widget.activityData,
                    data: data[paybackIndex]);
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
                                widget.data['type_operation']
                                        .toString()
                                        .toLowerCase()
                                        .contains('facture')
                                    ? Icons.call_missed_outgoing_outlined
                                    : Icons.call_missed_outlined,
                                color: widget.data['type_operation']
                                        .toString()
                                        .toLowerCase()
                                        .contains('facture')
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
                                                showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (context) =>
                                                        Center(
                                                            child: MakeBillPage(
                                                          accountData:
                                                              getTransactionProvider()
                                                                  .accountData,
                                                          activityData: widget
                                                              .activityData,
                                                          billData: widget.data,
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
