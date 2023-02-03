import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:flutter/material.dart';

class LastTransactionList extends StatelessWidget {
  const LastTransactionList({Key? key}) : super(key: key);

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
    return Card(
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets.textNormal(
                title: 'Last transaction',
                fontSize: 18,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 20,
            ),
            blockSeparator(
                title:
                    'Orion vous assure Le suivie en temps reel de Transaction deja effectue'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextWidgets.textBold(
                        title: 'Jour',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextWidgets.textBold(
                        title: 'Client',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidgets.textBold(
                        title: 'Transaction locale et national',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextWidgets.textBold(
                        title: 'Transaction locale et internationale',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextWidgets.textBold(
                        title: 'Montant',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor),
                  )
                ],
              ),
            ),
            ListView.builder(
                itemCount: 20,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextWidgets.textBold(
                                  title: 'Today',
                                  fontSize: 14,
                                  textColor: AppColors.kWhiteColor),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextWidgets.text300(
                                  title: 'Destin Kabote',
                                  fontSize: 14,
                                  textColor: AppColors.kWhiteColor),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextWidgets.text300(
                                  title: 'Transfert en CDF',
                                  fontSize: 14,
                                  textColor: AppColors.kWhiteColor),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextWidgets.text300(
                                  title: 'Transfert en USD',
                                  fontSize: 14,
                                  textColor: AppColors.kWhiteColor),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextWidgets.textBold(
                                  title: '2000\$',
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
                })
          ],
        ),
      ),
    );
  }
}
