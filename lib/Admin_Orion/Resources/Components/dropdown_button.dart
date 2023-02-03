import 'package:flutter/material.dart';

import '../../Resources/global_variables.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value, hintText;
  final List<String> items;
  Function callBack;
  Color? textColor = AppColors.kWhiteColor.withOpacity(0.2);
  Color? backColor = AppColors.kWhiteColor;
  CustomDropdownButton(
      {Key? key,
      required this.value,
      required this.hintText,
      required this.callBack,
      this.textColor,
      this.backColor,
      required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText ?? '',
            style: TextStyle(color: textColor),
          ),
          const SizedBox(
            height: 0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: backColor,
                borderRadius: BorderRadius.circular(kDefaultPadding / 4)),
            child: DropdownButton(
              dropdownColor: backColor,
              underline: Container(),
              isExpanded: true,
              items: items.map((element) {
                return DropdownMenuItem(
                  child: Text(
                    element,
                    style: TextStyle(color: textColor),
                  ),
                  value: element,
                );
              }).toList(),
              onChanged: (value) {
                callBack(value);
              },
              value: value,
            ),
          ),
        ],
      ),
    );
  }
}
