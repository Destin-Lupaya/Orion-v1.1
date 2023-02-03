import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/empty_model.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/card_title_subtitle_icon.dart';
import 'package:orion/Resources/Components/custom_network_image.dart';
import 'package:orion/Resources/Components/decorated_container.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Config/User/client.list.page.dart';
import 'package:orion/Views/Guichet/Caution/add_caution.page.dart';
import 'package:orion/Views/Guichet/Cloture/enclose_page.dart';
import 'package:orion/Views/Guichet/Demands/new_demand.dart';
import 'package:orion/Views/Guichet/Historique/historique_transaction.dart';
import 'package:orion/Views/Guichet/Menu Mobile Money/Airtel Money/sorti_airtel_money.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/demande_approvisionnement.dart';
import 'package:orion/Views/Guichet/Menu%20Mobile%20Money/Airtel%20Money/pret_airtel_money.dart';
import 'package:orion/Views/Guichet/Supply/supply_page.dart';
import 'package:orion/Views/Guichet/facture_page.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

import 'accounts_stat_widget.dart';

class GestionAirtelPage extends StatefulWidget {
  Map? accountData;
  Map? activityData;

  GestionAirtelPage({Key? key, this.accountData, this.activityData})
      : super(key: key);

  @override
  _GestionAirtelPageState createState() => _GestionAirtelPageState();
}

class _GestionAirtelPageState extends State<GestionAirtelPage> {
  final ScrollController _controller = ScrollController();
  List<PlatformFile> _pickedFiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // Getting activities with its inputs
      await getTransProvider().getActivities(isRefresh: true);
      Provider.of<AppStateProvider>(context, listen: false)
          .initUI(context: context);
      getTransProvider().getUsers(isRefresh: true);
      getTransProvider().getAccount();
      initData();
      context.read<PointsConfigProvider>().getData(isRefresh: true);
      Provider.of<ClientProvider>(context, listen: false).getData();
    });
  }

  int key = 0;

  initData() async {
    await getTransProvider().getAccountActivities();
    if (getTransProvider().accountActivity.isNotEmpty) {}
  }

  TransactionsStateProvider getTransProvider({bool listen = false}) {
    return Provider.of<TransactionsStateProvider>(context, listen: listen);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuStateProvider>(
        builder: (context, menuStateProvider, child) {
      return Scaffold(
        body: SafeArea(child: Consumer<AppStateProvider>(
          builder: (context, appStateProvider, _) {
            return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: SingleChildScrollView(
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userCard(),
                      if (getTransProvider().accounts.isNotEmpty &&
                          getTransProvider().accountActivity.isNotEmpty &&
                          getTransProvider().targetedActivity.isNotEmpty &&
                          getTransProvider().targetedActivity['inputs'] != null)
                        stepsList(),
                    ],
                  ),
                ),
              ),
            );
          },
        )),
      );
    });
  }

  collapse() {
    key = Random().nextInt(1000000);
    setState(() {});
  }

  displayCashWithActionWidget() {
    return Consumer<TransactionsStateProvider>(
        builder: (context, transactionProvider, _) {
      return CardWithIconTitleSubtitle(
          balance: {
            "virtuel_CDF":
                transactionProvider.accounts[0]['sold_cash_cdf'].toString(),
            "virtuel_USD":
                transactionProvider.accounts[0]['sold_cash_usd'].toString(),
            'stock': '0'
            // "cash_CDF": "CDF: 300",
            // "cash_USD": "USD: 400"
          },
          // width: !Responsive.isMobile(context) ? 350 : double.maxFinite,
          //icon: Icons.attach_money,
          title: "Compte",
          image: Container(
            child: Icon(Icons.attach_money_rounded, size: 80),
          ),
          subtitle: '',
          title2: '',
          title3: '',
          subtitle1: 'Soldes Cash',
          subtitle2: 'Soldes Cash',
          page: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      Provider.of<TransactionsStateProvider>(context,
                              listen: false)
                          .getAccountActivities();
                    },
                    icon: const Icon(Icons.autorenew)),
              ],
            ),
          ),
          backColor: Colors.grey[500]!,
          iconColor: AppColors.kBlackColor,
          titleColor: AppColors.kBlackColor,
          subtitleColor: AppColors.kBlackColor);
    });
  }

  userCard() {
    return Column(
      children: [
        if (Provider.of<TransactionsStateProvider>(navKey.currentContext!,
                    listen: false)
                .accounts
                .isNotEmpty &&
            !Responsive.isWeb(context))
          displayCashWithActionWidget(),
        Row(
          children: [
            if (Provider.of<TransactionsStateProvider>(navKey.currentContext!,
                        listen: false)
                    .accounts
                    .isNotEmpty &&
                Responsive.isWeb(context))
              displayCashWithActionWidget(),
            Expanded(
              child: Provider.of<TransactionsStateProvider>(
                              navKey.currentContext!,
                              listen: false)
                          .accounts
                          .isNotEmpty &&
                      (Provider.of<TransactionsStateProvider>(
                                      navKey.currentContext!,
                                      listen: false)
                                  .accounts[0]['activities'] !=
                              null &&
                          Provider.of<TransactionsStateProvider>(
                                  navKey.currentContext!,
                                  listen: false)
                              .accounts[0]['activities']
                              .isNotEmpty)
                  ? Card(
                      color: AppColors.kBlackColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding / 2)),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Consumer<TransactionsStateProvider>(
                                builder: (context, transactionProvider, _) {
                              return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        transactionProvider
                                            .accounts[0]['activities'].length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              collapse();
                                              await getTransProvider()
                                                  .getActivities(
                                                      isRefresh: true,
                                                      activityID:
                                                          transactionProvider
                                                              .accounts[0]
                                                                  ['activities']
                                                                  [index][
                                                                  'activity_id']
                                                              .toString()
                                                              .trim());
                                              transactionProvider
                                                      .accountActivity =
                                                  transactionProvider
                                                          .accounts[0]
                                                      ['activities'][index];
                                              widget.activityData =
                                                  transactionProvider
                                                          .accounts[0]
                                                      ['activities'][index];
                                              initData();
                                              setState(() {});
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: transactionProvider
                                                                    .accountActivity
                                                                    .isNotEmpty &&
                                                                transactionProvider
                                                                        .accountActivity[
                                                                            'id']
                                                                        .toString() ==
                                                                    transactionProvider
                                                                        .accounts[0]
                                                                            ['activities']
                                                                            [index]
                                                                            [
                                                                            'id']
                                                                        .toString()
                                                            ? AppColors
                                                                .kRedColor
                                                            : AppColors
                                                                .kTransparentColor,
                                                        width: 4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child:
                                                      CardWithIconTitleSubtitle(
                                                          balance: {
                                                        "virtuel_CDF":
                                                            "${transactionProvider.accounts[0]['activities'][index]['virtual_cdf']}",
                                                        "virtuel_USD":
                                                            "${transactionProvider.accounts[0]['activities'][index]['virtual_usd']}",
                                                        "stock":
                                                            "${transactionProvider.accounts[0]['activities'][index]['stock']}",
                                                        // "cash_CDF": "CDF: 300",
                                                        // "cash_USD": "USD: 400"
                                                      },
                                                          // width: !Responsive
                                                          //         .isWeb(
                                                          //             context)
                                                          //     ? 300
                                                          //     : 300,
                                                          //icon: Icons.attach_money,
                                                          title: transactionProvider
                                                              .accounts[0]
                                                                  ['activities']
                                                                  [index]
                                                                  ['name']
                                                              .toString(),
                                                          image:
                                                              CustomNetworkImage(
                                                            src: transactionProvider
                                                                    .accounts[0]
                                                                        [
                                                                        'activities']
                                                                        [index][
                                                                        'avatar']
                                                                    .toString()
                                                                    .trim()
                                                                    .contains(
                                                                        "clientfiles")
                                                                ? "${BaseUrl.ip}${transactionProvider.accounts[0]['activities'][index]['avatar'].toString().trim()}"
                                                                : "",
                                                            size: const Size(
                                                                96, 96),
                                                          ),
                                                          subtitle: '',
                                                          title2: '',
                                                          title3: '',
                                                          subtitle1:
                                                              'Soldes Cash',
                                                          subtitle2:
                                                              'Soldes Virtuel',
                                                          page: Container(),
                                                          backColor: AppColors
                                                              .kBlackColor,
                                                          iconColor: AppColors
                                                              .kGreyColor,
                                                          titleColor: AppColors
                                                              .kWhiteColor,
                                                          subtitleColor:
                                                              AppColors
                                                                  .kWhiteColor),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )));
                            })
                          ],
                        ),
                      ),
                    )
                  : EmptyModel(
                      color: AppColors.kGreyColor,
                      text:
                          "Nous n'avons trouvé aucune activité pour votre compte. Contactez votre administrateur"),
            ),
          ],
        ),
        Row(
          children: [
            TextWidgets.textBold(
                title: 'Actions',
                fontSize: 18,
                textColor: AppColors.kBlackColor),
            const SizedBox(width: 16),
            Expanded(
              child: DecoratedContainer(
                backColor: Colors.grey.shade200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: ScrollController(keepScrollOffset: false),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: CustomButton(
                            canSync: false,
                            text: "Clients externes",
                            backColor: AppColors.kGreenColor,
                            textColor: AppColors.kWhiteColor,
                            isEnabled: true,
                            callback: () {
                              Dialogs.showModal(
                                  title: 'Client', content: ClientList());
                            }),
                      ),
                      Container(
                        width: 150,
                        child: CustomButton(
                            canSync: false,
                            text: "Dépôt caution",
                            backColor: AppColors.kGreenColor,
                            textColor: AppColors.kWhiteColor,
                            isEnabled: true,
                            callback: () {
                              Dialogs.showNormalModal(
                                  content: NewCautionPage());
                            }),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 150,
                        child: CustomButton(
                            canSync: false,
                            text: "Cloturer",
                            backColor: AppColors.kGreenColor,
                            textColor: AppColors.kWhiteColor,
                            callback: () {
                              if (Provider.of<TransactionsStateProvider>(
                                          navKey.currentContext!,
                                          listen: false)
                                      .accounts
                                      .isEmpty &&
                                  (Provider.of<TransactionsStateProvider>(
                                                  navKey.currentContext!,
                                                  listen: false)
                                              .accounts[0]['activities'] !=
                                          null &&
                                      Provider.of<TransactionsStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .accounts[0]['activities']
                                          .isEmpty)) {
                                return;
                              }
                              Dialogs.showNormalModal(
                                  content: Center(
                                      child: EnclosePage(
                                accountData:
                                    Provider.of<TransactionsStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .accounts[0]!,
                                updatingData: false,
                              )));
                            }),
                      ),
                      Container(
                        width: 150,
                        child: CustomButton(
                            canSync: false,
                            text: "Approvisioner",
                            backColor: AppColors.kRedColor,
                            textColor: AppColors.kWhiteColor,
                            isEnabled: Provider.of<UserStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .clientData!
                                        .role
                                        .toString()
                                        .toLowerCase() ==
                                    'caissier'
                                ? false
                                : true,
                            callback: () {
                              if (Provider.of<TransactionsStateProvider>(
                                          navKey.currentContext!,
                                          listen: false)
                                      .accounts
                                      .isEmpty &&
                                  (Provider.of<TransactionsStateProvider>(
                                                  navKey.currentContext!,
                                                  listen: false)
                                              .accounts[0]['activities'] !=
                                          null &&
                                      Provider.of<TransactionsStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .accounts[0]['activities']
                                          .isEmpty)) {
                                return;
                              }
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => Center(
                                          child: SupplyPage(
                                        accountData: Provider.of<
                                                    TransactionsStateProvider>(
                                                navKey.currentContext!,
                                                listen: false)
                                            .accounts[0]!,
                                      )));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  stepsList() {
    return Container(
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isWeb(context))
                  TextWidgets.textBold(
                      title: "Activités",
                      fontSize: 18,
                      textColor: AppColors.kBlackColor,
                      align: TextAlign.center),
                if (Responsive.isWeb(context)) const SizedBox(height: 36),
                // ===============================Transaction============================
                // Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //     decoration: BoxDecoration(
                //         color: AppColors.kBlackColor,
                //         borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
                //     child: Consumer<UserStateProvider>(
                //         builder: (context, userStateProvider, _) {
                //       return ExpansionTile(
                //         key: ValueKey(key),
                //         title: Row(
                //           children: [
                //             // const SizedBox(width: 25),
                //             TextWidgets.textBold(
                //                 title: 'Transaction'.toUpperCase(),
                //                 fontSize: 16,
                //                 textColor: AppColors.kWhiteColor),
                //           ],
                //         ),
                //         children: [
                //           SortiAirtelmoneyPage(
                //             // accountData: Provider
                //             //     .of<TransactionsStateProvider>(
                //             //     navKey.currentContext!,
                //             //     listen: false)
                //             //     .accounts[0]!,
                //             activityData: Provider.of<TransactionsStateProvider>(
                //                     context,
                //                     listen: false)
                //                 .accountActivity,
                //             updatingData: false,
                //           ),
                //         ],
                //       );
                //     })),
                // ===============================Historique de Transaction============================

                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.kBlackColor,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 2)),
                    child: ExpansionTile(
                      key: ValueKey(key),
                      onExpansionChanged: (status) {
                        if (status == true) {
                          Provider.of<TransactionsStateProvider>(
                                  navKey.currentContext!,
                                  listen: false)
                              .getTransactions(
                                  activityID:
                                      Provider.of<TransactionsStateProvider>(
                                              context,
                                              listen: false)
                                          .accountActivity['activity_id']
                                          .toString()
                                          .trim());
                        }
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const SizedBox(width: 20),
                          Expanded(
                            child: TextWidgets.textBold(
                                title: 'TRANSACTION',
                                fontSize: 16,
                                textColor: AppColors.kWhiteColor),
                          ),
                          IconButton(
                              onPressed: () async {
                                if (Provider.of<UserStateProvider>(
                                                navKey.currentContext!,
                                                listen: false)
                                            .clientData!
                                            .role
                                            .toString()
                                            .toLowerCase() !=
                                        'caissier' &&
                                    !Provider.of<UserStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .clientData!
                                        .role
                                        .toString()
                                        .toLowerCase()
                                        .contains('agreg')) {
                                  Message.showToast(
                                      msg:
                                          "Vous n'avez les permissions d'effectuer cette opération");
                                  return;
                                }
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) => Center(
                                            child: SortiAirtelmoneyPage(
                                          // accountData: Provider
                                          //     .of<TransactionsStateProvider>(
                                          //     navKey.currentContext!,
                                          //     listen: false)
                                          //     .accounts[0]!,
                                          activityData: Provider.of<
                                                      TransactionsStateProvider>(
                                                  context,
                                                  listen: false)
                                              .accountActivity,
                                          updatingData: false,
                                        )));
                              },
                              icon: Icon(Icons.add_circle_outline_outlined,
                                  color: AppColors.kWhiteColor)),
                          IconButton(
                              onPressed: Provider.of<TransactionsStateProvider>(
                                          context)
                                      .accountActivity
                                      .isEmpty
                                  ? null
                                  : () {
                                      collapse();
                                      Provider.of<TransactionsStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .getTransactions(
                                              isRefresh: true,
                                              activityID: Provider.of<
                                                          TransactionsStateProvider>(
                                                      context,
                                                      listen: false)
                                                  .accountActivity[
                                                      'activity_id']
                                                  .toString());
                                    },
                              icon: Icon(Icons.replay_outlined,
                                  color: AppColors.kWhiteColor))
                        ],
                      ),
                      children: [
                        HistortransList(
                          accountData: Provider.of<TransactionsStateProvider>(
                                  navKey.currentContext!,
                                  listen: false)
                              .accounts[0]!,
                          activityData: Provider.of<TransactionsStateProvider>(
                                  context,
                                  listen: false)
                              .accountActivity,
                          isFullHistory: false,
                        )
                      ],
                    )),

                // ===============================Demande============================
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.kBlackColor,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 2)),
                    child: Consumer<UserStateProvider>(
                        builder: (context, userStateProvider, _) {
                      return ExpansionTile(
                        key: ValueKey(key),
                        onExpansionChanged: (status) {
                          if (status == true) {
                            Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .getDemands();
                          }
                        },
                        title: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextWidgets.textBold(
                                  title: 'DEMANDE',
                                  fontSize: 16,
                                  textColor: AppColors.kWhiteColor),
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (Provider.of<UserStateProvider>(
                                                  navKey.currentContext!,
                                                  listen: false)
                                              .clientData!
                                              .role
                                              .toString()
                                              .toLowerCase() !=
                                          'caissier' &&
                                      !Provider.of<UserStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .clientData!
                                          .role
                                          .toString()
                                          .toLowerCase()
                                          .contains('agreg')) {
                                    Message.showToast(
                                        msg:
                                            "Vous n'avez les permissions d'effectuer cette opération");
                                    return;
                                  }
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => Center(
                                              child: DemandPage(
                                            accountData: Provider.of<
                                                        TransactionsStateProvider>(
                                                    navKey.currentContext!,
                                                    listen: false)
                                                .accounts[0]!,
                                            activityData: Provider.of<
                                                        TransactionsStateProvider>(
                                                    context,
                                                    listen: false)
                                                .accountActivity,
                                            updatingData: false,
                                          )));
                                },
                                icon: Icon(Icons.add_circle_outline_outlined,
                                    color: AppColors.kWhiteColor)),
                            IconButton(
                                onPressed:
                                    Provider.of<TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .accountActivity
                                            .isEmpty
                                        ? null
                                        : () {
                                            collapse();
                                            Provider.of<TransactionsStateProvider>(
                                                    navKey.currentContext!,
                                                    listen: false)
                                                .getDemands(isRefresh: true);
                                          },
                                icon: Icon(Icons.replay_outlined,
                                    color: AppColors.kWhiteColor))
                          ],
                        ),
                        children: [
                          DemandeApprovList(
                            accountData: Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .accounts[0]!,
                            activityData:
                                Provider.of<TransactionsStateProvider>(context,
                                        listen: false)
                                    .accountActivity,
                            updatingData: false,
                          )
                        ],
                      );
                    })),

                // =============================== Facture ============================
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.kBlackColor,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 2)),
                    child: Consumer<UserStateProvider>(
                        builder: (context, userStateProvider, _) {
                      return ExpansionTile(
                        key: ValueKey(key),
                        onExpansionChanged: (status) {
                          if (status == true) {
                            Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .getFactures(
                                    activityID:
                                        Provider.of<TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .accountActivity['activity_id']
                                            .toString()
                                            .trim());
                          }
                        },
                        title: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextWidgets.textBold(
                                  title: 'Facture'.toUpperCase(),
                                  fontSize: 16,
                                  textColor: AppColors.kWhiteColor),
                            ),
                            IconButton(
                                onPressed: () async {
                                  if (Provider.of<UserStateProvider>(
                                                  navKey.currentContext!,
                                                  listen: false)
                                              .clientData!
                                              .role
                                              .toString()
                                              .toLowerCase() !=
                                          'caissier' &&
                                      !Provider.of<UserStateProvider>(
                                              navKey.currentContext!,
                                              listen: false)
                                          .clientData!
                                          .role
                                          .toString()
                                          .toLowerCase()
                                          .contains('agreg')) {
                                    Message.showToast(
                                        msg:
                                            "Vous n'avez les permissions d'effectuer cette opération");
                                    return;
                                  }
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => Center(
                                              child: MakeBillPage(
                                            accountData: Provider.of<
                                                        TransactionsStateProvider>(
                                                    navKey.currentContext!,
                                                    listen: false)
                                                .accountData,
                                            activityData: Provider.of<
                                                        TransactionsStateProvider>(
                                                    context,
                                                    listen: false)
                                                .accountActivity,
                                            updatingData: false,
                                          )));
                                },
                                icon: Icon(Icons.add_circle_outline_outlined,
                                    color: AppColors.kWhiteColor)),
                            IconButton(
                                onPressed:
                                    Provider.of<TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .accountActivity
                                            .isEmpty
                                        ? null
                                        : () {
                                            collapse();
                                            Provider.of<TransactionsStateProvider>(
                                                    navKey.currentContext!,
                                                    listen: false)
                                                .getFactures(
                                                    isRefresh: true,
                                                    activityID: Provider.of<
                                                                TransactionsStateProvider>(
                                                            context,
                                                            listen: false)
                                                        .accountActivity[
                                                            'activity_id']
                                                        .toString());
                                          },
                                icon: Icon(Icons.replay_outlined,
                                    color: AppColors.kWhiteColor))
                          ],
                        ),
                        children: [
                          BillsList(
                            accountData: Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .accounts[0]!,
                            activityData:
                                Provider.of<TransactionsStateProvider>(context,
                                        listen: false)
                                    .accountActivity,
                            updatingData: false,
                          )
                        ],
                      );
                    })),

                //============Pret=============
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.kBlackColor,
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 2)),
                    child: Consumer<UserStateProvider>(
                        builder: (context, userStateProvider, _) {
                      return ExpansionTile(
                        key: ValueKey(key),
                        onExpansionChanged: (status) {
                          if (status == true) {
                            Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .getTransactions(
                                    isRefresh: false,
                                    activityID:
                                        Provider.of<TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .accountActivity['activity_id']
                                            .toString()
                                            .trim());
                          }
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidgets.textBold(
                                title: 'PRET ET EMPRUNT',
                                fontSize: 16,
                                textColor: AppColors.kWhiteColor),
                            IconButton(
                                onPressed:
                                    Provider.of<TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .accountActivity
                                            .isEmpty
                                        ? null
                                        : () {
                                            collapse();
                                            Provider.of<TransactionsStateProvider>(
                                                    navKey.currentContext!,
                                                    listen: false)
                                                .getTransactions(
                                                    activityID: widget
                                                        .activityData![
                                                            'activity_id']
                                                        .toString(),
                                                    isRefresh: true);
                                          },
                                icon: Icon(Icons.replay_outlined,
                                    color: AppColors.kWhiteColor))
                          ],
                        ),
                        children: [
                          PretListPage(
                            accountData: Provider.of<TransactionsStateProvider>(
                                    navKey.currentContext!,
                                    listen: false)
                                .accounts[0]!,
                            activityData:
                                Provider.of<TransactionsStateProvider>(context,
                                        listen: false)
                                    .accountActivity,
                          )
                        ],
                      );
                    })),
                if (!Responsive.isWeb(context))
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColors.kBlackColor,
                          borderRadius:
                              BorderRadius.circular(kDefaultPadding / 2)),
                      child: Consumer<UserStateProvider>(
                          builder: (context, userStateProvider, _) {
                        return ExpansionTile(
                          key: ValueKey(key),
                          title: Row(
                            children: [
                              TextWidgets.textBold(
                                  title: 'Mon compte'.toUpperCase(),
                                  fontSize: 16,
                                  textColor: AppColors.kWhiteColor),
                            ],
                          ),
                          children: const [
                            AccountStatWidget(),
                          ],
                        );
                      })),
              ],
            ),
          ),
          if (Responsive.isWeb(context))
            const Flexible(fit: FlexFit.loose, child: AccountStatWidget())
        ],
      ),
    );
  }
}
