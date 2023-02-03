import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:provider/provider.dart';

import '../../Resources/global_variables.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {Key? key,
      required this.text,
      required this.backColor,
      required this.textColor,
      required this.callback,
      this.isEnabled})
      : super(key: key);

  final String text;
  final Color backColor;
  final Color textColor;
  bool? isEnabled = true;
  Function callback;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isButtonHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isEnabled == false) {
          Message.showToast(
              msg:
                  "Vous n'avez les permissions nécessaires pour exécuter cette action");
          return;
        }
        widget.callback();
      },
      child: MouseRegion(
        onHover: (value) => setState(() {
          isButtonHovered = true;
        }),
        onEnter: (value) => setState(() {
          isButtonHovered = true;
        }),
        onExit: (value) => setState(() {
          isButtonHovered = false;
        }),
        child: Consumer<AppStateProvider>(builder: (context, appProvider, _) {
          return appProvider.isAsync == false
              ? Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2, vertical: 5),
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2, vertical: 10),
                  decoration: BoxDecoration(
                    color: isButtonHovered
                        ? widget.backColor.withOpacity(0.9)
                        : widget.backColor,
                    borderRadius: BorderRadius.circular(kDefaultPadding / 2),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                        color: widget.isEnabled == false
                            ? widget.textColor.withOpacity(0.3)
                            : isButtonHovered
                                ? widget.textColor.withOpacity(0.5)
                                : widget.textColor,
                        fontWeight: FontWeight.w300),
                  ))
              : Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(widget.backColor),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
