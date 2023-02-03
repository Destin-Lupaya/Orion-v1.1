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
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Reports/dynamic_transactions_history.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Reports/global_report.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/titlebar.widget.dart';
import 'package:provider/provider.dart';

class BranchePage extends StatefulWidget {
  const BranchePage({
    Key? key,
  }) : super(key: key);

  @override
  _BranchePageState createState() => _BranchePageState();
}

class _BranchePageState extends State<BranchePage> {
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
                title: 'Branches',
                content: const CreateBranchPage(updatingData: false));
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
                      title: 'Branches',
                      callback: () {
                        Provider.of<AdminCaisseStateProvider>(context,
                                listen: false)
                            .getBranches(isRefresh: true);
                      }),
                  const DisplayBranchPage()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CreateBranchPage extends StatefulWidget {
  final bool updatingData;
  final Map? branch;

  const CreateBranchPage({Key? key, required this.updatingData, this.branch})
      : super(key: key);

  @override
  _CreateBranchPageState createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final PageController _controller = PageController();
  final TextEditingController _nameCtrller = TextEditingController();
  final TextEditingController _descriptionCtrller = TextEditingController();
  final TextEditingController _addressCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _nameCtrller.text = widget.branch!['name'].trim();
      _descriptionCtrller.text =
          widget.branch!['description'].toString().trim();
      _addressCtrller.text = widget.branch!['location'].toString().trim();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      initData();
    });
  }

  initData() {
    Provider.of<AdminCaisseStateProvider>(context, listen: false)
        .getBranches(isRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<adminAppStateProvider>(
        builder: (context, appStateProvider, _) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
        }),
        child: SingleChildScrollView(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const AppLogo(size: Size(100, 100)),
                CardWidget(
                  backColor: AppColors.kBlackLightColor,
                  title: 'Ajouter une branche',
                  content: Wrap(
                    children: [
                      Row(children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            maxLines: 1,
                            editCtrller: _nameCtrller,
                            hintText: 'Designation',
                            textColor: AppColors.kWhiteColor,
                            backColor: AppColors.kTextFormWhiteColor,
                          ),
                        ),
                        Expanded(
                          child: TextFormFieldWidget(
                            maxLines: 1,
                            editCtrller: _descriptionCtrller,
                            hintText: 'Description',
                            textColor: AppColors.kWhiteColor,
                            backColor: AppColors.kTextFormWhiteColor,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            maxLines: 1,
                            editCtrller: _addressCtrller,
                            hintText: 'Adresse',
                            textColor: AppColors.kWhiteColor,
                            backColor: AppColors.kTextFormWhiteColor,
                          ),
                        ),
                        Expanded(child: Consumer<AdminCaisseStateProvider>(
                            builder: (context, caisseProvider, _) {
                          return CustomButton(
                            text: 'Enregistrer',
                            backColor: AppColors.kYellowColor,
                            textColor: AppColors.kWhiteColor,
                            callback: () {
                              Map data = {
                                if (widget.updatingData == true)
                                  "id": widget.branch!['id'].toString(),
                                "name": _nameCtrller.text.trim(),
                                "description": _descriptionCtrller.text.trim(),
                                "location": _addressCtrller.text.trim(),
                                "statusActive": "1",
                                "users_id": Provider.of<UserStateProvider>(
                                        context,
                                        listen: false)
                                    .clientData!
                                    .id!
                                    .toString(),
                              };
                              caisseProvider.saveBranch(
                                  branch: data,
                                  updatingData: widget.updatingData,
                                  callback: () {
                                    _nameCtrller.text = "";
                                    _descriptionCtrller.text = "";
                                    _addressCtrller.text = "";
                                    Navigator.pop(context);
                                  });
                            },
                          );
                        }))
                      ]),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}

class DisplayBranchPage extends StatelessWidget {
  const DisplayBranchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Container(
        //         alignment: Alignment.centerRight,
        //         child: IconButton(
        //             onPressed: () {
        //               Provider.of<AdminCaisseStateProvider>(context,
        //                       listen: false)
        //                   .getBranches(isRefresh: true);
        //             },
        //             icon: Icon(Icons.autorenew, color: AppColors.kBlackColor))),
        //   ],
        // ),
        Consumer<AdminCaisseStateProvider>(
          builder: (context, caisseProvider, child) {
            return caisseProvider.branches.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: caisseProvider.branches.length,
                            itemBuilder: (context, int index) {
                              return ListItem(
                                  data: caisseProvider.branches[index]);
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
                            Provider.of<AdminCaisseStateProvider>(context,
                                    listen: false)
                                .getBranches(isRefresh: true);
                          }),
                    ),
                  ]);
          },
        ),
      ],
    );
  }
}

class ListItem extends StatefulWidget {
  final Map data;

  const ListItem({Key? key, required this.data}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  // Color borderColor = AppColors.kTransparentColor;
  bool isViewingMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Center(
                          child: Container(
                        width: Responsive.isWeb(context)
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width - 40,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * .50),
                        child: CreateBranchPage(
                          branch: widget.data,
                          updatingData: true,
                        ),
                      )));
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
                      color: AppColors.kBlackColor.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(Icons.short_text_sharp,
                              color: AppColors.kBlackColor, size: 30)),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => Center(
                                      child: DynamicHistoryTransList(
                                    activities:
                                        Provider.of<AdminUserStateProvider>(
                                                context,
                                                listen: false)
                                            .activitiesdata,
                                    branch: widget.data,
                                  )));
                        },
                        icon:
                            Icon(Icons.list_alt, color: AppColors.kBlackColor)),
                    title: TextWidgets.textBold(
                        overflow: TextOverflow.ellipsis,
                        title: widget.data['name'].toString().toUpperCase(),
                        fontSize: 14,
                        textColor: AppColors.kBlackColor),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextWidgets.text300(
                              overflow: TextOverflow.ellipsis,
                              title: widget.data['description'].toString(),
                              fontSize: 12,
                              textColor: AppColors.kBlackColor),
                          const SizedBox(height: 8),
                          TextWidgets.text300(
                              overflow: TextOverflow.ellipsis,
                              title: widget.data['location'].toString(),
                              fontSize: 12,
                              textColor: AppColors.kGreyColor),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
