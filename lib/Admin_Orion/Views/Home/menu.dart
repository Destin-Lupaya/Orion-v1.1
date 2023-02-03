import 'package:orion/Admin_Orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/menu_state_provider.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

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
          child: Column(
            children: [
              Expanded(
                child: Consumer<AdminMenuStateProvider>(
                    builder: (context, menuStateProvider, child) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: menuStateProvider.menu.length,
                      itemBuilder: (context, int index) {
                        return MenuItem(
                            title: menuStateProvider.menu[index].title,
                            icon: menuStateProvider.menu[index].icon,
                            textColor: AppColors.kBlackLightColor,
                            backColor: Colors.white);
                      });
                }),
              ),
              GestureDetector(
                onTap:(){
                  Provider.of<adminAppStateProvider>(navKey.currentContext!, listen:false).logOut(context: context);
                },
                child: Container(
                  color:Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color:AppColors.kWhiteColor,
                        ),
                        const SizedBox(width: 16.0),
                        Container(
                            padding: EdgeInsets.zero,
                            child: Text(
                              "Deconnexion",
                              style: TextStyle(
                                  color: AppColors.kWhiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class MenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  Color textColor;
  Color backColor;
  MenuItem(
      {required this.title,
      required this.icon,
      required this.backColor,
      required this.textColor});

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isButtonHovered = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminMenuStateProvider>(
        builder: (context, menuStateProvider, child) {
      return GestureDetector(
        onTap: () {
          menuStateProvider.changeMenu(newMenuValue: widget.title);
          if (!Responsive.isWeb(context)) {
            Navigator.pop(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            color:
                menuStateProvider.currentMenu == widget.title || isButtonHovered
                    ? widget.textColor
                    : widget.backColor,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            widget.icon,
                            color:
                                menuStateProvider.currentMenu == widget.title ||
                                        isButtonHovered
                                    ? widget.backColor
                                    : widget.textColor,
                          ),
                          const SizedBox(width: 16.0),
                          Container(
                              padding: EdgeInsets.zero,
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                    color: menuStateProvider.currentMenu ==
                                                widget.title ||
                                            isButtonHovered
                                        ? widget.backColor
                                        : widget.textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2,
                      color: Colors.black45,
                      thickness: 1,
                    )
                  ],
                ),
                // Positioned(
                //     top: 0,
                //     bottom: 0,
                //     right: -12,
                //     child: Align(
                //       alignment: Alignment.center,
                //       child: Icon(
                //         Icons.arrow_left_outlined,
                //         color: AppColors.kBlackColor,
                //         size: 30,
                //       ),
                //     ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
