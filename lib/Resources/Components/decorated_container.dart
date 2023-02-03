import 'package:flutter/material.dart';
import 'package:orion/Resources/global_variables.dart';

class DecoratedContainer extends StatelessWidget {
  final Color backColor;
  final Widget child;
  const DecoratedContainer(
      {Key? key, required this.backColor, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding / 2),
        color: backColor,
        // boxShadow: [
        //   BoxShadow(
        //       offset: const Offset(0, 0),
        //       color: backColor.withOpacity(0.2),
        //       blurRadius: 2,
        //       spreadRadius: 2)
        // ],
      ),
      child: child,
    );
  }
}
