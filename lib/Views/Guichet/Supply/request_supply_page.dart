import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/radio_button.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Demands/helper.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class RequestSupplyPage extends StatefulWidget {
  final Map accountData;
  final Map? supplyData;
  final bool updatingData;

  const RequestSupplyPage(
      {Key? key,
      required this.accountData,
      required this.updatingData,
      this.supplyData})
      : super(key: key);

  @override
  _RequestSupplyPageState createState() => _RequestSupplyPageState();
}

class _RequestSupplyPageState extends State<RequestSupplyPage> {
  final TextEditingController _receiverCtrller = TextEditingController(),
      _montantCtrller = TextEditingController();
  Map? receiverInfo;
  Map? receiverUser;
  TransactionsStateProvider? transactionProvider;
  List accountToSupply = [];

  @override
  void initState() {
    super.initState();
    transactionProvider =
        Provider.of<TransactionsStateProvider>(context, listen: false);
    if (widget.updatingData == true) {
      _montantCtrller.text = widget.supplyData!['amount'].toString();
      _receiverCtrller.text =
          Provider.of<TransactionsStateProvider>(context, listen: false)
              .othersAccounts
              .where((account) =>
                  account['id'].toString().trim() ==
                  widget.supplyData!['sender_id'].toString().trim())
              .toList()[0]['names'];
      receiverID = widget.supplyData!['sender_id'].toString().trim();
      if (widget.supplyData!['activity_id'] != null) {
        isCash = false;
        activityData = transactionProvider!.accounts[0]['activities']
            .where((activity) =>
                activity['activity_id'].toString() ==
                widget.supplyData!['activity_id'].toString())
            .toList()[0];
      }
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      accountToSupply = Provider.of<TransactionsStateProvider>(context,
              listen: false)
          .othersAccounts
          .where((account) =>
              account['id'].toString() != widget.accountData['id'].toString())
          .toList();
      if (Provider.of<UserStateProvider>(context, listen: false)
              .clientData!
              .role
              .toLowerCase() ==
          'agregateur') {
        accountToSupply = accountToSupply
            .where((account) => transactionProvider!.allUsers
                .where((user) =>
                    user['id'].toString() == account['users_id'].toString() &&
                    user['role'].toString().toLowerCase() == 'caissier')
                .toList()
                .isNotEmpty)
            .toList();
      }
      if (Provider.of<UserStateProvider>(context, listen: false)
              .clientData!
              .role
              .toLowerCase() ==
          'comptable') {
        accountToSupply = accountToSupply
            .where((account) => transactionProvider!.allUsers
                .where((user) =>
                    user['id'].toString() == account['users_id'].toString() &&
                    ["caissier", "agregateur"]
                        .contains(user['role'].toString().toLowerCase()))
                .toList()
                .isNotEmpty)
            .toList();
      }
      setState(() {});
    });
  }

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: AppColors.kYellowColor),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(children: [
                                TextWidgets.text300(
                                    title:
                                        'Approvisionner un compte qui en a besoin afin d\'augmenter son solde',
                                    fontSize: 14,
                                    textColor: AppColors.kYellowColor),
                                const SizedBox(height: 10),
                                TextWidgets.text300(
                                    title:
                                        'Cette action va transférer le montant saisi  vers le compte choisi.',
                                    fontSize: 14,
                                    textColor: AppColors.kYellowColor),
                              ]),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        IgnorePointer(
                          ignoring: widget.updatingData,
                          child: Wrap(direction: Axis.horizontal, children: [
                            CustomRadioButton(
                                textColor: AppColors.kWhiteColor,
                                value: isCash,
                                label: 'Cash',
                                callBack: () {
                                  isCash = true;
                                  setState(() {});
                                }),
                            CustomRadioButton(
                                textColor: AppColors.kWhiteColor,
                                value: isCash == true ? false : true,
                                label: 'Virtuel',
                                callBack: () async {
                                  isCash = false;
                                  if (activityData.isEmpty) {
                                    activityData = transactionProvider
                                        ?.accounts[0]['activities'][0];
                                    setState(() {});
                                  }
                                  if (receiverID != null) {
                                    if (isCash == false) {
                                      print(receiverID);
                                      await Provider.of<
                                                  TransactionsStateProvider>(
                                              context,
                                              listen: false)
                                          .getAccount(
                                              accountID: receiverID!.toString(),
                                              activityID:
                                                  activityData['activity_id']
                                                      .toString(),
                                              callback: () {
                                                print('exists');
                                                receiverID =
                                                    receiverID!.toString();
                                                setState(() {});
                                                return;
                                              },
                                              errorCallback: () {
                                                receiverID = null;
                                                Message.showToast(
                                                    msg:
                                                        "Ce compte n'a pas l'activité que vous avez choisi");
                                                setState(() {});
                                              });
                                    }
                                  }
                                  setState(() {});
                                }),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        TextWidgets.textBold(
                            title: "Le compte à approvisionner",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor),
                        const SizedBox(height: 8),
                        IgnorePointer(
                          ignoring: widget.updatingData,
                          child: SearchableTextFormFieldWidget(
                            hintText: 'Compte',
                            textColor: AppColors.kWhiteColor,
                            backColor: AppColors.kTextFormWhiteColor,
                            overlayColor: AppColors.kBlackLightColor,
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
                                        activityID: activityData['activity_id']
                                            .toString(),
                                        callback: () {
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
                            data: accountToSupply,
                            displayColumn: "names",
                            indexColumn: "id",
                          ),
                        ),
                        IgnorePointer(
                          ignoring: widget.updatingData,
                          child: Row(children: [
                            Expanded(
                                child: TextFormFieldWidget(
                              maxLines: 1,
                              hintText: 'Montant',
                              editCtrller: _montantCtrller,
                              textColor: AppColors.kWhiteColor,
                              backColor: AppColors.kTextFormWhiteColor,
                            )),
                            Expanded(
                                child: CustomDropdownButton(
                                    backColor: AppColors.kTextFormWhiteColor,
                                    textColor: AppColors.kWhiteColor,
                                    dropdownColor: AppColors.kBlackLightColor,
                                    value: choosedDevise!,
                                    hintText: "Devise",
                                    callBack: (newValue) {
                                      setState(() {
                                        choosedDevise = newValue;
                                      });
                                    },
                                    items: ["USD", "CDF", if(isCash==false)'STOCK']))
                          ]),
                        ),
                        if (isCash == false)
                          TextWidgets.textNormal(
                              title: 'Vos activité',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        if (isCash == false)
                          Container(
                              height: 100,
                              width: double.maxFinite,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: IgnorePointer(
                                  ignoring: widget.updatingData,
                                  child: Row(
                                    children: List.generate(
                                        transactionProvider
                                            ?.accounts[0]['activities']
                                            .length, (index) {
                                      return cardStatsWidget(
                                          data: transactionProvider!.accounts[0]
                                              ['activities'][index],
                                          width: 300,
                                          title: transactionProvider!
                                              .accounts[0]['activities'][index]
                                                  ['name']
                                              .toString(),
                                          subtitle:
                                              "STOCK: ${transactionProvider!.accounts[0]['activities'][index]['stock'].toString()}",
                                          backColor: AppColors.kBlackColor,
                                          textColor: AppColors.kWhiteColor,
                                          icon: Icons.credit_card,
                                          currency: "",
                                          value:
                                              "${transactionProvider!.accounts[0]['activities'][index]['virtual_cdf'].toString()} CDF",
                                          value2:
                                              "${transactionProvider!.accounts[0]['activities'][index]['virtual_usd'].toString()} USD");
                                    }),
                                  ),
                                ),
                              )),
                        if (isCash == true)
                          cardStatsWidget(
                              data: {},
                              title: "CASH",
                              subtitle: "Solde actuel en cash",
                              backColor: AppColors.kBlackColor,
                              textColor: AppColors.kWhiteColor,
                              icon: Icons.credit_card,
                              currency: "",
                              value:
                                  "${transactionProvider?.accounts[0]['sold_cash_cdf'].toString()} CDF",
                              value2:
                                  "${transactionProvider?.accounts[0]['sold_cash_usd'].toString()} USD"),
                        const SizedBox(height: 8),
                        if ((widget.updatingData == true &&
                                widget.supplyData!['status']
                                        .toString()
                                        .toLowerCase() ==
                                    'pending') ||
                            widget.updatingData == false)
                          CustomButton(
                            text: 'Approvisionner',
                            backColor: AppColors.kRedColor,
                            textColor: AppColors.kWhiteColor,
                            callback: () {
                              if (double.tryParse(
                                      _montantCtrller.text.trim()) ==
                                  null) {
                                Message.showToast(
                                    msg: "Veuillez saisir un montant valide");
                                return;
                              }
                              if (receiverID == null) {
                                Message.showToast(
                                    msg: "Veuillez choisir un caissier");
                                return;
                              }
                              if (Provider.of<UserStateProvider>(
                                          navKey.currentContext!,
                                          listen: false)
                                      .clientAccountData['id']
                                      .toString() ==
                                  receiverID!.toString().trim()) {
                                Message.showToast(
                                    msg:
                                        "Vous ne pouvez pas lancer une demande vers vous meme. Choisissez un autre caissier");
                                return;
                              }
                              if (choosedDevise!.toLowerCase() == 'cdf') {
                                if (isCash == false) {
                                  if (double.parse(activityData['virtual_cdf']
                                          .toString()) <
                                      double.parse(
                                          _montantCtrller.text.trim())) {
                                    Message.showToast(
                                        msg: "Solde virtuel insufisant");
                                    return;
                                  }
                                } else {
                                  if (double.parse(widget
                                          .accountData['sold_cash_cdf']
                                          .toString()) <
                                      double.parse(
                                          _montantCtrller.text.trim())) {
                                    Message.showToast(
                                        msg: "Solde cash insufisant");
                                    return;
                                  }
                                }
                              }
                              if (choosedDevise!.toLowerCase() == 'usd') {
                                if (isCash == false) {
                                  if (double.parse(activityData['virtual_usd']
                                          .toString()) <
                                      double.parse(
                                          _montantCtrller.text.trim())) {
                                    Message.showToast(
                                        msg: "Solde virtuel insufisant");
                                    return;
                                  }
                                } else {
                                  if (double.parse(widget
                                          .accountData['sold_cash_usd']
                                          .toString()) <
                                      double.parse(
                                          _montantCtrller.text.trim())) {
                                    Message.showToast(
                                        msg: "Solde cash insufisant");
                                    return;
                                  }
                                }
                              }
                              Dialogs.showDialogWithActionCustomContent(
                                  context: context,
                                  title: "Confirmation",
                                  content: Container(
                                      child: TextWidgets.text300(
                                          title:
                                              "Voulez-vous vraiment approvisionner ce compte?",
                                          fontSize: 14,
                                          textColor: AppColors.kGreyColor)),
                                  callback: () async {
                                    Navigator.pop(context);
                                    Map data = {
                                      "sender_id": receiverID,
                                      "receiver_id":
                                          Provider.of<UserStateProvider>(
                                                  navKey.currentContext!,
                                                  listen: false)
                                              .clientAccountData['id']
                                              .toString(),
                                      if (isCash == false)
                                        "activity_id":
                                            activityData['activity_id']
                                                .toString(),
                                      "amount": _montantCtrller.text.trim(),
                                      "type_devise": choosedDevise,
                                      "type_transaction":
                                          isCash == true ? "Cash" : "Virtuel",
                                      "status": "Pending",
                                      "alerte": "Approvisionnement"
                                    };
                                    await Provider.of<
                                                TransactionsStateProvider>(
                                            context,
                                            listen: false)
                                        .getAccount(
                                            accountID: receiverID.toString(),
                                            activityID: isCash == false
                                                ? activityData['activity_id']
                                                    .toString()
                                                : null,
                                            callback: () {},
                                            errorCallback: () {});
                                    if (widget.updatingData == true) {
                                      if (isCash == true) {
                                        DemandHelper(
                                                demandData: widget.supplyData!,
                                                montant:
                                                    _montantCtrller.text.trim(),
                                                senderInfo:
                                                    setSenderAndReceiverData()[
                                                        'senderInfo'],
                                                receiverInfo:
                                                    setSenderAndReceiverData()[
                                                        'receiverInfo'],
                                                accountData: widget.accountData,
                                                activityData: activityData)
                                            .validateCashDemand(
                                                choosedDevise: choosedDevise!,
                                                isSupply: true,
                                                callback: () {
                                                  transactionProvider!
                                                      .getAccountActivities();
                                                });
                                      } else {
                                        DemandHelper(
                                                demandData: widget.supplyData!,
                                                montant:
                                                    _montantCtrller.text.trim(),
                                                senderInfo:
                                                    setSenderAndReceiverData()[
                                                        'senderInfo'],
                                                receiverInfo:
                                                    setSenderAndReceiverData()[
                                                        'receiverInfo'],
                                                accountData: widget.accountData,
                                                activityData: activityData)
                                            .validateVirtualDemand(
                                                choosedDevise: choosedDevise!,
                                                isSupply: true,
                                                callback: () {
                                                  transactionProvider!
                                                      .getAccountActivities();
                                                });
                                      }
                                    } else {
                                      transactionProvider!.submitSupplyRequest(
                                          context: context,
                                          body: data,
                                          callback: () {
                                            Map submittedSupply =
                                                transactionProvider!
                                                    .submittedSupply;
                                            if (isCash == true) {
                                              DemandHelper(
                                                      demandData:
                                                          submittedSupply,
                                                      montant: _montantCtrller
                                                          .text
                                                          .trim(),
                                                      senderInfo:
                                                          setSenderAndReceiverData()[
                                                              'senderInfo'],
                                                      receiverInfo:
                                                          setSenderAndReceiverData()[
                                                              'receiverInfo'],
                                                      accountData:
                                                          widget.accountData,
                                                      activityData:
                                                          activityData)
                                                  .validateCashDemand(
                                                      choosedDevise:
                                                          choosedDevise!,
                                                      isSupply: true,
                                                      callback: () {
                                                        // Navigator.pop(navKey
                                                        //     .currentContext!);
                                                        // Navigator.pop(navKey.currentContext!);
                                                      });
                                            } else {
                                              DemandHelper(
                                                      demandData:
                                                          submittedSupply,
                                                      montant: _montantCtrller
                                                          .text
                                                          .trim(),
                                                      senderInfo:
                                                          setSenderAndReceiverData()[
                                                              'senderInfo'],
                                                      receiverInfo:
                                                          setSenderAndReceiverData()[
                                                              'receiverInfo'],
                                                      accountData:
                                                          widget.accountData,
                                                      activityData:
                                                          activityData)
                                                  .validateVirtualDemand(
                                                      choosedDevise:
                                                          choosedDevise!,
                                                      isSupply: true,
                                                      callback: () {
                                                        // Navigator.pop(navKey
                                                        //     .currentContext!);
                                                        // Navigator.pop(navKey.currentContext!);
                                                      });
                                            }
                                          });
                                    }
                                  });
                            },
                          ),
                      ]),
                    )
                  ]));
        }));
  }

  cardStatsWidget(
      {required Map data,
      required String title,
      required String subtitle,
      required IconData icon,
      required Color textColor,
      required Color backColor,
      required String value,
      required String value2,
      required String currency,
      double? width}) {
    return GestureDetector(
      onTap: () {
        activityData = data;
        if (data.isEmpty) {
          isCash = true;
        } else {
          isCash = false;
        }
        _receiverCtrller.text = "";
        receiverID = null;
        setState(() {});
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
                              title: title,
                              fontSize: 12,
                              textColor: textColor),
                          TextWidgets.text300(
                              overflow: TextOverflow.ellipsis,
                              title: subtitle,
                              fontSize: 12,
                              textColor: textColor),
                        ],
                      )),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(icon, color: textColor),
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
                            title: value, fontSize: 14, textColor: textColor),
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
          ),
        ),
      ),
    );
  }

  Map setSenderAndReceiverData() {
    Map submittedSupply = {};
    if (widget.updatingData == true) {
      submittedSupply = widget.supplyData!;
    } else {
      submittedSupply = transactionProvider!.submittedSupply;
    }
    Map senderInfo = {}, receiverInfo = {};
    if (widget.accountData['id'].toString() ==
        submittedSupply['sender_id'].toString()) {
      senderInfo = widget.accountData;
    } else {
      senderInfo =
          Provider.of<TransactionsStateProvider>(context, listen: false)
              .otherAccountData;
    }
    if (widget.accountData['id'].toString() ==
        submittedSupply['receiver_id'].toString()) {
      receiverInfo = widget.accountData;
    } else {
      receiverInfo =
          Provider.of<TransactionsStateProvider>(context, listen: false)
              .otherAccountData;
      ;
    }
    // print(senderInfo);
    // print(receiverInfo);
    return {"senderInfo": senderInfo, "receiverInfo": receiverInfo};
  }
}
