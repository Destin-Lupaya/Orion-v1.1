import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Demands/helper.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/tab.helper.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class DemandPage extends StatefulWidget {
  final bool updatingData;
  final bool? simpleUpdate;
  final Map activityData, accountData;
  final Map? demandData;

  const DemandPage(
      {Key? key,
      required this.updatingData,
      required this.accountData,
      required this.activityData,
      this.demandData,
      this.simpleUpdate})
      : super(key: key);

  @override
  _DemandPageState createState() => _DemandPageState();
}

class _DemandPageState extends State<DemandPage> {
  String? sousCompteId;
  final TextEditingController _receiverCtrller = TextEditingController();
  final TextEditingController _montantCtrller = TextEditingController();

  List<String> deviseList = ["USD", "CDF"];
  late String choosedDevise = "USD";

  List<String> typeTransactionList = ["Virtuel", "Cash"];
  late String choosedTransaction = "Virtuel";

  List<String> alertList = ["Urgent", "Rupture de stock", "Preventif"];
  late String choosedAlert = "Urgent";

  String? nomFournisseur;
  String? membreInterne;

  String? nomMembre;
  String? receiverID;

  bool isCash = true;
  String demandType = 'Normal';
  DemandAction? demandAction;
  ConnectedUser connectedUser = ConnectedUser.None;

  @override
  void initState() {
    super.initState();
    if ((widget.demandData != null &&
        widget.demandData?['receiver_id'].toString() ==
            Provider.of<UserStateProvider>(navKey.currentContext!,
                    listen: false)
                .clientAccountData['id']
                .toString())) {
      connectedUser = ConnectedUser.Receiver;
    }
    if (widget.demandData?['sender_id'].toString() ==
        Provider.of<UserStateProvider>(context, listen: false)
            .clientAccountData['id']
            .toString()) {
      connectedUser = ConnectedUser.Sender;
    }
    if (widget.updatingData == true &&
        widget.demandData != null &&
        (connectedUser == ConnectedUser.Sender ||
            connectedUser == ConnectedUser.Receiver)) {
      if (connectedUser == ConnectedUser.Receiver) {
        if (widget.demandData?['status'].toString().toLowerCase() ==
            'pending') {
          demandAction = DemandAction.Validate;
        }
        if (widget.demandData?['status'].toString().toLowerCase() ==
            'validated') {
          demandAction = DemandAction.Update;
        }
        if (widget.demandData?['status'].toString().toLowerCase() == 'paid') {
          demandAction = DemandAction.Terminate;
        }
      }
      if (connectedUser == ConnectedUser.Sender) {
        if (widget.demandData!['status'].toString().toLowerCase() ==
            'pending') {
          demandAction = DemandAction.Update;
        }
        if (widget.demandData!['status'].toString().toLowerCase() ==
            'validated') {
          demandAction = DemandAction.Accept;
        }
        if (widget.demandData!['status'].toString().toLowerCase() ==
            'accepted') {
          demandAction = DemandAction.Pay;
        }
      }
      // print(Provider.of<TransactionsStateProvider>(context, listen: false)
      //     .othersAccounts);
      isCash =
          widget.demandData!['type_transaction'].toString().toLowerCase() ==
                  'cash'
              ? true
              : false;
      if (widget.demandData!['status'].toString().toLowerCase() == 'pending') {
        if (connectedUser == ConnectedUser.Sender) {
          _receiverCtrller.text =
              Provider.of<TransactionsStateProvider>(context, listen: false)
                  .othersAccounts
                  .where((account) =>
                      account['id'].toString().trim() ==
                      widget.demandData!['receiver_id'].toString().trim())
                  .toList()[0]['names'];
          receiverID = widget.demandData!['receiver_id'].toString().trim();
        } else {
          _receiverCtrller.text =
              Provider.of<TransactionsStateProvider>(context, listen: false)
                  .othersAccounts
                  .where((account) =>
                      account['id'].toString().trim() ==
                      widget.demandData!['sender_id'].toString().trim())
                  .toList()[0]['names'];
          receiverID = widget.demandData!['sender_id'].toString().trim();
        }
      } else if (widget.demandData!['status'].toString().toLowerCase() ==
          'validated') {
        if (widget.demandData!['receiver_id'].toString().trim() ==
            widget.accountData['id'].toString()) {
          _receiverCtrller.text =
              Provider.of<TransactionsStateProvider>(context, listen: false)
                  .othersAccounts
                  .where((account) =>
                      account['id'].toString().trim() ==
                      widget.demandData!['sender_id'].toString().trim())
                  .toList()[0]['names'];
          receiverID = widget.demandData!['sender_id'].toString().trim();
        } else {
          _receiverCtrller.text =
              Provider.of<TransactionsStateProvider>(context, listen: false)
                  .othersAccounts
                  .where((account) =>
                      account['id'].toString().trim() ==
                      widget.demandData!['receiver_id'].toString().trim())
                  .toList()[0]['names'];
          receiverID = widget.demandData!['receiver_id'].toString().trim();
        }
      } else {
        _receiverCtrller.text =
            Provider.of<TransactionsStateProvider>(context, listen: false)
                .othersAccounts
                .where((account) =>
                    account['id'].toString().trim() ==
                    widget.demandData!['receiver_id'].toString().trim())
                .toList()[0]['names'];
        receiverID = widget.demandData!['receiver_id'].toString().trim();
      }

      _montantCtrller.text = widget.demandData!['amount_send'] != null
          ? widget.demandData!['amount_send'].toString().trim()
          : widget.demandData!['amount'].toString().trim();
      choosedDevise = widget.demandData!['type_devise'].toString().trim();
      choosedAlert = widget.demandData!['alerte'].toString().trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: !Responsive.isWeb(context)
            ? MediaQuery.of(context).size.width - 40
            : MediaQuery.of(context).size.width / 1.7,
        // height: MediaQuery.of(context).size.height * .85,
        // color: AppColors.kBlackLightColor,
        child: Center(
          child: SingleChildScrollView(
            child: CardWidget(
              backColor: AppColors.kBlackLightColor,
              title: 'Demandes',
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                IgnorePointer(
                  ignoring: widget.demandData == null
                      ? false
                      : widget.demandData != null &&
                              (widget.demandData!['sender_id'].toString() ==
                                      widget.accountData['id'].toString() &&
                                  widget.demandData!['status']
                                          .toString()
                                          .toLowerCase() ==
                                      'pending')
                          ? false
                          : true,
                  child: Flex(
                    direction: !Responsive.isWeb(context)
                        ? Axis.vertical
                        : Axis.horizontal,
                    mainAxisSize: !Responsive.isWeb(context)
                        ? MainAxisSize.min
                        : MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: TabHelperWidget(
                            tabs: ["Cash", "Virtuel"],
                            tabBackColor: AppColors.kTextFormWhiteColor,
                            activeColor: Colors.grey.shade100,
                            inactiveTextColor: Colors.grey.shade200,
                            title: "Transaction",
                            callback: (data) async {
                              isCash = data.toString().toLowerCase() == 'cash'
                                  ? true
                                  : false;
                              if (receiverID != null) {
                                if (isCash == false) {
                                  await Provider.of<TransactionsStateProvider>(
                                          context,
                                          listen: false)
                                      .getAccount(
                                          accountID: receiverID!.toString(),
                                          activityID: widget
                                              .activityData['activity_id']
                                              .toString(),
                                          callback: () {
                                            print('exists');
                                            receiverID = receiverID!.toString();
                                            setState(() {});
                                            return;
                                          },
                                          errorCallback: () {
                                            receiverID = null;
                                            _receiverCtrller.text = "";
                                            Message.showToast(
                                                msg:
                                                    "Ce compte n'a pas l'activité que vous avez choisi");
                                            setState(() {});
                                          });
                                }
                              }
                              setState(() {});
                            }),
                      ),
                      const SizedBox(width: 16, height: 8),
                      if (widget.demandData?['status']
                                  .toString()
                                  .toLowerCase() ==
                              'pending' ||
                          widget.demandData == null)
                        Flexible(
                          fit: FlexFit.loose,
                          child: TabHelperWidget(
                              tabs: ["Normale", "Express"],
                              tabBackColor: AppColors.kTextFormWhiteColor,
                              activeColor: Colors.grey.shade100,
                              inactiveTextColor: Colors.grey.shade200,
                              title: "Demande",
                              callback: (data) async {
                                demandType = data;
                                setState(() {});
                              }),
                        )
                    ],
                  ),
                ),
                IgnorePointer(
                  ignoring: demandAction == DemandAction.Terminate
                      ? true
                      : widget.demandData == null
                          ? false
                          : widget.demandData != null &&
                                  (widget.demandData!['sender_id'].toString() ==
                                          widget.accountData['id'].toString() &&
                                      widget.demandData!['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'pending')
                              ? false
                              : true,
                  child: Flex(
                      direction: !Responsive.isWeb(context)
                          ? Axis.vertical
                          : Axis.horizontal,
                      mainAxisSize: !Responsive.isWeb(context)
                          ? MainAxisSize.min
                          : MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: CustomDropdownButton(
                              backColor: AppColors.kTextFormWhiteColor,
                              dropdownColor: AppColors.kBlackLightColor,
                              textColor: AppColors.kWhiteColor,
                              value: choosedAlert,
                              hintText: "Alerte",
                              callBack: (newValue) {
                                setState(() {
                                  choosedAlert = newValue;
                                });
                              },
                              items: alertList),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: SearchableTextFormFieldWidget(
                            hintText: 'Caissier',
                            textColor: AppColors.kWhiteColor,
                            backColor: AppColors.kTextFormWhiteColor,
                            overlayColor: AppColors.kBlackColor,
                            editCtrller: _receiverCtrller,
                            maxLines: 1,
                            isEnabled: false,
                            callback: (value) async {
                              if (isCash == false) {
                                await Provider.of<TransactionsStateProvider>(
                                        context,
                                        listen: false)
                                    .getAccount(
                                        accountID: value.toString(),
                                        activityID: widget
                                            .activityData['activity_id']
                                            .toString(),
                                        callback: () {
                                          print('exists');
                                          receiverID = value.toString();
                                          setState(() {});
                                          return;
                                        },
                                        errorCallback: () {
                                          receiverID = null;
                                          _receiverCtrller.text = "";
                                          Message.showToast(
                                              msg:
                                                  "Ce compte n'a pas l'activité que vous avez choisi");
                                          setState(() {});
                                        });
                              } else {
                                receiverID = value.toString();
                                setState(() {});
                              }
                            },
                            data:
                                Provider.of<TransactionsStateProvider>(context)
                                    .othersAccounts
                                    .where((account) =>
                                        account['id'].toString() !=
                                        widget.accountData['id'].toString())
                                    .toList(),
                            displayColumn: "names",
                            indexColumn: "id",
                          ),
                        ),
                      ]),
                ),
                Flex(
                  direction: !Responsive.isWeb(context)
                      ? Axis.vertical
                      : Axis.horizontal,
                  mainAxisSize: !Responsive.isWeb(context)
                      ? MainAxisSize.min
                      : MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: TextFormFieldWidget(
                        maxLines: 1,
                        hintText: 'Montant',
                        isEnabled: demandAction == DemandAction.Terminate
                            ? false
                            : widget.demandData == null
                                ? true
                                : widget.demandData != null &&
                                            (widget.demandData!['sender_id']
                                                        .toString() ==
                                                    widget.accountData['id']
                                                        .toString() &&
                                                widget.demandData!['status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'pending') ||
                                        widget.demandData != null &&
                                            (widget.demandData!['receiver_id']
                                                        .toString() ==
                                                    widget.accountData['id']
                                                        .toString() &&
                                                widget.demandData!['status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'validated') ||
                                        widget.demandData != null &&
                                            widget.demandData!['status']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'pending'
                                    ? true
                                    : false,
                        editCtrller: _montantCtrller,
                        textColor: AppColors.kWhiteColor,
                        backColor: AppColors.kTextFormWhiteColor,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: IgnorePointer(
                        ignoring: demandAction == DemandAction.Terminate
                            ? true
                            : widget.demandData == null
                                ? false
                                : widget.demandData != null &&
                                        (widget.demandData!['sender_id']
                                                    .toString() ==
                                                widget.accountData['id']
                                                    .toString() &&
                                            widget.demandData!['status']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'pending')
                                    ? false
                                    : true,
                        child: CustomDropdownButton(
                            backColor: AppColors.kTextFormWhiteColor,
                            dropdownColor: AppColors.kBlackLightColor,
                            textColor: AppColors.kWhiteColor,
                            value: choosedDevise,
                            hintText: "Devise",
                            callBack: (newValue) {
                              setState(() {
                                choosedDevise = newValue;
                              });
                            },
                            items: deviseList),
                      ),
                    ),
                  ],
                ),
                if (demandAction == DemandAction.Update ||
                    demandAction == DemandAction.Terminate)
                  CustomButton(
                    text: demandAction == DemandAction.Terminate
                        ? 'Terminer'
                        : 'Modifier',
                    backColor: AppColors.kGreenColor,
                    textColor: AppColors.kWhiteColor,
                    callback: () {
                      if (receiverID == null) {
                        Message.showToast(msg: "Veuillez choisir un caissier");
                        return;
                      }
                      if (Provider.of<UserStateProvider>(navKey.currentContext!,
                                      listen: false)
                                  .clientAccountData['id']
                                  .toString() ==
                              receiverID!.toString().trim() &&
                          widget.demandData == null) {
                        Message.showToast(
                            msg:
                                "Vous ne pouvez pas lancer une demande vers vous meme. Choisissez un autre caissier");
                        return;
                      }
                      if (demandAction == DemandAction.Terminate) {
                        widget.demandData!['status'] = 'Terminated';
                        DemandHelper(
                          demandData: widget.demandData!,
                        ).updateDemand();
                        return;
                      }
                      if (demandAction == DemandAction.Update) {
                        if (connectedUser == ConnectedUser.Sender) {
                          widget.demandData!['amount'] =
                              double.parse(_montantCtrller.text.trim());
                        }
                        widget.demandData!['amount_send'] =
                            widget.demandData!['amount_send'] != null
                                ? double.parse(_montantCtrller.text.trim())
                                : null;
                        if (widget.demandData!['status']
                                .toString()
                                .toLowerCase() ==
                            'pending') {
                          widget.demandData!["receiver_id"] = receiverID;
                          // widget.demandData!["amount"] =
                          //     _montantCtrller.text.trim();
                          widget.demandData!["type_devise"] = choosedDevise;
                          widget.demandData!["type_transaction"] =
                              isCash == true ? "Cash" : "Virtuel";
                          widget.demandData!["alerte"] = choosedAlert;
                          widget.demandData!["activity_id"] = isCash == false
                              ? widget.activityData['activity_id'].toString()
                              : null;
                        }
                        // Map data = {"demand": widget.demandData};
                        // return print(data);
                        DemandHelper(
                          demandData: widget.demandData!,
                        ).updateDemand();
                      }
                    },
                  ),
                if ((widget.demandData != null &&
                        ((connectedUser == ConnectedUser.Sender &&
                                widget.demandData!['status'].toString().toLowerCase() !=
                                    'pending') ||
                            (connectedUser == ConnectedUser.Receiver &&
                                widget.demandData!['status'].toString().toLowerCase() !=
                                    'validated'))) ||
                    widget.demandData == null)
                  (widget.demandData != null &&
                              widget.demandData?['status'].toString().toLowerCase() !=
                                  'terminated') ||
                          widget.demandData == null
                      ? Consumer<TransactionsStateProvider>(builder: (context, transactionProvider, _) {
                          return Row(children: [
                            widget.updatingData == true &&
                                    widget.demandData != null &&
                                    demandAction == DemandAction.Validate &&
                                    connectedUser == ConnectedUser.Receiver
                                ? Expanded(
                                    child: CustomButton(
                                      text: 'Refuser',
                                      backColor: AppColors.kRedColor,
                                      textColor: AppColors.kWhiteColor,
                                      callback: () {},
                                    ),
                                  )
                                : Container(),
                            if (widget.demandData?['status']
                                    .toString()
                                    .toLowerCase() !=
                                'paid')
                              Expanded(
                                  child: CustomButton(
                                text: widget.demandData == null
                                    ? "Soumettre"
                                    : widget.demandData != null &&
                                            widget.demandData!['status']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'pending'
                                        ? 'Valider'
                                        : widget.demandData != null &&
                                                widget.demandData!['status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'accepted'
                                            ? "Rembourser"
                                            : "Accepter",
                                backColor: AppColors.kYellowColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () async {
                                  if (double.tryParse(
                                          _montantCtrller.text.trim()) ==
                                      null) {
                                    return Message.showToast(
                                        msg:
                                            "Veuillez saisir un montant valide");
                                  }
                                  if (receiverID == null) {
                                    return Message.showToast(
                                        msg: "Veuillez choisir un caissier");
                                  }
                                  if (widget.updatingData == true) {
                                    if (demandAction == DemandAction.Validate) {
                                      widget.demandData!['status'] =
                                          'Validated';
                                      widget.demandData!['amount_send'] =
                                          double.parse(
                                              _montantCtrller.text.trim());
                                      DemandHelper(
                                        demandData: widget.demandData!,
                                      ).updateDemand();
                                      return;
                                    }
                                    await Provider.of<
                                                TransactionsStateProvider>(
                                            context,
                                            listen: false)
                                        .getAccount(
                                            accountID: receiverID.toString(),
                                            activityID: isCash == false
                                                ? widget
                                                    .activityData['activity_id']
                                                    .toString()
                                                : null,
                                            callback: () {},
                                            errorCallback: () {});
                                    // setSenderAndReceiverData();
                                    if (demandAction == DemandAction.Accept) {
                                      if (isCash == false) {
                                        await DemandHelper(
                                                demandData: widget.demandData!,
                                                montant:
                                                    _montantCtrller.text.trim(),
                                                senderInfo:
                                                    setSenderAndReceiverData()[
                                                        'senderInfo'],
                                                receiverInfo:
                                                    setSenderAndReceiverData()[
                                                        'receiverInfo'],
                                                accountData: widget.accountData,
                                                activityData:
                                                    widget.activityData)
                                            .validateVirtualDemand(
                                                choosedDevise: choosedDevise,
                                                callback: () {});
                                        // Navigator.pop(navKey.currentContext!);
                                      } else {
                                        await DemandHelper(
                                                demandData: widget.demandData!,
                                                montant:
                                                    _montantCtrller.text.trim(),
                                                senderInfo:
                                                    setSenderAndReceiverData()[
                                                        'senderInfo'],
                                                receiverInfo:
                                                    setSenderAndReceiverData()[
                                                        'receiverInfo'],
                                                accountData: widget.accountData,
                                                activityData:
                                                    widget.activityData)
                                            .validateCashDemand(
                                                choosedDevise: choosedDevise,
                                                callback: () {});
                                        // Navigator.pop(navKey.currentContext!);
                                      }
                                    }
                                    if (demandAction == DemandAction.Pay) {
                                      if (isCash == false) {
                                        DemandHelper(
                                                demandData: widget.demandData!,
                                                montant:
                                                    _montantCtrller.text.trim(),
                                                senderInfo:
                                                    setSenderAndReceiverData()[
                                                        'senderInfo'],
                                                receiverInfo:
                                                    setSenderAndReceiverData()[
                                                        'receiverInfo'],
                                                accountData: widget.accountData,
                                                activityData:
                                                    widget.activityData)
                                            .refundVirtualDemand(
                                                choosedDevise: choosedDevise);
                                      } else {
                                        DemandHelper(
                                                demandData: widget.demandData!,
                                                montant:
                                                    _montantCtrller.text.trim(),
                                                senderInfo:
                                                    setSenderAndReceiverData()[
                                                        'senderInfo'],
                                                receiverInfo:
                                                    setSenderAndReceiverData()[
                                                        'receiverInfo'],
                                                accountData: widget.accountData,
                                                activityData:
                                                    widget.activityData)
                                            .refundCashDemand(
                                                choosedDevise: choosedDevise);
                                      }
                                    }
                                  } else {
                                    if (Provider.of<UserStateProvider>(
                                                navKey.currentContext!,
                                                listen: false)
                                            .clientAccountData['id']
                                            .toString() ==
                                        receiverID!.toString().trim()) {
                                      return Message.showToast(
                                          msg:
                                              "Vous ne pouvez pas lancer une demande vers vous meme. Choisissez un autre caissier");
                                    }
                                    Dialogs.showDialogWithActionCustomContent(
                                        context: context,
                                        title: "Confirmation",
                                        content: TextWidgets.text300(
                                            title:
                                                "Vous allez effectuer une demande de ${_montantCtrller.text.trim()} $choosedDevise vers ${_receiverCtrller.text.trim()}",
                                            fontSize: 14,
                                            textColor: AppColors.kBlackColor),
                                        callback: () {
                                          Map data = {
                                            "sender_id": demandType
                                                    .contains('Express')
                                                ? receiverID
                                                : Provider.of<
                                                            UserStateProvider>(
                                                        navKey.currentContext!,
                                                        listen: false)
                                                    .clientAccountData['id']
                                                    .toString(),
                                            "receiver_id": demandType
                                                    .contains('Express')
                                                ? Provider.of<
                                                            UserStateProvider>(
                                                        navKey.currentContext!,
                                                        listen: false)
                                                    .clientAccountData['id']
                                                    .toString()
                                                : receiverID,
                                            if (isCash == false)
                                              "activity_id": widget
                                                  .activityData['activity_id']
                                                  .toString(),
                                            "amount":
                                                _montantCtrller.text.trim(),
                                            if (demandType
                                                .toLowerCase()
                                                .contains('express'))
                                              "amount_send":
                                                  _montantCtrller.text.trim(),
                                            "type_devise": choosedDevise,
                                            "type_transaction": isCash == true
                                                ? "Cash"
                                                : "Virtuel",
                                            "status":
                                                demandType.contains('Normal')
                                                    ? "Pending"
                                                    : "Validated",
                                            "alerte": choosedAlert
                                          };
                                          // return print(data);
                                          transactionProvider.submitDemand(
                                              context: context,
                                              body: data,
                                              callback: () {
                                                // Navigator.pop(navKey.currentContext!);
                                              });
                                        });
                                  }
                                },
                              ))
                          ]);

                          //DisplayCaissePage()
                        })
                      : Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.kGreenColor),
                          child: TextWidgets.textBold(
                              title: "Demande ${widget.demandData != null ? widget.demandData!['status'].toString().trim() : ''}",
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor)),
              ]),
            ),
          ),
        ));
  }

  Map setSenderAndReceiverData() {
    Map senderInfo = {}, receiverInfo = {};
    if (widget.accountData['id'].toString() ==
        widget.demandData!['sender_id'].toString()) {
      senderInfo = widget.accountData;
    } else {
      senderInfo =
          Provider.of<TransactionsStateProvider>(context, listen: false)
              .otherAccountData;
    }
    if (widget.accountData['id'].toString() ==
        widget.demandData!['receiver_id'].toString()) {
      receiverInfo = widget.accountData;
    } else {
      receiverInfo =
          Provider.of<TransactionsStateProvider>(context, listen: false)
              .otherAccountData;
    }
    // print(senderInfo['activities']);
    // print(receiverInfo['activities']);
    return {"senderInfo": senderInfo, "receiverInfo": receiverInfo};
  }
}
