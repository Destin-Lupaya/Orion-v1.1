import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/empty_model.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/account_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Guichet/caisse_activity.dart';
import 'package:orion/Admin_Orion/Views/Guichet/update_caisse.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Reports/transaction_report.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/titlebar.widget.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class CaissePage extends StatelessWidget {
  const CaissePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<adminAppStateProvider>(
        builder: (context, appStateProvider, _) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.kGreenColor,
          onPressed: () {
            Dialogs.showModal(
                title: 'Caisses',
                content: const CreateCaissePage(updatingData: false));
          },
          child: Icon(Icons.add, color: AppColors.kWhiteColor),
        ),
        body: ModalProgress(
          isAsync: appStateProvider.isAsync,
          progressColor: AppColors.kYellowColor,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
            }),
            child: SingleChildScrollView(
              controller: ScrollController(),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleBarWidget(
                      searchCtrller: TextEditingController(),
                      title: 'Caisses',
                      callback: () {
                        Provider.of<AdminCaisseStateProvider>(context,
                                listen: false)
                            .getAccount();
                      }),
                  const DisplayCaissePage()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CreateCaissePage extends StatefulWidget {
  final bool updatingData;

  final CaisseModel? creationActiviteModel;

  const CreateCaissePage(
      {Key? key, required this.updatingData, this.creationActiviteModel})
      : super(key: key);

  @override
  _CreateCaissePageState createState() => _CreateCaissePageState();
}

List<String> typeactiviteList = ["Mobile Money", "Autres"];
late String typeactiviteMode = "Mobile Money";

String? nomFournisseur;
String? membreInterne;

String? id_caissier;
String? branch_id;

class _CreateCaissePageState extends State<CreateCaissePage> {
  final PageController _controller = PageController();
  String? sousCompteId;

  final TextEditingController _caissierCtrller = TextEditingController();
  final TextEditingController _branchCtrller = TextEditingController();
  final TextEditingController _soldecashCDFCtrller = TextEditingController();
  final TextEditingController _soldecashUSDCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _caissierCtrller.text = widget.creationActiviteModel!.caissier.trim();
      _soldecashCDFCtrller.text =
          widget.creationActiviteModel!.solde_cash_CDF.toString().trim();
      _soldecashUSDCtrller.text =
          widget.creationActiviteModel!.solde_cash_USD.toString().trim();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() {
    Provider.of<AdminCaisseStateProvider>(navKey.currentContext!, listen: false)
        .getAccount();
    Provider.of<AdminUserStateProvider>(context, listen: false)
        .getActivitiesData(isRefresh: true);
    Provider.of<AdminCaisseStateProvider>(context, listen: false)
        .getBranches(isRefresh: true);
    Provider.of<AdminUserStateProvider>(context, listen: false)
        .getUsersData(isRefreshed: true);
  }

  int nbrCaisse = 1;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        backColor: AppColors.kBlackLightColor,
        title: 'Creation Caisse',
        content: Wrap(
          children: [
            Row(children: [
              Expanded(
                child: SearchableTextFormFieldWidget(
                  hintText: 'Branche',
                  textColor: AppColors.kWhiteColor,
                  backColor: AppColors.kTextFormWhiteColor,
                  overlayColor: AppColors.kBlackColor,
                  editCtrller: _branchCtrller,
                  maxLines: 1,
                  callback: (value) {
                    branch_id = value.toString();
                    setState(() {});
                  },
                  data: Provider.of<AdminCaisseStateProvider>(context,
                              listen: false)
                          .branches
                          .isNotEmpty
                      ? Provider.of<AdminCaisseStateProvider>(context,
                              listen: false)
                          .branches
                          .map((branch) => branch)
                          .toSet()
                          .toList()
                      : [],
                  displayColumn: "name",
                  indexColumn: "id",
                  secondDisplayColumn: "location",
                ),
              ),
              Expanded(
                child: SearchableTextFormFieldWidget(
                  hintText: 'Caissier',
                  textColor: AppColors.kWhiteColor,
                  backColor: AppColors.kTextFormWhiteColor,
                  overlayColor: AppColors.kBlackColor,
                  editCtrller: _caissierCtrller,
                  maxLines: 1,
                  errorText: "Aucun caissier sans compte disponible",
                  callback: (value) {
                    id_caissier = value.toString();
                    setState(() {});
                  },
                  data: Provider.of<AdminUserStateProvider>(context,
                              listen: false)
                          .clients
                          .isNotEmpty
                      ? Provider.of<AdminUserStateProvider>(context,
                              listen: false)
                          .clients
                          .where((client) =>
                              !Provider.of<AdminCaisseStateProvider>(context,
                                      listen: false)
                                  .caisseData
                                  .map((caisse) => caisse.caissier.toString())
                                  .toList()
                                  .contains(client.id!.toString()) &&
                              !client.role.toLowerCase().contains('admin'))
                          .map((user) => user.toJson())
                          .toSet()
                          .toList()
                      : [],
                  displayColumn: "names",
                  indexColumn: "id",
                  secondDisplayColumn: "telephone",
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    maxLines: 1,
                    hintText: 'Solde Cash USD',
                    editCtrller: _soldecashUSDCtrller,
                    textColor: AppColors.kWhiteColor,
                    backColor: AppColors.kTextFormWhiteColor,
                  ),
                ),
                Expanded(
                  child: TextFormFieldWidget(
                    maxLines: 1,
                    hintText: 'Solde Cash CDF',
                    editCtrller: _soldecashCDFCtrller,
                    textColor: AppColors.kWhiteColor,
                    backColor: AppColors.kTextFormWhiteColor,
                  ),
                ),
              ],
            ),
            Row(children: [
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgets.text500(
                          title: "Nombre d'activité",
                          fontSize: 14,
                          textColor: AppColors.kWhiteColor),
                      const SizedBox(height: 10),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              if (nbrCaisse > 1) {
                                nbrCaisse--;
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.remove_circle_outline,
                                color: AppColors.kWhiteColor)),
                        const SizedBox(width: 10),
                        TextWidgets.text500(
                            title: "$nbrCaisse",
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor),
                        const SizedBox(width: 10),
                        IconButton(
                            onPressed: () {
                              if (nbrCaisse <
                                  Provider.of<AdminUserStateProvider>(context,
                                          listen: false)
                                      .activitiesdata
                                      .length) {
                                nbrCaisse++;
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.add_circle_outline,
                                color: AppColors.kWhiteColor))
                      ])
                    ]),
              ),
              Expanded(child: Container())
            ]),
            TextWidgets.textBold(
                title: "Activités",
                fontSize: 14,
                textColor: AppColors.kWhiteColor),
            Row(),
            Consumer<AdminCaisseStateProvider>(
                builder: (context, adminCaisseProvider, _) {
              return Wrap(
                  children: List.generate(
                      adminCaisseProvider.caisseActivity.length,
                      (index) => Container(
                            color: Colors.white.withOpacity(0.1),
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            width: Responsive.isMobile(context)
                                ? double.maxFinite
                                : MediaQuery.of(context).size.width / 3,
                            child: ListTile(
                              title: TextWidgets.textBold(
                                  title: adminCaisseProvider
                                      .caisseActivity[index]['name']
                                      .toString(),
                                  fontSize: 14,
                                  textColor: AppColors.kWhiteColor),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidgets.textNormal(
                                        title:
                                            "USD : ${adminCaisseProvider.caisseActivity[index]['virtual_usd'].toString()}",
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor),
                                    TextWidgets.textNormal(
                                        title:
                                            "CDF : ${adminCaisseProvider.caisseActivity[index]['virtual_cdf'].toString()}",
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor)
                                  ]),
                              trailing: IconButton(
                                  onPressed: () {
                                    adminCaisseProvider.caisseActivity.remove(
                                        adminCaisseProvider
                                            .caisseActivity[index]);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      color: Colors.grey)),
                            ),
                          )));
            }),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    canSync: false,
                    text: 'Ajouter les activites',
                    backColor: AppColors.kGreenColor,
                    textColor: AppColors.kWhiteColor,
                    callback: () {
                      // Provider.of<AdminCaisseStateProvider>(
                      //     context, listen: false)
                      //     .clearCaisseActivity();
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => Center(
                                  child: AddCaisseActivityPage(
                                nbrCaisse: nbrCaisse,
                                caissier: id_caissier,
                                updatingData: false,
                                activitiesList: Provider.of<
                                            AdminUserStateProvider>(
                                        context,
                                        listen: false)
                                    .activitiesdata
                                    .where((activity) =>
                                        !Provider.of<AdminCaisseStateProvider>(
                                                context,
                                                listen: false)
                                            .caisseActivity
                                            .map((accountActivity) =>
                                                accountActivity['activity_id']
                                                    .toString())
                                            .toList()
                                            .contains(activity.id!.toString()))
                                    .toSet()
                                    .toList()
                                    .map((activity) => activity.toJson())
                                    .toList(),
                              )));
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<AdminCaisseStateProvider>(
                      builder: (context, caisseProvider, _) {
                    return CustomButton(
                      canSync: true,
                      text: 'Enregistrer',
                      backColor: AppColors.kYellowColor,
                      textColor: AppColors.kWhiteColor,
                      callback: () {
                        if (double.tryParse(_soldecashCDFCtrller.text.trim()) ==
                                null ||
                            double.tryParse(_soldecashUSDCtrller.text.trim()) ==
                                null) {
                          return Message.showToast(
                              msg: "Les montants saisis ne sont pas valides");
                        }
                        if (id_caissier == null) {
                          return Message.showToast(
                              msg: "Veuillez choisir un caissier");
                        }
                        if (branch_id == null) {
                          Message.showToast(
                              msg: "Veuillez choisir une branche");
                          return;
                        }
                        Map data = {
                          "users_id": id_caissier!.trim(),
                          "sold_cash_cdf": _soldecashCDFCtrller.text.trim(),
                          "sold_cash_usd": _soldecashUSDCtrller.text.trim(),
                          "statusActive": "1",
                          "branch_id": branch_id,
                          "created_users_id": "1",
                        };

                        // return print(data);

                        caisseProvider.addcaisse(
                            context: context,
                            caisseModel: CaisseModel.fromJson(data),
                            updatingData: widget.updatingData,
                            callback: () {
                              _soldecashCDFCtrller.text = "";
                              _soldecashUSDCtrller.text = "";
                              id_caissier = null;
                              _caissierCtrller.text = "";
                              branch_id = null;
                              _branchCtrller.text = "";
                            });
                      },
                    );
                  }),
                ),
              ],
            ),
          ],
        ));
  }
}

class DisplayCaissePage extends StatefulWidget {
  const DisplayCaissePage({Key? key}) : super(key: key);

  @override
  State<DisplayCaissePage> createState() => _DisplayCaissePageState();
}

class _DisplayCaissePageState extends State<DisplayCaissePage> {
  bool isViewingMore = false;
  int activeAccount = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminCaisseStateProvider>(
      builder: (context, caisseProvider, child) {
        return caisseProvider.caisseData.isNotEmpty &&
                caisseProvider.branches.isNotEmpty
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CustomButton(
                        text: 'Rapport des caisses',
                        backColor: AppColors.kRedColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => const Center(
                                  child: TransactionsReportPage()));
                        },
                      )),
                      Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    Provider.of<AdminCaisseStateProvider>(
                                            navKey.currentContext!,
                                            listen: false)
                                        .getAccount();
                                    Provider.of<AdminUserStateProvider>(context,
                                            listen: false)
                                        .getActivitiesData(isRefresh: true);
                                    Provider.of<AdminCaisseStateProvider>(
                                            context,
                                            listen: false)
                                        .getBranches(isRefresh: true);
                                    Provider.of<AdminUserStateProvider>(context,
                                            listen: false)
                                        .getUsersData(isRefreshed: false);
                                  },
                                  icon: Icon(Icons.autorenew,
                                      color: AppColors.kBlackLightColor)))),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: caisseProvider.caisseData.length,
                        itemBuilder: (context, int index) {
                          // return ListItem(data:caisseProvider.caisseData[index].toJson());
                          return GestureDetector(
                            // onTap: null,
                            onTap: () {
                              activeAccount =
                                  caisseProvider.caisseData[index].id! ==
                                          activeAccount
                                      ? 0
                                      : caisseProvider.caisseData[index].id!;
                              setState(() {
                                isViewingMore =
                                    caisseProvider.caisseData[index].id ==
                                        activeAccount;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: borderColor),
                                  color: AppColors.kTextFormBackColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Card(
                                      color: AppColors.kWhiteColor
                                          .withOpacity(0.2),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Icon(
                                              Icons
                                                  .account_balance_wallet_rounded,
                                              color: AppColors.kBlackColor,
                                              size: 30)),
                                    ),
                                    title: TextWidgets.textBold(
                                        overflow: TextOverflow.ellipsis,
                                        title: caisseProvider
                                            .caisseData[index].caissierName
                                            .toString()
                                            .toUpperCase(),
                                        fontSize: 14,
                                        textColor: AppColors.kBlackColor),
                                    subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          TextWidgets.text300(
                                              overflow: TextOverflow.ellipsis,
                                              title: caisseProvider.branches
                                                  .where((branch) =>
                                                      branch['id'].toString() ==
                                                      caisseProvider
                                                          .caisseData[index]
                                                          .branch_id
                                                          .toString()
                                                          .trim())
                                                  .toList()[0]['name']
                                                  .toString(),
                                              fontSize: 12,
                                              textColor: AppColors.kGreyColor),
                                          const SizedBox(height: 8),
                                          Visibility(
                                              visible: caisseProvider
                                                      .caisseData[index].id ==
                                                  activeAccount,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await Provider.of<
                                                                          AdminCaisseStateProvider>(
                                                                      navKey
                                                                          .currentContext!,
                                                                      listen:
                                                                          false)
                                                                  .getAccountActivities(
                                                                      accountID: caisseProvider
                                                                          .caisseData[
                                                                              index]
                                                                          .id!
                                                                          .toString()
                                                                          .trim());
                                                              showCupertinoModalPopup(
                                                                  context:
                                                                      context,
                                                                  builder: (context) =>
                                                                      Center(
                                                                          child:
                                                                              UpdateCaissePage(
                                                                        caisseData:
                                                                            caisseProvider.caisseData[index],
                                                                        updatingData:
                                                                            true,
                                                                      )));
                                                            },
                                                            child: Card(
                                                                color: AppColors
                                                                    .kBlackColor
                                                                    .withOpacity(
                                                                        0.1),
                                                                child: Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4),
                                                                    child: TextWidgets.text300(
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        title:
                                                                            'Modifier la caisse',
                                                                        fontSize:
                                                                            12,
                                                                        textColor:
                                                                            AppColors.kGreyColor))),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Wrap(
                                                        // mainAxisAlignment: MainAxisAlignment
                                                        //     .spaceBetween,
                                                        runAlignment:
                                                            WrapAlignment.start,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                        runSpacing: 8,
                                                        spacing: 8,
                                                        children: [
                                                          TextWidgets.textWithLabel(
                                                              title: 'Cash USD',
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kBlackColor,
                                                              value: caisseProvider
                                                                  .caisseData[
                                                                      index]
                                                                  .solde_cash_USD
                                                                  .toString()),
                                                          TextWidgets.textWithLabel(
                                                              title: 'Cash CDF',
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kBlackColor,
                                                              value: caisseProvider
                                                                  .caisseData[
                                                                      index]
                                                                  .solde_cash_CDF
                                                                  .toString()),
                                                          TextWidgets.textWithLabel(
                                                              title: 'Pret USD',
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kBlackColor,
                                                              value: caisseProvider
                                                                  .caisseData[
                                                                      index]
                                                                  .solde_pret_usd
                                                                  .toString()),
                                                          TextWidgets.textWithLabel(
                                                              title: 'Pret CDF',
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kBlackColor,
                                                              value: caisseProvider
                                                                  .caisseData[
                                                                      index]
                                                                  .solde_pret_cdf
                                                                  .toString()),
                                                          TextWidgets.textWithLabel(
                                                              title:
                                                                  'Emprunt USD',
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kBlackColor,
                                                              value: caisseProvider
                                                                  .caisseData[
                                                                      index]
                                                                  .solde_emprunt_usd
                                                                  .toString()),
                                                          TextWidgets.textWithLabel(
                                                              title:
                                                                  'Emprunt CDF',
                                                              fontSize: 14,
                                                              textColor: AppColors
                                                                  .kBlackColor,
                                                              value: caisseProvider
                                                                  .caisseData[
                                                                      index]
                                                                  .solde_emprunt_cdf
                                                                  .toString()),
                                                        ]),
                                                  ]))
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              )
            : Column(children: [
                EmptyModel(color: AppColors.kGreyColor),
                Container(
                  width: 200,
                  child: CustomButton(
                      text: "Actualiser",
                      backColor: Colors.grey[200]!,
                      textColor: AppColors.kBlackColor,
                      callback: () {
                        Provider.of<AdminCaisseStateProvider>(
                                navKey.currentContext!,
                                listen: false)
                            .getAccount();
                        Provider.of<AdminUserStateProvider>(context,
                                listen: false)
                            .getActivitiesData(isRefresh: true);
                        Provider.of<AdminCaisseStateProvider>(context,
                                listen: false)
                            .getBranches(isRefresh: true);
                        Provider.of<AdminUserStateProvider>(context,
                                listen: false)
                            .getUsersData(isRefreshed: false);
                      }),
                ),
              ]);
      },
    );
  }
}
