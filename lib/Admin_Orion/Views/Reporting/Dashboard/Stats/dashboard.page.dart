import 'package:flutter/material.dart';
import 'package:orion/Admin_Orion/Views/Reporting/Dashboard/Stats/stat.widget.dart';
import 'package:orion/Resources/Components/empty_model.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // context.read<ClientProvider>().getStats(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColor,
          onPressed: () {
            // Navigation.pushNavigate(context: context, page: const ChatPage());
          },
          child: const Icon(
            Icons.message_rounded,
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
            width: double.maxFinite,
            color: Colors.white,
            child: const StatsWidget(),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: GridView(
                      // padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        statWidget(
                            title: "Aujourd'hui",
                            subtitle: "Enregistrées aujourd'hui",
                            value: '10'),
                        statWidget(
                            title: "Une semaine",
                            subtitle: "Enregistrées dans une semaine",
                            value: '12'),
                        statWidget(
                            title: "Ce mois",
                            subtitle: "Enregistrées le mois dernier",
                            value: '8'),
                        statWidget(
                            title: "Total",
                            subtitle: "Total des enregistrements",
                            value: '5'),
                      ],
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String activeTab = "";
  tabButton({required String title}) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        activeTab = title;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: activeTab == title
              ? AppColors.kWhiteColor
              : AppColors.kTransparentColor,
        ),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextWidgets.textNormal(
                align: TextAlign.center,
                title: title,
                fontSize: 16,
                textColor: AppColors.kBlackColor)),
      ),
    ));
  }

  statWidget(
      {required String title,
      required String subtitle,
      required String value}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      height: 200,
      decoration: BoxDecoration(
          color: AppColors.kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgets.textBold(
            // align: TextAlign.center,
            title: title,
            fontSize: 24,
            textColor: AppColors.kPrimaryColor,
          ),
          const SizedBox(
            height: 8,
          ),
          TextWidgets.text300(
            // align: TextAlign.center,
            title: subtitle,
            fontSize: 14,
            textColor: AppColors.kPrimaryColor,
          ),
          const Spacer(),
          TextWidgets.textBold(
            align: TextAlign.center,
            title: value,
            fontSize: 32,
            textColor: AppColors.kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
