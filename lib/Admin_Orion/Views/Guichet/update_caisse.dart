import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/account_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Guichet/caisse_activity.dart';
import 'package:provider/provider.dart';

class UpdateCaissePage extends StatefulWidget {
  final bool updatingData;

  final CaisseModel caisseData;
  const UpdateCaissePage(
      {Key? key, required this.updatingData, required this.caisseData})
      : super(key: key);

  @override
  _UpdateCaissePageState createState() => _UpdateCaissePageState();
}

List<String> typeactiviteList = ["Mobile Money", "Autres"];
late String typeactiviteMode = "Mobile Money";

String? nomFournisseur;
String? membreInterne;

String? nomMembre;

class _UpdateCaissePageState extends State<UpdateCaissePage> {
  final PageController _controller = PageController();
  String? sousCompteId;
  final TextEditingController _activiteCtrller = TextEditingController();
  final TextEditingController _nomcaissierCtrller = TextEditingController();
  final TextEditingController _soldeVUSDCtrller = TextEditingController();

  final TextEditingController _soldeVCDFCtrller = TextEditingController();
  final TextEditingController _soldeCaCDFCtrller = TextEditingController();
  final TextEditingController _soldeCaUSDCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _soldeCaCDFCtrller.text =
          widget.caisseData.solde_cash_CDF.toString().trim();
      _soldeCaUSDCtrller.text =
          widget.caisseData.solde_cash_USD.toString().trim();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // Provider.of<UserStateProvider>(context, listen: false)
      //     .getactivities(context: context, isRefreshed: false);
      Provider.of<AdminCaisseStateProvider>(context, listen: false)
          .clearCaisseActivity();
      setState(() {});
      dbActivities.clear();
      givenActivities.clear();
      remainActivities.clear();
      newActivities.clear();
      dbActivities = Provider.of<AdminUserStateProvider>(context, listen: false)
          .activitiesdata
          .map((activity) => activity.toJson())
          .toList();
      givenActivities = widget.caisseData.activities;
      for (int i = 0; i < dbActivities.length; i++) {
        for (int j = 0; j < givenActivities.length; j++) {
          if (givenActivities[j]['activity_id'].toString() !=
              dbActivities[i]['id'].toString()) {
            remainActivities.add(dbActivities[i]);
          }
        }
      }
    });
  }

  List dbActivities = [],
      givenActivities = [],
      remainActivities = [],
      newActivities = [];
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height * .85,
        // color: AppColors.kBlackLightColor,
        child: Consumer<adminAppStateProvider>(
            builder: (context, appStateProvider, _) {
          return ModalProgress(
            isAsync: appStateProvider.isAsync,
            progressColor: AppColors.kYellowColor,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
              }),
              child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: 'Ajouter des activites a la caisse',
                      content: Wrap(children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormFieldWidget(
                                isEnabled: false,
                                maxLines: 1,
                                hintText: 'Solde Cash USD',
                                editCtrller: _soldeCaUSDCtrller,
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                            Expanded(
                              child: TextFormFieldWidget(
                                isEnabled: false,
                                maxLines: 1,
                                hintText: 'Solde Cash CDF',
                                editCtrller: _soldeCaCDFCtrller,
                                textColor: AppColors.kWhiteColor,
                                backColor: AppColors.kTextFormWhiteColor,
                              ),
                            ),
                          ],
                        ),
                        Card(
                          color: Colors.white12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidgets.textBold(
                                      title: "Activites",
                                      fontSize: 14,
                                      textColor: AppColors.kWhiteColor),
                                  IconButton(
                                      onPressed: () {
                                        if (remainActivities.isEmpty) {
                                          Message.showToast(
                                              msg:
                                                  "Aucune activité disponible");
                                          return;
                                        }
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) => Center(
                                                    child:
                                                        AddCaisseActivityPage(
                                                  activitiesList:
                                                      remainActivities,
                                                  caissier: widget
                                                      .caisseData.caissier
                                                      .trim(),
                                                  nbrCaisse: 1,
                                                  updatingData: false,
                                                )));
                                      },
                                      icon: Icon(
                                          Icons.add_circle_outline_rounded,
                                          color: AppColors.kWhiteColor))
                                ]),
                          ),
                        ),
                        Wrap(
                          children: List.generate(
                              widget.caisseData.activities.length,
                              (index) => Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidgets.textBold(
                                            title: widget.caisseData
                                                .activities[index]['name']
                                                .toString()
                                                .trim(),
                                            fontSize: 12,
                                            textColor: AppColors.kWhiteColor),
                                        TextWidgets.text300(
                                            title:
                                                "CDF ${widget.caisseData.activities[index]['virtual_cdf'].toString().trim()}",
                                            fontSize: 12,
                                            textColor: AppColors.kWhiteColor),
                                        TextWidgets.text300(
                                            title:
                                                "USD ${widget.caisseData.activities[index]['virtual_usd'].toString().trim()}",
                                            fontSize: 12,
                                            textColor: AppColors.kWhiteColor),
                                        TextWidgets.text300(
                                            title:
                                                "Stock: ${widget.caisseData.activities[index]['stock'].toString().trim()}",
                                            fontSize: 12,
                                            textColor: AppColors.kWhiteColor),
                                      ]))),
                        ),
                        Card(
                          color: Colors.white12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidgets.textBold(
                                      title: "Nouvelles activites",
                                      fontSize: 14,
                                      textColor: AppColors.kWhiteColor),
                                ]),
                          ),
                        ),
                        Consumer<AdminCaisseStateProvider>(
                            builder: (context, adminCaisseProvider, _) {
                          return Column(
                              children: List.generate(
                                  adminCaisseProvider.caisseActivity.length,
                                  (index) => ListTile(
                                        title: TextWidgets.textBold(
                                            title: adminCaisseProvider
                                                .caisseActivity[index]['name']
                                                .toString(),
                                            fontSize: 14,
                                            textColor: AppColors.kWhiteColor),
                                        subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextWidgets.text300(
                                                  title:
                                                      "USD : ${adminCaisseProvider.caisseActivity[index]['virtual_usd'].toString()}",
                                                  fontSize: 14,
                                                  textColor:
                                                      AppColors.kWhiteColor),
                                              TextWidgets.text300(
                                                  title:
                                                      "CDF : ${adminCaisseProvider.caisseActivity[index]['virtual_cdf'].toString()}",
                                                  fontSize: 14,
                                                  textColor:
                                                      AppColors.kWhiteColor)
                                            ]),
                                      )));
                        }),
                        Consumer<AdminCaisseStateProvider>(
                            builder: (context, caisseProvider, _) {
                          return Row(children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Supprimer',
                                backColor: AppColors.kRedColor,
                                textColor: AppColors.kWhiteColor,
                                callback: () {},
                              ),
                            ),
                            Expanded(
                              child: CustomButton(
                                text: 'Suspendre',
                                backColor: AppColors.kRedColor.withOpacity(0.5),
                                textColor: AppColors.kWhiteColor,
                                callback: () {},
                              ),
                            ),
                            Expanded(
                                child: CustomButton(
                              text: 'Modifier',
                              backColor: AppColors.kYellowColor,
                              textColor: AppColors.kWhiteColor,
                              callback: () async {
                                if (caisseProvider.caisseActivity.isEmpty) {
                                  Message.showToast(
                                      msg: 'Aucune activité ajoutée');
                                  return;
                                }
                                await caisseProvider.saveCaisseActivity(
                                  caisseActivity: caisseProvider.caisseActivity,
                                  caisse: widget.caisseData,
                                );
                                Navigator.pop(context);
                                _soldeCaCDFCtrller.text = "";
                                _soldeCaUSDCtrller.text = "";
                              },
                            ))
                          ]);
                        }),
                      ]),

                      //DisplayCaissePage()
                    )
                  ]),
            ),
          );
        }));
  }
}
