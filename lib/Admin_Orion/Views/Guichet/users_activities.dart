import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/Components/button.dart';
import 'package:orion/Admin_Orion/Resources/Components/card.dart';
import 'package:orion/Admin_Orion/Resources/Components/empty_model.dart';
import 'package:orion/Admin_Orion/Resources/Components/text_fields.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/Models/Guichet/users_activities_model.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

class UsersActivitiesPage extends StatefulWidget {
  final bool updatingData;
  final UsersActivitiesModel? fraiscommissionModel;
  const UsersActivitiesPage(
      {Key? key, required this.updatingData, this.fraiscommissionModel})
      : super(key: key);

  @override
  _UsersActivitiesPageState createState() => _UsersActivitiesPageState();
}

class _UsersActivitiesPageState extends State<UsersActivitiesPage> {
  List<String> calculModeList = ["Valeur absolue", "Pourcentage"];
  List<String> groupeFraisList = ["Groupe 1", "Groupe2"];
  late String modeCalcul = "Pourcentage";
  late String valueGroupeFrais = "Groupe 1";
  // late String classeFrais = "Frais ouverture dossier";
  String? sousCompteId;
  String? nomFournisseur;
  String? membreInterne;

  String? nomMembre;

  final PageController _controller = PageController();
  final TextEditingController _idactiviteCtrller = TextEditingController();
  final TextEditingController _designCtrller = TextEditingController();
  final TextEditingController _idaffectCtrller = TextEditingController();
  final TextEditingController _avatarCtrller = TextEditingController();
  final TextEditingController _designationCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.updatingData == true) {
      _idactiviteCtrller.text =
          widget.fraiscommissionModel!.id_activities.trim();
      _designCtrller.text = widget.fraiscommissionModel!.designation.trim();
      _idaffectCtrller.text =
          widget.fraiscommissionModel!.affected_by.toString().trim();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // Provider.of<FraiscommStateProvider>(context, listen: false)
      //     .getFraiscommission(context: context, isRefreshed: false);
    });
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
                title: 'Les Activites de l\'Utilisateur',
                content: Wrap(
                  children: [
                    // SearchTextFormFieldWidget(
                    //     backColor: AppColors.kTextFormWhiteColor,
                    //     hintText: 'Search...',
                    //     isObsCured: false,
                    //     editCtrller: _searchCtrller,
                    //     textColor: AppColors.kWhiteColor,
                    //     maxLines: 1),
                    TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'ID Activites',
                      editCtrller: _idactiviteCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),
                    TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Designation',
                      editCtrller: _designationCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),

                    // CustomDropdownButton(
                    //     value: modeCalcul,
                    //     hintText: "Code de Retrait",
                    //     callBack: (newValue) {
                    //       setState(() {
                    //         modeCalcul = newValue;
                    //       });
                    //     },
                    //     items: calculModeList),
                    TextFormFieldWidget(
                      maxLines: 1,
                      hintText: 'Avatar',
                      editCtrller: _avatarCtrller,
                      textColor: AppColors.kWhiteColor,
                      backColor: AppColors.kTextFormWhiteColor,
                    ),

                    Consumer<AdminUserStateProvider>(
                        builder: (context, fraiscommStateProvider, _) {
                      return CustomButton(
                        text: 'Enregistrer',
                        backColor: AppColors.kYellowColor,
                        textColor: AppColors.kWhiteColor,
                        callback: () {
                          Map data = {
                            "id_activities": _idactiviteCtrller.text.trim(),
                            "designation": _designCtrller.text.trim(),
                            "affected_by": _idaffectCtrller.text.trim(),
                            'users_id': Provider.of<AdminUserStateProvider>(
                                    context,
                                    listen: false)
                                .clientData!
                                .id!
                                .toString()
                          };
                          // fraiscommStateProvider.addfraiscommission(
                          //     context: context,
                          //     fraiscommissionModel:
                          //         UsersActivitiesModel.fromJson(data),
                          //     updatingData: widget.updatingData,
                          //     callback: () {});
                        },
                      );
                    })
                  ],
                )),

            const DisplayCommissionTypePage()
          ],
        ),
      ),
    );
  }
}

class DisplayCommissionTypePage extends StatelessWidget {
  const DisplayCommissionTypePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUserStateProvider>(
      builder: (context, fraiscommStateProvider, child) {
        return fraiscommStateProvider.usersData.isNotEmpty
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
                              title: 'ID Activite',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Date Affectation',
                              fontSize: 14,
                              textColor: AppColors.kWhiteColor),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextWidgets.text300(
                              title: 'Affecte par',
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
                        itemCount: fraiscommStateProvider.usersData.length,
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
                                          title: fraiscommStateProvider
                                              .usersData[index].designation
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: fraiscommStateProvider
                                              .usersData[index].value
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: fraiscommStateProvider
                                              .usersData[index].sous_comptes_id
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: fraiscommStateProvider
                                              .usersData[index].modeCalcule
                                              .trim(),
                                          fontSize: 14,
                                          textColor: AppColors.kWhiteColor),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextWidgets.text300(
                                          title: fraiscommStateProvider
                                              .usersData[index].groupeFees
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
