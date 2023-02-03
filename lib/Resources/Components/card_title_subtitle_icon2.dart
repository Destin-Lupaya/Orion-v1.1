import 'package:orion/Resources/Components/texts.dart';
import 'package:flutter/material.dart';
import 'package:orion/Resources/global_variables.dart';

class CardWithIconTitleSubtitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String title2;
  final String title3;
  final String subtitle;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final String subtitle4;
  final String subtitle5;
  final String subtitle6;
  final String subtitle7;
  final Widget page;
  //final Widget image;
  //final Widget cardStatsWidget;
  final Color iconColor, titleColor, subtitleColor;
  final double width;
  final Map balance;
  CardWithIconTitleSubtitle(
      {Key? key,
      required this.icon,
      required this.title,
      required this.title2,
      required this.title3,
      required this.subtitle,
      required this.subtitle1,
      required this.subtitle2,
      required this.subtitle4,
      required this.subtitle3,
      required this.subtitle5,
      required this.subtitle6,
      required this.subtitle7,
      required this.page,
      // required this.image,
      //required this.cardStatsWidget,
      required this.iconColor,
      required this.titleColor,
      required this.subtitleColor,
      required this.width,
      required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            color: titleColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            //image,
            //cardStatsWidget,
            Icon(icon, color: iconColor, size: 50),
            const SizedBox(height: 20),
            TextWidgets.textBold(
                align: TextAlign.center,
                title: title,
                fontSize: 20,
                textColor: titleColor),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: [],
                ),
                Column(
                  children: [],
                )
              ],
            ),

            TextWidgets.text300(
                align: TextAlign.center,
                title: subtitle,
                fontSize: 16,
                textColor: subtitleColor),
            Row(
              children: [
                Column(
                  children: [
                    TextWidgets.textBold(
                        align: TextAlign.center,
                        title: title2,
                        fontSize: 11,
                        textColor: AppColors.kGreenColor.withOpacity(0.5)),
                    const SizedBox(height: 11),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle2,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle3,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle4,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: balance['virtuel_CDF'],
                        fontSize: 16,
                        textColor: subtitleColor),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: balance['virtuel_USD'],
                        fontSize: 16,
                        textColor: subtitleColor),
                  ],
                ),
                Column(
                  children: [
                    TextWidgets.textBold(
                        align: TextAlign.center,
                        title: title3,
                        fontSize: 11,
                        textColor: AppColors.kGreenColor.withOpacity(0.5)),
                    const SizedBox(height: 11),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle1,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle5,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle6,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: subtitle7,
                        fontSize: 16,
                        textColor: AppColors.kYellowColor.withOpacity(0.5)),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: balance['cash_CDF'],
                        fontSize: 16,
                        textColor: subtitleColor),
                    TextWidgets.text300(
                        align: TextAlign.center,
                        title: balance['cash_USD'],
                        fontSize: 16,
                        textColor: subtitleColor),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                Column(
                  children: [],
                ),
                Column(
                  children: [],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
