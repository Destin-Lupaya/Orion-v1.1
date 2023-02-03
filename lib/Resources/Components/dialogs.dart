import 'package:flutter/cupertino.dart';
import 'package:orion/Resources/Components/applogo.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:flutter/material.dart';
import 'package:orion/main.dart';

class Dialogs {
  static showDialogNoAction(
      {required BuildContext context,
      required String title,
      required String content,
      double heightFactor = 2}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height /
                      (heightFactor == 2 ? 2 : heightFactor),
                  width: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width - 100
                      : MediaQuery.of(context).size.width / 2.5,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0,
                            top: 20.0 + 16.0,
                            right: 16.0,
                            bottom: 16.0),
                        margin: const EdgeInsets.only(top: 50.0, bottom: 50),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColors.kWhiteColor,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 5),
                            ]),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            TextWidgets.textBold(
                                align: TextAlign.center,
                                title: title,
                                fontSize: 18,
                                textColor: AppColors.kBlackColor),
                            const SizedBox(
                              height: 15,
                            ),
                            Expanded(
                                child: ListView(
                              children: [
                                Row(
                                  children: [
                                    Container(width: double.maxFinite)
                                  ],
                                ),
                                TextWidgets.text300(
                                    title: content,
                                    fontSize: 14,
                                    textColor: AppColors.kBlackColor),
                              ],
                            )),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                      callback: () async {
                                        Navigator.pop(context);
                                      },
                                      text: "Fermer",
                                      backColor: AppColors.kYellowColor,
                                      textColor: AppColors.kBlackColor),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 50,
                        right: 50,
                        top: 0,
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: AppColors.kWhiteColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: const AppLogo(size: const Size(80, 80)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  static showChoiceDialog(
      {BuildContext? context,
      required String title,
      required Widget content,
      double heightFactor = 2,
      var callback}) {
    return showDialog(
        context: context ?? navKey.currentContext!,
        // barrierDismissible: true,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(0),
                // height: MediaQuery.of(context).size.height /
                //     (heightFactor == 2 ? 2 : heightFactor),
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.5,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      // margin: const EdgeInsets.only(top: 8.0, bottom: 50),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 1),
                                blurRadius: 5),
                          ]),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextWidgets.textBold(
                              align: TextAlign.center,
                              title: title,
                              fontSize: 18,
                              textColor: AppColors.kBlackColor),
                          const SizedBox(
                            height: 15,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [Row(), content],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  static showModal(
      {required String title, required Widget content, Color? backColor}) {
    return showCupertinoModalPopup(
        context: navKey.currentContext!,
        builder: (context) => Container(
              width: Responsive.isWeb(navKey.currentContext!)
                  ? MediaQuery.of(navKey.currentContext!).size.width / 2
                  : MediaQuery.of(navKey.currentContext!).size.width - 40,
              constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(navKey.currentContext!).size.height * .80),
              decoration: BoxDecoration(
                  color: AppColors.kTransparentColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Material(
                  color: backColor ?? AppColors.kBlackLightColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(keepScrollOffset: false),
                    child: content,
                  )),
            ));
  }

  static showNormalModal({required Widget content}) {
    return showDialog(
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        // barrierDismissible: true,
        context: navKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            elevation: 0,
            backgroundColor: AppColors.kTransparentColor,
            content: Container(
              width: Responsive.isWeb(navKey.currentContext!)
                  ? MediaQuery.of(navKey.currentContext!).size.width / 2
                  : MediaQuery.of(navKey.currentContext!).size.width - 40,
              constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(navKey.currentContext!).size.height * .80),
              decoration: BoxDecoration(
                  color: AppColors.kTransparentColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Material(
                  color: AppColors.kBlackLightColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(keepScrollOffset: false),
                    child: content,
                  )),
            ),
          );
        });
  }

  //
  // static showDialogWithAction(
  //     {required BuildContext context,
  //     required String title,
  //     required String content,
  //     required Function callback()}) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       child: Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //         child: Center(
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 2,
  //             child: Stack(
  //               children: <Widget>[
  //                 Container(
  //                   padding: EdgeInsets.only(
  //                       left: 16.0,
  //                       top: 20.0 + 16.0,
  //                       right: 16.0,
  //                       bottom: 16.0),
  //                   margin: EdgeInsets.only(top: 50.0, bottom: 50),
  //                   decoration: BoxDecoration(
  //                       shape: BoxShape.rectangle,
  //                       color: MyColors.whiteColor,
  //                       borderRadius: BorderRadius.circular(16.0),
  //                       boxShadow: [
  //                         BoxShadow(
  //                             color: Colors.black,
  //                             offset: Offset(0, 1),
  //                             blurRadius: 5),
  //                       ]),
  //                   child: Column(
  //                     children: <Widget>[
  //                       SizedBox(height: 20),
  //                       TextWidgets.textBoldCenter(
  //                           text: title,
  //                           size: 18,
  //                           textColor: MyColors.blackColor),
  //                       SizedBox(height: 10),
  //                       Expanded(
  //                           child: Center(
  //                         child: SingleChildScrollView(
  //                           child: Column(
  //                             children: [
  //                               Row(
  //                                 children: [
  //                                   Container(width: double.maxFinite)
  //                                 ],
  //                               ),
  //                               SizedBox(
  //                                 height: 15,
  //                               ),
  //                               TextWidgets.text300Center(
  //                                   text: content,
  //                                   size: 14,
  //                                   textColor: MyColors.blackColor),
  //                             ],
  //                           ),
  //                         ),
  //                       )),
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                             child: MyWidgets.buttonForm(
  //                                 callBack: () async {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 title: "Annuler",
  //                                 backColor: Colors.grey[200],
  //                                 textColor: MyColors.blackColor),
  //                           ),
  //                           SizedBox(width: 20),
  //                           Expanded(
  //                             child: MyWidgets.buttonForm(
  //                                 callBack: () async {
  //                                   callback();
  //                                 },
  //                                 title: "Continuer",
  //                                 backColor: MyColors.appColor,
  //                                 textColor: MyColors.whiteColor),
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Positioned(
  //                   left: 50,
  //                   right: 50,
  //                   top: 0,
  //                   child: Center(
  //                     child: Container(
  //                       width: 100,
  //                       height: 100,
  //                       padding: EdgeInsets.all(10.0),
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.rectangle,
  //                         color: MyColors.whiteColor,
  //                         borderRadius: BorderRadius.circular(100),
  //                       ),
  //                       alignment: Alignment.bottomCenter,
  //                       child: appLogo(width: 80, height: 80, isBlack: false),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }
  //
  static showDialogWithActionCustomContent(
      {required BuildContext context,
      required String title,
      required Widget content,
      double heightFactor = 2,
      required Function callback}) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                // height: MediaQuery.of(context).size.height /
                //     (heightFactor == 2 ? 2 : heightFactor),
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width - 100
                    : MediaQuery.of(context).size.width / 2.5,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 20.0 + 16.0,
                          right: 16.0,
                          bottom: 16.0),
                      margin: const EdgeInsets.only(top: 50.0, bottom: 0),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 1),
                                blurRadius: 5),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          TextWidgets.textBold(
                              align: TextAlign.center,
                              title: title,
                              fontSize: 18,
                              textColor: AppColors.kBlackColor),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            child: content,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                      callback: () async {
                                        Navigator.pop(context);
                                      },
                                      text: "Fermer",
                                      backColor: Colors.grey[200]!,
                                      textColor: AppColors.kBlackColor)),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomButton(
                                    callback: () async {
                                      callback();
                                    },
                                    text: "Continuer",
                                    backColor: AppColors.kYellowColor,
                                    textColor: AppColors.kBlackColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      left: 50,
                      right: 50,
                      top: 0,
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppColors.kWhiteColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: const AppLogo(size: Size(80, 80)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
