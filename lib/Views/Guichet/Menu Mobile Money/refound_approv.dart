// import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
// import 'package:orion/Resources/AppStateProvider/loan_stateprovider.dart';
// import 'package:orion/Resources/AppStateProvider/Approvisionement_method_provider.dart';
// import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
// import 'package:orion/Resources/Components/button.dart';
// import 'package:orion/Resources/Components/card.dart';
// import 'package:orion/Resources/Components/empty_model.dart';
// import 'package:orion/Resources/Components/modal_progress.dart';
// import 'package:orion/Resources/Components/text_fields.dart';
// import 'package:orion/Resources/Components/texts.dart';
// import 'package:orion/Resources/Helpers/date_parser.dart';
// import 'package:orion/Resources/Models/payback_calendar.model.dart';
// import 'package:orion/Resources/global_variables.dart';
// import 'package:orion/Resources/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class RefundApprovPage extends StatefulWidget {
//   final PaybackModel loanRefund;
//
//   const RefundApprovPage({Key? key, required this.loanRefund})
//       : super(key: key);
//
//   @override
//   State<RefundApprovPage> createState() => _RefundApprovPageState();
// }
//
// class _RefundApprovPageState extends State<RefundApprovPage> {
//   final TextEditingController _amountCtrller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.kTransparentColor,
//       child: Container(
//           width: Responsive.isMobile(context)
//               ? MediaQuery.of(context).size.width
//               : MediaQuery.of(context).size.width / 2,
//           height: MediaQuery.of(context).size.height * .85,
//           // color: AppColors.kBlackLightColor,
//           child: Consumer<AppStateProvider>(
//               builder: (context, appStateProvider, child) {
//             double total = 0;
//             if (widget.loanRefund.payment != null &&
//                 widget.loanRefund.payment!.isNotEmpty) {
//               for (int i = 0; i < widget.loanRefund.payment!.length; i++) {
//                 total = total +
//                     double.parse(
//                         widget.loanRefund.payment![i]['amount'].toString());
//               }
//             }
//             return ModalProgress(
//               isAsync: appStateProvider.isAsync,
//               progressColor: AppColors.kYellowColor,
//               child: ListView(
//                 children: [
//                   CardWidget(
//                       backColor: AppColors.kBlackLightColor,
//                       title: 'Revoir une demande d\'approvisionnement',
//                       content: Column(
//                         children: [
//                           Container(
//                               width: double.maxFinite,
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                   color: AppColors.kBlackColor.withOpacity(0.4),
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextWidgets.textBold(
//                                       title: 'Details',
//                                       fontSize: 18,
//                                       textColor: AppColors.kWhiteColor),
//                                   const SizedBox(height: 20),
//                                   TextWidgets.textHorizontalWithLabel(
//                                       title: 'Montant',
//                                       fontSize: 14,
//                                       textColor: AppColors.kWhiteColor,
//                                       value:
//                                           '${widget.loanRefund.amount.toStringAsFixed(2)}\$'),
//                                   TextWidgets.textHorizontalWithLabel(
//                                       title: 'Remboursement',
//                                       fontSize: 14,
//                                       textColor: AppColors.kWhiteColor,
//                                       value:
//                                           '${parseDate(date: widget.loanRefund.refundDate)}'),
//                                   TextWidgets.textHorizontalWithLabel(
//                                       title: 'Total intérêt',
//                                       fontSize: 14,
//                                       textColor: AppColors.kWhiteColor,
//                                       value:
//                                           '${widget.loanRefund.interestRate.toStringAsFixed(2)}\$'),
//                                   TextWidgets.textHorizontalWithLabel(
//                                       title: 'Pénalites',
//                                       fontSize: 14,
//                                       textColor: AppColors.kRedColor,
//                                       value:
//                                           '${DateTime.now().isAfter(DateTime.parse(widget.loanRefund.refundDate)) ? widget.loanRefund.overDueFees!.toStringAsFixed(2) : 0}\$'),
//                                   TextWidgets.textHorizontalWithLabel(
//                                       title: 'Total à rembourser',
//                                       fontSize: 14,
//                                       textColor: AppColors.kGreenColor,
//                                       value:
//                                           "${(widget.loanRefund.amount + widget.loanRefund.interestRate + (DateTime.now().isAfter(DateTime.parse(widget.loanRefund.refundDate)) ? widget.loanRefund.overDueFees! : 0)).toStringAsFixed(3)}\$"),
//                                   TextWidgets.textHorizontalWithLabel(
//                                       title: 'Total remboursement',
//                                       fontSize: 14,
//                                       textColor: total <
//                                               (widget.loanRefund.amount +
//                                                   widget
//                                                       .loanRefund.interestRate)
//                                           ? AppColors.kRedColor
//                                           : AppColors.kGreenColor,
//                                       value: "${total.toStringAsFixed(3)}\$")
//                                 ],
//                               )),
//                           CardWidget(
//                               backColor: AppColors.kBlackLightColor,
//                               title: 'Moyen de paiement',
//                               content: Consumer<ApprovisionementMethodProvider>(
//                                   builder: (context, paymentProvider, _) {
//                                 return ListView.builder(
//                                   padding: const EdgeInsets.all(0),
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount:
//                                       paymentProvider.paymentMethods.length,
//                                   itemBuilder: (context, int index) {
//                                     return GestureDetector(
//                                       onTap: () {
//                                         paymentProvider.setRefundMethod(
//                                             context: context,
//                                             newPaymentMethod: paymentProvider
//                                                 .paymentMethods[index]);
//                                       },
//                                       child: Container(
//                                           width: double.maxFinite,
//                                           padding: const EdgeInsets.all(10),
//                                           margin: const EdgeInsets.all(5),
//                                           decoration: BoxDecoration(
//                                               color: AppColors.kWhiteColor
//                                                   .withOpacity(0.07),
//                                               border: Border.all(
//                                                   color: paymentProvider
//                                                               .refundPaymentMethod!
//                                                               .number
//                                                               .toString()
//                                                               .trim() ==
//                                                           paymentProvider
//                                                               .paymentMethods[
//                                                                   index]
//                                                               .number
//                                                               .toString()
//                                                               .trim()
//                                                       ? AppColors.kWhiteColor
//                                                       : AppColors
//                                                           .kTransparentColor),
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       TextWidgets.text500(
//                                                           title: paymentProvider
//                                                               .paymentMethods[
//                                                                   index]
//                                                               .type
//                                                               .toString()
//                                                               .trim(),
//                                                           fontSize: 16,
//                                                           textColor: AppColors
//                                                               .kWhiteColor
//                                                               .withOpacity(
//                                                                   0.5)),
//                                                       const SizedBox(
//                                                           height: 16.0),
//                                                       TextWidgets.textBold(
//                                                           title: paymentProvider
//                                                               .paymentMethods[
//                                                                   index]
//                                                               .number
//                                                               .toString()
//                                                               .trim(),
//                                                           fontSize: 20,
//                                                           textColor: AppColors
//                                                               .kWhiteColor),
//                                                     ]),
//                                               ),
//                                               paymentProvider
//                                                           .refundPaymentMethod!
//                                                           .number
//                                                           .toString()
//                                                           .trim() ==
//                                                       paymentProvider
//                                                           .paymentMethods[index]
//                                                           .number
//                                                           .toString()
//                                                           .trim()
//                                                   ? const Icon(
//                                                       Icons.check_circle,
//                                                       color: Colors.green,
//                                                     )
//                                                   : Container(),
//                                             ],
//                                           )),
//                                     );
//                                   },
//                                 );
//                               })),
//                           TextFormFieldWidget(
//                               backColor: AppColors.kTextFormBackColor,
//                               hintText: 'Montant',
//                               editCtrller: _amountCtrller,
//                               inputType: TextInputType.number,
//                               textColor: AppColors.kWhiteColor,
//                               maxLines: 1),
//                           total <
//                                   (widget.loanRefund.amount +
//                                       widget.loanRefund.interestRate)
//                               ? Consumer<LoanStateProvider>(
//                                   builder: (context, loanProvider, _) {
//                                   return CustomButton(
//                                     backColor: AppColors.kYellowColor,
//                                     text: 'Rembourser',
//                                     textColor: AppColors.kBlackColor,
//                                     callback: () {
//                                       if (_amountCtrller.text
//                                               .toString()
//                                               .trim()
//                                               .isEmpty ||
//                                           double.tryParse(_amountCtrller.text
//                                                   .toString()
//                                                   .trim()) ==
//                                               null) {
//                                         return Message.showToast(
//                                             msg:
//                                                 'Veuilles saisir un montant valide');
//                                       }
//                                       if (double.parse(_amountCtrller.text
//                                                   .toString()
//                                                   .trim()) +
//                                               total >
//                                           (widget.loanRefund.amount +
//                                               widget.loanRefund.interestRate)) {
//                                         return Message.showToast(
//                                             msg:
//                                                 'Le montant saisi est supérieur au montant de l\'échéance');
//                                       }
//                                       Map data = {
//                                         'refund_calendars_id':
//                                             widget.loanRefund.id!.toString(),
//                                         'validation': '1',
//                                         'amount': double.parse(_amountCtrller
//                                             .text
//                                             .toString()
//                                             .trim()),
//                                         'created_at': DateTime.now().toString(),
//                                         'ways_payments_id': Provider.of<
//                                                     ApprovisionementMethodProvider>(
//                                                 context,
//                                                 listen: false)
//                                             .refundPaymentMethod!
//                                             .id!
//                                             .toString()
//                                             .trim(),
//                                         'users_id':
//                                             Provider.of<UserStateProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .userId
//                                                 .toString(),
//                                       };
//                                       // loanProvider.makePayment(
//                                       //     context: context,
//                                       //     refundData: widget.loanRefund,
//                                       //     payment: data,
//                                       //     callback: () {
//                                       //       Navigator.pop(context);
//                                       //     });
//                                     },
//                                   );
//                                 })
//                               : Center(
//                                   child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                           color: AppColors.kWhiteColor
//                                               .withOpacity(0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: TextWidgets.textBold(
//                                         title:
//                                             'Echéance entièrement remboursée',
//                                         fontSize: 16,
//                                         textColor: AppColors.kGreenColor,
//                                       ))),
//                         ],
//                       )),
//                   CardWidget(
//                       backColor: AppColors.kBlackLightColor,
//                       title: 'Historique',
//                       content: widget.loanRefund.payment != null &&
//                               widget.loanRefund.payment!.isNotEmpty
//                           ? ListView.builder(
//                               itemCount: widget.loanRefund.payment!.length,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, int index) {
//                                 return Container(
//                                     padding: const EdgeInsets.all(8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Text(Provider.of<
//                                                       ApprovisionementMethodProvider>(
//                                                   context,
//                                                   listen: false)
//                                               .paymentMethods
//                                               .where((paymentMethod) =>
//                                                   paymentMethod.id!
//                                                       .toString()
//                                                       .trim() ==
//                                                   widget
//                                                       .loanRefund
//                                                       .payment![index]
//                                                           ['ways_payments_id']
//                                                       .toString()
//                                                       .trim())
//                                               .toList()[0]
//                                               .number
//                                               .toString()
//                                               .trim()),
//                                         ),
//                                         Expanded(
//                                           child: Text(
//                                               "${widget.loanRefund.payment![index]['amount'].toString()}\$"),
//                                         ),
//                                         Expanded(
//                                           child: Text(parseDate(
//                                               date: widget.loanRefund
//                                                   .payment![index]['created_at']
//                                                   .toString()
//                                                   .substring(0, 10))),
//                                         ),
//                                       ],
//                                     ));
//                               })
//                           : Container()),
//                 ],
//               ),
//             );
//           })),
//     );
//   }
// }
//
// class CreditHistoryPage extends StatelessWidget {
//   const CreditHistoryPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserStateProvider>(
//       builder: (context, userStateProvider, child) {
//         return userStateProvider.creditHistoryData.isNotEmpty
//             ? Column(
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: TextWidgets.text300(
//                               title: 'Institution',
//                               fontSize: 14,
//                               textColor: AppColors.kWhiteColor),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: TextWidgets.text300(
//                               title: 'Adresse',
//                               fontSize: 14,
//                               textColor: AppColors.kWhiteColor),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: TextWidgets.text300(
//                               title: 'Statut',
//                               fontSize: 14,
//                               textColor: AppColors.kWhiteColor),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: TextWidgets.text300(
//                               title: 'Montant',
//                               fontSize: 14,
//                               textColor: AppColors.kWhiteColor),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: TextWidgets.text300(
//                               title: 'Durée',
//                               fontSize: 14,
//                               textColor: AppColors.kWhiteColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: userStateProvider.creditHistoryData.length,
//                         itemBuilder: (context, int index) {
//                           return Column(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 10),
//                                 color: index % 2 == 0
//                                     ? AppColors.kWhiteColor.withOpacity(0.03)
//                                     : AppColors.kTransparentColor,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: TextWidgets.text300(
//                                           title: userStateProvider
//                                               .creditHistoryData[index]
//                                               .institution
//                                               .trim(),
//                                           fontSize: 14,
//                                           textColor: AppColors.kWhiteColor),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: TextWidgets.text300(
//                                           title: userStateProvider
//                                               .creditHistoryData[index].address
//                                               .trim(),
//                                           fontSize: 14,
//                                           textColor: AppColors.kWhiteColor),
//                                     ),
//                                     Expanded(
//                                       flex: 3,
//                                       child: TextWidgets.text300(
//                                           title: userStateProvider
//                                               .creditHistoryData[index]
//                                               .loanStatus
//                                               .trim(),
//                                           fontSize: 14,
//                                           textColor: AppColors.kWhiteColor),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: TextWidgets.text300(
//                                           title: userStateProvider
//                                               .creditHistoryData[index].amount
//                                               .toString()
//                                               .trim(),
//                                           fontSize: 14,
//                                           textColor: AppColors.kWhiteColor),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: TextWidgets.text300(
//                                           title:
//                                               "${userStateProvider.creditHistoryData[index].loanStatus.trim() == 'En cours' ? DateTime.now().difference(DateTime.parse(userStateProvider.creditHistoryData[index].startDate.toString().trim())).inDays.toString() : userStateProvider.creditHistoryData[index].loanStatus.trim() == 'Remboursé à 100%' ? DateTime.parse(userStateProvider.creditHistoryData[index].completedDate.toString().trim()).difference(DateTime.parse(userStateProvider.creditHistoryData[index].startDate.toString().trim())).inDays.toString() : 'Inconue'} jours",
//                                           fontSize: 14,
//                                           textColor: AppColors.kWhiteColor),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(
//                                   height: 2,
//                                   thickness: 1,
//                                   color: AppColors.kWhiteColor.withOpacity(0.4))
//                             ],
//                           );
//                         }),
//                   )
//                 ],
//               )
//             : EmptyModel(color: AppColors.kGreyColor);
//       },
//     );
//   }
// }
