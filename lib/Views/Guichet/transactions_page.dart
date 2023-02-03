// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
// import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
// import 'package:orion/Resources/Components/Guichet/applogo_airtel.dart';
// import 'package:orion/Resources/Components/button.dart';
// import 'package:orion/Resources/Components/card.dart';
// import 'package:orion/Resources/Components/modal_progress.dart';
// import 'package:orion/Resources/Components/radio_button.dart';
// import 'package:orion/Resources/Components/searchable_textfield.dart';
// import 'package:orion/Resources/Components/text_fields.dart';
// import 'package:orion/Resources/Components/texts.dart';
// import 'package:orion/Resources/global_variables.dart';
// import 'package:orion/Resources/responsive.dart';
// import 'package:provider/provider.dart';
//
// //import "package:dialog/~file~";
// blockSeparator({required String title}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(),
//       const SizedBox(
//         height: 20,
//       ),
//       TextWidgets.text500(
//           title: title, fontSize: 14, textColor: AppColors.kGreenColor),
//     ],
//   );
// }
//
// class SortiAirtelmoneyPage extends StatefulWidget {
//   final bool updatingData;
//   final Map accountData;
//   final Map activityData;
//   final String typeOperation;
//   SortiAirtelmoneyPage(
//       {Key? key,
//       required this.updatingData,
//       required this.accountData,
//       required this.activityData,
//       required this.typeOperation})
//       : super(key: key);
//
//   @override
//   State<SortiAirtelmoneyPage> createState() => _SortiAirtelmoneyPageState();
// }
//
// class _SortiAirtelmoneyPageState extends State<SortiAirtelmoneyPage> {
//   List<String> deviseModeList = ["USD", "CDF"];
//   late String deviseMode = "USD";
//
//   List<String> typetransactionModeList = ["Cash", "Virtuel"];
//   late String typetransactionMode = "Virtuel";
//
//   List<String> typeoperationModeList = ["Depot", "Retrait"];
//   late String typeoperationMode = "Depot";
//
//   List<String> alertList = ["Prevention", "Rupture de stock", "Urgence"];
//   late String alertMode = "Prevention";
//
//   String? nomMembre;
//   final ScrollController _controller = ScrollController();
//   final TextEditingController _nomCtrller = TextEditingController();
//   final TextEditingController _commentCtrller = TextEditingController();
//   final TextEditingController _montantCtrller = TextEditingController();
//   final TextEditingController _pswCtrller = TextEditingController();
//   final FocusNode node1 = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         color: AppColors.kTransparentColor,
//         child: Container(
//
//             // padding: const EdgeInsets.symmetric(horizontal: 10),
//             width: Responsive.isMobile(context)
//                 ? MediaQuery.of(context).size.width
//                 : MediaQuery.of(context).size.width / 2,
//             height: MediaQuery.of(context).size.height * .85,
//             // color: AppColors.kBlackLightColor,
//             child: Consumer<AppStateProvider>(
//                 builder: (context, appStateProvider, _) {
//               return ModalProgress(
//                 isAsync: appStateProvider.isAsync,
//                 progressColor: AppColors.kYellowColor,
//                 child: ListView(
//                   // shrinkWrap: true,
//                   // physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     CardWidget(
//                         backColor: AppColors.kBlackLightColor,
//                         title: widget.typeOperation.toUpperCase(),
//                         content: Column(
//                           children: [
//                             const AppLogo(size: Size(100, 100)),
//                             Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   // blockSeparator(title: 'Type Approvisionnement'),
//                                   Card(
//                                       child: Column(
//                                     children: [
//                                       blockSeparator(title: 'Type Transaction'),
//                                       Wrap(
//                                           direction: Axis.horizontal,
//                                           children: List.generate(
//                                               typetransactionModeList.length,
//                                               (index) => CustomRadioButton(
//                                                   textColor:
//                                                       AppColors.kBlackColor,
//                                                   value: typetransactionMode ==
//                                                           typetransactionModeList[
//                                                                   index]
//                                                               .toString()
//                                                       ? true
//                                                       : false,
//                                                   label:
//                                                       typetransactionModeList[
//                                                               index]
//                                                           .toString(),
//                                                   callBack: () {
//                                                     typetransactionMode =
//                                                         typetransactionModeList[
//                                                             index];
//                                                     setState(() {});
//                                                   }))),
//                                     ],
//                                   )),
//                                   // blockSeparator(title: 'Type Devise'),
//                                   widget.typeOperation.toLowerCase()=='demande'?
//                                   Card(
//                                     child: Column(
//                                       children: [
//                                         blockSeparator(title: "Type d'alerte"),
//                                         Wrap(
//                                             direction: Axis.horizontal,
//                                             children: List.generate(
//                                                 alertList.length,
//                                                     (index) => CustomRadioButton(
//                                                     textColor:
//                                                     AppColors.kBlackColor,
//                                                     value: alertMode ==
//                                                         alertList[
//                                                         index]
//                                                             .toString()
//                                                         ? true
//                                                         : false,
//                                                     label: alertList[index]
//                                                         .toString(),
//                                                     callBack: () {
//                                                       alertMode =
//                                                       alertList[index];
//                                                       setState(() {});
//                                                     }))),
//                                       ],
//                                     ),
//                                   ):Card(
//                                     child: Column(
//                                       children: [
//                                         blockSeparator(title: 'Type Devise'),
//                                         Wrap(
//                                             direction: Axis.horizontal,
//                                             children: List.generate(
//                                                 deviseModeList.length,
//                                                     (index) => CustomRadioButton(
//                                                     textColor:
//                                                     AppColors.kBlackColor,
//                                                     value: deviseMode ==
//                                                         deviseModeList[
//                                                         index]
//                                                             .toString()
//                                                         ? true
//                                                         : false,
//                                                     label: deviseModeList[index]
//                                                         .toString(),
//                                                     callBack: () {
//                                                       deviseMode =
//                                                       deviseModeList[index];
//                                                       setState(() {});
//                                                     }))),
//                                       ],
//                                     ),
//                                   ),
//                                   //blockSeparator(title: 'Niveau Alert'),
//                                   widget.typeOperation.toLowerCase()!='demande'?Card(
//                                     child: Column(
//                                       children: [
//                                         blockSeparator(title: 'Type Operation'),
//                                         Wrap(
//                                             direction: Axis.horizontal,
//                                             children: List.generate(
//                                                 typeoperationModeList.length,
//                                                 (index) => CustomRadioButton(
//                                                     textColor:
//                                                         AppColors.kBlackColor,
//                                                     value: typeoperationMode ==
//                                                             typeoperationModeList[
//                                                                     index]
//                                                                 .toString()
//                                                         ? true
//                                                         : false,
//                                                     label:
//                                                         typeoperationModeList[
//                                                                 index]
//                                                             .toString(),
//                                                     callBack: () {
//                                                       typeoperationMode =
//                                                           typeoperationModeList[
//                                                               index];
//                                                       setState(() {});
//                                                     }))),
//                                       ],
//                                     ),
//                                   ):Container(),
//                                 ]),
//                             blockSeparator(title: 'Coordonnees du Fournisseur'),
//                             Row(children: [
//                               Expanded(
//                                 child: SearchableTextFormFieldWidget(
//                                   hintText: 'Numero Beneficiaire',
//                                   textColor: AppColors.kWhiteColor,
//                                   backColor: AppColors.kTextFormWhiteColor,
//                                   editCtrller: _nomCtrller,
//                                   maxLines: 1,
//                                   callback: (value) {
//                                     nomMembre = value.toString();
//                                     setState(() {});
//                                   },
//                                   //data: Provider.of<AppStateProvider>(context)
//                                   data: Provider.of<UserStateProvider>(context)
//                                       // .membreInscrit,
//                                       .usersData,
//                                   displayColumn: "telephone",
//                                   indexColumn: "telephone",
//                                   secondDisplayColumn: "fname",
//                                 ),
//                               )
//                             ]),
//                             TextFormFieldWidget(
//                                 backColor: AppColors.kTextFormBackColor,
//                                 hintText: 'Ref (Commentaire)',
//                                 editCtrller: _commentCtrller,
//                                 textColor: AppColors.kWhiteColor,
//                                 maxLines: 1),
//                             TextFormFieldWidget(
//                                 backColor: AppColors.kTextFormBackColor,
//                                 hintText: 'Montant',
//                                 editCtrller: _montantCtrller,
//                                 textColor: AppColors.kWhiteColor,
//                                 maxLines: 1),
//                             Consumer<UserStateProvider>(
//                                 builder: (context, userStateProvider, _) {
//                               return CustomButton(
//                                 backColor: AppColors.kYellowColor,
//                                 text: 'Valider',
//                                 textColor: AppColors.kBlackColor,
//                                 callback: () {
//                                   // onPressed:
//                                   // () {
//                                   if (_nomCtrller.text.isEmpty ||
//                                       _montantCtrller.text.isEmpty) {
//                                     return
//                                         //
//                                         showDialog<void>(
//                                       context: context,
//                                       barrierDismissible:
//                                           false, // user must tap button!
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           title: const Text('Champs vide'),
//                                           content: SingleChildScrollView(
//                                             child: ListBody(
//                                               children: const <Widget>[
//                                                 Text(
//                                                     'Le numero de telephone et le montant sont obligatoire'),
//                                                 Text(
//                                                     'Veillez remplir tous les champs?'),
//                                               ],
//                                             ),
//                                           ),
//                                           actions: <Widget>[
//                                             TextButton(
//                                               child: const Text('Fermer'),
//                                               onPressed: () {
//                                                 Navigator.of(context).pop();
//                                               },
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   }
//                                   return showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                             content: Container(
//                                                 padding: EdgeInsets.all(5),
//                                                 width: double.minPositive,
//                                                 height: 100,
//                                                 child: Column(
//                                                   children: [
//                                                     TextFormFieldWidget(
//                                                         focusNode: node1,
//                                                         backColor: AppColors
//                                                             .kTextFormBackColor,
//                                                         hintText: 'PIN',
//                                                         editCtrller:
//                                                             _pswCtrller,
//                                                         textColor: AppColors
//                                                             .kBlackColor,
//                                                         //
//                                                         maxLines: 1)
//                                                   ],
//                                                 )),
//                                             actions: [
//                                               ElevatedButton(
//                                                   onPressed: () {
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: Text('Annuler')),
//                                               ElevatedButton(
//                                                   onPressed: () async {
//                                                     if (_pswCtrller
//                                                         .text.isEmpty) {
//                                                       return
//                                                           //  Message.showToast(
//                                                           //     msg:
//                                                           //         'Veuillez entre un code PIN');
//                                                           showDialog(
//                                                               context: context,
//                                                               builder: (BuildContext
//                                                                       context) =>
//                                                                   new AlertDialog(
//                                                                     title: new Text(
//                                                                         'Warning'),
//                                                                     content:
//                                                                         new Text(
//                                                                             'Veuillez entre un code PIN'),
//                                                                     actions: <
//                                                                         Widget>[
//                                                                       new IconButton(
//                                                                           icon: new Icon(Icons
//                                                                               .close),
//                                                                           onPressed:
//                                                                               () {
//                                                                             Navigator.pop(context);
//                                                                           })
//                                                                     ],
//                                                                   ));
//                                                     }
//                                                     if (_pswCtrller.text !=
//                                                         "1234") {
//                                                       return
//                                                           //  Message.showToast(
//                                                           //     msg:
//                                                           //         'Code PIN incorrect');
//                                                           showDialog(
//                                                               context: context,
//                                                               builder: (BuildContext
//                                                                       context) =>
//                                                                   new AlertDialog(
//                                                                     title: new Text(
//                                                                         'Warning'),
//                                                                     content:
//                                                                         new Text(
//                                                                             'Code PIN incorrect'),
//                                                                     actions: <
//                                                                         Widget>[
//                                                                       new IconButton(
//                                                                           icon: new Icon(Icons
//                                                                               .close),
//                                                                           onPressed:
//                                                                               () {
//                                                                             Navigator.pop(context);
//                                                                           })
//                                                                     ],
//                                                                   ));
//                                                     }
//                                                     if (double.parse(
//                                                                 _montantCtrller
//                                                                     .text
//                                                                     .trim()) >
//                                                             double.parse(widget
//                                                                 .activityData[
//                                                                     'virtual_usd']
//                                                                 .toString()
//                                                                 .trim()) &&
//                                                         deviseMode
//                                                                 .toLowerCase() ==
//                                                             'usd') {
//                                                       return Message.showToast(
//                                                           msg:
//                                                               "Solde insuffisant");
//                                                     }
//                                                     if (double.parse(
//                                                                 _montantCtrller
//                                                                     .text
//                                                                     .trim()) >
//                                                             double.parse(widget
//                                                                 .activityData[
//                                                                     'virtual_cdf']
//                                                                 .toString()
//                                                                 .trim()) &&
//                                                         deviseMode
//                                                                 .toLowerCase() ==
//                                                             'cdf') {
//                                                       return Message.showToast(
//                                                           msg:
//                                                               "Solde insuffisant");
//                                                     }
//                                                     Navigator.pop(context);
//                                                     String uuid =
//                                                         "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
//                                                     Map data = {
//                                                       "sender": "Julio",
//                                                       "receiver":
//                                                           nomMembre!.trim(),
//                                                       "refkey": uuid,
//                                                       "dateTrans":
//                                                           DateTime.now()
//                                                               .toString()
//                                                               .substring(0, 10),
//                                                       "amount": double.parse(
//                                                               _montantCtrller
//                                                                   .text
//                                                                   .trim())
//                                                           .toStringAsFixed(3),
//                                                       "type_operation":
//                                                           typeoperationMode,
//                                                       "type_devise": deviseMode,
//                                                       "type_transaction":
//                                                           typetransactionMode,
//                                                       "account_id": "1",
//                                                       "account_activity_id":
//                                                           widget.activityData[
//                                                                   'activity_id']
//                                                               .toString(),
//                                                       "demands_id": null,
//                                                       "users_id": "1"
//                                                     };
//                                                     userStateProvider
//                                                         .envoiVirtuel3check(
//                                                             montant: double.parse(
//                                                                 _montantCtrller
//                                                                     .text
//                                                                     .trim()),
//                                                             devise: deviseMode,
//                                                             typeTransaction:
//                                                                 typetransactionMode,
//                                                             typeoperation:
//                                                                 typeoperationMode,
//                                                             body: data,
//                                                             context: context,
//                                                             callback: () {
//                                                               Navigator.pop(
//                                                                   context);
//                                                             });
//                                                   },
//                                                   child: Text('Confirmer')),
//                                             ],
//                                           ));
//                                   // }
//                                 },
//                               );
//                             })
//                           ],
//                         ))
//                   ],
//                 ),
//               );
//             })));
//     //     ),
//     //   ),
//     // );
//   }
// }
