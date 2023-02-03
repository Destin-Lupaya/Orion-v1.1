import 'package:flutter/material.dart';
import 'package:orion/Resources/Components/texts.dart';

class CardWithIconTitleSubtitle extends StatelessWidget {
  //final IconData icon;
  final String title;
  final String title2;
  final String title3;
  final String subtitle;
  final String subtitle1;
  final String subtitle2;
  final Widget page;
  final Widget image;
  //final Widget cardStatsWidget;
  final Color iconColor, titleColor, subtitleColor, backColor;
  double? width;
  final Map balance;
  CardWithIconTitleSubtitle(
      {Key? key,
      //required this.icon,
      required this.title,
      required this.title2,
      required this.title3,
      required this.subtitle,
      required this.subtitle1,
      required this.subtitle2,
      required this.page,
      required this.image,
      //required this.cardStatsWidget,
      required this.backColor,
      required this.iconColor,
      required this.titleColor,
      required this.subtitleColor,
      this.width,
      required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
          color: backColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          image,
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgets.textBold(
                  align: TextAlign.center,
                  title: title,
                  fontSize: 18,
                  textColor: titleColor),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidgets.text300(
                          align: TextAlign.center,
                          title: subtitle2,
                          fontSize: 14,
                          textColor: subtitleColor.withOpacity(0.5)),
                      TextWidgets.text300(
                          align: TextAlign.center,
                          title: "CDF :${balance['virtuel_CDF']}",
                          fontSize: 14,
                          textColor: subtitleColor),
                      TextWidgets.text300(
                          align: TextAlign.center,
                          title: "USD :${balance['virtuel_USD']}",
                          fontSize: 14,
                          textColor: subtitleColor),
                      TextWidgets.text300(
                          align: TextAlign.center,
                          title: "Stock :${balance['stock']}",
                          fontSize: 14,
                          textColor: subtitleColor),
                    ],
                  ),
                  page
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
