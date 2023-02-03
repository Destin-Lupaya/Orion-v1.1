import 'package:flutter/material.dart';
import 'package:orion/Views/Guichet/Historique/historique_transaction.dart';

import '../../../Resources/Components/texts.dart';
import '../../../Resources/global_variables.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  ScrollController _controller = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
  //     Provider.of<UserStateProvider>(context, listen: false).getUserData();
  //     Provider.of<LoanStateProvider>(context, listen: false)
  //         .getLoansType(context: context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _controller,
          child: HistortransList(
            accountData: {},
            activityData: {},
            isFullHistory: true,
          ),
        ),
      ),
    );
  }

  cardStatsWidget(
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color textColor,
      required Color backColor,
      required String value,
      required String value2,
      required String currency}) {
    return Container(
      child: Card(
        color: backColor,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding / 2)),
        child: Container(
          // width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgets.textBold(
                          title: title, fontSize: 16, textColor: textColor),
                      TextWidgets.text300(
                          title: subtitle, fontSize: 12, textColor: textColor),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(children: [
                    TextWidgets.textBold(
                        title: value, fontSize: 20, textColor: textColor),
                  ])),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextWidgets.textBold(
                          title: value2, fontSize: 20, textColor: textColor),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidgets.textBold(
                          title: currency, fontSize: 20, textColor: textColor),
                    ],
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
