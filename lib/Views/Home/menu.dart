import 'package:orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../Resources/global_variables.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: AppColors.kBlackColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Consumer<MenuStateProvider>(
              builder: (context, menuStateProvider, child) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: menuStateProvider.menu.length,
                itemBuilder: (context, int index) {
                  return MenuItem(
                      title: menuStateProvider.menu[index].title,
                      action: menuStateProvider.menu[index].action,
                      icon: menuStateProvider.menu[index].icon,
                      textColor: AppColors.kBlackLightColor,
                      hoverColor: AppColors.kYellowColor,
                      backColor: Colors.white);
                });
          })),
    );
  }
}

class MenuItem extends StatefulWidget {
  final String title;
  final String? action;
  final IconData icon;
  Color textColor;
  Color hoverColor;
  Color backColor;
  MenuItem(
      {required this.title,
      required this.icon,
      required this.backColor,
      required this.hoverColor,
      required this.textColor,
      this.action});

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isButtonHovered = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<MenuStateProvider>(
        builder: (context, menuStateProvider, child) {
      return GestureDetector(
        onTap: () {
          if (widget.action == null) {
            menuStateProvider.changeMenu(newMenuValue: widget.title);
            if (!Responsive.isWeb(context)) {
              Navigator.pop(context);
            }
          } else if (widget.action != null &&
              widget.action!.toLowerCase() == 'replace') {
            Navigation.pushReplaceNavigate(
                context: context,
                page: menuStateProvider.menu
                    .where((menu) {
                      return menu.title.toLowerCase() ==
                          widget.title.toLowerCase();
                    })
                    .toList()[0]
                    .page);
          }
        },
        child: MouseRegion(
          // cursor: MouseCursor.,
          onHover: (value) => setState(() {
            isButtonHovered = true;
          }),
          onEnter: (value) => setState(() {
            isButtonHovered = true;
          }),
          onExit: (value) => setState(() {
            isButtonHovered = false;
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            decoration: BoxDecoration(
              color: menuStateProvider.currentMenu == widget.title
                  ? AppColors.kWhiteColor.withOpacity(0.10)
                  : widget.backColor,
              // borderRadius: BorderRadius.circular(10),
            ),
            // menuStateProvider.currentMenu == widget.title || isButtonHovered
            //     ? widget.textColor
            //     : widget.backColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(Responsive.isMobile(context)) Icon(
                        widget.icon,
                        color: menuStateProvider.currentMenu == widget.title ||
                                isButtonHovered
                            ? widget.hoverColor
                            : widget.textColor,
                      ),
                      if(Responsive.isMobile(context))const SizedBox(width: 16.0),
                      Container(
                          padding: EdgeInsets.zero,
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                color: menuStateProvider.currentMenu ==
                                            widget.title ||
                                        isButtonHovered
                                    ? widget.hoverColor
                                    : widget.textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                // const Divider(
                //   height: 2,
                //   color: Colors.black45,
                //   thickness: 1,
                // )
              ],
            ),
          ),
        ),
      );
    });
  }
}
