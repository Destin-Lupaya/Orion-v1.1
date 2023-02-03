//import 'package:andema/Resources/AppStateProvider/type_cred__stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/Guichet/creation_caisse_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/applogo.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Components/searchable_textfield.dart';
import 'package:orion/Resources/Components/card.dart';
import 'package:orion/Resources/Components/empty_model.dart';
import 'package:orion/Resources/Components/radio_button.dart';
import 'package:orion/Resources/Components/text_fields.dart';
import 'package:orion/Resources/Models/Guichet_Model/creation_caisse_model.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigTransAgentPage extends StatefulWidget {
  final bool updatingData;
  final CaisseModel? caisseModel;
  const ConfigTransAgentPage(
      {Key? key, required this.updatingData, this.caisseModel})
      : super(key: key);

  @override
  _ConfigTransAgentPageState createState() => _ConfigTransAgentPageState();
}

class _ConfigTransAgentPageState extends State<ConfigTransAgentPage> {
  List<String> calculMode = ["Degressif", "Constant", "Progressif"];
  late String modeCalcul = "Degressif";
  // List<String> delais = [
  //   "3 jours",
  //   "hebdomadaire",
  //   "Mensuel",
  //   "Trimestriel",
  //   "Semestriel",
  //   "Annuel"
  // ];
  // late String delaisecheance = "Annuel";
  // late String decaissement = "Capital Social";
  // late String compteRemboursementCap = '';
  // String? modeCalculs;
  // String? decaissements;
  // String? fraiscommission;
  // String? compteRemboursementCaps;
  // String? compteRemboursementInt;
  // String? constitutionEpargne;

  final PageController _controller = PageController();
  final TextEditingController _fromCtrller = TextEditingController();
  final TextEditingController _toCtrller = TextEditingController();
  final TextEditingController _montCtrller = TextEditingController();
  final TextEditingController _compteCtrller = TextEditingController();
  final TextEditingController _datetimCtrller = TextEditingController();
  //final TextEditingController _VirtuelUSDCtrller = TextEditingController();

  final TextEditingController _searchCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _fromCtrller.text = widget.caisseModel!.Nom_caisse.trim();
      _toCtrller.text = widget.caisseModel!.utilisateur.toString().trim();
      _montCtrller.text = widget.caisseModel!.activite.toString().trim();
      _compteCtrller.text = widget.caisseModel!.Telephone.trim();
      _datetimCtrller.text = widget.caisseModel!.Virtuel_CDF.toString().trim();
    }
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   Provider.of<TypeCredStateProvider>(context, listen: false)
    //       .getypedecredit(context: context, isRefreshed: false);
    //   Provider.of<TypeCredStateProvider>(context, listen: false)
    //       .getConstEpargne(context: context, isRefreshed: false);
    //   Provider.of<TypeCredStateProvider>(context, listen: false)
    //       .getFraisCommission(context: context, isRefreshed: false);
    // });
  }

  blockSeparator({required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        const SizedBox(
          height: 20,
        ),
        TextWidgets.text500(
            title: title,
            fontSize: 14,
            textColor: AppColors.kYellowColor.withOpacity(0.5)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: [
          // const AppLogo(size: Size(100, 100)),
          CardWidget(
            title: 'Ravitaillement inter-agent',
            content: Column(
              children: [
                blockSeparator(title: 'En provenance de'),
                Row(children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'De l\'agent',
                      editCtrller: _fromCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Vers l\'Agent',
                      editCtrller: _toCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                ]),
                TextFormFieldWidget(
                  maxLines: 1,
                  hintText: 'Montant',
                  editCtrller: _montCtrller,
                  textColor: AppColors.kWhiteColor,
                  backColor: AppColors.kTextFormWhiteColor,
                ),
                blockSeparator(title: 'Montant'),
                Row(children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Compte',
                      editCtrller: _compteCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Date time',
                      editCtrller: _datetimCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                  )
                ]),
                blockSeparator(title: ''),
                Row(children: [
                  // Expanded(
                  //   child: TextFormFieldWidget(
                  //     maxLines: 1,
                  //     hintText: 'Virtuel en dollar',
                  //     editCtrller: _VirtuelUSDCtrller,
                  //     textColor: AppColors.kWhiteColor,
                  //     backColor: AppColors.kTextFormWhiteColor,
                  //   ),
                  // ),
                  // Expanded(
                  //   child: CustomDropdownButton(
                  //       value: modeCalcul,
                  //       hintText: "Mode de calcul",
                  //       callBack: (newValue) {
                  //         setState(() {
                  //           modeCalcul = newValue;
                  //         });
                  //       },
                  //       items: calculMode),
                  // )
                ]),
                blockSeparator(title: ''),
                Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SearchableTextFormFieldWidget(
                        //   hintText: 'Frais et commission',
                        //   textColor: AppColors.kWhiteColor,
                        //   backColor: AppColors.kTextFormWhiteColor,
                        //   editCtrller: _fraiscommissionCtrller,
                        //   maxLines: 1,
                        //   callback: (value) {
                        //     fraiscommission = value.toString();
                        //     setState(() {});
                        //   },
                        //   data: Provider.of<TypeCredStateProvider>(context)
                        //       .fraisCommission,
                        //   displayColumn: "designation",
                        //   indexColumn: "id",
                        //   secondDisplayColumn: "groupeFees",
                        // ),
                        Row(children: [
                          // Expanded(
                          //   child: SearchableTextFormFieldWidget(
                          //     hintText: 'Compte de decaissement',
                          //     textColor: AppColors.kWhiteColor,
                          //     backColor: AppColors.kTextFormWhiteColor,
                          //     editCtrller: _decaissementsCtrller,
                          //     maxLines: 1,
                          //     callback: (value) {
                          //       decaissements = value.toString();
                          //       setState(() {});
                          //     },
                          //     data: Provider.of<AppStateProvider>(context)
                          //         .sousCompte,
                          //     displayColumn: "name",
                          //     indexColumn: "id",
                          //     secondDisplayColumn: "number",
                          //   ),
                          // ),
                          // Expanded(
                          //   child: SearchableTextFormFieldWidget(
                          //     hintText: "Constitution d'epargne",
                          //     textColor: AppColors.kWhiteColor,
                          //     backColor: AppColors.kTextFormWhiteColor,
                          //     editCtrller: _constitutionEpargneCtrller,
                          //     maxLines: 1,
                          //     callback: (value) {
                          //       constitutionEpargne = value.toString();
                          //       setState(() {});
                          //     },
                          //     data: Provider.of<TypeCredStateProvider>(context)
                          //         .constitutionEpargne,
                          //     displayColumn: "designation",
                          //     indexColumn: "id",
                          //     secondDisplayColumn: "taux",
                          //   ),
                          // )
                        ]),
                        blockSeparator(title: ''),
                        Row(children: [
                          // Expanded(
                          //   child: SearchableTextFormFieldWidget(
                          //     hintText: 'Remboursement capital',
                          //     textColor: AppColors.kWhiteColor,
                          //     backColor: AppColors.kTextFormWhiteColor,
                          //     editCtrller: _compteRemboursementCapsCtrller,
                          //     maxLines: 1,
                          //     callback: (value) {
                          //       compteRemboursementCaps = value.toString();
                          //       setState(() {});
                          //     },
                          //     data: Provider.of<AppStateProvider>(context)
                          //         .sousCompte,
                          //     displayColumn: "name",
                          //     indexColumn: "id",
                          //     secondDisplayColumn: "number",
                          //   ),
                          // ),
                          // Expanded(
                          //   child: SearchableTextFormFieldWidget(
                          //     hintText: 'Remboursement interet',
                          //     textColor: AppColors.kWhiteColor,
                          //     backColor: AppColors.kTextFormWhiteColor,
                          //     editCtrller: _compteRemboursementIntCtrller,
                          //     maxLines: 1,
                          //     callback: (value) {
                          //       compteRemboursementInt = value.toString();
                          //       setState(() {});
                          //     },
                          //     data: Provider.of<AppStateProvider>(context)
                          //         .sousCompte,
                          //     displayColumn: "name",
                          //     indexColumn: "id",
                          //     secondDisplayColumn: "number",
                          //   ),
                          // )
                        ]),

                        // blockSeparator(title: 'Frais à payer'),
                        // Wrap(
                        //   children: List.generate(
                        //       Provider.of<TypeCredStateProvider>(context)
                        //           .fraisCommission
                        //           .length,
                        //       (index) => Consumer<TypeCredStateProvider>(
                        //               builder: (context, typeLoanProvider, _) {
                        //             return CustomRadioButton(
                        //                 textColor: AppColors.kWhiteColor,
                        //                 value: typeLoanProvider.creditFees
                        //                             .where((fees) =>
                        //                                 fees[
                        //                                     'fees_commissions_id'] ==
                        //                                 typeLoanProvider
                        //                                     .fraisCommission[
                        //                                         index]['id']
                        //                                     .toString())
                        //                             .toList()
                        //                             .length ==
                        //                         1
                        //                     ? true
                        //                     : false,
                        //                 label: typeLoanProvider
                        //                     .fraisCommission[index]
                        //                         ['designation']
                        //                     .toString(),
                        //                 callBack: () {
                        //                   typeLoanProvider.addFees(
                        //                       value: typeLoanProvider
                        //                           .fraisCommission[index]['id']
                        //                           .toString());
                        //                 });
                        //           })),
                        // ),
                        Consumer<CaisseStateProvider>(
                            builder: (context, caisseStateProvider, _) {
                          return CustomButton(
                            text: 'Envoyer',
                            backColor: AppColors.kBlackColor,
                            textColor: AppColors.kWhiteColor,
                            callback: () async {
                              // print(
                              //     "${decaissements},${compteRemboursementCaps},${compteRemboursementInt},${constitutionEpargne}");
                              // return;
                              Map data = {
                                "provenance": _fromCtrller.text.trim(),
                                "destination": _toCtrller.text.trim(),
                                "montant": _montCtrller.text.trim(),
                                "type_compte": _compteCtrller.text.trim(),
                                "datetime": _datetimCtrller.text.trim(),
                                'users_id': Provider.of<UserStateProvider>(
                                        context,
                                        listen: false)
                                    .clientData!
                                    .id!
                                    .toString()
                              };
                              // return print(data);
                              caisseStateProvider.addcaisse(
                                  context: context,
                                  caisseModel: CaisseModel.fromJson(data),
                                  updatingData: widget.updatingData,
                                  callback: () {});
                            },
                          );
                        })
                      ],
                    )),
                const DisplayLoansTypePageState()
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class DisplayLoansTypePageState extends StatelessWidget {
  const DisplayLoansTypePageState({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CaisseStateProvider>(
      builder: (context, caisseStateProvider, child) {
        return caisseStateProvider.caisseData.isNotEmpty
            ? Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextWidgets.text300(
                              title: 'Nom',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Taux d\'interet',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextWidgets.text300(
                              title: 'Detail',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextWidgets.text300(
                              title: 'Montant Minimal',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Montant Maximal',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextWidgets.text300(
                              title: 'Periode',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Compte de decaissement',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Remboursement capital ',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextWidgets.text300(
                              title: 'Remboursement interet',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Constitution d\'epargnel',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: caisseStateProvider.caisseData.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: TextWidgets.text300(
                                          title: caisseStateProvider
                                              .caisseData[index].Nom_caisse
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: caisseStateProvider
                                              .caisseData[index].utilisateur
                                              .toString()
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: caisseStateProvider
                                              .caisseData[index].activite
                                              .toString()
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: caisseStateProvider
                                              .caisseData[index].Telephone
                                              .toString()
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: caisseStateProvider
                                              .caisseData[index].Virtuel_CDF
                                              .toString()
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: caisseStateProvider
                                              .caisseData[index].Virtuel_USD
                                              .toString()
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                  height: 2,
                                  thickness: 1,
                                  color: AppColors.kWhiteColor.withOpacity(0.4))
                            ],
                          );
                        }),
                  )
                ],
              )
            : EmptyModel(color: AppColors.kGreyColor);
      },
    );
  }
}
