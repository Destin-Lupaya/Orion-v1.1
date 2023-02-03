import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Helpers/transaction.helper.dart';
import 'package:orion/Resources/Models/external_client.model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/tab.helper.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

//import "package:dialog/~file~";
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

class SortiAirtelmoneyPage extends StatefulWidget {
  final bool updatingData;

  // final Map accountData;
  Map activityData;
  Map? targetedData;

  SortiAirtelmoneyPage(
      {Key? key,
      required this.updatingData,
      // required this.accountData,
      required this.activityData,
      this.targetedData})
      : super(key: key);

  @override
  State<SortiAirtelmoneyPage> createState() => _SortiAirtelmoneyPageState();
}

class _SortiAirtelmoneyPageState extends State<SortiAirtelmoneyPage> {
  TransactionsStateProvider? _transactionProvider;

  TransactionsStateProvider getProvider({required bool listen}) {
    _transactionProvider = Provider.of<TransactionsStateProvider>(
        navKey.currentContext!,
        listen: listen);
    return _transactionProvider!;
  }

  List<String> deviseModeList = ["USD", "CDF"];
  late String deviseMode = "USD";

  // List<String> typetransactionModeList = ["Cash", "Virtuel"];
  late String typePaymentMode = "Cash";

  // List<String> typeoperationModeList = ["Depot", "Retrait"];
  late String typeoperationMode =
      getProvider(listen: false).targetedActivity['cashIn'] ?? "Depot";

  List<String> alertList = ["Success", "Pending", "Denied"];
  late String alertMode = "Success";

  String? nomFournisseur;
  String? membreInterne;
  String? nomMembre;
  final TextEditingController _montantCtrller = TextEditingController();
  final TextEditingController _quantityCtrller = TextEditingController();
  final TextEditingController _clientNumberCtrller = TextEditingController();
  final TextEditingController _pswCtrller = TextEditingController();
  final FocusNode node1 = FocusNode();
  List<TextEditingController> inputsController = [];

  @override
  void initState() {
    for (int i = 0;
        i <
            Provider.of<TransactionsStateProvider>(navKey.currentContext!,
                    listen: true)
                .targetedActivity['inputs']
                .length;
        i++) {
      inputsController.add(TextEditingController());
    }
    if (widget.updatingData == true && widget.targetedData != null) {
      for (int i = 0;
          i <
              widget.targetedData!.keys
                  .toList()
                  .where((key) => key.toString().contains('col_'))
                  .toList()
                  .length;
          i++) {
        inputsController[i].text = widget.targetedData![widget
                .targetedData!.keys
                .toList()
                .where((key) => key.toString().contains('col_'))
                .toList()[i]]
            .toString();
      }
      _montantCtrller.text = widget.targetedData!['amount'].toString();
      deviseMode = widget.targetedData!['type_devise'].toString();
      typeoperationMode = widget.targetedData!['type_operation'].toString();
      isExternalTransaction = true;
    }
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Provider.of<TransactionsStateProvider>(navKey.currentContext!,
              listen: false)
          .getAccountActivities();
    });
  }

  bool isExternalTransaction = false;
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

            // height: MediaQuery.of(context).size.height * .85,
            color: AppColors.kTransparentColor,
            child: Consumer<AppStateProvider>(
                builder: (context, appStateProvider, _) {
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                shrinkWrap: true,
                physics: widget.updatingData == false
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                children: [
                  CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: "Transaction",
                      titleColor: AppColors.kWhiteColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.spaceAround,
                            runSpacing: 16,
                            spacing: 16,
                            children: [
                              IgnorePointer(
                                ignoring: isExternalTransaction,
                                child: TabHelperWidget(
                                    activeTab: typeoperationMode,
                                    title: "",
                                    tabs: [
                                      if (getProvider(listen: false)
                                              .targetedActivity['cashIn'] !=
                                          null)
                                        getProvider(listen: false)
                                            .targetedActivity['cashIn'],
                                      if (getProvider(listen: false)
                                              .targetedActivity['cashOut'] !=
                                          null)
                                        ...getProvider(listen: false)
                                            .targetedActivity['cashOut']
                                            .toString()
                                            .split(','),
                                    ],
                                    tabBackColor: AppColors.kTextFormWhiteColor,
                                    activeColor: Colors.grey.shade100,
                                    inactiveTextColor: Colors.grey.shade200,
                                    callback: (op) {
                                      typeoperationMode = op;
                                      setState(() {});
                                    }),
                              ),
                              const SizedBox(width: 2, height: 2),
                              TabHelperWidget(
                                  activeTab: typePaymentMode,
                                  title: "",
                                  tabs: [
                                    'Cash',
                                    'Points',
                                    'Caution',
                                    if (isExternalTransaction == false) ...[
                                      'Pret',
                                      'Emprunt'
                                    ]
                                  ],
                                  tabBackColor: AppColors.kTextFormWhiteColor,
                                  activeColor: Colors.grey.shade100,
                                  inactiveTextColor: Colors.grey.shade200,
                                  callback: (op) {
                                    typePaymentMode = op;
                                    // print(typetransactionMode);
                                    setState(() {});
                                    // if (op.toString().toLowerCase() ==
                                    //         'points' &&
                                    //     _clientNumberCtrller.text
                                    //         .trim()
                                    //         .isNotEmpty) {
                                    //   context
                                    //       .read<PointsConfigProvider>()
                                    //       .getClientPoints(
                                    //           clientID: _clientNumberCtrller
                                    //               .text
                                    //               .trim());
                                    // }
                                    // else {
                                    //   typePaymentMode = 'Cash';
                                    //   Message.showToast(
                                    //       msg: 'Aucun numéro du client trouvé');
                                    // }
                                  }),
                              const SizedBox(width: 2, height: 2),
                              IgnorePointer(
                                ignoring: isExternalTransaction,
                                child: TabHelperWidget(
                                    activeTab: deviseMode,
                                    title: "",
                                    tabs: [...deviseModeList],
                                    tabBackColor: AppColors.kTextFormWhiteColor,
                                    activeColor: Colors.grey.shade100,
                                    inactiveTextColor: Colors.grey.shade200,
                                    callback: (op) {
                                      deviseMode = op;
                                      setState(() {});
                                    }),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              blockSeparator(title: 'Coordonnees du client'),
                              Wrap(
                                children: List.generate(
                                    getProvider(listen: false)
                                        .targetedActivity['inputs']
                                        .length,
                                    (index) => LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Wrap(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                width: !Responsive.isMobile(
                                                        context)
                                                    ? constraints.maxWidth / 2
                                                    : constraints.maxWidth,
                                                child: TextFormFieldWidget(
                                                  isEnabled:
                                                      widget.updatingData ==
                                                              true
                                                          ? false
                                                          : true,
                                                  maxLines: 1,
                                                  hintText: getProvider(
                                                                  listen: false)
                                                              .targetedActivity[
                                                          'inputs'][index]
                                                      ['designation'],
                                                  editCtrller:
                                                      inputsController[index],
                                                  textColor:
                                                      AppColors.kWhiteColor,
                                                  backColor: AppColors
                                                      .kTextFormWhiteColor,
                                                ),
                                              ),
                                            ],
                                          );
                                        })),
                              ),
                              Flex(
                                direction: !Responsive.isMobile(context)
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                mainAxisSize: !Responsive.isMobile(context)
                                    ? MainAxisSize.max
                                    : MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: TextFormFieldWidget(
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'Montant',
                                          isEnabled: widget.updatingData == true
                                              ? false
                                              : true,
                                          editCtrller: _montantCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 1)),
                                  if (context.select<TransactionsStateProvider,
                                              int>(
                                          (provider) => provider
                                              .targetedActivity['hasStock']) ==
                                      1)
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: TextFormFieldWidget(
                                            backColor:
                                                AppColors.kTextFormWhiteColor,
                                            hintText: 'Quantité',
                                            isEnabled:
                                                widget.updatingData == true
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: SearchableTextFormFieldWidget(
                                          overlayColor:
                                              AppColors.kBlackLightColor,
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
                                          backColor:
                                              AppColors.kTextFormWhiteColor,
                                          hintText: 'Numéro du client',
                                          isEnabled: widget.updatingData == true
                                              ? false
                                              : true,
                                          editCtrller: _clientNumberCtrller,
                                          textColor: AppColors.kWhiteColor,
                                          maxLines: 1)),
                                  Flexible(
                                      fit: FlexFit.loose, child: Container()),
                                ],
                              ),
                              Consumer<TransactionsStateProvider>(
                                  builder: (context, transactionProvider, _) {
                                return appStateProvider.isAsync == false
                                    ? CustomButton(
                                        backColor: AppColors.kYellowColor,
                                        text: widget.updatingData == false
                                            ? 'Valider'
                                            : "Rembourser",
                                        textColor: AppColors.kBlackColor,
                                        callback: widget.updatingData == true
                                            ? () async {
                                                Dialogs
                                                    .showDialogWithActionCustomContent(
                                                        context: context,
                                                        title: "Code PIN",
                                                        content: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                TextWidgets.text300(
                                                                    title:
                                                                        'Vous allez faire un $typePaymentMode en $typePaymentMode.\nCode PIN pour continuer.',
                                                                    fontSize:
                                                                        14,
                                                                    textColor:
                                                                        AppColors
                                                                            .kBlackColor),
                                                                TextFormFieldWidget(
                                                                    isObsCured:
                                                                        true,
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
                                                                    maxLines: 1)
                                                              ],
                                                            )),
                                                        callback: () async {
                                                          Navigator.pop(
                                                              context);
                                                          if (_pswCtrller
                                                              .text.isEmpty) {
                                                            return Message
                                                                .showToast(
                                                                    msg:
                                                                        'Veuillez entre un code PIN');
                                                          }
                                                          if (_pswCtrller
                                                                  .text !=
                                                              Provider.of<UserStateProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .clientData!
                                                                  .code
                                                                  .toString()
                                                                  .trim()) {
                                                            return Message
                                                                .showToast(
                                                                    msg:
                                                                        'Code PIN incorrect');
                                                          }
                                                          _pswCtrller.text = "";
                                                          if (widget.targetedData![
                                                                  'id'] ==
                                                              null) {
                                                            Navigator.pop(navKey
                                                                .currentContext!);
                                                            return Message
                                                                .showToast(
                                                                    msg:
                                                                        'Données invalides, veuillez actualiser la liste puis réessayer');
                                                          }
                                                          var updatedData = TransactionHelper
                                                              .updateDataRefund(
                                                                  typeOperation:
                                                                      typeoperationMode
                                                                          .trim(),
                                                                  devise:
                                                                      deviseMode,
                                                                  montant:
                                                                      _montantCtrller
                                                                          .text
                                                                          .trim());
                                                          if (updatedData ==
                                                              null) {
                                                            Message.showToast(
                                                                msg:
                                                                    "Aucun compte n'a ete modifie, veuillez vérifier vos données");
                                                            return;
                                                          }
                                                          widget.targetedData![
                                                                  'status'] =
                                                              'paid';
                                                          widget.targetedData![
                                                                  'updated_at'] =
                                                              DateTime.now()
                                                                  .toString();
                                                          Map account =
                                                              getProvider(
                                                                      listen:
                                                                          false)
                                                                  .accountData;
                                                          Map accountData = {
                                                            "id": account['id']
                                                                .toString()
                                                                .trim(),
                                                            'sold_cash_cdf': updatedData[
                                                                        'cashCDF'] ==
                                                                    0
                                                                ? account[
                                                                        'sold_cash_cdf']
                                                                    .toString()
                                                                : updatedData[
                                                                        'cashCDF']
                                                                    .toString()
                                                                    .trim(),
                                                            'sold_cash_usd': updatedData[
                                                                        'cashUSD'] ==
                                                                    0
                                                                ? account[
                                                                        'sold_cash_usd']
                                                                    .toString()
                                                                : updatedData[
                                                                        'cashUSD']
                                                                    .toString()
                                                                    .trim(),
                                                            'sold_pret_cdf': typePaymentMode
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'pret') &&
                                                                    deviseMode ==
                                                                        'CDF'
                                                                ? updatedData[
                                                                        'pretCDF']
                                                                    .toString()
                                                                    .trim()
                                                                : account[
                                                                        'sold_pret_cdf']
                                                                    .toString(),
                                                            'sold_pret_usd': typePaymentMode
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'pret') &&
                                                                    deviseMode ==
                                                                        'USD'
                                                                ? updatedData[
                                                                        'pretUSD']
                                                                    .toString()
                                                                    .trim()
                                                                : account[
                                                                        'sold_pret_usd']
                                                                    .toString(),
                                                            'sold_emprunt_cdf': typePaymentMode
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'emprunt') &&
                                                                    deviseMode ==
                                                                        'CDF'
                                                                ? updatedData[
                                                                        'empruntCDF']
                                                                    .toString()
                                                                    .trim()
                                                                : account[
                                                                        'sold_emprunt_cdf']
                                                                    .toString(),
                                                            'sold_emprunt_usd': typePaymentMode
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            'emprunt') &&
                                                                    deviseMode ==
                                                                        'USD'
                                                                ? updatedData[
                                                                        'empruntUSD']
                                                                    .toString()
                                                                    .trim()
                                                                : account[
                                                                        'sold_emprunt_usd']
                                                                    .toString(),
                                                          };

                                                          // print(widget
                                                          //     .targetedData);
                                                          // print(getProvider(
                                                          //         listen: false)
                                                          //     .targetedActivity);
                                                          // return print(
                                                          //     accountData);
                                                          transactionProvider
                                                              .pretPayment(
                                                                  body: widget
                                                                      .targetedData!,
                                                                  account:
                                                                      accountData,
                                                                  activityData: getProvider(
                                                                          listen:
                                                                              false)
                                                                      .targetedActivity,
                                                                  callback: () {
                                                                    for (int i =
                                                                            0;
                                                                        i < inputsController.length;
                                                                        i++) {
                                                                      inputsController[
                                                                              i]
                                                                          .text = "";
                                                                    }

                                                                    _montantCtrller
                                                                        .text = "";
                                                                    _quantityCtrller
                                                                        .text = "";
                                                                    Navigator.pop(
                                                                        navKey
                                                                            .currentContext!);
                                                                  });
                                                          await getProvider(
                                                                  listen: false)
                                                              .getAccountActivities();
                                                        });
                                              }
                                            : () {
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
                                                if (_montantCtrller
                                                        .text.isEmpty ||
                                                    double.tryParse(
                                                            _montantCtrller
                                                                .text) ==
                                                        null) {
                                                  Message.showToast(
                                                      msg:
                                                          "Veuillez saisir un montant valide");
                                                  return null;
                                                }
                                                if (inputsError == true) {
                                                  Message.showToast(
                                                      msg:
                                                          "Veuillez remplir tous les champs");
                                                  return null;
                                                }
                                                Dialogs
                                                    .showDialogWithActionCustomContent(
                                                        context: context,
                                                        title: 'Code PIN',
                                                        content: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                TextWidgets.text300(
                                                                    title:
                                                                        'Vous allez faire un $typePaymentMode en $typePaymentMode.\nCode PIN pour continuer.',
                                                                    fontSize:
                                                                        14,
                                                                    textColor:
                                                                        AppColors
                                                                            .kBlackColor),
                                                                TextFormFieldWidget(
                                                                    isObsCured:
                                                                        true,
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
                                                                    maxLines: 1)
                                                              ],
                                                            )),
                                                        callback: () async {
                                                          saveData();
                                                        });
                                                // }
                                              },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.kYellowColor),
                                        ),
                                      );
                              })
                            ],
                          )
                        ],
                      ))
                ],
              );
            })));
    //     ),
    //   ),
    // );
  }

  saveData() async {
    Navigator.pop(context);
    Map accountActivity = getProvider(listen: false).accountActivity;
    if (_pswCtrller.text.isEmpty) {
      Message.showToast(msg: "Veuillez saisir un code PIN");
      return;
    }
    if (_pswCtrller.text !=
        Provider.of<UserStateProvider>(context, listen: false)
            .clientData!
            .code
            .toString()
            .trim()) {
      Message.showToast(msg: "Code PIN incorrect");
      return;
    }
    if (_clientNumberCtrller.text.isEmpty &&
        typePaymentMode.toLowerCase() == 'points') {
      Message.showToast(msg: "Veuillez choisir un client");
      return;
    }
    if ((_clientNumberCtrller.text.isEmpty || clientData == null) &&
        typePaymentMode.toLowerCase() == 'caution') {
      Message.showToast(msg: "Veuillez choisir un client");
      return;
    }
    if (typePaymentMode.toLowerCase() == 'caution' &&
        clientData!.caution! < double.parse(_montantCtrller.text.trim())) {
      Message.showToast(msg: "Le solde caution du client est insuffisant");
      return;
    }
    double neededClientPoints = 0;
    _pswCtrller.text = "";
    if (typePaymentMode.toLowerCase() == 'points') {
      neededClientPoints = navKey.currentContext!
          .read<PointsConfigProvider>()
          .calculateClientPointAmount(
              amount: num.parse(_montantCtrller.text.trim()).toDouble(),
              devise: deviseMode);
      neededClientPoints = num.parse(neededClientPoints.toString()).toDouble();
      if (neededClientPoints > (clientData!.pointsClient!) &&
          typePaymentMode.toLowerCase().contains('point')) {
        return Message.showToast(
            msg:
                'Le total requis pour cette transactions est de ${neededClientPoints.toString()} points .Les points du client sont insuffisants pour la transaction');
      }
    }

    // return;
    //Checking for deposit (virtual money and amount)
    // if (double.parse(_montantCtrller.text.trim()) >
    //         double.parse(accountActivity['virtual_usd'].toString().trim()) &&
    //     deviseMode.toLowerCase() == 'usd' &&
    //     typeoperationMode.toLowerCase() == 'depot') {
    //   return Message.showToast(msg: "Solde virtuel insuffisant");
    // }
    // if (double.parse(_montantCtrller.text.trim()) >
    //         double.parse(accountActivity['virtual_cdf'].toString().trim()) &&
    //     deviseMode.toLowerCase() == 'cdf' &&
    //     typeoperationMode.toLowerCase() == 'depot') {
    //   return Message.showToast(msg: "Solde virtuel insuffisant");
    // }
    // //Checking for withdrawal (cash and amount)
    // if (double.parse(_montantCtrller.text.trim()) >
    //         double.parse(accountActivity['sold_cash_usd'].toString().trim()) &&
    //     deviseMode.toLowerCase() == 'usd' &&
    //     typeoperationMode.toLowerCase() == 'depot') {
    //   return Message.showToast(msg: "Solde cash insuffisant");
    // }
    // if (double.parse(_montantCtrller.text.trim()) >
    //         double.parse(accountActivity['sold_cash_cdf'].toString().trim()) &&
    //     deviseMode.toLowerCase() == 'cdf' &&
    //     typeoperationMode.toLowerCase() == 'depot') {
    //   return Message.showToast(msg: "Solde cash insuffisant");
    // }
    if (typeoperationMode.isEmpty) {
      return Message.showToast(msg: "Veuillez choisir un type d'opération");
    }
    Map dynamicInputsValues = {};
    for (int i = 0;
        i < getProvider(listen: false).targetedActivity['inputs'].length;
        i++) {
      dynamicInputsValues.addAll({"col_${i + 1}": inputsController[i].text});
    }
    // print('saving');
    String uuid =
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    Map transactionData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": num.parse(_montantCtrller.text.trim()),
      "quantity": num.tryParse(_quantityCtrller.text.trim()) ?? 0,
      "type_operation": typeoperationMode,
      "type_payment": typePaymentMode,
      "client_number": clientID,
      "type_devise": deviseMode,
      "account_id": getProvider(listen: false).accountData['id'].toString(),
      "status": typePaymentMode.toLowerCase().contains('pret') ||
              typePaymentMode.toLowerCase().contains('emprunt')
          ? "pending"
          : "validated",
      "source": "mobile",
      "users_id": Provider.of<UserStateProvider>(context, listen: false)
          .clientData!
          .id!
          .toString()
          .trim()
    };
    transactionData.addAll(dynamicInputsValues);
    // print(dynamicInputsValues);
    // return;
    var updatedData = TransactionHelper.updateData(
        typeOperation: typeoperationMode.trim(),
        typePayment: typePaymentMode.trim(),
        devise: deviseMode,
        montant: _montantCtrller.text.trim(),
        quantity: _quantityCtrller.text.trim());
    // return;
    if (updatedData == null) {
      // Message.showToast(msg: "Aucun compte n'a ete modifie");
      return;
    }
    Map activityData = {
      "id": getProvider(listen: false).accountActivity['id'].toString().trim(),
      "activity_id": accountActivity['activity_id'].toString().trim(),
      'virtual_cdf': updatedData['virtuelCDF'] == null
          ? accountActivity['virtual_cdf'].toString().trim()
          : updatedData['virtuelCDF'].toString().trim(),
      'virtual_usd': updatedData['virtuelUSD'] == null
          ? accountActivity['virtual_usd'].toString().trim()
          : updatedData['virtuelUSD'].toString().trim(),
      'stock': updatedData['stock'] == null
          ? accountActivity['stock'].toString().trim()
          : updatedData['stock'].toString().trim(),
    };
    // return print(getProvider(listen:false).activeActivity);
    Map accountData = {};
    if (!typePaymentMode.toLowerCase().contains('point')) {
      accountData = {
        "id": getProvider(listen: false).accountData['id'].toString().trim(),
        'sold_cash_cdf': updatedData['cashCDF'] == null
            ? getProvider(listen: false).accountData['sold_cash_cdf'].toString()
            : updatedData['cashCDF'].toString().trim(),
        'sold_cash_usd': updatedData['cashUSD'] == null
            ? getProvider(listen: false).accountData['sold_cash_usd'].toString()
            : updatedData['cashUSD'].toString().trim(),
        'sold_pret_cdf':
            typePaymentMode.toString().toLowerCase().contains('pret') &&
                    deviseMode == 'CDF' &&
                    updatedData['pretCDF'] != null
                ? updatedData['pretCDF'].toString().trim()
                : getProvider(listen: false)
                    .accountData['sold_pret_cdf']
                    .toString(),
        'sold_pret_usd':
            typePaymentMode.toString().toLowerCase().contains('pret') &&
                    deviseMode == 'USD' &&
                    updatedData['pretUSD'] != null
                ? updatedData['pretUSD'].toString().trim()
                : getProvider(listen: false)
                    .accountData['sold_pret_usd']
                    .toString(),
        'sold_emprunt_cdf':
            typePaymentMode.toString().toLowerCase().contains('emprunt') &&
                    deviseMode == 'CDF' &&
                    updatedData['empruntCDF'] != null
                ? updatedData['empruntCDF'].toString().trim()
                : getProvider(listen: false)
                    .accountData['sold_emprunt_cdf']
                    .toString(),
        'sold_emprunt_usd':
            typePaymentMode.toString().toLowerCase().contains('emprunt') &&
                    deviseMode == 'USD' &&
                    updatedData['empruntUSD'] != null
                ? updatedData['empruntUSD'].toString().trim()
                : getProvider(listen: false)
                    .accountData['sold_emprunt_usd']
                    .toString(),
      };
    }

    Map data = {
      "trans": transactionData,
      "activity": activityData,
      if (!typePaymentMode.toLowerCase().contains('point'))
        "account": accountData,
      if (typePaymentMode.toLowerCase().contains('point'))
        "points": {"point": neededClientPoints, "client_number": clientID},
      if (typePaymentMode.toLowerCase().contains('caution'))
        "caution": {
          "activity_id": accountActivity['activity_id'].toString().trim(),
          "account_id": getProvider(listen: false).accountData['id'].toString(),
          "amount": num.parse(_montantCtrller.text.trim()),
          "type_operation": "Consommation",
          "external_clients_id": clientID
        }
    };
    // print(transactionData);
    // return;
    // return print(data);
    // return print(widget
    //     .activityData);
    getProvider(listen: false).envoiVirtuel3check(
        body: data,
        callback: () async {
          for (int i = 0; i < inputsController.length; i++) {
            inputsController[i].text = "";
          }

          _montantCtrller.text = "";
          _clientNumberCtrller.text = "";
        });
    await getProvider(listen: false).getAccountActivities();
  }
}
