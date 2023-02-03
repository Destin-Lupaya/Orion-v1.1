import 'package:flutter/cupertino.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/theme_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/search_textfield.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/points_config.model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/theme.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Views/Config/Settings/points_config.page.dart';
import 'package:orion/Admin_Orion/Views/Config/User/create_user.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<PointsConfigProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(keepScrollOffset: false),
        child: Column(
          children: [
            CardWidget(
              title: 'Points',
              backColor: AppColors.kWhiteColor,
              titleColor: AppColors.kBlackColor,
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        child: SearchTextFormFieldWidget(
                            maxLines: 1,
                            editCtrller: TextEditingController(),
                            hintText: 'Recherchez...',
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor),
                      ),
                      IconButton(
                          onPressed: () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Center(child: PointsConfigPage());
                                });
                          },
                          icon: const Icon(
                            Icons.add,
                          ))
                    ],
                  ),
                  Selector<PointsConfigProvider, List<PointConfigModel>>(
                      builder: (_, dataList, __) {
                        return Container(
                          constraints: const BoxConstraints(
                              maxHeight: 300, minHeight: 20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    tileColor: Colors.grey.shade100,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      child: Icon(Icons.attach_money_outlined,
                                          color: AppColors.kBlackColor),
                                    ),
                                    title: TextWidgets.textBold(
                                        title: dataList[index].name,
                                        fontSize: 18,
                                        textColor: AppColors.kBlackColor),
                                    subtitle: TextWidgets.text300(
                                        title:
                                            "USD ${dataList[index].toUSD} - CDF ${dataList[index].toCDF}",
                                        fontSize: 12,
                                        textColor: AppColors.kBlackColor),
                                  ),
                                );
                              }),
                        );
                      },
                      selector: (_, provider) => provider.dataList)
                ],
              ),
            ),
            // CardWidget(
            //   backColor: AppColors.kBlackLightColor,
            //   title: 'Deconnexion',
            //   content: Consumer<adminAppStateProvider>(
            //     builder: (context, appStateProvider, child) {
            //       return Container(
            //         child: Column(
            //           children: [
            //             CustomButton(
            //                 text: 'Deconnecter mon compte',
            //                 backColor: AppColors.kRedColor,
            //                 textColor: AppColors.kWhiteColor,
            //                 callback: () {
            //                   appStateProvider.logOut(context: context);
            //                 })
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
