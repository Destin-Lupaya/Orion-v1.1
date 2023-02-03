import '../../../Resources/Components/texts.dart';
import '../../../Resources/global_variables.dart';
import 'package:flutter/material.dart';

class GraphStatsWidget extends StatelessWidget {
  const GraphStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets.textNormal(
                title: 'All expenses',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cardStatsWidget(
                    title: 'Weekly',
                    textColor: AppColors.kGreyColor,
                    backColor: AppColors.kBlackLightColor,
                    value: '10877',
                    currency: '\$'),
                cardStatsWidget(
                    title: 'Monthly',
                    textColor: AppColors.kGreyColor,
                    backColor: AppColors.kBlackLightColor,
                    value: '10877',
                    currency: '\$'),
                cardStatsWidget(
                    title: 'Yearly',
                    textColor: AppColors.kGreyColor,
                    backColor: AppColors.kBlackLightColor,
                    value: '10877',
                    currency: '\$'),
              ],
            )
          ],
        ),
      ),
    );
  }

  cardStatsWidget(
      {required String title,
      required Color textColor,
      required Color backColor,
      required String value,
      required String currency}) {
    return Expanded(
      child: Card(
        color: backColor,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgets.text300(
                          title: title, fontSize: 14, textColor: textColor),
                    ],
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextWidgets.textBold(
                      title: value, fontSize: 16, textColor: textColor),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidgets.textBold(
                      title: currency, fontSize: 16, textColor: textColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
