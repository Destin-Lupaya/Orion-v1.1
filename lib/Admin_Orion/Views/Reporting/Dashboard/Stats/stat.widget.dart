import 'package:flutter/material.dart';
import 'package:orion/Resources/Components/texts.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:provider/provider.dart';

import 'stats.model.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatItem(
              title: 'Statistiques du mois',
              values: List.generate(
                  7,
                  (index) => StatModel(
                      title: '27/10',
                      value: (2 * index).toDouble(),
                      color: AppColors.kPrimaryColor)),
              max: 50)
        ],
      ),
    );
  }
}

class StatItem extends StatefulWidget {
  final String title;
  List<StatModel> values;
  final double max;
  StatItem(
      {Key? key, required this.title, required this.values, required this.max})
      : super(key: key);

  @override
  State<StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<StatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets.textBold(
                title: widget.title,
                fontSize: 18,
                textColor: AppColors.kBlackColor),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...List.generate(
                      widget.values.length,
                      (index) => Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 18),
                                  progressWidget(
                                      title: widget.values[index].title,
                                      max: widget.max,
                                      value: widget.values[index].value!,
                                      color: widget.values[index].color),
                                  progressWidget(
                                      title: widget.values[index].title,
                                      max: widget.max,
                                      value: widget.values[index].value!,
                                      color: Colors.red),
                                  const SizedBox(width: 18),
                                ],
                              ),
                              TextWidgets.textBold(
                                  title: widget.values[index].title,
                                  fontSize: 14,
                                  textColor: AppColors.kBlackColor),
                            ],
                          )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

progressWidget(
    {required String title,
    required double max,
    required double value,
    required Color color}) {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 2,
    ),
    height: 200,
    child: LayoutBuilder(builder: (context, constraints) {
      // print(constraints.maxHeight);
      double percent = (value * 100) / max;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: constraints.maxHeight - 20,
            width: 10,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 10,
                height: (constraints.maxHeight - 20) * (percent / 100),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          // TextWidgets.textBold(
          //     title: title, fontSize: 14, textColor: AppColors.kBlackColor),
          // TextWidgets.textBold(
          //     title: "${percent.toStringAsFixed(2)}%",
          //     fontSize: 10,
          //     textColor: AppColors.kBlackColor),
          // const SizedBox(height: 4),
        ],
      );
    }),
  );
}
