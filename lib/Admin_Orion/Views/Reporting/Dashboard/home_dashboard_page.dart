import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/admin_caisse_stateprovider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/stats.provider.dart';
import 'package:orion/Admin_Orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/Components/dropdown_button.dart';
import 'package:orion/Admin_Orion/Resources/Components/texts.dart';
import 'package:orion/Admin_Orion/Resources/global_variables.dart';
import 'package:orion/Admin_Orion/Resources/responsive.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class HomeDashboardPage extends StatefulWidget {
  @override
  _HomeDashboardPageState createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  int userCount = 0, activityCount = 0, accountCount = 0, branchCount = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await initData();
      userCount = Provider.of<AdminUserStateProvider>(context, listen: false)
          .clients
          .length;
      activityCount =
          Provider.of<AdminUserStateProvider>(context, listen: false)
              .activitiesdata
              .length;
      accountCount =
          Provider.of<AdminCaisseStateProvider>(context, listen: false)
              .caisseData
              .length;
      branchCount =
          Provider.of<AdminCaisseStateProvider>(context, listen: false)
              .branches
              .length;
      setState(() {});
      context.read<StatsDataProvider>().getData();
    });
  }

  initData() async {
    await Provider.of<AdminCaisseStateProvider>(navKey.currentContext!,
            listen: false)
        .getAccount();
    await Provider.of<AdminUserStateProvider>(context, listen: false)
        .getActivitiesData(isRefresh: true);
    await Provider.of<AdminCaisseStateProvider>(context, listen: false)
        .getBranches(isRefresh: true);
    await Provider.of<AdminUserStateProvider>(context, listen: false)
        .getUsersData(isRefreshed: true);
  }

  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LineChartWidget(),
                ),
                const SizedBox(
                  height: 16,
                ),
                Flex(
                  direction: !Responsive.isMobile(context)
                      ? Axis.horizontal
                      : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        cardStatsWidget(
                            width: 300,
                            title: "Clients externes",
                            subtitle: "Nombre des clients externes",
                            icon: Icons.people,
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor,
                            value: context
                                .select<StatsDataProvider, Map>((provider) =>
                                    provider.countStats)['countClient']
                                .toString()),
                        cardStatsWidget(
                            width: 300,
                            title: "Demandes",
                            subtitle: "Nombre des demandes",
                            icon: Icons.mode_standby_rounded,
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor,
                            value: context
                                .select<StatsDataProvider, Map>((provider) =>
                                    provider.countStats)['countDemands']
                                .toString()),
                        cardStatsWidget(
                            width: 300,
                            title: "Cautions",
                            subtitle: "Nombre des cautions déposées",
                            icon: Icons.attach_money_rounded,
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor,
                            value: context
                                .select<StatsDataProvider, Map>((provider) =>
                                    provider.countStats)['countDemands']
                                .toString()),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cardStatsWidget(
                            width: 300,
                            title: "Utilisateurs",
                            subtitle: "Nombre des utilisateurs actifs",
                            icon: Icons.person,
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor,
                            value: userCount.toString(),
                          ),
                          cardStatsWidget(
                            width: 300,
                            title: "Branches",
                            subtitle: "Nombre des branches actives",
                            icon: Icons.short_text_sharp,
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor,
                            value: branchCount.toString(),
                          ),
                          cardStatsWidget(
                            width: 300,
                            title: "Activites",
                            subtitle: "Nombre des activites actives",
                            icon: Icons.local_activity,
                            textColor: AppColors.kBlackColor,
                            backColor: AppColors.kTextFormBackColor,
                            value: activityCount.toString(),
                          ),
                          cardStatsWidget(
                              width: 300,
                              title: "Caisse",
                              subtitle: "Nombre des caisses actives",
                              icon: Icons.account_balance_outlined,
                              textColor: AppColors.kBlackColor,
                              backColor: AppColors.kTextFormBackColor,
                              value: accountCount.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
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
      double? width}) {
    return Container(
      width: !Responsive.isMobile(context) ? width : null,
      child: Card(
        color: backColor,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          // width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(icon, color: textColor),
                  ),
                  Expanded(
                      child: Row(children: [
                    TextWidgets.textBold(
                        title: value, fontSize: 20, textColor: textColor),
                  ])),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({Key? key}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  String? period;
  @override
  Widget build(BuildContext context) {
    double interval = context.watch<StatsDataProvider>().maxAmount / 10 < 1
        ? 1
        : context.watch<StatsDataProvider>().maxAmount / 10;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flex(
        //   direction: Axis.horizontal,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Flexible(
        //       fit: FlexFit.loose,
        //       child: CustomDropdownButton(
        //           backColor: AppColors.kTextFormBackColor,
        //           textColor: AppColors.kBlackColor,
        //           dropdownColor: AppColors.kWhiteColor,
        //           value: period,
        //           hintText: 'Periode',
        //           callBack: (value) {
        //             setState(() {
        //               period = value;
        //             });
        //           },
        //           items: const ['Hebdomadaire', 'Mensuel', 'Annuel']),
        //     ),
        //     Flexible(
        //       fit: FlexFit.loose,
        //       child: Container(),
        //     )
        //   ],
        // ),
        const SizedBox(height: 8),
        Container(
            width: double.maxFinite,
            height: 300,
            child: LineChart(LineChartData(
                minX: 0,
                maxX: context.read<StatsDataProvider>().dates.length.toDouble(),
                minY: 0,
                maxY: context.watch<StatsDataProvider>().maxAmount,
                titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                        showTitles: true,
                        // margin: 12,
                        rotateAngle: 90,
                        getTitles: (value) {
                          // print(value.toString());
                          return "${DateTime.parse(context.read<StatsDataProvider>().dates[(value).toInt()]['date'].toString()).day.toString()}/${DateTime.parse(context.read<StatsDataProvider>().dates[value.toInt()]['date'].toString()).month.toString()}";
                        }),
                    leftTitles: SideTitles(
                        showTitles: true,
                        margin: 10,
                        rotateAngle: 45,
                        interval: interval,
                        getTitles: (value) {
                          return "$value\$";
                        })),
                gridData: FlGridData(
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    // verticalInterval: 8,
                    show: true,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color: AppColors.kGreyColor.withOpacity(0.5),
                          strokeWidth: 1);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                          color: AppColors.kGreyColor.withOpacity(0.5),
                          strokeWidth: 1);
                    }),
                borderData: FlBorderData(
                    show: true, border: Border.all(color: Colors.transparent)),
                lineBarsData: [
                  LineChartBarData(
                      barWidth: 2,
                      isCurved: true,
                      // curveSmoothness: 0.1,
                      belowBarData: BarAreaData(
                          show: true,
                          colors: [AppColors.kGreenColor.withOpacity(0.1)]),
                      colors: [
                        AppColors.kGreenColor
                      ],
                      spots: [
                        // FlSpot(0, 9),
                        // FlSpot(1, 3),
                        // FlSpot(2, 6),
                        // FlSpot(3, 0),
                        // FlSpot(4, 8),
                        // FlSpot(5, 6),
                        // FlSpot(6, 1),
                        // FlSpot(7, 5),
                        ...List.generate(
                            context.watch<StatsDataProvider>().dates.length,
                            (index) => FlSpot(
                                (index).toDouble(),
                                double.parse(context
                                    .watch<StatsDataProvider>()
                                    .dates[index.toInt()]['cashIn']
                                    .toString())))
                      ]),
                  LineChartBarData(
                      barWidth: 2,
                      isCurved: true,
                      belowBarData: BarAreaData(
                          show: true,
                          colors: [AppColors.kRedColor.withOpacity(0.1)]),
                      colors: [
                        AppColors.kRedColor
                      ],
                      spots: [
                        // FlSpot(0, 3),
                        // FlSpot(1, 7),
                        // FlSpot(2, 1),
                        // FlSpot(3, 9),
                        // FlSpot(4, 5),
                        // FlSpot(5, 9),
                        // FlSpot(6, 5),
                        // FlSpot(7, 2),
                        ...List.generate(
                            context.watch<StatsDataProvider>().dates.length,
                            (index) => FlSpot(
                                (index).toDouble(),
                                double.parse(context
                                    .watch<StatsDataProvider>()
                                    .dates[index.toInt()]['cashOut']
                                    .toString())))
                      ]),
                ]))),
      ],
    );
  }
}
