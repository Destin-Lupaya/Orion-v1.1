import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Resources/AppStateProvider/account_provider.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/decorated_container.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Models/account.model.dart';
import 'package:orion/Resources/Models/account_activities.model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/provider.dart';

class TransferActivityPage extends StatefulWidget {
  const TransferActivityPage({Key? key}) : super(key: key);

  @override
  State<TransferActivityPage> createState() => _TransferActivityPageState();
}

class _TransferActivityPageState extends State<TransferActivityPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<AccountProvider>().getData();
    });
  }

  final TextEditingController _senderCtrller = TextEditingController();
  final TextEditingController _receiverCtrller = TextEditingController();
  String? senderID, receiverID;
  AccountActivityModel? selectedActivities;
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
                physics: const BouncingScrollPhysics(),
                children: [
                  CardWidget(
                      backColor: AppColors.kBlackLightColor,
                      title: "Transférer une activité",
                      titleColor: AppColors.kWhiteColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SearchableTextFormFieldWidget(
                                  overlayColor: AppColors.kBlackLightColor,
                                  hintText: 'Source',
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                  editCtrller: _senderCtrller,
                                  callback: (data) {
                                    senderID = data.toString();
                                    context.read<AccountProvider>().getData(
                                        accountID: int.parse(data.toString()));
                                    setState(() {});
                                  },
                                  data: context
                                      .read<AccountProvider>()
                                      .dataList
                                      .map((e) => e.toJSON())
                                      .toList(),
                                  displayColumn: 'userNames',
                                  // secondDisplayColumn: 'phone',
                                  indexColumn: 'id'),
                              if (context.select<AccountProvider,
                                          AccountModel?>(
                                      (provider) => provider.senderAccount) !=
                                  null)
                                DecoratedContainer(
                                    backColor: Colors.white12,
                                    child: TextWidgets.text500(
                                        title: 'Activities',
                                        fontSize: 14,
                                        textColor: AppColors.kWhiteColor)),
                              if (context.select<AccountProvider,
                                          AccountModel?>(
                                      (provider) => provider.senderAccount) !=
                                  null)
                                Wrap(
                                  children: [
                                    ...List.generate(
                                        context
                                            .select<AccountProvider,
                                                    List<AccountActivityModel>>(
                                                (provider) => provider
                                                    .senderAccount!.activities)
                                            .length, (index) {
                                      AccountActivityModel data = context
                                          .read<AccountProvider>()
                                          .senderAccount!
                                          .activities[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (selectedActivities?.id ==
                                              data.id) {
                                            selectedActivities = null;
                                          } else {
                                            if (data.virtualCDF > 0 ||
                                                data.virtualUSD > 0 ||
                                                data.stock > 0) {
                                              // Dialogs.showDialogNoAction(
                                              //     context: context,
                                              //     title: 'Erreur',
                                              //     content:
                                              //         "Un des soldes de cette activité n'est pas nulle, et de ce fait, elle ne peut être transférée.");
                                              // return;
                                            }
                                            selectedActivities = (data);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: selectedActivities?.id ==
                                                        data.id
                                                    ? Colors.white12
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidgets.textBold(
                                                      title: data.activityName
                                                          .toString()
                                                          .trim(),
                                                      fontSize: 12,
                                                      textColor: AppColors
                                                          .kWhiteColor),
                                                  TextWidgets.text300(
                                                      title:
                                                          "CDF ${data.virtualCDF.toString().trim()}",
                                                      fontSize: 12,
                                                      textColor: AppColors
                                                          .kWhiteColor),
                                                  TextWidgets.text300(
                                                      title:
                                                          "USD ${data.virtualUSD.toString().trim()}",
                                                      fontSize: 12,
                                                      textColor: AppColors
                                                          .kWhiteColor),
                                                  TextWidgets.text300(
                                                      title:
                                                          "Stock: ${data.stock.toString().trim()}",
                                                      fontSize: 12,
                                                      textColor: AppColors
                                                          .kWhiteColor),
                                                ])),
                                      );
                                    })
                                  ],
                                ),
                              SearchableTextFormFieldWidget(
                                  overlayColor: AppColors.kBlackLightColor,
                                  hintText: 'Destination',
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                  editCtrller: _receiverCtrller,
                                  callback: (data) {
                                    receiverID = data.toString();
                                    context.read<AccountProvider>().getData(
                                        isReceiver: true,
                                        accountID: int.parse(data.toString()));
                                    setState(() {});
                                  },
                                  data: context
                                      .read<AccountProvider>()
                                      .dataList
                                      .map((e) => e.toJSON())
                                      .toList(),
                                  displayColumn: 'userNames',
                                  // secondDisplayColumn: 'phone',
                                  indexColumn: 'id'),
                              context.select<AppStateProvider, bool>(
                                          (provider) => provider.isAsync) ==
                                      false
                                  ? CustomButton(
                                      backColor: AppColors.kYellowColor,
                                      text: 'Enregistrer',
                                      textColor: AppColors.kBlackColor,
                                      callback: () {
                                        selectedActivities?.account_id =
                                            int.parse(receiverID!.toString());
                                        if (selectedActivities == null) {
                                          Dialogs.showDialogNoAction(
                                              context: context,
                                              title: 'Erreur',
                                              content:
                                                  "Aucune activité n'a été sélectionnée");
                                          return;
                                        }
                                        if (context
                                            .read<AccountProvider>()
                                            .receiverAccount!
                                            .activities
                                            .map((e) => e.activity_id)
                                            .toList()
                                            .contains(selectedActivities
                                                ?.activity_id)) {
                                          Dialogs.showDialogNoAction(
                                              context: context,
                                              title: 'Erreur',
                                              content:
                                                  "Cette caisse possède déjà cette activité, veuillez choisir une autre");
                                          return;
                                        }
                                        Dialogs
                                            .showDialogWithActionCustomContent(
                                                context: context,
                                                title: 'Confirmation',
                                                content: TextWidgets.text300(
                                                    title:
                                                        "Vous allez transférer l'qctivité ${selectedActivities?.activityName} vers ${_receiverCtrller.text.trim()}.\nCliquez sur continuer pour valider",
                                                    fontSize: 14,
                                                    textColor:
                                                        AppColors.kBlackColor),
                                                callback: () {
                                                  context
                                                      .read<
                                                          AdminCaisseStateProvider>()
                                                      .updateCaisseActivity(
                                                          caisseActivity:
                                                              selectedActivities!,
                                                          callback: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                });
                                      })
                                  : Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.kYellowColor),
                                      ),
                                    )
                            ],
                          )
                        ],
                      ))
                ],
              );
            })));
  }
}
