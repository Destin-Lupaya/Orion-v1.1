import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Views/Config/User/create_user.dart';
import 'package:orion/Report_Widgets/report_widgets.dart';
import 'package:orion/Resources/AppStateProvider/client.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/button.dart';
import 'package:orion/Resources/Components/dialogs.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Resources/Components/empty_model.dart';
import 'package:orion/Resources/Components/search_textfield.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/Models/external_client.model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:orion/Views/Config/User/new_client.page.dart';
import 'package:orion/Views/Guichet/Demands/new_demand.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class ClientList extends StatefulWidget {
  bool? updatingData;
  Map? clientData;

  ClientList({Key? key, this.clientData, this.updatingData = false})
      : super(key: key);

  @override
  State<ClientList> createState() => _DemandeApprovListState();
}

class _DemandeApprovListState extends State<ClientList> {
  final TextEditingController _searchCtrller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<ClientProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.kTransparentColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                TextWidgets.textBold(
                    title: "Clients externes",
                    fontSize: 16,
                    textColor: AppColors.kWhiteColor),
                const SizedBox(
                  height: 16,
                ),
                Flex(
                  direction: !Responsive.isMobile(context)
                      ? Axis.horizontal
                      : Axis.vertical,
                  mainAxisSize: !Responsive.isMobile(context)
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: CustomButton(
                          text: "Nouveau",
                          backColor: AppColors.kGreenColor,
                          textColor: AppColors.kWhiteColor,
                          callback: () {
                            Dialogs.showModal(
                                title: 'New client',
                                content: NewClientPage(updatingData: false));
                          }),
                    ),
                    const SizedBox(width: 16, height: 16),
                    Flexible(
                      fit: FlexFit.loose,
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
              ],
            ),
            buildLoansList(context: context)
          ],
        ),
      ),
    );
  }

  buildLoansList({required BuildContext context}) {
    return Selector<ClientProvider, List<ExternalClientModel>>(
      selector: (_, provider) => provider.dataList,
      builder: (context, dataList, _) {
        return dataList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataList.length,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: AppColors.kTextFormWhiteColor,
                      title: TextWidgets.textBold(
                          title: dataList[index].name,
                          fontSize: 16,
                          textColor: AppColors.kWhiteColor),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidgets.text300(
                              title: dataList[index].phone,
                              fontSize: 12,
                              textColor: AppColors.kWhiteColor),
                          TextWidgets.text300(
                              title: dataList[index].email ?? '',
                              fontSize: 12,
                              textColor: AppColors.kGreyColor)
                        ],
                      ),
                    ),
                  );
                },
              )
            : EmptyModel(color: AppColors.kWhiteDarkColor);
      },
    );
  }
}
