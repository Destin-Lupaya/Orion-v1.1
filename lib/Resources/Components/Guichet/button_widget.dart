import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color backColor;
  final Color textColor;
  final VoidCallback onClicked;
  Function callback;
  Key? key;

  ButtonWidget({
    required this.text,
    required this.onClicked,
    required this.backColor,
    required this.textColor,
    required this.callback,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textColor: Colors.white,
        onPressed: () {
          callback();
        },
      );
}
