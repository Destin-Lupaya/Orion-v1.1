import 'package:flutter/material.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Models/payback_calendar.model.dart';
import 'package:orion/Resources/Models/saved_loan.model.dart';
import 'package:orion/Resources/responsive.dart';

import '../../../Resources/Components/texts.dart';
import '../../../Resources/global_variables.dart';

class LastTransactionList extends StatefulWidget {
  LastTransactionList({Key? key}) : super(key: key);

  @override
  State<LastTransactionList> createState() => _LastTransactionListState();
}

class _LastTransactionListState extends State<LastTransactionList> {
  final TextEditingController _searchCtrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextWidgets.textNormal(
                      title: 'Dernières transactions',
                      fontSize: 18,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  child: SearchTextFormFieldWidget(
                      backColor: AppColors.kTextFormWhiteColor,
                      hintText: 'Recherchez...',
                      isObsCured: false,
                      editCtrller: _searchCtrller,
                      textColor: AppColors.kWhiteColor,
                      maxLines: 1),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            buildLoansList(context: context)
          ],
        ),
      ),
    );
  }

  buildLoansList({required BuildContext context}) {
    // return Consumer<LoanStateProvider>(builder: (context, loanProvider, _) {
    //   return ListView.builder(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: loanProvider.myLoans.length,
    //     itemBuilder: (context, int index) {
    //       return trackItem(
    //         savedLoan: loanProvider.myLoans[index],
    //         index: index,
    //       );
    //     },
    //   );
    // });
  }

  trackItem({
    required SavedLoanModel savedLoan,
    required int index,
  }) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(top: 15),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: AppColors.kBlackColor.withOpacity(1),
                  borderRadius: BorderRadius.circular(10)),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // TextWidgets.textBold(
                          //   title: savedLoan.loanData.name.toString().trim(),
                          //   fontSize: 14,
                          //   textColor: AppColors.kWhiteColor,
                          // ),
                          TextWidgets.text300(
                            title:
                                '${savedLoan.duration.toString().trim()} mois',
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor,
                          )
                        ],
                      ),
                      // trailing: TextWidgets.text300(
                      //   title: '${savedLoan.duration.toString().trim()} mois',
                      //   fontSize: 14,
                      //   textColor: AppColors.kWhiteColor,
                      // ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TextWidgets.text300(
                            //   title:
                            //       'Calcul ${savedLoan.loanData.modeCalcul.toString().trim().toUpperCase()}',
                            //   fontSize: 14,
                            //   textColor: AppColors.kWhiteColor,
                            // ),
                            TextWidgets.text300(
                              title: savedLoan.refundMode!.toString().trim(),
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     TextWidgets.textWithLabel(
                    //         title: 'Credit',
                    //         fontSize: 14,
                    //         textColor: AppColors.kWhiteColor,
                    //         value: savedLoan.loanData.name.toString().trim()),
                    //     TextWidgets.textWithLabel(
                    //         title: 'Calcul',
                    //         fontSize: 14,
                    //         textColor: AppColors.kWhiteColor,
                    //         value: savedLoan.loanData.modeCalcul
                    //             .toString()
                    //             .trim()
                    //             .toUpperCase()),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     TextWidgets.textWithLabel(
                    //         title: 'Durée',
                    //         fontSize: 14,
                    //         textColor: AppColors.kWhiteColor,
                    //         value:
                    //             '${savedLoan.duration.toString().trim()} mois'),
                    //     TextWidgets.textWithLabel(
                    //         title: 'Remboursement',
                    //         fontSize: 14,
                    //         textColor: AppColors.kWhiteColor,
                    //         value: savedLoan.refundMode!.toString().trim()),
                    //   ],
                    // ),
                  ],
                ),
                children: [
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount:
                  //       Provider.of<LoanStateProvider>(context, listen: false)
                  //           .myLoans[index]
                  //           .payback
                  //           .length,
                  //   itemBuilder: (context, int paybackIndex) {
                  //     return paybackItem(
                  //       singlePayback: Provider.of<LoanStateProvider>(context,
                  //               listen: false)
                  //           .myLoans[index]
                  //           .payback[paybackIndex],
                  //     );
                  //   },
                  // )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 20,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.kYellowColor),
                child: TextWidgets.textBold(
                  title: '${savedLoan.amount.toString().trim()}\$',
                  fontSize: 14,
                  textColor: AppColors.kBlackColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  paybackItem({
    required PaybackModel singlePayback,
  }) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(left: 5),
            decoration: const BoxDecoration(
                border:
                    Border(left: BorderSide(color: Colors.yellow, width: 2))),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColors.kBlackLightColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  if (Responsive.isMobile(context))
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // TextWidgets.textWithLabel(
                          //     title: 'Jour',
                          //     fontSize: 14,
                          //     textColor: AppColors.kWhiteColor,
                          //     value: singlePayback.refundDay.toString().trim()),
                          TextWidgets.textWithLabel(
                              title: 'Montant',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor,
                              value:
                                  '${singlePayback.amount.toStringAsFixed(2).trim()}\$'),
                          TextWidgets.textWithLabel(
                              title: 'Interet',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor,
                              value:
                                  '${singlePayback.interestRate.toStringAsFixed(2).trim()}\$'),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidgets.textWithLabel(
                              title: 'Total',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor,
                              value:
                                  '${(singlePayback.interestRate + singlePayback.amount).toStringAsFixed(2)}\$'),
                          TextWidgets.textWithLabel(
                              title: 'Penalites',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor,
                              value:
                                  '${singlePayback.overDueFees!.toStringAsFixed(2).trim()}\$'),
                        ],
                      ),
                    ),
                  if (!Responsive.isMobile(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TextWidgets.textWithLabel(
                        //     title: 'Jour',
                        //     fontSize: 14,
                        //     textColor: AppColors.kWhiteColor,
                        //     value: singlePayback.refundDay.toString().trim()),
                        TextWidgets.textWithLabel(
                            title: 'Montant',
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor,
                            value:
                                '${singlePayback.amount.toStringAsFixed(2).trim()}\$'),
                        TextWidgets.textWithLabel(
                            title: 'Interet',
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor,
                            value:
                                '${singlePayback.interestRate.toStringAsFixed(2).trim()}\$'),
                        TextWidgets.textWithLabel(
                            title: 'Total',
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor,
                            value:
                                '${(singlePayback.interestRate + singlePayback.amount).toStringAsFixed(2)}\$'),
                        TextWidgets.textWithLabel(
                            title: 'Penalites',
                            fontSize: 14,
                            textColor: AppColors.kWhiteColor,
                            value: '4%'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.kRedColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
