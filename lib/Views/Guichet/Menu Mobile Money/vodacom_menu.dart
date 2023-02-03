// import 'package:andema/Resources/AppStateProvider/app_stateprovider.dart';
// import 'package:andema/Resources/AppStateProvider/user_stateprovider.dart';
// import 'package:andema/Resources/Components/button.dart';
// import 'package:andema/Resources/Components/search_textfield.dart';
// import 'package:andema/Resources/Components/card.dart';
// import 'package:andema/Resources/Components/card_title_subtitle_icon.dart';
// import 'package:andema/Resources/Components/dropdown_button.dart';
// import 'package:andema/Resources/Components/empty_model.dart';
// import 'package:andema/Resources/Components/modal_progress.dart';
// import 'package:andema/Views/Guichet/Menu Mobile Money/M-Pesa/receive_mpesa.dart';
// import 'package:andema/Views/Guichet/Menu Mobile Money/M-Pesa/send_mpesa.dart';
// import 'package:andema/Views/Guichet/Activites Bancaires/ecobank.dart';
// import 'package:andema/Resources/global_variables.dart';
// import 'package:andema/Resources/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/cupertino.dart';

// class AddMPesaPage extends StatefulWidget {
//   const AddMPesaPage({Key? key}) : super(key: key);

//   @override
//   State<AddMPesaPage> createState() => _AddMPesaPageState();
// }

// class _AddMPesaPageState extends State<AddMPesaPage> {
//   final TextEditingController _searchCtrller = TextEditingController();

//   String type = "En cours";

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.kTransparentColor,
//       child: Container(
//           // padding: const EdgeInsets.symmetric(horizontal: 10),
//           width: Responsive.isMobile(context)
//               ? MediaQuery.of(context).size.width
//               : MediaQuery.of(context).size.width / 2,
//           height: MediaQuery.of(context).size.height * .85,
//           // color: AppColors.kBlackLightColor,
//           child: Consumer<AppStateProvider>(
//               builder: (context, appStateProvider, child) {
//             return ModalProgress(
//               isAsync: appStateProvider.isAsync,
//               progressColor: AppColors.kYellowColor,
//               child: ListView(
//                 // shrinkWrap: false,
//                 // physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   CardWidget(
//                       backColor: AppColors.kBlackLightColor,
//                       title: 'Tout vos comptes au meme endroit',
//                       content: Column(
//                         children: [
//                           //Expanded(
//                           //child:
//                           // SearchTextFormFieldWidget(
//                           //     backColor: AppColors.kTextFormWhiteColor,
//                           //     hintText: 'Recherchez...',
//                           //     isObsCured: false,
//                           //     editCtrller: _searchCtrller,
//                           //     textColor: AppColors.kWhiteColor,
//                           //     maxLines: 1),
//                           //),
//                           CardWithIconTitleSubtitle(
//                               balance: {
//                                 "virtuel_CDF": "CDF: 100",
//                                 "virtuel_USD": "USD: 200",
//                                 "cash_CDF": "CDF: 300",
//                                 "cash_USD": "USD: 400"
//                               },
//                               width: !Responsive.isWeb(context)
//                                   ? double.maxFinite
//                                   : 300,
//                               //icon: Icons.attach_money,
//                               title: 'Transferez du cash',
//                               image:
//                                   Image.asset('Assets/Images/Orion/mpesa.png'),
//                               subtitle:
//                                   "Transferez de l'argent rapidement a vos clients ECOBANK avec Orion",
//                               title2: 'Compte 990268381 - Destin Kabote',
//                               title3: '',
//                               subtitle1: 'Soldes Cash',
//                               subtitle2: 'Soldes Virtuel',
//                               page: EnvoieMPesaPage(
//                                 updatingData: false,
//                               ),
//                               iconColor: AppColors.kYellowColor,
//                               titleColor: AppColors.kWhiteColor,
//                               subtitleColor: AppColors.kGreyColor),
//                           // Expanded(
//                           //     child:
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     showCupertinoModalPopup(
//                                         context: context,
//                                         builder: (context) {
//                                           return Center(
//                                             child: EnvoieMPesaPage(
//                                               updatingData: false,
//                                             ),
//                                           );
//                                         });
//                                   },
//                                   icon: Icon(
//                                     Icons.add_circle_outline,
//                                     color: AppColors.kYellowColor,
//                                   )),
//                             ],
//                           )
//                           //)
//                           ,
//                           CardWithIconTitleSubtitle(
//                               width: !Responsive.isWeb(context)
//                                   ? double.maxFinite
//                                   : 300,
//                               //icon: Icons.attach_money,
//                               title: 'Transfert Virtuel',
//                               image:
//                                   Image.asset('Assets/Images/Orion/mpesa.png'),
//                               balance: {
//                                 "virtuel_CDF": "CDF: 100",
//                                 "virtuel_USD": "USD: 200",
//                                 "cash_CDF": "CDF: 300",
//                                 "cash_USD": "USD: 400"
//                               },
//                               subtitle:
//                                   "Transferez de l'argent rapidement a vos clients ECOBANK avec Orion",
//                               title2: 'Compte 990268381 - Destin Kabote',
//                               title3: '',
//                               subtitle1: 'Soldes Cash',
//                               subtitle2: 'Soldes Virtuel',
//                               page: EnvoieMPesaPage(
//                                 updatingData: false,
//                               ),
//                               iconColor: AppColors.kYellowColor,
//                               titleColor: AppColors.kWhiteColor,
//                               subtitleColor: AppColors.kGreyColor),
//                           // Expanded(
//                           //     child:
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     showCupertinoModalPopup(
//                                         context: context,
//                                         builder: (context) {
//                                           return Center(
//                                             child: EnvoieMPesaPage(
//                                               updatingData: false,
//                                             ),
//                                           );
//                                         });
//                                   },
//                                   icon: Icon(
//                                     Icons.add_circle_outline,
//                                     color: AppColors.kYellowColor,
//                                   )),
//                             ],
//                           )
//                           //)
//                         ],
//                       ))
//                 ],
//               ),
//             );
//           })),
//     );
//   }
// }
