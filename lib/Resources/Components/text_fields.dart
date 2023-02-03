import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Resources/global_variables.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final Color textColor;
  final Color backColor;
  final bool? isEnabled;
  bool? isObsCured;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

  final TextEditingController editCtrller;
  TextInputType inputType = TextInputType.text;
  int maxLines = 1;
  var maxLength = null;
  TextFormFieldWidget(
      {Key? key,
      required this.hintText,
      required this.textColor,
      required this.backColor,
      required this.editCtrller,
      TextInputType? inputType,
      maxLength,
      this.isEnabled,
      this.isObsCured,
      this.focusNode,
      this.keyboardType,
      this.decoration,
      this.textInputAction,
      required this.maxLines});

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hintText,
            style: TextStyle(color: widget.textColor.withOpacity(0.7)),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: widget.backColor,
                borderRadius: BorderRadius.circular(kDefaultPadding / 4)),
            child: Stack(
              children: [
                TextFormField(
                  enabled: widget.isEnabled != null ? widget.isEnabled! : true,
                  obscureText:
                      widget.isObsCured != null ? widget.isObsCured! : false,
                  maxLines: widget.maxLines,
                  style: TextStyle(color: widget.textColor),
                  textAlign: TextAlign.left,
                  controller: widget.editCtrller,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    hintText: widget.hintText,
                    hintStyle:
                        TextStyle(color: widget.textColor.withOpacity(0.5)),
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: widget.textColor, width: 3)),
                    // hintText: widget.hintText,
                    // hintStyle:
                    //     TextStyle(color: widget.textColor.withOpacity(0.5))
                  ),
                ),
                if (widget.isObsCured != null)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          widget.isObsCured = !widget.isObsCured!;
                          setState(() {});
                        },
                        child: Center(
                          child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: widget.textColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPadding / 4)),
                              child: Icon(
                                  widget.isObsCured != null &&
                                          widget.isObsCured == false
                                      ? Icons.vpn_key_rounded
                                      : Icons.remove_red_eye,
                                  color: widget.textColor,
                                  size: 20)),
                        ),
                      ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextFormVerification extends StatefulWidget {
  final String hintText;
  final Color textColor;
  final Color backColor;
  final TextEditingController editCtrller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  int maxLines = 1;
  TextFormVerification(
      {Key? key,
      required this.hintText,
      required this.textColor,
      required this.backColor,
      required this.editCtrller,
      this.focusNode,
      this.keyboardType,
      this.decoration,
      this.textInputAction,
      required this.maxLines});

  @override
  _TextFormVerificationState createState() => _TextFormVerificationState();
}

class _TextFormVerificationState extends State<TextFormVerification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 5),
            decoration: BoxDecoration(
                color: widget.backColor,
                borderRadius: BorderRadius.circular(kDefaultPadding / 4)),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              obscureText: false,
              maxLines: widget.maxLines,
              style: TextStyle(color: widget.textColor),
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                // contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: widget.textColor.withOpacity(0.5)),
                // border: UnderlineInputBorder(
                //     borderSide: BorderSide(color: widget.textColor, width: 1)),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: widget.textColor, width: 3)),
                // hintText: widget.hintText,
                // hintStyle:
                //     TextStyle(color: widget.textColor.withOpacity(0.5))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
