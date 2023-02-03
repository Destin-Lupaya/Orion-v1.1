import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {Key? key,
      required this.text,
      required this.backColor,
      required this.textColor,
      required this.callback,
      this.isEnabled,
      this.canSync = true})
      : super(key: key);

  final String text;
  final Color backColor;
  final Color textColor;
  bool? isEnabled = true, canSync = true;
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
        child:
            Consumer<adminAppStateProvider>(builder: (context, appProvider, _) {
          return (appProvider.isAsync == false && widget.canSync == true) ||
                  widget.canSync == false
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
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.kYellowColor),
                  ),
                );
        }),
      ),
    );
  }
}
