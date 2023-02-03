import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/radio_button.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/create_activity_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class UpdateActivityPage extends StatefulWidget {
  final bool updatingData;

  final CreatActiviteModel? creationActiviteModel;

  const UpdateActivityPage(
      {Key? key, required this.updatingData, this.creationActiviteModel})
      : super(key: key);

  @override
  _UpdateActivityPageState createState() => _UpdateActivityPageState();
}

List<String> typeactiviteList = ["Mobile Money", "Autres"];
late String typeactiviteMode = "Mobile Money";

String? nomFournisseur;
String? membreInterne;

String? nomMembre;

class _UpdateActivityPageState extends State<UpdateActivityPage> {
  String? sousCompteId;
  final TextEditingController _designationCtrller = TextEditingController();
  final TextEditingController _descriptCtrller = TextEditingController();
  final TextEditingController _pointsCtrller = TextEditingController();

  // CahsIn and CashOut controller
  final TextEditingController _entryFeesCtrller =
      TextEditingController(text: "Depot");
  final TextEditingController _cashOutCtrller =
      TextEditingController(text: "Retrait");

  bool entryFees = true, withdrawFees = true, canBePublishedOnWeb = true;

  List<TextEditingController> inputsList = [];
  List<bool> inputsListVisibility = [];
  bool hasStock = false, hasNegativeSold = false;

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _designationCtrller.text =
          widget.creationActiviteModel!.designation.trim();
      _descriptCtrller.text = widget.creationActiviteModel!.description.trim();
      _entryFeesCtrller.text = widget.creationActiviteModel!.cashIn ?? '';
      _cashOutCtrller.text = widget.creationActiviteModel!.cashOut ?? '';
      _pointsCtrller.text =
          widget.creationActiviteModel!.points?.toString() ?? '0';
      canBePublishedOnWeb = widget.creationActiviteModel!.web_visibility != null
          ? widget.creationActiviteModel!.web_visibility! == "0"
              ? false
              : true
          : true;
      entryFees = widget.creationActiviteModel!.cashIn != null ? true : false;
      withdrawFees =
          widget.creationActiviteModel!.cashOut != null ? true : false;
      hasStock = widget.creationActiviteModel?.hasStock == 1 ? true : false;
      hasNegativeSold =
          widget.creationActiviteModel?.hasNegativeSold == 1 ? true : false;
    }
    if (widget.creationActiviteModel!.inputs != null) {
      for (int i = 0; i < widget.creationActiviteModel!.inputs!.length; i++) {
        inputsList.add(TextEditingController(
            text: widget.creationActiviteModel!.inputs![i]['designation']
                .toString()));
        inputsListVisibility.add(
            widget.creationActiviteModel!.inputs![i]['web'] == 1
                ? true
                : false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUserStateProvider>(
        builder: (context, userStateProvider, _) {
      return Container(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width - 40
              : MediaQuery.of(context).size.width / 2,
          // height: MediaQuery.of(context).size.height * .85,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .85,
              minHeight: 300),
          // color: AppColors.kBlackLightColor,
          child: Consumer<adminAppStateProvider>(
              builder: (context, appStateProvider, _) {
            return ModalProgress(
              isAsync: appStateProvider.isAsync,
              progressColor: AppColors.kYellowColor,
              child: ListView(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: 'Modifier l\'activité',
                      content: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Designation',
                                  editCtrller: _designationCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                ),
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Description',
                                  editCtrller: _descriptCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Points (%)',
                                  editCtrller: _pointsCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                  inputType: TextInputType.number,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              )
                            ],
                          ),
                          const Divider(color: Colors.white54),
                          CustomRadioButton(
                              textColor: AppColors.kWhiteColor,
                              label: 'Visible sur le site web?',
                              value: canBePublishedOnWeb,
                              callBack: () {
                                canBePublishedOnWeb = !canBePublishedOnWeb;
                                setState(() {});
                              }),
                          Row(
                            children: [
                              Expanded(
                                child: CustomRadioButton(
                                    textColor: AppColors.kWhiteColor,
                                    label: 'Entre des fonds',
                                    value: entryFees,
                                    callBack: () {
                                      entryFees = !entryFees;
                                      if (entryFees == false) {
                                        _entryFeesCtrller.text = "";
                                      }
                                      setState(() {});
                                    }),
                              ),
                              Expanded(
                                child: CustomRadioButton(
                                    textColor: AppColors.kWhiteColor,
                                    label: 'Sorti des fonds',
                                    value: withdrawFees,
                                    callBack: () {
                                      withdrawFees = !withdrawFees;
                                      if (withdrawFees == false) {
                                        _cashOutCtrller.text = "";
                                      }
                                      setState(() {});
                                    }),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Entré des fonds',
                                  isEnabled: entryFees,
                                  editCtrller: _entryFeesCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                ),
                              ),
                              Expanded(
                                child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: 'Sorti des fonds',
                                  isEnabled: withdrawFees,
                                  editCtrller: _cashOutCtrller,
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Card(
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidgets.textBold(
                                        title: "Informations de l'activité",
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor),
                                  ]),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            children: List.generate(
                                inputsList.length,
                                (index) => Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormFieldWidget(
                                            maxLines: 1,
                                            isEnabled: false,
                                            hintText: inputsList[index].text,
                                            editCtrller: inputsList[index],
                                            textColor: AppColors.kWhiteColor,
                                            backColor:
                                                AppColors.kTextFormWhiteColor,
                                          ),
                                        ),
                                        IgnorePointer(
                                          ignoring: true,
                                          child: CustomRadioButton(
                                              textColor: AppColors.kWhiteColor,
                                              label: 'Web',
                                              value:
                                                  inputsListVisibility[index],
                                              callBack: () {
                                                inputsListVisibility[index] =
                                                    !inputsListVisibility[
                                                        index];
                                                setState(() {});
                                              }),
                                        )
                                      ],
                                    ))),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomRadioButton(
                                    textColor: AppColors.kWhiteColor,
                                    label: "L'activité possède un stock",
                                    value: hasStock,
                                    callBack: () {
                                      hasStock = !hasStock;
                                      setState(() {});
                                    }),
                              ),
                              Expanded(
                                child: CustomRadioButton(
                                    textColor: AppColors.kWhiteColor,
                                    label:
                                        "L'activité dispose des soldes négatifs",
                                    value: hasNegativeSold,
                                    callBack: () {
                                      hasNegativeSold = !hasNegativeSold;
                                      setState(() {});
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Consumer<AdminUserStateProvider>(
                              builder: (context, creationActiviteModel, _) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text:
                                        widget.creationActiviteModel?.active ==
                                                1
                                            ? 'Suspendre'
                                            : 'Réactiver',
                                    backColor:
                                        AppColors.kRedColor.withOpacity(0.5),
                                    textColor: AppColors.kWhiteColor,
                                    callback: () async {
                                      Map activity = {
                                        "id": widget.creationActiviteModel!.id,
                                        "name": _designationCtrller.text.trim(),
                                        "description":
                                            _descriptCtrller.text.trim(),
                                        "web_visibility":
                                            canBePublishedOnWeb ? "1" : "0",
                                        "cashIn": entryFees == true
                                            ? _entryFeesCtrller.text
                                            : null,
                                        "cashOut": withdrawFees == true
                                            ? _cashOutCtrller.text
                                            : null,
                                        "hasStock": hasStock == true ? 1 : 0,
                                        "hasNegativeSold":
                                            hasNegativeSold == true ? 1 : 0,
                                        "points": double.tryParse(
                                                _pointsCtrller.text.trim()) ??
                                            '0',
                                        "statusActive": widget
                                                    .creationActiviteModel
                                                    ?.active ==
                                                1
                                            ? 0
                                            : 1
                                      };
                                      await userStateProvider.addactivities(
                                          context: context,
                                          updatingData: true,
                                          imgStream: null,
                                          data: activity,
                                          callback: () {
                                            Navigator.of(navKey.currentContext!,
                                                    rootNavigator: true)
                                                .pop();
                                            Navigator.of(navKey.currentContext!,
                                                    rootNavigator: true)
                                                .pop();
                                          });
                                    },
                                  ),
                                ),
                                Expanded(
                                    child: CustomButton(
                                  text: 'Modifier',
                                  backColor: AppColors.kYellowColor,
                                  textColor: AppColors.kWhiteColor,
                                  callback: () async {
                                    Map activity = {
                                      "id": widget.creationActiviteModel!.id,
                                      "name": _designationCtrller.text.trim(),
                                      "description":
                                          _descriptCtrller.text.trim(),
                                      "web_visibility":
                                          canBePublishedOnWeb ? "1" : "0",
                                      "cashIn": entryFees == true
                                          ? _entryFeesCtrller.text
                                          : null,
                                      "cashOut": withdrawFees == true
                                          ? _cashOutCtrller.text
                                          : null,
                                      "hasStock": hasStock == true ? 1 : 0,
                                      "hasNegativeSold":
                                          hasNegativeSold == true ? 1 : 0,
                                      "points": double.tryParse(
                                              _pointsCtrller.text.trim()) ??
                                          '0',
                                    };
                                    // print('data');
                                    await userStateProvider.addactivities(
                                        context: context,
                                        updatingData: true,
                                        imgStream: null,
                                        data: activity,
                                        callback: () {
                                          Navigator.of(navKey.currentContext!,
                                                  rootNavigator: true)
                                              .pop();
                                          Navigator.of(navKey.currentContext!,
                                                  rootNavigator: true)
                                              .pop();
                                        });
                                  },
                                ))
                              ],
                            );
                          }),
                        ],
                      )),
                ],
              ),
            );
          }));
    });
  }
}
