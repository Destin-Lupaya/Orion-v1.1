import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/empty_model.dart';
import 'package:orion/Admin_Orion/Resources/Components/modal_progress.dart';
import 'package:orion/Admin_Orion/Resources/Components/radio_button.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/create_activity_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Guichet/update_activity.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/custom_network_image.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/titlebar.widget.dart';
import 'package:orion/Views/Guichet/Historique/dynamic_transactions_history.dart';
import 'package:provider/provider.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({
    Key? key,
  }) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
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
                title: 'Activités',
                content: AddActivityWidget(updatingData: false));
          },
          child: Icon(Icons.add, color: AppColors.kWhiteColor),
        ),
        body: ModalProgress(
          isAsync: appStateProvider.isAsync,
          progressColor: AppColors.kYellowColor,
          child: SingleChildScrollView(
            controller: ScrollController(),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleBarWidget(
                    searchCtrller: TextEditingController(),
                    title: 'Activite',
                    callback: () {
                      Provider.of<AdminUserStateProvider>(context,
                              listen: false)
                          .getActivitiesData(isRefresh: true);
                    }),
                const DisplayCreateactivityPage()
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AddActivityWidget extends StatefulWidget {
  final bool updatingData;

  final CreatActiviteModel? creationActiviteModel;
  AddActivityWidget(
      {Key? key, required this.updatingData, this.creationActiviteModel})
      : super(key: key);

  @override
  State<AddActivityWidget> createState() => AddActivityWidgetState();
}

class AddActivityWidgetState extends State<AddActivityWidget> {
  final PageController _controller = PageController();
  final TextEditingController _designationCtrller = TextEditingController();
  final TextEditingController _descriptCtrller = TextEditingController();
  final TextEditingController _pointsCtrller = TextEditingController();

  // CahsIn and CashOut controller
  final TextEditingController _entryFeesCtrller =
      TextEditingController(text: "Depot");
  final TextEditingController _cashOutCtrller =
      TextEditingController(text: "Retrait");

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _designationCtrller.text =
          widget.creationActiviteModel!.designation.trim();
      _descriptCtrller.text = widget.creationActiviteModel!.description.trim();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  int inputCount = 1;
  List<TextEditingController> inputsList = [TextEditingController()];
  List<bool> inputsListVisibility = [true];
  bool entryFees = true, withdrawFees = true, canBePublishedOnWeb = true;
  Image? image;
  List<int>? imgStream;
  bool hasStock = false, hasNegativeSold = false;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
        backColor: AppColors.kBlackLightColor,
        title: 'Creation des Activites',
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Responsive.isMobile(context)
                    ? Axis.vertical
                    : Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Designation',
                      editCtrller: _designationCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
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
              Flex(
                direction: Responsive.isMobile(context)
                    ? Axis.vertical
                    : Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Points (%)',
                      editCtrller: _pointsCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                      inputType: TextInputType.number,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(),
                  )
                ],
              ),
              const Divider(color: Colors.white54),
              Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: CustomRadioButton(
                          textColor: AppColors.kWhiteColor,
                          label: 'Visible sur le site web?',
                          value: canBePublishedOnWeb,
                          callBack: () {
                            canBePublishedOnWeb = !canBePublishedOnWeb;
                            setState(() {});
                          }),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidgets.text500(
                                title: "Nombre des champs",
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (inputCount > 1) {
                                          inputCount--;
                                          inputsList.removeLast();
                                          inputsListVisibility.removeLast();
                                          setState(() {});
                                        }
                                      },
                                      icon: Icon(Icons.remove_circle_outline,
                                          color: AppColors.kWhiteColor)),
                                  const SizedBox(width: 10),
                                  TextWidgets.text500(
                                      title: "$inputCount",
                                      fontSize: 14,
                                      textColor: AppColors.kWhiteColor),
                                  const SizedBox(width: 10),
                                  IconButton(
                                      onPressed: () {
                                        inputCount++;
                                        inputsList.add(TextEditingController());
                                        inputsListVisibility.add(true);
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.add_circle_outline,
                                          color: AppColors.kWhiteColor))
                                ])
                          ]),
                    ),
                  ]),
              const Divider(
                color: Colors.white54,
              ),
              TextWidgets.text500(
                  title: "Nom des champs",
                  fontSize: 14,
                  textColor: AppColors.kWhiteColor),
              LayoutBuilder(builder: (context, constrains) {
                return Wrap(
                  children: List.generate(
                      inputsList.length,
                      (index) => Container(
                          width: Responsive.isMobile(context)
                              ? double.maxFinite
                              : constrains.maxWidth / 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  maxLines: 1,
                                  hintText: inputsList[index].text,
                                  editCtrller: inputsList[index],
                                  textColor: AppColors.kWhiteColor,
                                  backColor: AppColors.kTextFormWhiteColor,
                                ),
                              ),
                              CustomRadioButton(
                                  textColor: AppColors.kWhiteColor,
                                  label: 'Web',
                                  value: inputsListVisibility[index],
                                  callBack: () {
                                    inputsListVisibility[index] =
                                        !inputsListVisibility[index];
                                    setState(() {});
                                  })
                            ],
                          ))),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                  // width: MediaQuery.of(context).size.width / 2.8,
                  child: Flex(
                direction: Responsive.isMobile(context)
                    ? Axis.vertical
                    : Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      isEnabled: false,
                      hintText: "Montant",
                      editCtrller: TextEditingController(),
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      isEnabled: false,
                      hintText: "Numéro client",
                      editCtrller: TextEditingController(),
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                ],
              )),
              const Divider(color: Colors.white54),
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
              Flex(
                direction: Responsive.isMobile(context)
                    ? Axis.vertical
                    : Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Entré des fonds',
                      isEnabled: entryFees,
                      editCtrller: _entryFeesCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
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
                        label: "L'activité dispose des soldes négatifs",
                        value: hasNegativeSold,
                        callBack: () {
                          hasNegativeSold = !hasNegativeSold;
                          setState(() {});
                        }),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(children: [
                if (context.read<UserStateProvider>().pickedFiles.isNotEmpty)
                  Container(
                      width: 100,
                      // height: 100,
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: image ?? Container(),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<AdminUserStateProvider>()
                                        .imageBytes = null;
                                    context
                                        .read<UserStateProvider>()
                                        .pickedFiles
                                        .clear();
                                    setState(() {});
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      color: Colors.white,
                                      child: const Icon(
                                          Icons.delete_forever_rounded,
                                          color: Colors.black,
                                          size: 16)),
                                ),
                              ))
                        ],
                      ))
              ]),
              Row(children: [
                Expanded(
                  child: Consumer<AdminUserStateProvider>(
                      builder: (context, creationActiviteModel, _) {
                    return CustomButton(
                        text: 'Ajouter une image de l\'activité',
                        backColor: AppColors.kGreenColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () async {
                          FilePickerResult? fileResult =
                              await FilePicker.platform.pickFiles(
                                  withReadStream: true,
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                "png",
                                "jpg",
                                "jpeg",
                              ]);
                          if (fileResult != null && fileResult.count > 0) {
                            late StreamSubscription subscription;
                            subscription = fileResult.files.first.readStream!
                                .listen((event) {
                              imgStream = event;
                              image = Image.memory(Uint8List.fromList(event));
                              subscription.cancel();
                              setState(() {});
                              context.read<AdminUserStateProvider>().addFiles(
                                  picked: fileResult.files, callback: () {});

                              // print(context
                              //     .read<UserStateProvider>()
                              //     .pickedFiles
                              //     .length);
                              // userStateProvider.imageBytes = Uint8List.fromList(await pickedFiles.first.readStream!.single);
                              //                                           userStateProvider.
                            });
                            // userStateProvider.addFiles(
                            //     context: context,
                            //     picked: fileResult.files,
                            //     callback: () {});
                          }
                        });
                  }),
                ),
                Expanded(
                  child: Consumer<AdminUserStateProvider>(
                      builder: (context, creationActiviteModel, _) {
                    return CustomButton(
                      canSync: true,
                      text: 'Enregistrer',
                      backColor: AppColors.kYellowColor,
                      textColor: AppColors.kWhiteColor,
                      callback: () {
                        if (_designationCtrller.text.isEmpty ||
                            _descriptCtrller.text.isEmpty ||
                            double.tryParse(_pointsCtrller.text) == null) {
                          Message.showToast(
                              msg:
                                  "Veuillez saisir une designation et une description, et un pourcentage valide pour les points");
                          return;
                        }
                        if (imgStream == null) {
                          Message.showToast(msg: "Veuillez choisir une image");
                          return;
                        }
                        if (_entryFeesCtrller.text.isEmpty &&
                            _cashOutCtrller.text.isEmpty) {
                          Message.showToast(
                              msg:
                                  "Veuillez choisir au moins une operation (Entré ou sortie)");
                          return;
                        }
                        bool hasErrors = false;
                        for (int i = 0; i < inputsList.length; i++) {
                          if (inputsList[i].text.isEmpty) {
                            hasErrors = true;
                          }
                        }
                        if (hasErrors) {
                          Message.showToast(
                              msg: "Veuillez remplir tous les champs");
                          return;
                        }
                        Map activity = {
                          "name": _designationCtrller.text.trim(),
                          "description": _descriptCtrller.text.trim(),
                          "avatar": "test",
                          "users_id": "1",
                          "web_visibility": canBePublishedOnWeb ? "1" : "0",
                          if (entryFees == true)
                            "cashIn": _entryFeesCtrller.text,
                          if (withdrawFees == true)
                            "cashOut": _cashOutCtrller.text,
                          "hasStock": hasStock == true ? 1 : 0,
                          "hasNegativeSold": hasNegativeSold == true ? 1 : 0,
                          "points":
                              double.tryParse(_pointsCtrller.text.trim()) ??
                                  '0',
                        };
                        List inputs = [];
                        for (int i = 0; i < inputsList.length; i++) {
                          inputs.add({
                            "designation": inputsList[i].text,
                            "web": inputsListVisibility[i]
                          });
                        }
                        // List inputs = inputsList
                        //     .map((input) => {"name":input.text, "web":})
                        //     .toList();
                        Map data = {"activity": activity, "inputs": inputs};
                        // return print(activity);
                        context.read<AdminUserStateProvider>().addactivities(
                            context: context,
                            data: data,
                            imgStream: imgStream,
                            updatingData: widget.updatingData,
                            callback: () {
                              image = null;
                              imgStream = null;
                              // typeactiviteMode = "Mobile Money";
                              entryFees = true;
                              withdrawFees = true;
                              _descriptCtrller.text = "";
                              _designationCtrller.text = "";
                              inputsList.clear();
                              inputsList.add(TextEditingController());
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                      },
                    );
                  }),
                )
              ]),
            ],
          ),
        ));
  }
}

fileContainer({required PlatformFile file}) {
  return GestureDetector(
    onTap: () {
      // showCupertinoModalPopup(
      //     context: context,
      //     builder: (builder) {
      //       return Center(
      //         child: Container(
      //           padding: const EdgeInsets.all(10),
      //           child: Image.memory(file.bytes!),
      //         ),
      //       );
      //     });
    },
    child: Container(
        color: Colors.white.withOpacity(0.1),
        child: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: const EdgeInsets.all(0),
              child: Image.memory(
                file.bytes!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: -2,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.black.withOpacity(0.5)])),
                child: TextWidgets.textBold(
                    title: file.name,
                    fontSize: 12,
                    textColor: AppColors.kWhiteColor),
              )),
          Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10))),
                child: TextWidgets.text300(
                    title:
                        "${((file.size / 1024) / 1024).toStringAsFixed(2)} mb",
                    fontSize: 10,
                    textColor: AppColors.kWhiteColor),
              )),
        ])),
  );
}

class DisplayCreateactivityPage extends StatelessWidget {
  const DisplayCreateactivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUserStateProvider>(
      builder: (context, userStateProvider, child) {
        return userStateProvider.activitiesdata.isNotEmpty
            ? Column(
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(child: Container()
                  //         // child: CustomButton(
                  //         //     text: "Imprimer",
                  //         //     backColor: AppColors.kGreenColor,
                  //         //     textColor: AppColors.kWhiteColor,
                  //         //     callback: () {}),
                  //         ),
                  //     ClipRRect(
                  //       borderRadius: BorderRadius.circular(50),
                  //       child: Container(
                  //           width: 50,
                  //           alignment: Alignment.center,
                  //           color: AppColors.kTextFormBackColor,
                  //           child: IconButton(
                  //               onPressed: () {},
                  //               icon: Icon(Icons.autorenew,
                  //                   color: AppColors.kBlackColor))),
                  //     ),
                  //     const SizedBox(width: 16),
                  //   ],
                  // ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextWidgets.text300(
                              title: 'Image',
                              fontSize: 14,
                              textColor: AppColors.kBlackLightColor),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextWidgets.text300(
                              title: 'Designation',
                              fontSize: 14,
                              textColor: AppColors.kBlackLightColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Description',
                              fontSize: 14,
                              textColor: AppColors.kBlackLightColor),
                        ),
                        Expanded(
                          child: Center(
                              child: TextWidgets.text300(
                                  title: 'Status',
                                  fontSize: 14,
                                  textColor: AppColors.kBlackLightColor)),
                        ),
                        TextWidgets.text300(
                            title: 'Export',
                            fontSize: 14,
                            textColor: AppColors.kBlackLightColor),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userStateProvider.activitiesdata.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              await Provider.of<AdminUserStateProvider>(context,
                                      listen: false)
                                  .getActivitiesData(
                                      isRefresh: true,
                                      activityID: userStateProvider
                                          .activitiesdata[index].id
                                          .toString()
                                          .trim());
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => Center(
                                          child: UpdateActivityPage(
                                        creationActiviteModel: userStateProvider
                                            .activitiesdata[index],
                                        updatingData: true,
                                      )));
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  color: AppColors.kTextFormBackColor,
                                  // color: index % 2 == 0
                                  //     ? AppColors.kBlackLightColor
                                  //     : AppColors.kBlackLightColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CustomNetworkImage(
                                                src: userStateProvider
                                                        .activitiesdata[index]
                                                        .avatar
                                                        .toString()
                                                        .trim()
                                                        .contains("clientfiles")
                                                    ? "${BaseUrl.ip}${userStateProvider.activitiesdata[index].avatar.toString().trim()}"
                                                    : "",
                                                size: const Size(60, 60),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: TextWidgets.text300(
                                            title: userStateProvider
                                                .activitiesdata[index]
                                                .designation
                                                .toString()
                                                .trim(),
                                            fontSize: 14,
                                            textColor: AppColors.kBlackColor),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TextWidgets.text300(
                                            title: userStateProvider
                                                .activitiesdata[index]
                                                .description
                                                .toString()
                                                .trim(),
                                            fontSize: 14,
                                            textColor: AppColors.kBlackColor),
                                      ),
                                      Expanded(
                                        child: Icon(
                                            userStateProvider
                                                        .activitiesdata[index]
                                                        .active ==
                                                    1
                                                ? Icons
                                                    .check_circle_outline_rounded
                                                : Icons.cancel,
                                            color: userStateProvider
                                                        .activitiesdata[index]
                                                        .active ==
                                                    1
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      IconButton(onPressed: () async {
                                        await Provider.of<
                                                    TransactionsStateProvider>(
                                                context,
                                                listen: false)
                                            .getTransactions(
                                                activityID: userStateProvider
                                                    .activitiesdata[index].id
                                                    .toString()
                                                    .trim());
                                        await Provider.of<
                                                    AdminUserStateProvider>(
                                                context,
                                                listen: false)
                                            .getActivitiesData(
                                                isRefresh: true,
                                                activityID: userStateProvider
                                                    .activitiesdata[index].id
                                                    .toString()
                                                    .trim());
                                        showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) => Center(
                                                    child:
                                                        DynamicHistoryTransList(
                                                  activityData:
                                                      userStateProvider
                                                          .activitiesdata[index]
                                                          .toJson(),
                                                  data: Provider.of<
                                                              TransactionsStateProvider>(
                                                          context,
                                                          listen: false)
                                                      .transactions[
                                                          userStateProvider
                                                              .activitiesdata[
                                                                  index]
                                                              .id
                                                              .toString()
                                                              .trim()]
                                                      .toList(),
                                                )));
                                        return;
                                      }, icon: Consumer<AppStateProvider>(
                                          builder:
                                              (context, appStateProvider, _) {
                                        return !appStateProvider.isAsync
                                            ? Icon(Icons.download_for_offline,
                                                color: AppColors.kBlackColor)
                                            : Center(
                                                child: Column(
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              AppColors
                                                                  .kRedColor),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                      })),
                                    ],
                                  ),
                                ),
                                Divider(
                                    height: 2,
                                    thickness: 1,
                                    color:
                                        AppColors.kWhiteColor.withOpacity(0.4))
                              ],
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
                        userStateProvider.getActivitiesData(isRefresh: true);
                      }),
                ),
              ]);
      },
    );
  }
}
