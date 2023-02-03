import 'package:flutter/material.dart';

class TextWidgets {
  static textWithLabel(
      {required String title,
      required double fontSize,
      required Color textColor,
      required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // width: double.maxFinite,
            padding: EdgeInsets.zero,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: fontSize, color: textColor.withOpacity(0.3)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            // width: double.maxFinite,
            padding: EdgeInsets.zero,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static textHorizontalWithLabel(
      {required String title,
      required double fontSize,
      required Color textColor,
      required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // width: double.maxFinite,
            padding: EdgeInsets.zero,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: fontSize, color: textColor.withOpacity(0.3)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            // width: double.maxFinite,
            padding: EdgeInsets.zero,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static textNormal(
      {required String title,
      required double fontSize,
      required Color textColor,
      TextAlign align = TextAlign.left}) {
    return Container(
      // width: double.maxFinite,
      padding: EdgeInsets.zero,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
    );
  }

  static text300(
      {required String title,
      required double fontSize,
      required Color textColor,
      TextAlign align = TextAlign.left}) {
    return Container(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.w300, color: textColor),
      ),
    );
  }

  static text500(
      {required String title,
      required double fontSize,
      required Color textColor,
      TextAlign align = TextAlign.left}) {
    return Container(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }

  static textBold(
      {required String title,
      required double fontSize,
      required Color textColor,
      TextAlign align = TextAlign.left}) {
    return Container(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        textAlign: align,
        style: TextStyle(
            fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
