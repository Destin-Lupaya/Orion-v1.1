import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/search_textfield.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';

class TitleBarWidget extends StatelessWidget {
  TextEditingController searchCtrller;
  Function callback;
  final String title;
  TitleBarWidget(
      {Key? key,
      required this.searchCtrller,
      required this.title,
      required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: Flex(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          direction:
              Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets.textBold(
                    title: title.toUpperCase(),
                    fontSize: 22,
                    textColor: AppColors.kBlackColor),
                const SizedBox(
                  height: 8,
                ),
                TextWidgets.text300(
                    title: "List des ${title.toLowerCase()} disponibles",
                    fontSize: 16,
                    textColor: AppColors.kBlackColor),
                // SearchTextFormFieldWidget(
                //     hintText: 'Recherchez ici...',
                //     textColor: AppColors.kBlackColor,
                //     backColor: AppColors.kTextFormBackColor,
                //     editCtrller: searchCtrller,
                //     maxLines: 1),
              ],
            ),
            // const SizedBox(width: 32, height: 16),
            IconButton(
                onPressed: () {
                  callback();
                },
                icon: Icon(Icons.autorenew))
          ],
        ));
  }
}
