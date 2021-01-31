import 'package:dash/components/ChartCard.dart';
import 'package:dash/providers/air/AirChartCN.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AirfieldStatusPieChart extends StatefulWidget {
  AirfieldStatusPieChart({this.chartCardDims, this.padding});
  final chartCardDims;
  final padding;

  @override
  _AirfieldStatusPieChartState createState() => _AirfieldStatusPieChartState();
}

class _AirfieldStatusPieChartState extends State<AirfieldStatusPieChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      width: widget.chartCardDims,
      height: widget.chartCardDims,
      padding: widget.padding,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Airfield Status",
              style: TextStyle(
                fontSize: widget.chartCardDims / 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Flexible(
              child: Container(
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: widget.chartCardDims / 5.5,
                    sections: showingSections(chartCardDims: widget.chartCardDims),
                    // pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    //   setState(() {
                    //     if (pieTouchResponse.touchInput is FlLongPressStart || pieTouchResponse.touchInput is FlPanEnd) {
                    //       touchedIndex = -1;
                    //     } else {
                    //       touchedIndex = pieTouchResponse.touchedSectionIndex;
                    //     }
                    //   });
                    // }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections({chartCardDims}) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? chartCardDims / 10 : chartCardDims / 15;
      final double radius = isTouched ? chartCardDims / 2 - (chartCardDims / 3.8) : chartCardDims / 2 - (chartCardDims / 3.2);
      switch (i) {
        case 0:
          double value =
              Provider.of<AirChartCN>(context, listen: true).numOpAfld / Provider.of<AirChartCN>(context, listen: true).airfieldList.length * 100;
          return PieChartSectionData(
            color: Color(0xff33C073),
            value: value,
            title: isTouched
                ? Provider.of<AirChartCN>(context, listen: true).numOpAfld.toString() +
                    " / " +
                    Provider.of<AirChartCN>(context, listen: true).airfieldList.length.toString()
                : value.toStringAsFixed(1) + "%",
            badgeWidget: Text(""),
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xff005828)),
          );
        case 1:
          double value =
              Provider.of<AirChartCN>(context, listen: true).numNonopAfld / Provider.of<AirChartCN>(context, listen: true).airfieldList.length * 100;

          return PieChartSectionData(
            color: Color(0xffff5252),
            value: value,
            title: isTouched
                ? Provider.of<AirChartCN>(context, listen: true).numNonopAfld.toString() +
                    " / " +
                    Provider.of<AirChartCN>(context, listen: true).airfieldList.length.toString()
                : value.toStringAsFixed(1) + "%",
            badgeWidget: Text(""),
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xff7f0000)),
          );
        case 2:
          double value =
              Provider.of<AirChartCN>(context, listen: true).numLimopAfld / Provider.of<AirChartCN>(context, listen: true).airfieldList.length * 100;

          return PieChartSectionData(
            color: Color(0xffffff52),
            value: value,
            title: isTouched
                ? Provider.of<AirChartCN>(context, listen: true).numLimopAfld.toString() +
                    " / " +
                    Provider.of<AirChartCN>(context, listen: true).airfieldList.length.toString()
                : value.toStringAsFixed(1) + "%",
            badgeWidget: Text(""),
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xff7f7f00)),
          );
        default:
          return null;
      }
    });
  }
}
