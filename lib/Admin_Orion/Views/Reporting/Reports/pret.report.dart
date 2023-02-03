import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_transaction.provider.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Resources/AppStateProvider/app_stateprovider.dart';
import 'package:orion/Resources/Components/empty_model.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:provider/provider.dart';

class LoanReportWidget extends StatefulWidget {
  String? accountID;
  LoanReportWidget({Key? key, this.accountID}) : super(key: key);

  @override
  State<LoanReportWidget> createState() => _LoanReportWidgetState();
}

class _LoanReportWidgetState extends State<LoanReportWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read<AdminTransactionProvider>()
          .getData(isRefresh: false, accountID: widget.accountID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.kTransparentColor,
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .85,
              minHeight: MediaQuery.of(context).size.height * .20),
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height * .85,
          // color: AppColors.kBlackLightColor,
          child: context.select<AppStateProvider, bool>(
                          (provider) => provider.isAsync) ==
                      false &&
                  context
                      .select<AdminTransactionProvider, List>(
                          (provider) => provider.filteredData)
                      .isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: context.select<AdminTransactionProvider, int>(
                      (provider) => provider.filteredData.length),
                  itemBuilder: (context, index) {
                    Map data = context
                        .read<AdminTransactionProvider>()
                        .filteredData[index];

                    return Card(
                      elevation: 0,
                      color: AppColors.kTextFormWhiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                          title: TextWidgets.textBold(
                              title: data['type_operation'].toString(),
                              fontSize: 16,
                              textColor: AppColors.kWhiteColor),
                          subtitle: TextWidgets.text300(
                              title: data['type_payment'].toString(),
                              fontSize: 16,
                              textColor: AppColors.kWhiteColor),
                          trailing: TextWidgets.textBold(
                              title:
                                  "${data['amount'].toString()} ${data['type_devise'].toString()}",
                              fontSize: 16,
                              textColor: AppColors.kWhiteColor)),
                    );
                  })
              : context.select<AppStateProvider, bool>(
                      (provider) => provider.isAsync == true)
                  ? CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.kYellowColor),
                    )
                  : EmptyModel(color: AppColors.kWhiteDarkColor),
        ));
  }
}
