import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/modal_progress.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/provider.dart';

class AddCaisseActivityPage extends StatefulWidget {
  final bool updatingData;
  final int nbrCaisse;
  final List? activitiesList;
  final String? caissier;

  AddCaisseActivityPage(
      {Key? key,
      required this.updatingData,
      required this.nbrCaisse,
      this.activitiesList,
      this.caissier})
      : super(key: key);

  @override
  State<AddCaisseActivityPage> createState() => _AddCaisseActivityPageState();
}

class _AddCaisseActivityPageState extends State<AddCaisseActivityPage> {
  int currStep = 0;
  List<CreateCaisseActivityPage> caisseScreen = [];
  List caisseActivite = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.nbrCaisse; i++) {
      caisseScreen.add(CreateCaisseActivityPage(
        activities: widget.activitiesList?.toSet().toList(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kTransparentColor,
      child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height * .85,
          // color: AppColors.kBlackLightColor,
          child: Consumer<AppStateProvider>(
              builder: (context, appStateProvider, child) {
            return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                }),
                child: ListView(
                  // shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    CardWidget(
                        backColor: AppColors.kBlackLightColor,
                        title: 'Ajouter les activités',
                        content: Column(
                          children: [
                            Stepper(
                                physics: const NeverScrollableScrollPhysics(),
                                controlsBuilder: _createEventControlBuilder,
                                currentStep: currStep,
                                onStepCancel: () {
                                  if (currStep > 0) {
                                    currStep--;
                                    setState(() {});
                                  }
                                },
                                onStepContinue: () {
                                  if ((double.tryParse(caisseScreen[currStep]
                                                  .virtualUSDCtrller
                                                  .text
                                                  .trim()) ==
                                              null ||
                                          double.tryParse(caisseScreen[currStep]
                                                  .virtualCDFCtrller
                                                  .text
                                                  .trim()) ==
                                              null) &&
                                      double.tryParse(caisseScreen[currStep]
                                              .stockCtrller
                                              .text
                                              .trim()) ==
                                          null) {
                                    Message.showToast(
                                        msg:
                                            'Le stock ou le montant CDF ou USD saisi n\'est pas valide');
                                    return;
                                  }

                                  if (widget.caissier != null &&
                                      Provider.of<AdminUserStateProvider>(
                                                  context,
                                                  listen: false)
                                              .clients
                                              .where((client) =>
                                                  client.id!.toString() ==
                                                  widget.caissier!.toString())
                                              .toList()[0]
                                              .role
                                              .toString()
                                              .toLowerCase() ==
                                          'comptable') {
                                    if ((double.parse(caisseScreen[currStep]
                                                    .virtualUSDCtrller
                                                    .text
                                                    .trim()) ==
                                                0 ||
                                            double.parse(caisseScreen[currStep]
                                                    .virtualCDFCtrller
                                                    .text
                                                    .trim()) ==
                                                0) &&
                                        double.parse(caisseScreen[currStep]
                                                .stockCtrller
                                                .text
                                                .trim()) ==
                                            0) {
                                      Message.showToast(
                                          msg:
                                              'Le comtable ne doit pas avoir des soldes nulls');
                                      return;
                                    }
                                  }
                                  Map activiteData = {
                                    "activity_id":
                                        caisseScreen[currStep].id_activite,
                                    "name": caisseScreen[currStep]
                                        .activiteCtrller
                                        .text
                                        .trim(),
                                    "virtual_usd": double.tryParse(
                                            caisseScreen[currStep]
                                                .virtualUSDCtrller
                                                .text
                                                .trim()) ??
                                        0,
                                    "virtual_cdf": double.tryParse(
                                            caisseScreen[currStep]
                                                .virtualCDFCtrller
                                                .text
                                                .trim()) ??
                                        0,
                                    "stock": double.tryParse(
                                            caisseScreen[currStep]
                                                .stockCtrller
                                                .text
                                                .trim()) ??
                                        0,
                                    "bonus_usd": double.tryParse(
                                            caisseScreen[currStep]
                                                .bonusUSDCtrller
                                                .text) ??
                                        0,
                                    "bonus_cdf": double.tryParse(
                                            caisseScreen[currStep]
                                                .bonusCDFCtrller
                                                .text
                                                .trim()) ??
                                        0,
                                    "percentage": "0",
                                  };
                                  if (caisseActivite.length > currStep) {
                                    caisseActivite[currStep] = activiteData;
                                  } else {
                                    caisseActivite.add(activiteData);
                                  }
                                  if (currStep < widget.nbrCaisse - 1) {
                                    currStep++;
                                    setState(() {});
                                  } else {
                                    Provider.of<AdminCaisseStateProvider>(
                                            context,
                                            listen: false)
                                        .addCaisseActivity(
                                            caisses: caisseActivite);
                                    Navigator.pop(context);
                                  }
                                },
                                steps: List<Step>.generate(
                                    widget.nbrCaisse,
                                    (index) => Step(
                                        title: Text('Activité ${index + 1}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: caisseScreen[index]))),
                          ],
                        ))
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget _createEventControlBuilder(BuildContext context,
      {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            currStep > 0
                ? RaisedButton(
//                  animationDuration: Duration(seconds: 10),
                    color: Colors.grey,
                    onPressed: onStepCancel,
                    child: const Text(
                      '< PRECEDENT',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
            RaisedButton(
              color: AppColors.kYellowColor,
              onPressed: onStepContinue,
              child: Text(
                currStep < widget.nbrCaisse - 1 ? 'SUIVANT >' : 'VALIDER',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
    );
  }
}

class CreateCaisseActivityPage extends StatefulWidget {
  TextEditingController virtualCDFCtrller = TextEditingController(),
      stockCtrller = TextEditingController(),
      activiteCtrller = TextEditingController(),
      bonusUSDCtrller = TextEditingController(),
      bonusCDFCtrller = TextEditingController(),
      virtualUSDCtrller = TextEditingController();
  String id_activite = "";
  final List? activities;

  CreateCaisseActivityPage({Key? key, this.activities}) : super(key: key);

  @override
  _CreateCaisseActivityPageState createState() =>
      _CreateCaisseActivityPageState();
}

class _CreateCaisseActivityPageState extends State<CreateCaisseActivityPage> {
  checkHasStock() {
    return context
        .read<AdminUserStateProvider>()
        .activitiesdata
        .firstWhereOrNull(
            (element) => widget.id_activite == element.id.toString())
        ?.hasStock;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      SearchableTextFormFieldWidget(
        hintText: 'Activites',
        textColor: AppColors.kWhiteColor,
        backColor: AppColors.kTextFormWhiteColor,
        overlayColor: AppColors.kBlackColor,
        editCtrller: widget.activiteCtrller,
        maxLines: 1,
        callback: (value) {
          widget.id_activite = value.toString();
          if (checkHasStock() == 1) {
            widget.virtualCDFCtrller.text = '0';
            widget.virtualUSDCtrller.text = '0';
          } else {
            widget.stockCtrller.text = '0';
          }
          setState(() {});
        },
        //data: Provider.of<AppStateProvider>(context)
        data: widget.activities == null
            ? Provider.of<AdminUserStateProvider>(context)
                .activitiesdata
                .map((item) => item.toJson())
                .toList()
            : widget.activities!,
        displayColumn: "name",
        indexColumn: "id",
      ),
      if (checkHasStock() == 0)
        TextFormFieldWidget(
            backColor: AppColors.kTextFormWhiteColor,
            hintText: 'Virtuel CDF',
            editCtrller: widget.virtualCDFCtrller,
            textColor: AppColors.kWhiteColor,
            maxLines: 1),
      if (checkHasStock() == 0)
        TextFormFieldWidget(
            backColor: AppColors.kTextFormWhiteColor,
            hintText: 'Virtuel USD',
            editCtrller: widget.virtualUSDCtrller,
            inputType: TextInputType.number,
            textColor: AppColors.kWhiteColor,
            maxLines: 1),
      if (checkHasStock() == 1)
        TextFormFieldWidget(
            backColor: AppColors.kTextFormWhiteColor,
            hintText: 'Stock',
            editCtrller: widget.stockCtrller,
            inputType: TextInputType.number,
            textColor: AppColors.kWhiteColor,
            maxLines: 1),
      TextFormFieldWidget(
          backColor: AppColors.kTextFormWhiteColor,
          hintText: 'Bonus CDF',
          editCtrller: widget.bonusCDFCtrller,
          textColor: AppColors.kWhiteColor,
          maxLines: 1),
      TextFormFieldWidget(
          backColor: AppColors.kTextFormWhiteColor,
          hintText: 'Bonus USD',
          editCtrller: widget.bonusUSDCtrller,
          inputType: TextInputType.number,
          textColor: AppColors.kWhiteColor,
          maxLines: 1),
    ]));
  }
}
