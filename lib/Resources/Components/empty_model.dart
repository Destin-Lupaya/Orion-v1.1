import 'package:orion/Resources/Components/texts.dart';
import 'package:flutter/material.dart';

class EmptyModel extends StatelessWidget {
  final Color color;
  const EmptyModel({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.delete_outline_rounded, size: 40, color: color),
          const SizedBox(
            height: 20,
          ),
          TextWidgets.text300(
              title: 'No data found', fontSize: 18, textColor: color)
        ],
      ),
    );
  }
}
