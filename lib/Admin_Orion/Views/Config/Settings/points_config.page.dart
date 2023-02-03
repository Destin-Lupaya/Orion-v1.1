import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/points.provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/points_config.model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/src/provider.dart';

class PointsConfigPage extends StatefulWidget {
  EnumActions? action;
  PointConfigModel? data;
  PointsConfigPage({Key? key, this.action = EnumActions.Save})
      : super(key: key);

  @override
  State<PointsConfigPage> createState() => _PointsConfigPageState();
}

class _PointsConfigPageState extends State<PointsConfigPage> {
  final TextEditingController _nameCtrller = TextEditingController(),
      _toUSDCtrller = TextEditingController(),
      _toCDFCtrller = TextEditingController();

  String? selectedName;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width / 2.3,
        // color: AppColors.kBlackLightColor,
        constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * .85),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidgets.textBold(
                        title: 'Configuration des points',
                        fontSize: 22,
                        textColor: AppColors.kBlackColor),
                    const SizedBox(height: 16),
                    CustomDropdownButton(
                        dropdownColor: AppColors.kWhiteColor,
                        backColor: AppColors.kTextFormBackColor,
                        value: selectedName,
                        hintText: 'Désignation',
                        callBack: (value) {
                          setState(() {
                            selectedName = value;
                          });
                        },
                        items: const ['Points', 'Commissions', 'Bonus']),
                    TextFormFieldWidget(
                        isEnabled: false,
                        maxLines: 1,
                        editCtrller: TextEditingController(
                            text: '1 ${selectedName ?? ""}'),
                        hintText: selectedName ?? "",
                        textColor: AppColors.kBlackColor,
                        backColor: AppColors.kTextFormBackColor),
                    TextFormFieldWidget(
                        maxLines: 1,
                        editCtrller: _toUSDCtrller,
                        hintText: 'Conversion en USD',
                        textColor: AppColors.kBlackColor,
                        backColor: AppColors.kTextFormBackColor),
                    TextFormFieldWidget(
                        maxLines: 1,
                        editCtrller: _toCDFCtrller,
                        hintText: 'Conversion en CDF',
                        textColor: AppColors.kBlackColor,
                        backColor: AppColors.kTextFormBackColor),
                    CustomButton(
                        text: 'Enregistrer',
                        backColor: AppColors.kGreenColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () {
                          if (selectedName == null ||
                              _toUSDCtrller.text.isEmpty ||
                              _toCDFCtrller.text.isEmpty) {
                            Message.showToast(
                                msg: 'Veuillez remplir tous les champs');
                            return;
                          }
                          if (double.tryParse(_toUSDCtrller.text.trim()) ==
                                  null ||
                              double.tryParse(_toCDFCtrller.text.trim()) ==
                                  null) {
                            Message.showToast(
                                msg:
                                    'Veuillez remplir des montant valides dans les champs de conversion');
                            return;
                          }
                          PointConfigModel data = PointConfigModel(
                              id: widget.data?.id,
                              name: selectedName!,
                              toUSD: double.parse(_toUSDCtrller.text.trim()),
                              toCDF: double.parse(_toCDFCtrller.text.trim()));
                          context
                              .read<PointsConfigProvider>()
                              .saveData(data: data, action: widget.action);
                        })
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
