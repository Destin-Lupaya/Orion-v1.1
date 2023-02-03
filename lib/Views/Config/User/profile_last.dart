import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/Resources/responsive.dart';
import 'package:flutter/material.dart';

class ProfileLastPage extends StatefulWidget {
  const ProfileLastPage({Key? key}) : super(key: key);

  @override
  _ProfileLastPageState createState() => _ProfileLastPageState();
}

class _ProfileLastPageState extends State<ProfileLastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Responsive(
              mobile: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [userCard(), identityCard()],
                    ),
                  ),
                ],
              ),
              tablet: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userCard(),
                        Expanded(
                          child: identityCard(),
                        )
                      ],
                    ),
                  ),
                  // Text('tablet'),
                ],
              ),
              web: Container(
                color: Colors.blue,
              )),
        ),
      ),
    );
  }

  identityCard() {
    return Card(
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidgets.textWithLabel(
                      title: 'Nom',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor,
                      value: '#Genesis01'),
                ),
                Expanded(
                    child: TextWidgets.textWithLabel(
                        title: 'Phone',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor,
                        value: '+243 840172420')),
                Expanded(
                  child: TextWidgets.textWithLabel(
                      title: 'E-mail',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor,
                      value: 'julio@gmail.com'),
                ),
                Expanded(
                    child: TextWidgets.textWithLabel(
                        title: 'Adresse',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor,
                        value: '8360, Wallstreet, New York, USA')),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextWidgets.textWithLabel(
                        title: 'Pays',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor,
                        value: 'DRC')),
                Expanded(
                    child: TextWidgets.textWithLabel(
                        title: 'Ville',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor,
                        value: 'Goma')),
                Expanded(
                  child: TextWidgets.textWithLabel(
                      title: 'Piece d\'identite',
                      fontSize: 14,
                      textColor: AppColors.kWhiteColor,
                      value: 'Passeport'),
                ),
                Expanded(
                    child: TextWidgets.textWithLabel(
                        title: 'ID',
                        fontSize: 14,
                        textColor: AppColors.kWhiteColor,
                        value: '22139217872')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  userCard() {
    return Card(
      color: AppColors.kBlackColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                      color: AppColors.kWhiteColor,
                      width: 2,
                    )),
                child: const FlutterLogo(
                  size: 80,
                ),
              ),
            ),
            TextWidgets.textBold(
                title: '#Genesis01',
                fontSize: 16,
                textColor: AppColors.kWhiteColor),
            const SizedBox(
              height: 10,
            ),
            TextWidgets.text300(
                title: 'genesis01@nalediservices.com',
                fontSize: 12,
                textColor: AppColors.kWhiteColor),
          ],
        ),
      ),
    );
  }
}
