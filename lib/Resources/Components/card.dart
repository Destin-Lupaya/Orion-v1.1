import '../../Resources/Components/texts.dart';
import '../../Resources/global_variables.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final Widget content;
  Color? backColor = AppColors.kBlackColor.withOpacity(0.4);

  CardWidget(
      {Key? key, required this.title, required this.content, this.backColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidgets.textBold(
                title: title, fontSize: 18, textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: kDefaultPadding,
                  top: kDefaultPadding / 2,
                  right: kDefaultPadding / 2,
                  bottom: kDefaultPadding / 2),
              width: double.maxFinite,
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
