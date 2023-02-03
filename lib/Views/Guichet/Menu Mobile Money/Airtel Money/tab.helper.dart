import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';

class TabHelperWidget extends StatefulWidget {
  List<String> tabs;
  String title;
  String? activeTab;
  Color? tabBackColor, backColor, activeColor, textColor, inactiveTextColor;
  Function callback;
  TabHelperWidget(
      {Key? key,
      this.title = '',
      required this.tabs,
      this.tabBackColor = Colors.transparent,
      this.backColor = Colors.transparent,
      this.activeColor = Colors.white,
      this.textColor = Colors.black,
      this.inactiveTextColor = Colors.grey,
      required this.callback,
      this.activeTab})
      : super(key: key);

  @override
  State<TabHelperWidget> createState() => _TabHelperWidgetState();
}

class _TabHelperWidgetState extends State<TabHelperWidget> {
  @override
  void initState() {
    // print(widget.activeTab);
    activeTab = widget.activeTab ?? widget.tabs[0];
    super.initState();
  }

  String activeTab = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidgets.textBold(
            title: widget.title,
            fontSize: 12,
            textColor: AppColors.kWhiteColor),
        const SizedBox(width: 8),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            decoration: BoxDecoration(
                color: widget.tabBackColor,
                borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                      widget.tabs.length,
                      (index) => GestureDetector(
                            onTap: () {
                              activeTab = widget.tabs[index];
                              widget.callback(widget.tabs[index]);
                              setState(() {});
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: activeTab == widget.tabs[index]
                                        ? widget.activeColor
                                        : widget.backColor),
                                child: TextWidgets.text500(
                                    title: widget.tabs[index].toUpperCase(),
                                    fontSize: 12,
                                    textColor: activeTab == widget.tabs[index]
                                        ? widget.textColor!
                                        : widget.inactiveTextColor!)),
                          ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
