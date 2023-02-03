import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final Size size;
  const AppLogo({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Image.asset("Assets/Images/Orion/ecobank.png"),
      ),
    );
  }
}
