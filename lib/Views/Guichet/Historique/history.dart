import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Models/loan_model_last.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    minTauxValue =
        double.parse(scores[int.parse(scoreValue.toString()) - 1]['minTaux']);
    maxTauxValue =
        double.parse(scores[int.parse(scoreValue.toString()) - 1]['maxTaux']);
    setLoanType();
    currentLoan = credits[0].name;
    choosedLoanType = credits
        .where((credit) {
          return credit.name == currentLoan;
        })
        .toList()[0]
        .toJson();
    amountValue = choosedLoanType['montantMin'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Responsive(
                  mobile: Column(
                    children: [
                      presentWidget(),
                      loanCalculationWidget(),
                      paybackCalendarWidgetentrees(),
                      paybackCalendarWidgetsorties(),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      presentWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(flex: 3, child: loanCalculationWidget()),
                          Expanded(
                            flex: 2,
                            child: paybackCalendarWidgetentrees(),
                          ),

                          Expanded(
                            flex: 2,
                            child: paybackCalendarWidgetsorties(),
                          )
                        ],
                      ),
                    ],
                  ),
                  web: Column(
                    children: [
                      presentWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(flex: 3, child: loanCalculationWidget()),
                          Expanded(
                            flex: 2,
                            child: paybackCalendarWidgetentrees(),
                          ),
                          Expanded(
                            flex: 2,
                            child: paybackCalendarWidgetsorties(),
                          )
                        ],
                      ),
                    ],
                  )))),
    );
  }

  presentWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgets.textBold(
              title: 'Historique des transactions',
              fontSize: 20,
              textColor: AppColors.kWhiteColor),
          const SizedBox(
            height: 20,
          ),
          TextWidgets.text300(
              title:
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum error deleniti porro dicta omnis. Natus dolorem aperiam non, consectetur iste rem vitae possimus magnam molestias nihil! Quam quo itaque voluptate?\nLorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum error deleniti porro dicta omnis. Natus dolorem aperiam non, consectetur iste rem vitae possimus magnam molestias nihil! Quam quo itaque voluptate?',
              fontSize: 14,
              textColor: AppColors.kWhiteColor),
          const SizedBox(
            height: 10,
          ),
          TextWidgets.text300(
              title:
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum error deleniti porro dicta omnis. Natus dolorem aperiam non, consectetur iste rem vitae possimus magnam molestias nihil! Quam quo itaque voluptate?\nLorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum error deleniti porro dicta omnis. Natus dolorem aperiam non, consectetur iste rem vitae possimus magnam molestias nihil! Quam quo itaque voluptate?',
              fontSize: 14,
              textColor: AppColors.kWhiteColor),
          const SizedBox(
            height: 10,
          ),
          TextWidgets.text300(
              title:
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum error deleniti porro dicta omnis. Natus dolorem aperiam non, consectetur iste rem vitae possimus magnam molestias nihil! Quam quo itaque voluptate?',
              fontSize: 14,
              textColor: AppColors.kWhiteColor),
        ],
      ),
    );
  }

  double amountValue = 300;
  double minTauxValue = 0;
  double maxTauxValue = 0;
  double durationValue = 12;
  double scoreValue = 5;
  List<Map> scores = [
    {"designation": "Faible", "minTaux": "12", "maxTaux": "18"},
    {"designation": "Assez bien", "minTaux": "9", "maxTaux": "15"},
    {"designation": "Bien", "minTaux": "7", "maxTaux": "12"},
    {"designation": "Tres bien", "minTaux": "5", "maxTaux": "9"},
    {"designation": "Excellent", "minTaux": "3", "maxTaux": "6"},
  ];
  List<Map> creditTypes = [
    {
      "designation": "Credit personnel",
      "montantMin": "100",
      "montantMax": "800",
      "taux": "12",
      "modeCalcul": "constant"
    },
    {
      "designation": "Credit solidaire",
      "montantMin": "100",
      "montantMax": "8000",
      "taux": "5",
      "modeCalcul": "constant"
    },
    {
      "designation": "Credit d'entreprise",
      "montantMin": "1000",
      "montantMax": "100000",
      "taux": "3",
      "modeCalcul": "constant"
    },
    {
      "designation": "Credit employé",
      "montantMin": "100",
      "montantMax": "2000",
      "taux": "9",
      "modeCalcul": "constant"
    },
  ];
  List<LoanModel> credits = [];
  setLoanType() {
    for (var i = 0; i < creditTypes.length; i++) {
      credits.add(LoanModel.fromJSON(creditTypes[i]));
    }
  }

  Map choosedLoanType = {};
  String currentLoan = "";
  loanCalculationWidget() {
    return Card(
      elevation: 0,
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Container(
        // margin: EdgeInsets.symmetric(
        //     horizontal: MediaQuery.of(context).size.width / 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextWidgets.textBold(
            //     title: 'Personal loan payment calculator',
            //     fontSize: 18,
            //     textColor: AppColors.kWhiteColor),
            // const SizedBox(
            //   height: 20,
            // ),
            // CustomDropdownButton(
            //     value: currentLoan,
            //     hintText: 'Type de credit',
            //     callBack: (value) {
            //       currentLoan = value;
            //       choosedLoanType = credits
            //           .where((credit) {
            //             return credit.name == value;
            //           })
            //           .toList()[0]
            //           .toJson();
            //       amountValue = choosedLoanType['montantMin'];
            //       setState(() {});
            //     },
            //     items: credits.map((credit) {
            //       return credit.name;
            //     }).toList()),
            // Center(
            //   child: Container(
            //     width: double.maxFinite,
            //     padding: const EdgeInsets.all(16),
            //     margin: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       color: AppColors.kWhiteColor.withOpacity(0.08),
            //       borderRadius: BorderRadius.circular(kDefaultPadding),
            //     ),
            //     child: Center(
            //       child: Column(
            //         children: [
            //           TextWidgets.text300(
            //               title: 'Taux',
            //               fontSize: 14,
            //               textColor: AppColors.kGreyColor),
            //           const SizedBox(height: 5),
            //           TextWidgets.textBold(
            //               title: "${choosedLoanType['taux']}%",
            //               fontSize: 16,
            //               textColor: AppColors.kWhiteColor),
            //           const SizedBox(height: 30),
            //           TextWidgets.text300(
            //               title: 'Paiement mensuel',
            //               fontSize: 14,
            //               textColor: AppColors.kGreyColor),
            //           const SizedBox(height: 5),
            //           TextWidgets.textBold(
            //               title:
            //                   '${((amountValue / durationValue) + (amountValue * (choosedLoanType['taux'] / 100))).toStringAsFixed(2)}\$',
            //               fontSize: 16,
            //               textColor: AppColors.kWhiteColor),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 50),
            // TextWidgets.text300(
            //     title: 'Montant: $amountValue\$',
            //     fontSize: 14,
            //     textColor: AppColors.kWhiteColor),
            // sliderWidget(
            //     onChange: (value) {
            //       setState(() {
            //         amountValue = value;
            //       });
            //     },
            //     value: amountValue,
            //     division: 10,
            //     min: choosedLoanType['montantMin'],
            //     max: choosedLoanType['montantMax']),
            // const SizedBox(height: 10),
            // TextWidgets.text300(
            //     title: 'Duration : $durationValue mois',
            //     fontSize: 14,
            //     textColor: AppColors.kWhiteColor),
            // sliderWidget(
            //     onChange: (value) {
            //       setState(() {
            //         durationValue = value;
            //       });
            //     },
            //     value: durationValue,
            //     division: 11,
            //     min: 1,
            //     max: 12),
            // const SizedBox(height: 10),
            // TextWidgets.text300(
            //     title:
            //         'Score: ${scores[int.parse(scoreValue.toString()) - 1]['designation']}',
            //     fontSize: 14,
            //     textColor: AppColors.kWhiteColor),
            // sliderWidget(
            //     onChange: (value) {
            //       setState(() {
            //         scoreValue = value;
            //         minTauxValue = double.parse(
            //             scores[int.parse(scoreValue.toString()) - 1]
            //                 ['minTaux']);
            //         maxTauxValue = double.parse(
            //             scores[int.parse(scoreValue.toString()) - 1]
            //                 ['maxTaux']);
            //       });
            //     },
            //     value: scoreValue,
            //     division: 4,
            //     min: 1,
            //     max: 5),
          ],
        ),
      ),
    );
  }

  loanTypeWidget({required Map loan}) {}

  sliderWidget({
    required Function onChange,
    required double value,
    required double min,
    required double max,
    required int division,
  }) {
    return Slider(
      activeColor: AppColors.kYellowColor.withOpacity(1),
      inactiveColor: AppColors.kGreyColor.withOpacity(0.1),
      value: value,
      label: '$value',
      mouseCursor: MouseCursor.defer,
      thumbColor: AppColors.kBlackColor,
      divisions: division,
      min: min,
      max: max,
      onChanged: (value) {
        onChange(value);
      },
    );
  }

  paybackCalendarWidgetentrees() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.kBlackColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgets.textBold(
              title: "Historique des Transactions Entrees",
              fontSize: 18,
              textColor: AppColors.kWhiteColor),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: TextWidgets.textBold(
                      title: '#',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidgets.textBold(
                      title: 'Jour',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 2,
                  child: TextWidgets.textBold(
                      title: 'Montant',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 2,
                  child: TextWidgets.textBold(
                      title: 'Expediteur',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidgets.textBold(
                      title: 'Destinateur',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidgets.textBold(
                      title: 'Total',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                )
              ],
            ),
          ),
          ListView.builder(
              itemCount: int.parse(durationValue.toString()),
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      color: index % 2 == 0
                          ? AppColors.kWhiteColor.withOpacity(0.03)
                          : AppColors.kTransparentColor,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextWidgets.textBold(
                                title: (index + 1).toString(),
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextWidgets.text300(
                                title: DateTime.now()
                                    .add(Duration(days: 30 * index))
                                    .toString()
                                    .substring(0, 10),
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextWidgets.text300(
                                title:
                                    '${((amountValue / durationValue)).toStringAsFixed(2)}\$',
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextWidgets.text300(
                                title: (amountValue *
                                        (choosedLoanType['taux'] / 100))
                                    .toStringAsFixed(2),
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextWidgets.text300(
                                title:
                                    '${((amountValue / durationValue) + (amountValue * (choosedLoanType['taux'] / 100))).toStringAsFixed(2)}\$',
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: AppColors.kGreyColor,
                    )
                  ],
                );
              }),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            text: ' Voir le Solde restant',
            backColor: AppColors.kYellowColor,
            textColor: AppColors.kBlackColor,
            callback: () {},
          )
        ],
      ),
    );
  }

  paybackCalendarWidgetsorties() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: AppColors.kBlackColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgets.textBold(
              title: "Historique des Transactions Sorties",
              fontSize: 18,
              textColor: AppColors.kWhiteColor),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: TextWidgets.textBold(
                      title: '#',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidgets.textBold(
                      title: 'Jour',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 2,
                  child: TextWidgets.textBold(
                      title: 'Montant',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 2,
                  child: TextWidgets.textBold(
                      title: 'Beneficiaire',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidgets.textBold(
                      title: 'Expediteur',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                ),
                Expanded(
                  flex: 3,
                  child: TextWidgets.textBold(
                      title: 'Total',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor),
                )
              ],
            ),
          ),
          ListView.builder(
              itemCount: int.parse(durationValue.toString()),
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      color: index % 2 == 0
                          ? AppColors.kWhiteColor.withOpacity(0.03)
                          : AppColors.kTransparentColor,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextWidgets.textBold(
                                title: (index + 1).toString(),
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextWidgets.text300(
                                title: DateTime.now()
                                    .add(Duration(days: 30 * index))
                                    .toString()
                                    .substring(0, 10),
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextWidgets.text300(
                                title:
                                    '${((amountValue / durationValue)).toStringAsFixed(2)}\$',
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextWidgets.text300(
                                title: (amountValue *
                                        (choosedLoanType['taux'] / 100))
                                    .toStringAsFixed(2),
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextWidgets.text300(
                                title:
                                    '${((amountValue / durationValue) + (amountValue * (choosedLoanType['taux'] / 100))).toStringAsFixed(2)}\$',
                                fontSize: 14,
                                textColor: AppColors.kWhiteColor),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: AppColors.kGreyColor,
                    )
                  ],
                );
              }),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            text: 'Voir le Solde restant',
            backColor: AppColors.kYellowColor,
            textColor: AppColors.kBlackColor,
            callback: () {},
          )
        ],
      ),
    );
  }
}
