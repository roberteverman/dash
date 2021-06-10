import 'package:dash/components/ChartCard.dart';
import 'package:dash/providers/ThemeChanger.dart';
import 'package:dash/providers/ground/GroundChartCN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class GroundSubCommandHealthChart2 extends StatelessWidget {
  GroundSubCommandHealthChart2({
    this.chartCardDims,
    this.padding,
    this.percent,
    this.unit,
  });
  final double chartCardDims;
  final double padding;
  final String unit;
  final double percent;

  @override
  Widget build(BuildContext context) {
    Color progressColor;

    if (percent >= .90) {
      progressColor = Colors.green;
    } else if (percent >= .74) {
      progressColor = Colors.amber;
    } else if (percent >= .50) {
      progressColor = Colors.red;
    } else {
      progressColor = Colors.black;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: Text(
              unit,
              style: TextStyle(
                fontSize: chartCardDims / 10,
                color: Theme.of(context).accentColor,
              ),
            ),
            onTap: () {
              Provider.of<GroundChartCN>(context, listen: false).visitedUnits.add(unit);
              Provider.of<GroundChartCN>(context, listen: false).displayParent = unit;
              Provider.of<GroundChartCN>(context, listen: false).updateMap();
              Provider.of<GroundChartCN>(context, listen: false).updateCharts(Provider.of<ThemeChanger>(context, listen: false).lightMode);
            },
          ),
        ),
        Expanded(
          child: LinearPercentIndicator(
            progressColor: progressColor,
            lineHeight: chartCardDims / 8,
            percent: percent,
            padding: EdgeInsets.symmetric(horizontal: chartCardDims / 4),
            center: Text(
              (percent * 100).toStringAsFixed(0) + "%",
              style: TextStyle(
                fontSize: chartCardDims / 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
